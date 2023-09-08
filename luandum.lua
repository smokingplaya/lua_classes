-- Luandum
-- made by smokingplaya

println = print

local functionsIsTable = {"string", "number", "function", "table", "userdata"}

for _, n in ipairs(functionsIsTable) do
    _G["is" .. n] = function(value)
        return type(value) == n
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

-- ERRORS

local msg_errors = {}

function msg_error_add(t, n)
    msg_errors[t] = n
end


msg_error_add("invalidArgument", "Argument(s) doesn't found.")
msg_error_add("syntaxError", "Incorrect syntax!")
msg_error_add("invalidType", "Invalid type of argument")
msg_error_add("wrongDataType", "Wrong data type!")
msg_error_add("nonExistentClass", "Attempting to use a non-existent class")

function msg_error(t, ...)
    local toFormat = {...}

    local msg = msg_errors[t]

    if not msg then msg_error("invalidArgument") end

    local msg = msg_errors[t]

    if #toFormat ~= 0 then
        msg = msg:format(...)
    end

    error(msg)
end

--

function argCheck(...)
    local t = {...}
    if not t or #t == 0 then msg_error("invalidArgument") end

    for i, tt in ipairs(t) do
        local argType, argument = tt[1], tt[2]

        if not argType or not argument then msg_error("invalidType") end

        local cachedTypeInG = _G["is" .. argType]

        if cachedTypeInG == nil then msg_error("invalidType") end

        if not cachedTypeInG(argument) then msg_error("wrongDataType") end
    end
end

-- function addDefaults(table CLASS)
-- example:
-- local player = newClass(CLASS_PLAYER, id64)
-- addDefaults(player)
-- player:set("nick", "smokingplaya")
-- println(player:get("nick")) -- => string "smokingplaya"
--
-- second example:
-- local player = newClass(CLASS_PLAYER, id64)
-- player.onSet = function(self)
--      println(self:get("nick"))
-- end
--
-- player:set("nick", "smokingplaya")
--
function addDefaults(t)
    local dataTable = {}

    argCheck({TYPE_TABLE, t})

    t.get = function(self, var)
        if self.onGet then self:OnGet(var) end
    
        return dataTable[var]
    end

    t.getDataTable = function()
        return dataTable
    end

    t.set = function(self, var, value)
        dataTable[var] = value

        if self.onSet then self:OnSet(var, value) end
    end
end

--

local classTable = {}

function registerClass(name, argumentName)
    if not argumentName then
        argumentName = name
    end

    local classTab = {}

    classTab.__index = classTab

    if argumentName then
        _G["CLASS_" .. argumentName:upper()] = argumentName
    end

    classTable[name] = classTab

    return classTab
end

function newClass(name, ...)
    local classTab = classTable[name]

    if not classTab then msg_error("nonExistentClass") end

    local tab = {}
    tab.__tostring = function()
        return "Luandum class " .. name
    end

    setmetatable(tab, classTable[name])

    if tab.main then tab:main(...) end

    return tab
end

-- function getClass
-- example:
-- local playerClass = getClass("Player")
-- function playerClass:newMethod(p_Frags)
--      argCheck({TYPE_INT, p_Frags})
--      self.frags = p_Frags
-- end
function getClass(n)
    return classTable[n]
end

TYPE_STRING = "string"
TYPE_NUMBER = "number"
TYPE_FUNCTION = "function"
TYPE_FLOAT = "float"
TYPE_INT = "int"
TYPE_TABLE = "table"
TYPE_USERDATA = "userdata"

-- EXAMPLE

local playerClass = registerClass("Player")

function playerClass:main(p_Age, p_Name)
    argCheck({TYPE_INT, p_Age}, {TYPE_STRING, p_Name})

    addDefaults(self)

    self.onSet = function()
        println(self:get("p_age"))
    end

    self:set("p_age", p_Age)
end

local player = newClass(CLASS_PLAYER, 6, "smokingplaya")
