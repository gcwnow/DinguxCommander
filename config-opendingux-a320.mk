CXX:=mipsel-linux-g++
CXXFLAGS:=-DPLATFORM_DINGOO -O3 -fomit-frame-pointer -ffast-math -funroll-loops
SDL_CONFIG:=$(shell $(CXX) -print-sysroot)/usr/bin/sdl-config
