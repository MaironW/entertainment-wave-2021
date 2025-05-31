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
const SDL_Color COLOR_BLUE = {0, 0, 255, 255};
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


struct MenuItem {
    std::string label;
    std::function<void()> action;
};

struct Menu {
    std::string title;
    std::vector<MenuItem> items;
    int selectedIndex = 0;

    void render(SDL_Renderer* renderer, TTF_Font* font) {
        SDL_SetRenderDrawColor(renderer, COLOR_BLUE.r, COLOR_BLUE.g, COLOR_BLUE.b, COLOR_BLUE.a);
        SDL_RenderClear(renderer);

        // Render title
        SDL_Surface* titleSurf = TTF_RenderText_Solid(font, title.c_str(), COLOR_WHITE);
        SDL_Texture* titleTex = SDL_CreateTextureFromSurface(renderer, titleSurf);
        int titleW = titleSurf->w;
        int titleH = titleSurf->h;
        SDL_FreeSurface(titleSurf);
        SDL_Rect titleRect = {SCREEN_WIDTH / 2 - titleW / 2, 70, titleW, titleH};
        SDL_RenderCopy(renderer, titleTex, nullptr, &titleRect);
        SDL_DestroyTexture(titleTex);

        // Render items
        int yOffset = 150;
        int xOffset = 150;
        for (size_t i = 0; i < items.size(); ++i) {
            SDL_Color fgColor = (i == selectedIndex) ? COLOR_BLUE : COLOR_WHITE;
            SDL_Color bgColor = (i == selectedIndex) ? COLOR_WHITE : COLOR_BLUE;

            SDL_Surface* surf = TTF_RenderText_Solid(font, items[i].label.c_str(), fgColor);
            SDL_Texture* tex = SDL_CreateTextureFromSurface(renderer, surf);
            int textW = surf->w;
            int textH = surf->h;
            SDL_FreeSurface(surf);

            SDL_Rect bgRect = {SCREEN_WIDTH / 2 - xOffset, yOffset + (int)i * 50, textW, textH};
            SDL_SetRenderDrawColor(renderer, bgColor.r, bgColor.g, bgColor.b, bgColor.a);
            SDL_RenderFillRect(renderer, &bgRect);

            SDL_Rect textRect = {SCREEN_WIDTH / 2 - xOffset, yOffset + (int)i * 50, textW, textH};
            SDL_RenderCopy(renderer, tex, nullptr, &textRect);
            SDL_DestroyTexture(tex);
        }
    }
};

struct MediaMenu : public Menu {
    std::string directory;

    MediaMenu(const std::string& title, const std::string& dirPath) {
        this->title = title;
        directory = dirPath;
        updateItems();
    }

    void updateItems() {
        items.clear();
        for (const auto& entry : fs::directory_iterator(directory)) {
            if (entry.is_regular_file()) {
                std::string filePath = entry.path().string();
                std::string fileName = entry.path().filename().string();

                // Capture full path by value in the lambda
                items.push_back({fileName, [filePath]() {
                    std::string command = "xdg-open \"" + filePath + "\"";
                    std::system(command.c_str());
                }});
            }
        }
    }

    void render(SDL_Renderer* renderer, TTF_Font* font) {
        updateItems();  // Refresh the file list at each render

        SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255);  // Black background
        SDL_RenderClear(renderer);

        // Render title
        SDL_Surface* titleSurf = TTF_RenderText_Solid(font, title.c_str(), COLOR_WHITE);
        SDL_Texture* titleTex = SDL_CreateTextureFromSurface(renderer, titleSurf);
        int titleW = titleSurf->w;
        int titleH = titleSurf->h;
        SDL_FreeSurface(titleSurf);
        SDL_Rect titleRect = {20, 30, titleW, titleH};
        SDL_RenderCopy(renderer, titleTex, nullptr, &titleRect);
        SDL_DestroyTexture(titleTex);

        // Render file list with smaller text
        int yOffset = 80;
        for (size_t i = 0; i < items.size(); ++i) {
            SDL_Color color = (i == selectedIndex) ? COLOR_BLUE : COLOR_WHITE;
            SDL_Surface* surf = TTF_RenderText_Solid(font, items[i].label.c_str(), color);
            SDL_Texture* tex = SDL_CreateTextureFromSurface(renderer, surf);
            int textW = surf->w;
            int textH = surf->h;
            SDL_FreeSurface(surf);

            SDL_Rect rect = {40, yOffset + static_cast<int>(i) * 30, textW, textH};
            SDL_RenderCopy(renderer, tex, nullptr, &rect);
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

    SDL_Window* window = SDL_CreateWindow("Wave", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, SCREEN_WIDTH, SCREEN_HEIGHT, 0);
    SDL_Renderer* renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);
    TTF_Font* font = TTF_OpenFont("VCR_OSD_MONO_1.001.ttf", 48);
    if (!font) {
        std::cerr << "TTF_OpenFont Error: " << TTF_GetError() << std::endl;
        return 1;
    }

    SDL_GameController* controller = nullptr;

    std::stack<Menu> menuStack;

    auto config = loadConfig("config.txt");

    std::string mtvPath = config.count("MTV") ? config["MTV"] : "~/Pictures";
    std::string vhsPath = config.count("VHS") ? config["VHS"] : "~/Pictures";

    MediaMenu mtvCollection("MTV", mtvPath);
    MediaMenu vhsCollection("VHS", vhsPath);

    Menu mtvMenu = {"MTV", {
        {"SHUFFLE", []() { system("echo SHUFFLE selected"); }},
        {"COLLECTION", [&]() { menuStack.push(mtvCollection); }}
    }};

    Menu vhsMenu = {"VHS", {
        {"SHUFFLE", []() { system("echo SHUFFLE selected"); }},
        {"COLLECTION", [&]() { menuStack.push(vhsCollection); }}
    }};

    Menu tvMenu = {"TV", {
        {"MTV", [&]() { menuStack.push(mtvMenu); }},
        {"VHS", [&]() { menuStack.push(vhsMenu); }},
        {"CABLE", []() { system("echo Cable selected"); }}
    }};

    Menu mainMenu = {"MENU", {
        {"TV", [&]() { menuStack.push(tvMenu); }},
        {"VIDEOGAME", []() { system("echo VIDEOGAME selected"); }},
        {"RADIO", []() { system("echo RADIO selected"); }},
        {"CONFIGURATION", []() { system("echo CONFIG selected"); }}
    }};


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
                            menuStack.top().selectedIndex = (menuStack.top().selectedIndex - 1 + menuStack.top().items.size()) % menuStack.top().items.size();
                            break;
                        case SDLK_DOWN:
                            menuStack.top().selectedIndex = (menuStack.top().selectedIndex + 1) % menuStack.top().items.size();
                            break;
                        case SDLK_RETURN:
                            menuStack.top().items[menuStack.top().selectedIndex].action();
                            break;
                        case SDLK_BACKSPACE:
                            if (menuStack.size() > 1) menuStack.pop();
                            break;
                    }
                    break;
                case SDL_CONTROLLERBUTTONDOWN:
                    if (e.cbutton.button == SDL_CONTROLLER_BUTTON_DPAD_UP) {
                        menuStack.top().selectedIndex = (menuStack.top().selectedIndex - 1 + menuStack.top().items.size()) % menuStack.top().items.size();
                    } else if (e.cbutton.button == SDL_CONTROLLER_BUTTON_DPAD_DOWN) {
                        menuStack.top().selectedIndex = (menuStack.top().selectedIndex + 1) % menuStack.top().items.size();
                    } else if (e.cbutton.button == SDL_CONTROLLER_BUTTON_A) {
                        menuStack.top().items[menuStack.top().selectedIndex].action();
                    } else if (e.cbutton.button == SDL_CONTROLLER_BUTTON_B) {
                        if (menuStack.size() > 1) menuStack.pop();
                    }
                    break;
            }
        }

        menuStack.top().render(renderer, font);
        SDL_RenderPresent(renderer);
        SDL_Delay(16);
    }

    if (controller) SDL_GameControllerClose(controller);
    TTF_CloseFont(font);
    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    TTF_Quit();
    SDL_Quit();
    return 0;
}
