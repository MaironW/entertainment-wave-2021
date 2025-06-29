# Makefile for building SDL2 Wave project

CXX = g++
LDFLAGS = -lSDL2 -lSDL2_ttf

TARGET = wave
SRC = wave.cpp

all: $(TARGET)

$(TARGET): $(SRC)
	$(CXX) $(CXXFLAGS) -o $(TARGET) $(SRC) $(LDFLAGS)

clean:
	rm -f $(TARGET)
