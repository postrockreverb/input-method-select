ARCHS := arm64 x86_64

DIST_DIR_arm64 := dist-arm64
DIST_DIR_x86_64 := dist-x86_64

.PHONY: all clean

all: $(ARCHS)

$(ARCHS):
	mkdir -p $(DIST_DIR_$@)
	clang -arch $@ -framework Cocoa -framework Carbon input-method-select.m -o $(DIST_DIR_$@)/input-method-select

clean:
	rm -rf $(DIST_DIR_arm64) $(DIST_DIR_x86_64)
