ifeq ($(CONFIG),)
CONFIGS:=$(foreach CFG,$(wildcard config-*.mk),$(CFG:config-%.mk=%))
$(error Please specify CONFIG, possible values: $(CONFIGS))
endif

include config-$(CONFIG).mk

CXXFLAGS+=-Wall -Wno-unknown-pragmas -Wno-format
CXXFLAGS+=$(shell $(SDL_CONFIG) --cflags)
LINKFLAGS+=-s
LINKFLAGS+=$(shell $(SDL_CONFIG) --libs) -lSDL_image -lSDL_ttf

ifdef V
	CMD:=
	SUM:=@\#
else
	CMD:=@
	SUM:=@echo
endif

OUTDIR:=output/$(CONFIG)

EXECUTABLE:=$(OUTDIR)/DinguxCommander

OBJS:=main.o sdlutils.o resourceManager.o fileLister.o commander.o panel.o \
      dialog.o window.o fileutils.o viewer.o keyboard.o

.PHONY: all clean

all: $(EXECUTABLE)

$(EXECUTABLE): $(addprefix $(OUTDIR)/,$(OBJS))
	$(SUM) "  LINK    $@"
	$(CMD)$(CXX) $(LINKFLAGS) -o $@ $^

$(OUTDIR)/%.o: src/%.cpp
	@mkdir -p $(@D)
	$(SUM) "  CXX     $@"
	$(CMD)$(CXX) $(CXXFLAGS) -c $< -o $@

clean:
	$(SUM) "  RM      $(OUTDIR)"
	$(CMD)rm -rf $(OUTDIR)

main.o: main.cpp def.h resourceManager.h commander.h sdlutils.h

sdlutils.o: sdlutils.h sdlutils.cpp def.h window.h resourceManager.h

resourceManager.o: resourceManager.h resourceManager.cpp def.h sdlutils.h def.h

fileLister.o: fileLister.h fileLister.cpp

commander.o: commander.h commander.cpp panel.h resourceManager.h sdlutils.h def.h window.h dialog.h fileutils.h viewer.h keyboard.h

panel.o: panel.h panel.cpp fileLister.h def.h resourceManager.h sdlutils.h fileutils.h

dialog.o: dialog.h dialog.cpp sdlutils.h resourceManager.h def.h window.h

window.o: window.h window.cpp def.h

fileutils.o: fileutils.h fileutils.cpp def.h sdlutils.h

viewer.o: viewer.h viewer.cpp window.h def.h resourceManager.h sdlutils.h

keyboard.o: keyboard.h keyboard.cpp window.h def.h resourceManager.h sdlutils.h
