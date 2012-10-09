ifeq ($(CONFIG),)
CONFIGS:=$(foreach CFG,$(wildcard config-*.mk),$(CFG:config-%.mk=%))
$(error Please specify CONFIG, possible values: $(CONFIGS))
endif

include config-$(CONFIG).mk

RESDIR:=res

CXXFLAGS+=-Wall -Wno-unknown-pragmas -Wno-format
CXXFLAGS+=$(shell $(SDL_CONFIG) --cflags)
CXXFLAGS+=-DRESDIR="\"$(RESDIR)\""
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

DEPFILES:=$(patsubst %.o,$(OUTDIR)/%.d,$(OBJS))

.PHONY: all clean

all: $(EXECUTABLE)

$(EXECUTABLE): $(addprefix $(OUTDIR)/,$(OBJS))
	$(SUM) "  LINK    $@"
	$(CMD)$(CXX) $(LINKFLAGS) -o $@ $^

$(OUTDIR)/%.o: src/%.cpp
	@mkdir -p $(@D)
	$(SUM) "  CXX     $@"
	$(CMD)$(CXX) $(CXXFLAGS) -MP -MMD -MF $(@:%.o=%.d) -c $< -o $@
	@touch $@ # Force .o file to be newer than .d file.

clean:
	$(SUM) "  RM      $(OUTDIR)"
	$(CMD)rm -rf $(OUTDIR)

# Load dependency files.
-include $(DEPFILES)

# Generate dependencies that do not exist yet.
# This is only in case some .d files have been deleted;
# in normal operation this rule is never triggered.
$(DEPFILES):
