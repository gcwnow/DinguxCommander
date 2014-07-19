CXX:=mipsel-gcw0-linux-uclibc-g++
CXXFLAGS:=-DPLATFORM_GCW0 -O3 -fomit-frame-pointer -ffast-math -funroll-loops
SDL_CONFIG:=$(shell $(CXX) -print-sysroot)/usr/bin/sdl-config
