# Host tests for the bench sketch; see README.md.
# `make` builds the sketch for both boards (BOARD_V026 false and true) and runs
# the tests on each; `make TEST=name` runs only the tests whose name has `name`.

CXX ?= c++
CXXFLAGS = -std=c++17 -Wall -Wextra -Wno-unused-parameter -Istubs -Ibuild
SKETCH = ../open-rally-remote.ino
VARIANTS = false true

.PHONY: test clean
test: $(VARIANTS:%=build/test-%)
	@for v in $(VARIANTS); do ./build/test-$$v $(TEST) || exit 1; done

build/sketch-%.ino: $(SKETCH) | build
	sed 's/^constexpr bool BOARD_V026 = false;/constexpr bool BOARD_V026 = $*;/' $< > $@
	grep -q '^constexpr bool BOARD_V026 = $*;' $@

build/test-%: test_sketch.cpp build/sketch-%.ino stubs/host.h
	$(CXX) $(CXXFLAGS) -DSKETCH='"sketch-$*.ino"' -o $@ test_sketch.cpp

build:
	mkdir -p build

clean:
	rm -rf build
