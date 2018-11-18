# FEM for FDEs on 2D and 3D domains
This package implements the finite element method for fractional 
differential equations on 2D/3D domains in MATLAB. For more detail of
the algorithms, please see paper
[Zongze Yang, Zhanbin Yuan, Jungang Wang and Yufeng Nie.
_Finite element methods for fractional PDEs in three dimensions._](
https://arxiv.org/abs/1811.03339)

## Platform
    1. MATLAB 2017b
    2. MinGW64 Compiler or Microsoft Visual C++ 2017

## How to use

   1. Run `prepare_env` to prepare the environment.
   2. Run numerical examples in directory `examples`, such as `main_*.m`.

## Directory tree

    code/
      +-- core/                                     : 
          +-- build_mesh_info.m                     : building mesh information
          +-- assemble_matrix.m                     : mass or stiffness matrix
          +-- assemble_stiffness_matrix_riesz.m     : for Riesz derivatives
          +-- assemble_stiffness_matrix_normal.m    : for integer order derivatives
          +-- MyTimer.m                             : timer
          +-- get_path.m                            : searching integral paths
          +-- get_intersect_point.m                 : computing intersection points
      +-- examples/                                 : numerical examples
          +-- main_steady.m
          +-- main_transient.m
      +-- utils/                                    : for post-process
      +-- prepare_env.m                             : 
      +-- README.md

## License

MIT License

Copyright (c) 2019 Yang Zongze (yangzongze@gmail.com)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.