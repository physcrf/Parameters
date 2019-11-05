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

For example, to define an `Int64` with name `A`
without `default` and `documentation`:
```julia
define(params, "A", Int64)
```

To define a `Float64` with name `B` and
`default` and without `documentation`:
```julia
define(params, "B", Float64, 1)
```

To define a `Complex{Float64}` with name `C`, 
`default` and `documentation`:
```julia
define(params, "C", Complex{Float64}, 2+1im, "A complex number")
```

To define a `String` with name `D`:
```julia
define(params, "D", String, "hello", "A string")
```

It is also allowed to define array parameter. However, because Julie
does support fixed size array yet so here only one-dimensional array
is supported:
```julia
define(params, "E", Array{Float64,1}, [1,2], "A float array")
```

