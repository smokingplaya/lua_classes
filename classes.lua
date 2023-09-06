-- by smokingplaya 2023

local functionsIsTable = {"string", "number", "function"}

for k, v in ipairs(functionsIsTable) do
    _G["is" .. v] = function(value)
        return type(value) == v
    end
end

function isfloat(i)
    if not isnumber(i) then return false end

    local residue = i % 1

    return residue ~= 0 and residue < 1
end

function isint(i)
    if not isnumber(i) then return false end

    local residue = i % 1

    return residue == 0
end

function toint(v)
    v = tonumber(v)

    local residue = v % 1

    return v-residue
end

local msg_errors = {}

function msg_error_add(t, n)
    msg_errors[t] = n
end


msg_error_add("invalidArgument", "Argument(s) doesn't found.")
msg_error_add("syntaxError", "Incorrect syntax!")
msg_error_add("invalidType", "Invalid type of argument")
msg_error_add("wrongDataType", "Wrong data type!")

function msg_error(t)
    local msg = msg_errors[t]

    if not msg then msg_error("invalidArgument") end

    error(msg_errors[t])
end

--

function argCheck(t)
    if not t or #t == 0 then msg_error("invalidArgument") end

    for i, tt in ipairs(t) do
        local argType, argument = tt[1], tt[2]

        if not argType or not argument then msg_error("syntaxError") end

        local cachedTypeInG = _G["is" .. argType]

        if cachedTypeInG == nil then msg_error("invalidType") end

        if not cachedTypeInG(argument) then msg_error("wrongDataType") end
    end
end

--

local classTable = {}

function registerClass(t)
    t.__index = t

    classTable[t.name] = t

    return t.table
end

function newClass(t)
    local tab = t.table or {}

    setmetatable(tab, classTable[t.name])

    if tab.main then
        local args

        if t.main_args then
            args = t.main_args
        end

        tab.main(table.unpack(args))
    end

    return tab
end

function getClass(n)
    return classTable[n]
end

TYPE_STRING = "string"
TYPE_NUMBER = "number"
TYPE_FUNCTION = "function"
TYPE_FLOAT = "float"
TYPE_INT = "int"

--

registerClass {
    name = "Color",
    main = function(p_Age, p_Name)
        argCheck{ {TYPE_INT, p_Age}, {TYPE_STRING, p_Name} }
    end
}

local color1 = newClass {
    name = "Color",
    main_args = {6, "Anus"},
    table = {}
}
