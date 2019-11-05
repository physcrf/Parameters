mutable struct Variable
    value
    type::DataType
    documentation::String
end

struct Params
    database::Dict{String, Variable}
end

Params()=Params(Dict{String, Variable}())

function Base.getindex(params::Params, name::String)
    name in keys(params.database) || return nothing
    params.database[name].value
end

function Base.setindex!(params::Params, value, name::String)
    if !(name in keys(params.database))
        error("Unknown parameter: ", name)
        return nothing
    end
    variable = params.database[name]
    variable.value = convert(variable.type, value)
end    

function Base.show(io::IO, ::MIME"text/plain", params::Params)
    if isempty(params.database)
        print(io, "Empty Parameter List")
    else
        klist = sort(collect(keys(params.database)))
        if length(klist) == 1
            println(io, "Parameter List with 1 entry:")
        else
            println(io, "Parameter List with ", length(klist), " entries:")
        end
        for key in klist
            variable = params.database[key]
            value = variable.value
            type = variable.type
            documentation = variable.documentation
            println(io, "  ", key, "::", type, " = ", value, ", ", documentation)
        end
    end
end

function list(params::Params)
    collect(keys(params.database))
end

