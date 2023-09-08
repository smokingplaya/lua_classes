-- works on 5.4
require "luandum"

local playerClass = registerClass("Player")

function playerClass:main(p_Age, p_Name)
    argCheck({TYPE_INT, p_Age}, {TYPE_STRING, p_Name})

    addDefaults(self)

    self.onSet = function(_, var, value) println(var, " = ", value) end -- _ cause self already defined

    self:set("p_age", p_Age)
end

local player = newClass(CLASS_PLAYER, 6, "smokingplaya")
player:set("getBack", function(yappi_dor)
    println("getBack function; example var = ", yappi_dor)
end)

local getBackFunc = player:get("getBack")

getBackFunc(666)