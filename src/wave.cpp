#include <SDL2/SDL.h>
#include <SDL2/SDL_ttf.h>
#include <iostream>
#include <vector>
#include <string>
#include <stack>
#include <functional>
#include <cstdlib>
#include <filesystem>
#include <fstream>
#include <unordered_map>

namespace fs = std::filesystem;

const int SCREEN_WIDTH = 640;
const int SCREEN_HEIGHT = 480;
const int MENU_FONT_SIZE = 48;
const int LIST_FONT_SIZE = 32;
const SDL_Color COLOR_BLUE = {0, 0, 255, 255};
const SDL_Color COLOR_BLACK = {0, 0, 0, 255};
const SDL_Color COLOR_WHITE = {255, 255, 255, 255};

// Load config key-value pairs from a file
std::unordered_map<std::string, std::string> loadConfig(const std::string& filename) {
    std::unordered_map<std::string, std::string> config;
    std::ifstream file(filename);
    if (!file) {
        std::cerr << "Warning: Could not open config file: " << filename << "\n";
        return config;
    }

    std::string line;
    while (std::getline(file, line)) {
        auto pos = line.find('=');
        if (pos == std::string::npos) continue;
        std::string key = line.substr(0, pos);
        std::string val = line.substr(pos + 1);
        config[key] = val;
    }
    return config;
}

void playShuffledDirectory(const std::string& dir) {
    std::string command = "mpv --fs --shuffle ";
    for (const auto& entry : fs::directory_iterator(dir)) {
        if (entry.is_regular_file()) {
            command += "\"" + entry.path().string() + "\" ";
        }
    }
    command += "&";
    std::system(command.c_str());
}

struct MenuItem {
    std::string label;
    std::function<void()> action;
};

struct Menu {
    std::string title;
    std::vector<MenuItem> items;
    int selectedIndex = 0;

    virtual void render(SDL_Renderer* renderer, TTF_Font* menuFont, TTF_Font* listFont) {
        SDL_SetRenderDrawColor(renderer, COLOR_BLUE.r, COLOR_BLUE.g, COLOR_BLUE.b, COLOR_BLUE.a);
        SDL_RenderClear(renderer);

        // Render title
        SDL_Surface* titleSurf = TTF_RenderText_Solid(menuFont, title.c_str(), COLOR_WHITE);
        SDL_Texture* titleTex = SDL_CreateTextureFromSurface(renderer, titleSurf);
        int titleW = titleSurf->w;
        int titleH = titleSurf->h;
        SDL_FreeSurface(titleSurf);
        SDL_Rect titleRect = {SCREEN_WIDTH / 2 - titleW / 2, 70, titleW, titleH};
        SDL_RenderCopy(renderer, titleTex, nullptr, &titleRect);
        SDL_DestroyTexture(titleTex);

        // Calculate max item width
        int maxWidth = 0;
        for (const auto& item : items) {
            SDL_Surface* surf = TTF_RenderText_Solid(menuFont, item.label.c_str(), COLOR_WHITE);
            if (surf) {
                if (surf->w > maxWidth) maxWidth = surf->w;
                SDL_FreeSurface(surf);
            }
        }

        // Center the list using maxWidth
        int listX = SCREEN_WIDTH / 2 - maxWidth / 2;
        int yOffset = 150;
        int itemHeight = MENU_FONT_SIZE;

        for (size_t i = 0; i < items.size(); ++i) {
            SDL_Color fgColor = (i == selectedIndex) ? COLOR_BLUE : COLOR_WHITE;
            SDL_Color bgColor = (i == selectedIndex) ? COLOR_WHITE : COLOR_BLUE;

            SDL_Surface* surf = TTF_RenderText_Solid(menuFont, items[i].label.c_str(), fgColor);
            SDL_Texture* tex = SDL_CreateTextureFromSurface(renderer, surf);
            int textW = surf->w;
            int textH = surf->h;
            SDL_FreeSurface(surf);

            SDL_Rect bgRect = {listX, yOffset + (int)i * itemHeight, textW, textH};
            SDL_SetRenderDrawColor(renderer, bgColor.r, bgColor.g, bgColor.b, bgColor.a);
            SDL_RenderFillRect(renderer, &bgRect);

            // Align text left within the background
            SDL_Rect textRect = {listX, yOffset + (int)i * itemHeight, textW, textH};
            SDL_RenderCopy(renderer, tex, nullptr, &textRect);
            SDL_DestroyTexture(tex);
        }
    }
};

struct MediaMenu : public Menu {
    std::string directory;
    int scrollOffset = 0;
    int visibleItems = 10;


    MediaMenu(const std::string& title, const std::string& dirPath, std::stack<std::shared_ptr<Menu>>& menuStack) {
        this->title = title;
        directory = dirPath;
        updateItems(menuStack);
    }

    void updateItems(std::stack<std::shared_ptr<Menu>>& menuStack) {
        items.clear();

        // Temporary vector to store directory entries
        std::vector<fs::directory_entry> entries;

        // Populate the vector with directory entries
        for (const auto& entry : fs::directory_iterator(directory)) {
            entries.push_back(entry);
        }

        // Sort the entries: directories first, then files, both in alphabetical order
        std::sort(entries.begin(), entries.end(), [](const fs::directory_entry& a, const fs::directory_entry& b) {
            bool isDirA = a.is_directory();
            bool isDirB = b.is_directory();

            if (isDirA != isDirB) {
                // Directories come first
                return isDirA > isDirB;
            }

            // Sort alphabetically within the same type
            return a.path().filename().string() < b.path().filename().string();
        });

        // Populate the items vector with sorted entries
        for (const auto& entry : entries) {
            std::string path = entry.path().string();
            std::string name = entry.path().filename().string();

            if (entry.is_directory()) {
                items.push_back({name + "/", [this, path, &menuStack]() {
                    if (!fs::exists(path)) {
                        std::cerr << "Error: Directory does not exist: " << path << std::endl;
                        return;
                    }

                    // Push a new MediaMenu instance onto the menu stack
                    auto newMenu = std::make_shared<MediaMenu>(this->title, path, menuStack);
                    newMenu->selectedIndex = 0;
                    newMenu->scrollOffset = 0;

                    menuStack.push(newMenu);
                }});
            } else if (entry.is_regular_file()) {
                items.push_back({name, [path]() {
                    std::string command = "mpv --fs \"" + path + "\" &";
                    std::system(command.c_str());
                }});
            }
        }
    }

    void updateScroll() {
        if (selectedIndex < scrollOffset) {
            scrollOffset = selectedIndex;
        } else if (selectedIndex >= scrollOffset + visibleItems) {
            scrollOffset = selectedIndex - visibleItems + 1;
        }
    }

    void render(SDL_Renderer* renderer, TTF_Font* menuFont, TTF_Font* listFont) {
        SDL_SetRenderDrawColor(renderer, COLOR_BLACK.r, COLOR_BLACK.g, COLOR_BLACK.b, COLOR_BLACK.a);
        SDL_RenderClear(renderer);

        // Render title
        SDL_Surface* titleSurf = TTF_RenderText_Solid(menuFont, title.c_str(), COLOR_WHITE);
        SDL_Texture* titleTex = SDL_CreateTextureFromSurface(renderer, titleSurf);
        int titleW = titleSurf->w;
        int titleH = titleSurf->h;
        SDL_FreeSurface(titleSurf);
        SDL_Rect titleRect = {SCREEN_WIDTH / 2 - titleW / 2, 70, titleW, titleH};
        SDL_RenderCopy(renderer, titleTex, nullptr, &titleRect);
        SDL_DestroyTexture(titleTex);

        // Render file list
        int maxWidth = SCREEN_WIDTH - 48;
        int listX = SCREEN_WIDTH / 2 - maxWidth / 2;
        int yOffset = 150;
        int itemHeight = LIST_FONT_SIZE;

        for (size_t i = scrollOffset; i < std::min(items.size(), static_cast<size_t>(scrollOffset + visibleItems)); ++i) {
            int drawIndex = i - scrollOffset;
            SDL_Color fgColor = (i == selectedIndex) ? COLOR_BLUE : COLOR_WHITE;
            SDL_Color bgColor = (i == selectedIndex) ? COLOR_WHITE : COLOR_BLACK;

            SDL_Surface* surf = TTF_RenderText_Solid(listFont, items[i].label.c_str(), fgColor);
            SDL_Texture* tex = SDL_CreateTextureFromSurface(renderer, surf);
            int textW = surf->w;
            int textH = surf->h;
            SDL_FreeSurface(surf);

            SDL_Rect bgRect = {listX, yOffset + drawIndex * itemHeight, maxWidth, textH};
            SDL_SetRenderDrawColor(renderer, bgColor.r, bgColor.g, bgColor.b, bgColor.a);
            SDL_RenderFillRect(renderer, &bgRect);

            SDL_Rect textRect = {listX, yOffset + drawIndex * itemHeight, textW, textH};
            SDL_RenderCopy(renderer, tex, nullptr, &textRect);
            SDL_DestroyTexture(tex);
        }
    }
};

int main(int argc, char* argv[]) {
    if (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_GAMECONTROLLER) != 0) {
        std::cerr << "SDL_Init Error: " << SDL_GetError() << std::endl;
        return 1;
    }
    if (TTF_Init() != 0) {
        std::cerr << "TTF_Init Error: " << TTF_GetError() << std::endl;
        SDL_Quit();
        return 1;
    }

    SDL_Window* window = SDL_CreateWindow("Wave", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, SCREEN_WIDTH, SCREEN_HEIGHT, SDL_WINDOW_BORDERLESS);
    SDL_Renderer* renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);
    TTF_Font* menuFont = TTF_OpenFont("VCR_OSD_MONO_1.001.ttf", MENU_FONT_SIZE);
    if (!menuFont) {
        std::cerr << "TTF_OpenFont Error: " << TTF_GetError() << std::endl;
        return 1;
    }

    TTF_Font* listFont = TTF_OpenFont("VCR_OSD_MONO_1.001.ttf", LIST_FONT_SIZE);
    if (!listFont) {
        std::cerr << "TTF_OpenFont Error: " << TTF_GetError() << std::endl;
        return 1;
    }

    SDL_GameController* controller = nullptr;

    std::stack<std::shared_ptr<Menu>> menuStack;

    auto config = loadConfig("config.txt");

    std::string mtvPath = config.count("MTV") ? config["MTV"] : "~/Videos";
    std::string vhsPath = config.count("VHS") ? config["VHS"] : "~/Videos";

    auto mtvCollection = std::make_shared<MediaMenu>("MTV", mtvPath, menuStack);
    auto vhsCollection = std::make_shared<MediaMenu>("VHS", vhsPath, menuStack);

    auto mtvMenu = std::make_shared<Menu>();
    mtvMenu->title = "MTV";
    mtvMenu->items = {
        {"SHUFFLE", [&]() { playShuffledDirectory(mtvPath); }},
        {"COLLECTION", [&]() {
            mtvCollection->updateItems(menuStack);
            menuStack.push(mtvCollection);
        }}
    };

    auto vhsMenu = std::make_shared<Menu>();
    vhsMenu->title = "VHS";
    vhsMenu->items = {
        {"SHUFFLE", [&]() { playShuffledDirectory(vhsPath); }},
        {"COLLECTION", [&]() {
            vhsCollection->updateItems(menuStack);
            menuStack.push(vhsCollection);
        }}
    };

    auto tvMenu = std::make_shared<Menu>();
    tvMenu->title = "TV";
    tvMenu->items = {
        {"MTV", [&]() { menuStack.push(mtvMenu); }},
        {"VHS", [&]() { menuStack.push(vhsMenu); }},
        {"CABLE", []() { system("echo Cable selected"); }}
    };

    auto settingsMenu = std::make_shared<Menu>();
    settingsMenu->title = "SETTINGS";
    settingsMenu->items = {
        {"SHUTDOWN", []() { system("sudo shutdown now"); }},
        {"REBOOT", []() { system("sudo reboot now"); }},
        {"UPDATE", []() { system("xterm -e bash update.sh"); }}
    };

    auto mainMenu = std::make_shared<Menu>();
    mainMenu->title = "MENU";
    mainMenu->items = {
        {"TV", [&]() { menuStack.push(tvMenu); }},
        {"VIDEOGAME", []() { system("openbox --exit"); }},
        {"RADIO", []() { system("xterm -e bash spt.sh"); }},
        {"SETTINGS", [&]() { menuStack.push(settingsMenu); }}
    };

    menuStack.push(mainMenu);

    bool quit = false;
    SDL_Event e;
    while (!quit) {
        while (SDL_PollEvent(&e)) {
            switch (e.type) {
                case SDL_QUIT:
                    quit = true;
                    break;
                case SDL_CONTROLLERDEVICEADDED:
                    if (!controller)
                        controller = SDL_GameControllerOpen(e.cdevice.which);
                    break;
                case SDL_CONTROLLERDEVICEREMOVED:
                    if (controller && SDL_JoystickInstanceID(SDL_GameControllerGetJoystick(controller)) == e.cdevice.which) {
                        SDL_GameControllerClose(controller);
                        controller = nullptr;
                    }
                    break;
                case SDL_KEYDOWN:
                    switch (e.key.keysym.sym) {
                        case SDLK_UP:
                            menuStack.top()->selectedIndex = (menuStack.top()->selectedIndex - 1 + menuStack.top()->items.size()) % menuStack.top()->items.size();
                            if (auto media = std::dynamic_pointer_cast<MediaMenu>(menuStack.top())) media->updateScroll();
                            break;
                        case SDLK_DOWN:
                            menuStack.top()->selectedIndex = (menuStack.top()->selectedIndex + 1) % menuStack.top()->items.size();
                            if (auto media = std::dynamic_pointer_cast<MediaMenu>(menuStack.top())) media->updateScroll();
                            break;
                        case SDLK_RETURN:
                            menuStack.top()->items[menuStack.top()->selectedIndex].action();
                            break;
                        case SDLK_BACKSPACE:
                            if (menuStack.size() > 1) menuStack.pop();
                            break;
                        case SDLK_w:
                            if (e.key.keysym.sym == SDLK_w && (e.key.keysym.mod & KMOD_CTRL) && (e.key.keysym.mod & KMOD_SHIFT)) quit = true;
                            break;
                    }
                    break;
                case SDL_CONTROLLERBUTTONDOWN:
                    switch(e.cbutton.button) {
                        case SDL_CONTROLLER_BUTTON_DPAD_UP:
                            menuStack.top()->selectedIndex = (menuStack.top()->selectedIndex - 1 + menuStack.top()->items.size()) % menuStack.top()->items.size();
                            if (auto media = std::dynamic_pointer_cast<MediaMenu>(menuStack.top())) media->updateScroll();
                            break;
                        case SDL_CONTROLLER_BUTTON_DPAD_DOWN:
                            menuStack.top()->selectedIndex = (menuStack.top()->selectedIndex + 1) % menuStack.top()->items.size();
                            if (auto media = std::dynamic_pointer_cast<MediaMenu>(menuStack.top())) media->updateScroll();
                            break;
                        case SDL_CONTROLLER_BUTTON_A:
                            menuStack.top()->items[menuStack.top()->selectedIndex].action();
                            break;
                        case SDL_CONTROLLER_BUTTON_B:
                            if (menuStack.size() > 1) menuStack.pop();
                            break;
                    }
                    break;
            }
        }

        menuStack.top()->render(renderer, menuFont, listFont);
        SDL_RenderPresent(renderer);
        SDL_Delay(16);
    }

    if (controller) SDL_GameControllerClose(controller);
    TTF_CloseFont(menuFont);
    TTF_CloseFont(listFont);
    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    TTF_Quit();
    SDL_Quit();
    return 0;
}
