# Detect system OS.
ifeq ($(OS),Windows_NT)
	detected_OS := Windows
else
	detected_OS := $(shell sh -c 'uname -s 2>/dev/null || echo not')
endif

# Set the default include path of GNUstep.
ifeq (,$(GNUSTEP_INCLUDE))
	GNUSTEP_INCLUDE=/usr/GNUstep/System/Library/Headers
endif

# Set the default library path of GNUstep.
ifeq (,$(GNUSTEP_LIB))
	GNUSTEP_LIB=/usr/GNUstep/System/Library/Libraries
endif

# Set the library path of GCC.
GCC_LIB=$(shell sh -c 'dirname `gcc -print-prog-name=cc1 /dev/null`')

C_SRCS=$(shell find src -type f -name *.c)
CXX_SRCS=$(shell find src -type f -name *.cc -o -name *.cpp -o -name *.cxx)
OBJC_SRCS=$(shell find src -type f -name *.m)
OBJCXX_SRCS=$(shell find src -type f -name *.mm)

CXX_OBJS=$(CXX_SRCS:.cc=.o)
CXX_OBJS_1=$(CXX_OBJS:.cpp=.o)
CXX_OBJS_2=$(CXX_OBJS_1:.cxx=.o)

OBJS=$(C_SRCS:.c=.o)
OBJS+=$(CXX_OBJS_2)
OBJS+=$(OBJC_SRCS:.m=.o)
OBJS+=$(OBJCXX_SRCS:.mm=.o)

# Use libstdc++ in CC
ifneq (,$(CXX_SRCS))
	LIBCXX=-lstdc++
endif

ifneq (,$(OBJCXX_SRCS))
	LIBCXX=-lstdc++
endif

# Modify the executable name by yourself.
ifeq (,$(PROGRAM))
	PROGRAM=program
endif

ifeq ($(detected_OS),Windows)
	TARGET=$(PROGRAM).exe
else
	TARGET=$(PROGRAM)
endif

# Set the C standard.
ifeq (,$(C_STD))
	C_STD=c11
endif

# Set the C++ standard.
ifeq (,$(CXX_STD))
	CXX_STD=c++17
endif


# Set the include path of libobjc on non-Apple platforms.
OBJC_INCLUDE := -I $(GCC_LIB)/include

.PHONY: all clean

all: dist/$(TARGET)

dist/$(TARGET): $(OBJS)
ifeq ($(detected_OS),Darwin)
	$(CC) -o dist/$(TARGET) $(OBJS) \
		$(LDFLAGS) $(LIBCXX) -lobjc -framework Foundation
else
	$(CC) -o dist/$(TARGET) $(OBJS) \
		$(LDFLAGS) $(LIBCXX) -lobjc -lgnustep-base -L $(GNUSTEP_LIB)
endif

%.o:%.c
	$(CC) -std=$(C_STD) -c $< -o $@ $(CFLAGS) -I include

%.o:%.cc
	$(CXX) -std=$(CXX_STD) -c $< -o $@ $(CXXFLAGS) -I include

%.o:%.cpp
	$(CXX) -std=$(CXX_STD) -c $< -o $@ $(CXXFLAGS) -I include

%.o:%.cxx
	$(CXX) -std=$(CXX_STD) -c $< -o $@ $(CXXFLAGS) -I include

%.o:%.m
ifeq ($(detected_OS),Darwin)
	$(CC) -std=$(C_STD) -c $< -o $@ $(CFLAGS) -I include \
		-fconstant-string-class=NSConstantString
else
	$(CC) -std=$(C_STD) -c $< -o $@ $(CFLAGS) -I include \
		$(OBJC_INCLUDE) -I $(GNUSTEP_INCLUDE) \
		-fconstant-string-class=NSConstantString
endif

%.o:%.mm
ifeq ($(detected_OS),Darwin)
	$(CXX) -std=$(CXX_STD) -c $< -o $@ $(CXXFLAGS) -I include \
		-fconstant-string-class=NSConstantString
else
	$(CXX) -std=$(CXX_STD) -c $< -o $@ $(CXXFLAGS) -I include \
		$(OBJC_INCLUDE) -I $(GNUSTEP_INCLUDE) \
		-fconstant-string-class=NSConstantString
endif

clean:
	$(RM) dist/$(TARGET) $(OBJS)
