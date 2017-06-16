cp ..\*.a src\leveldb /y
cd build
qmake ..\*.pro -r -spec win32-g++
mingw32-make -f Makefile.Release
