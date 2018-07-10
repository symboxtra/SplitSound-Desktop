[![Build Status](https://api.travis-ci.org/symboxtra/SplitSound-Desktop.svg?branch=master)](https://travis-ci.org/symboxtra/SplitSound-Desktop/builds "Travis Linux/OSX build")
[![Build Status](https://ci.appveyor.com/api/projects/status/iofaswhgc1kt7txa/branch/master?svg=true)](https://ci.appveyor.com/project/symboxtra/splitsound-desktop/history "AppVeyor Windows build")
[![Coverage Status](https://codecov.io/gh/symboxtra/SplitSound-Desktop/branch/master/graph/badge.svg)](https://codecov.io/gh/symboxtra/SplitSound-Desktop)
[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://www.opensource.org/licenses/GPL-3.0)

# Contributing to SplitSound-Desktop #

**Project status**: Early development

We welcome contributions from outside collaborators. Feel free to fork and open a PR!

Want us to support an additional platform or feature? Open an issue or send us an [email](mailto:dev.symboxtra@gmail.com), and we'll gladly investigate.

For those who don't like the short story long or have done this before, a much briefer set of instructions can be found [here](#tldr).


## Design ##

This project is a CMake based Qt project designed to support as many platforms as possible.
The front-end is written in Qt Quick QML, with the back-end a majority C++.
We currently build with GCC (Linux), Apple Clang (OSX), and MSVC (Windows) and plan to deploy using CPack.

Much of the information contained in this document is speculative and may change with development.
We aim to keep this an up-to-date resource for dependencies and build information.



## Cloning ##

There are submodules included in the project, so be sure to clone using `git clone --recurse-submodules` 
or call `git submodule update --init --recursive` inside the project once cloned.

#### Example: ####
```
git --recurse-submodules clone https://github.com/symboxtra/SplitSound-Desktop
```
or
```
git clone https://github.com/symboxtra/SplitSound-Desktop
cd SplitSound-Desktop
git submodule update --init --recursive
```

We also periodically pull updates into our submodules. This will usually coincide with a major or minor release.
If you prefer, you can manually update the submodules on your branch with the latest commits on the remote using the command:
```
git submodule update --remote --merge
```
This will fetch any missing commits in all submodules and checkout the latest revision.
These changes can be staged and committed by anyone, but we prefer that someone on the team verify that the submodule is ready to go.



## Branching ##

Every feature/line of development should have its own branch. 
Unless you know what you're doing, this branch should typically be a direct child of the `master` branch (see example below).
Releases accumulate in release branches before being merged into master.

Merging to master requires passing all continuous integration (CI) and a review from at least one member of the team.

#### Example: ####
```
git checkout master                     # Switch to the master branch
git pull origin master                  # Pull down latest changes
git checkout -b add-crazy-new-feature   # Create your new branch
                                        # Do werk
```



## Development ##

Given the application's cross-platform nature, environment setup can get a bit tricky. 
With a Qt installation, CMake, and the compiler of your choice, we hope there should be only a few strange quirks (but we know there shall be many).

### Requirements ###
| Package Name | Version | Use |
| :---: | :---: | :--- |
| Qt | 5.10.0+ | Cross-platform GUI |
| CMake | 3.5+ | Cross-platform 'Makefile' generator |
| Boost | 1.6+ | Portable C++ thread libraries |

#### Compilers ####
| Platform | Compiler | Version |
| :---: | :---: | :---: |
| Windows | MSVC | N/A |
| OSX | Apple Clang | N/A |
| Linux | GCC | N/A |

**Note**: Minimum compiler versions have not yet been determined.

### Environment ###

Our CMake build is compatible with the Qt Creator IDE, which provides nice auto-complete and debugging tools.
Select the root `CMakeList.txt` when opening the project. 
It's sometimes easiest to build once from the command line and then import that configured build.
Qt Creator flips out a little bit when trying to generate the fresh CMake itself.

If the project doesn't build on Windows, check the `Build Steps` section under the `Projects` tab in the left navigation bar. The command should be `cmake.exe --build . --target ALL_BUILD` or simply `cmake --build .`.

More instructions and pictures should be coming soon.


[CMake Installation and Support for all Platforms](http://cgold.readthedocs.io/en/latest/first-step/installation.html)

#### Windows ####

Qt can be downloaded from https://www.qt.io/download. 
If you don't plan to cross-compile, only the `msvc2017_64` (64 bit) and/or `msvc2015` (32 bit) libraries are needed.

#### ENVIRONMENT WARNING ####
If you do plan to compile 32-bit applications on a 64-bit OS, be sure to **keep the Qt 64-bit `bin` folder off `PATH`**.
Even though we use an absolute path to call the 32-bit version of `windeployqt` when applicable, it insists on copying the 64-bit DLLs if the 64-bit `bin` folder is on `PATH`.

----

Once installed, add the following environment variables to Windows [[help]](https://www.howtogeek.com/51807/how-to-create-and-use-global-system-environment-variables/).
```
QT_ROOT        C:\Your\Path\To\This\Qt\5.10.1
```

If you prefer not to set the environment variable, you can also provide the Qt path directly when running CMake
```
cmake .. -A x64 -DQT_ROOT="C:\Your\Path\To\This\Qt\5.10.1"
```

Referring to `QT_ROOT` make switching between `x64` and `x86` builds as simple as changing a flag.

```
cmake .. -A x64                     # Normal 64-bit build
cmake ..                            # 32-bit build
```

But does come with a few caveats. We chose the `msvc2017_64` distribution for `x64` and the `msvc2015` distribution for `x86`.
If these choices don't align with your Visual Studio installation, you'll need to modify the `######## Qt ########` section of the root `CMakeLists.txt`.

We would be interested in implementing something waterfall-ish (see below), but chose to leave it out unless needed.

```cmake
if (WIN32 AND NOT DEFINED Qt5_DIR)
    if(64BIT)
        if (EXISTS "${QT_ROOT}\\msvc2017_64")
            set (Qt5_DIR "${QT_ROOT}\\msvc2017_64\\lib\\cmake\\Qt5")
        elseif (EXISTS "${QT_ROOT}\\msvc2015_64")
            set (Qt5_DIR "${QT_ROOT}\\msvc2015_64\\lib\\cmake\\Qt5")
            # Cascade any others you might need
        endif ()
    else ()
        if (EXISTS "${QT_ROOT}\\msvc2015")
            set (Qt5_DIR "${QT_ROOT}\\msvc2015\\lib\\cmake\\Qt5")
        elseif (EXISTS "${QT_ROOT}\\msvc2013")
            set (Qt5_DIR "${QT_ROOT}\\msvc2013\\lib\\cmake\\Qt5")
            # Cascade any others you might need
        endif ()
    endif ()

    message (STATUS "Qt5_DIR: ${Qt5_DIR}")
endif ()
```


Boost is also required on all platforms. Prebuilt Windows binaries can be found at https://dl.bintray.com/boostorg/release/1.67.0/binaries.
We currently use the `msvc-all-32-64` option to download all versions or just `msvc-14.1-32` and `msvc-14.1-64` depending on your system.

Once installed, add the following environment variable to Windows:
```
BOOST_ROOT        C:\Your\Path\To\boost
```

or pass the following option to CMake:
```
cmake .. -DBOOST_ROOT="C:\Your\Path\To\boost"
```


#### OSX ####

We recommend installing all packages via the [HomeBrew](https://brew.sh) package manager.
```
brew install qt
brew install cmake
brew install boost
brew install lcov # Used for code coverage
```

In order to function properly, CMake needs the Qt's `bin` folder on the path.
For one-time-use, this can be accomplished using the command:
```
export PATH=/usr/local/opt/qt/bin:${PATH}
```
For extended use, this can be configured in your [`~/.bashrc`](https://stackoverflow.com/questions/4952177/include-additional-files-in-bashrc).

To check your Qt version and to ensure Qt is on the path, you can run:
```
qmake -v
```
which should generate something similar to:
```
QMake version 3.1
Using Qt version 5.11.0 in /usr/local/Cellar/qt/5.11.0/lib
```

You can also install Qt/Qt Creator via their standard GUI installer.


#### Linux ####

If the package manager on your system has Qt 5.10+, you can install it that way. If not, you can install via Qt's standard GUI installer.

As with OSX, Qt's `bin` directory should be on your path. Most package managers take care of this for you.

If you're looking to setup Linux-based CI with Qt 5.10+, we've experienced the struggle and would be happy to assist [privately](mailto:dev.symboxtra@gmail.com).


To install boost on Linux, run the following command:
```
sudo apt install libboost-all-dev
```


#### Troubleshooting ####

If things aren't working out (especially runtime crashes), exporting the following variables can help point things in the right direction.

```
export LD_LIBRARY_PATH=$HOME/qt/5.10.1/gcc_64/lib       # Show linker where to link
export QT_PLUGIN_PATH=$HOME/qt/5.10.1/gcc_64/plugins    # Find the plugins for plugging
export QML_IMPORT_PATH=$HOME/qt/5.10.1/gcc_64/qml       # Old QML module location
export QML2_IMPORT_PATH=$HOME/qt/5.10.1/gcc_64/qml      # QML module location
```

Or to get a better idea of what the trouble is:
```
export QT_DEBUG_PLUGINS=1
export QT_IMPORT_TRACE=1
```

**Note**: Since we use some of the newer features of Qt Quick, we've found that Qt version 5.10+ is REQUIRED and is not supplied by the popular `apt` package manager on Ubuntu.
You can check your Qt version by running `qmake -v`.

If you experience any problems finding boost, check the following variables and make sure they are correct for your system:

```
export BOOST_LIBRARYDIR=/Path/to/boost/lib64-msvc-14.1    # Path to boost libraries
export BOOST_INCLUDE_DIRS=/Path/to/boost                  # Path to boost to indicate includes
```



## Building ##

The best option to keep your source clean is to perform an out-of-source build.
This ensures that all build artifacts remain separate from the source, typically in a subdirectory named `build`.
Hence the common set of commands:

```
mkdir build         # Create the directory
cd build            # Move into the directory
cmake ..            # Call CMake on the upper source directory
cmake --build .     # Build the generated CMake files
```

To start fresh, simply remove the build directory and repeat the process.

```
rm -r ./build
```

The folder does not have to be named build and multiple build folders can coexist.
For example (Windows):
```
mkdir build-win32    # Create directory for 32-bit build
cd build-win32       # Move into the directory
cmake ..             # Call CMake on the upper source directory, specifying the path to the 32-bit Qt installation
cmake --build .      # Build the generated CMake files

cd ..

mkdir build-win64   # Create directory for 64-bit build
cd build-win64      # Move into the directory
cmake .. -A x64     # Call CMake on the upper source directory, specifying 64-bit
cmake --build .     # Build the generated CMake files
```

To create a Release build, use the `DCMAKE_BUILD_TYPE` flag when generating and the `--config Release` when building.
```
cmake .. -DCMAKE_BUILD_TYPE=Release
cmake --build . --config Release
```



## Testing ##

Unit tests are managed via CTest and written using the Google Test framework. All test source is stored under the `src/test` directory.
Each `.cpp` file in the directory is compiled and output to `bin/test`.

The tests can be run independently as normal executables or as a complete suite using:
```
ctest -V
```
or (the configuration type is required on Windows)
```
ctest -V -C Debug
```
**Note**: **Must be in the `build` directory. NOT `bin`**

### Continuous Integration (CI) ###

The two CI services for this project, Travis (Linux/OSX) and AppVeyor (Windows), handle the automated building and testing of the application after every push to GitHub.

- Travis: https://travis-ci.org/symboxtra/SplitSound-Desktop/builds
- AppVeyor: https://ci.appveyor.com/project/symboxtra/splitsound-desktop/history

The configuration for each service is stored in the respective `.yml` files in the repository root.



## Code Coverage ##

Code coverage is calculated via a combination of `gcov` and `lcov` on Linux and OSX, and OpenCppCoverage on Windows.

Coverage data is uploaded to and tracked on [codecov.io](https://codecov.io/gh/symboxtra/SplitSound-Desktop).
The CI server performs the upload after successfully running the test suite.

Since some of the code is platform dependent, 100% of it will never be run by any singular CI build.
To mitigate this, CodeCov handles merging the results from each of the individual platform builds, creating a unified coverage report.



## TL;DR ##

### Dependencies ###
- Qt 5.10+
- Boost 1.6+
- CMake 3.5+
- C++ Compiler (MSVC, GCC, Apple Clang)

### Commands ###
```
git clone https://github.com/symboxtra/SplitSound-Desktop
cd SplitSound-Desktop
git submodule update --init --recursive
mkdir build
cd build
cmake ..            # -A x64 for 64 bit
cmake --build .   
ctest -V            # Windows: ctest -C Debug -V
./bin/splitsound.exe
```
