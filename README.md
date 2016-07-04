sokoban-solver
==============

## SMV

`screen2smv` converts a Sokoban `screen file` to a `smv` file that can be used by [NuSMV](http://nusmv.fbk.eu) to see if it is solvable.

### Usage
```sh
$ ./screen2smv.rb screen.2000 > screen.2000.smv
```

## Sylvan
`screen2cpp` converts a Sokoban `screen file` to a `cpp` file that can be compiled together with [Sylvan](https://github.com/utwente-fmt/sylvan) to solve it and get a solution.

### Usage
```sh
$ ./screen2cpp.rb screen.2000 > sokoban.cpp
$ g++ -O3 -g -Wall -std=gnu++11 -I../sylvan/src -c -o sokoban.o sokoban.cpp
$ g++ -O3 -g -Wall -std=gnu++11 -I../sylvan/src sokoban.o ../sylvan/src/libsylvan.a -lm -lhwloc -lpthread -o sokoban
$ ./sokoban
```
