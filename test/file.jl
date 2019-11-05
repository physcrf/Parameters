push!(LOAD_PATH, "..")
using Parameters

params = Params()
define(params, "A", Int64, 1, "An integer")
define(params, "B", Float64, 2, "A floating number")
define(params, "C", Array{Bool,1}, [true], "A Bool array")
define(params, "D", Array{Complex{Float64},1}, [0], "A complex number array")
define(params, "E", String, "hello", "A string")

println("Before read from input file")
show(stdout, "text/plain", params)

read(params, "input")
println("After read from input file")
show(stdout, "text/plain", params)
