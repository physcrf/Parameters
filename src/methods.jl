function define(params::Params, name::String,
                type::DataType, default = 0,
                documentation="")
    if occursin(r"\s", name)
        error("Parameter name can not contain white space")
        return params
    end

    if !(type <: Number || type <: String || type <: Array{T, 1} where T)
        error("Parameter type must be Number, String or one dimensional Array")
        return params
    end

    if type <: Number
        variable = Variable(convert(type, default), type, documentation)
    elseif type <: String
        if !(typeof(default) <: String)
            variable = Variable("", type, documentation)
        else
            variable = Variable(default, type, documentation)
        end
    else
        if typeof(default) <: Array{T,1} where T
            variable = Variable(convert(type, default), type, documentation)
        else
            variable = Variable(type(undef,0), type, documentation)
        end
    end

    params.database[name] = variable
    params
end

function undefine(params::Params, name::String)
    delete!(params.database, name)
end

function Base.parse(params::Params, str::String)
    if match(r"^[^=]*=[^=]*([#!].*)?$", str) == nothing
        error("Unrecognized parameter line: ", str)
        return nothing
    end
    str = replace(str, r"[#!].*$" => s"")	# remove comments 
    str = strip(str)				# trim both sides
    (name,value) = split(str, r"\s*=\s*")		
    name = string(name)
    value = string(value)	# substring to string
    if params[name] == nothing
        error("Unknown parameter: ", name)
        return nothing
    end
    type = params.database[name].type
    params[name] = parse(type, value)
end

function Base.read(params::Params, filename::String)
    for line in readlines(filename)
        if match(r"^\s*$", line) == nothing
            parse(params, line)
        end
    end
    params
end

function Base.read(params::Params, args::Array{String,1}=ARGS)
    for arg in args
        if match(r"^[^=]+=[^=]+$", arg) != nothing
            arg = replace(arg, r"^\s*--" => s"")
            parse(params, arg)
        end
    end
end
