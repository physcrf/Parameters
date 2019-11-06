# Parameters
[![Version Badge](https://img.shields.io/badge/version-0.1-brightgreen.svg)](https://github.com/physcrf/Parameters)

Typed parameters and input utilities for Julia.

## Introduction 

It is common to define global parameters and then read them from input
files or command line when programming, and to write this part of code
for every project is cumbersome. This package allows one to define
typed parameters and read them according to their types.

## Installation 
This package is not in a registry, you can install it by URL:
```julia
(v1.2) pkg> add https://github.com/physcrf/Parameters
```

## Usage 
### Allocate an `Params` object
Since defining global typed parameters is not allowed, one use an
object of type `Params` to contain parameters. An `Params` object is
allocated by its constructor:
```julia
using Parameters
params = Params()
```
At this time (and when you type `params` in REPL), the output should be 
```julia
Empty Parameter List
```

### Define parameters
To define a typed parameter in `params` one can use function `define`
whose declaration is:
#### [function] define(params::Params, name::String, type::DataType, default = 0, documentation = "")

Here `name` is the parameter name, `type` is the corresponding type,
`default` is the default value and `documentation` is the
documentation string. 

Supported types are `Bool, Number, String, Array{T,1} where T`, note
that only numeric array is supported (`T` must be a subtype of
`Number`).

For example, to define parameters:
```julia
define(params, "A", Int64)
define(params, "B", Float64, 1)
define(params, "C", Complex{Float64}, 2+1im, "A complex number")
define(params, "D", String, "hello", "A string")
define(params, "E", Array{Float64,1}, [1,2], "A float array")
```

Note that since Julia does not support fixed size array yet, only
one-dimensional numeric array is acceptable.

At this time, if one type `params`, the output should be:
```julia
Parameter List with 5 entries:
  A::Int64 = 0 # 
  B::Float64 = 1.0 # 
  C::Complex{Float64} = 2.0 + 1.0im # A complex number
  D::String = hello # A string
  E::Array{Float64,1} = [1.0, 2.0] # A float array
```

### Access elements in a `Params` object
To access an element in a `Params` object is similar to `Dict`:
```julia
params["A"]
```
It is writable:
```julia
params["A"] = 0
```

### Read parameters from an input file
Prepare an input file, for instance, let us write a file with name
`input` whose content is
```
A = 1 # this is comment 

  B = 1.5 ! this is also comment
  C = 1+5im # a complex floating number
D = hello, world 
this line cannot be recognized and should be ignored
E = 1,2,3,4,5 # an array with five elements
```
then to read from this file, just type
```julia
read(params, "input")
```
Note that elements of an array should be separated by comma.

After the read and type `params`, the output should be
```julia
Parameter List with 5 entries:
  A::Int64 = 1 # 
  B::Float64 = 1.5 # 
  C::Complex{Float64} = 1.0 + 5.0im # A complex number
  D::String = hello, world # A string
  E::Array{Float64,1} = [1.0, 2.0, 3.0, 4.0, 5.0] # A float array
```

### Read parameters from command line
Julia store command line options in variable `ARGS`, to read from it
simply type:
```julia
read(params, ARGS)
```

Then you may type something like `julia test.jl A=1` or `julia test.jl
--A=1` in the shell to give values to `params`.

### Undefine parameters
To undefine a parameter in `Params` object, just type:
```julia
undefine(params, "A")
```
The parameter entry with name `A` is then removed.

### Miscellaneous
#### [function] list(params::Params)
This function returns all `Variable` in `params`.
#### [function] Base.names(params::Params)
This function returns all parameter names in `params`.
