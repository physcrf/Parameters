function define(params::Params, name::String, type::DataType, default = 0,
                documentation = "")
    if occursin(r"\s", name)
        error("define: Parameter name can not contain white space")
    end

    if !(type <: Union{Bool, Number, String, Array{T, 1} where T})
        error("define: Unrecognized Parameter type:", type)
    end

    if type <: Array{T,1} where T && !(type.parameters[1] <: Union{Bool,Number})
        error("define: Parameter Array must be of Bool or Number.")
    end
        
    if type <: Union{Bool, Number}
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
    # If unrecognized, just ignore it
    if match(r"^[^=]*=[^=]*([#!].*)?$", str) == nothing
        return nothing
    end
    str = replace(str, r"[#!].*$" => s"")	# remove comments 
    str = strip(str)				# trim both sides
    (name,value) = split(str, r"\s*=\s*")		
    name = string(name)
    value = string(value)	# substring to string
    # If name is unknown, just ignore it
    if params[name] == nothing
        return nothing
    end
    
    type = params.database[name].type
    if type <: Union{Bool, Number}
        params[name] = parse(type, value)
    elseif type <: String
        params[name] = value
    else # array type
        arrayType = type.parameters[1]
        params[name] = map(x -> parse(arrayType, x), split(value, r"\s*,\s*"))
    end
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
