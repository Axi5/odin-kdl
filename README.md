# Build Instructions

As a standalone package you can just run:
```
git clone --recurse-submodules https://github.com/Axi5/odin-kdl.git
```

To add to existing projects I recommend including this as a git submodule:
```
git submodule add https://github.com/Axi5/odin-kdl.git
git submodule update --init --recursive
```

You can build the ckdl binaries yourself following the instructions over at their [documentation page](https://ckdl.readthedocs.io/en/latest/index.html).
However this repo includes an odin build script that calls the CMake commands for you, just run:
```
odin run ./_build
```

To build debug binaries add `-define:CONFIGURATION=Debug`, this is set to `Release` by default.
To build statically add `-define:SHARED_LIB=OFF`

Once complete the package should contain the artifacts, a lib file in root if built statically, or dynamic libraries in `bin/Release`.

You should now be able to `import "kdl"` in odin and use it, be sure to copy the shared library to your executable folder.
