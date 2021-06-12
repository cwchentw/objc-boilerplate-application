# Objective-C Boilerplate for Application

An Objective-C boilerplate project to build an Objective-C based application.

## System Requirements

* Objective-C compiler (Clang or GCC)
* Cocoa or GNUstep
* GNU Make (for compilation only)

## Usage

Clone the project:

```
$ git clone https://github.com/cwchentw/objc-boilerplate-application.git myapp
```

Move your working directory to the root of *myapp*:

```
$ cd myapp
```

Modify *main.m* as needed. You may add or remove Objective-C source files (*.m*) or C source files (*.c*) as well.

Compile the application:

```
$ make
```

Run the compiled program:

```
$ ./dist/program
```

Set your own remote repository:

```
$ git remote set-url origin https://example.com/user/project.git
```

Push your modification to your own repo:

```
$ git push
```

## Project Configuration

Here are the parameters in *Makefile*:

* **PROGRAM**: the name of the compiled program
* **C_STD**: the C standard as a GCC C dialect
* **CXX_STD**: the C++ standard as a GCC C++ dialect
* **GNUSTEP_INCLUDE**: the include path of GNUstep
* **GNUSTEP_LIB**: the library path of GNUstep

## Note

C++ and Objective-C++ are supported as well.

## Copyright

Copyright (c) 2020-2021 Michelle Chen. Licensed under MIT.