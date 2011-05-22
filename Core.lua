local LES = LibStub:GetLibrary("LibEnchantScroll-1.0")
local skilletTUJ = {}
local o = {}
local timeoffset

local GOLD="ffd100"
local SILVER="e6e6e6"
local COPPER="c8602c"
local goldFmt = "|cff%s%d|cff000000.|cff%s%02d|cff000000.|cff%s%02d|r"
local silverFmt = "|cff%s%d|cff000000.|cff%s%02d|r"
local copperFmt = "|cff%s%d|r"

local function FormatGold(coppers)
	coppers = math.floor(tonumber(coppers) or 0)
	local g = math.floor(coppers / 10000)
	local s = math.floor(coppers % 10000 / 100)
	local c = coppers % 100

	if g > 0 then
		return string.format(goldFmt, GOLD, g, SILVER, s, COPPER, c)
	elseif s > 0 then
		return string.format(silverFmt, SILVER, s, COPPER, c)
	else
		return string.format(copperFmt, COPPER, c)
	end

end

-- Main plugin entry point
-- returns: label, text
-- skill is a table that contains info about the selected skill
--   { itemID [number], name [string], numMade [number], reagentData [table], spellID [number], tools [table], tradeID [number], vendorOnly [bool] }
-- recipe seems to be blank most of the time
function skilletTUJ:GetExtraText(skill, recipe)
	local spellId = skill.spellID
	if spellId then
		local scrollId = LES:GetScrollForEnchant(spellId)
		TUJMarketInfo(scrollId,o)

		local s1, s2 = "The Undermine Journal\n", "\n"

		-- Last updated time
		if o.age then
			s1 = s1 .. "As of\n"
			s2 = s2 .. SecondsToTime(o.age, o.age>60) .. " ago\n"
		end

		-- Market Latest
		if o.market then
			s1 = s1 .. "Market Latest\n"
			s2 = s2 .. FormatGold(o.market) .. "\n"
		end


		-- Market Mean
		if o.marketaverage then
			s1 = s1 .. "Market Mean\n"
			s2 = s2 .. FormatGold(o.marketaverage) .. "\n"
		end

		-- Market Std Dev
		if o.marketstddev then
			s1 = s1 .. "Market Std Dev\n"
			s2 = s2 .. FormatGold(o.marketstddev) .. "\n"
		end

		-- Reagent cost
		if o.reagentprice then
			s1 = s1 .. "Reagents Latest\n"
			s2 = s2 .. FormatGold(o.reagentprice) .. "\n"
		end


		-- Qty AVailable
		if o.quantity then
			s1 = s1 .. "Qty Available\n"
			s2 = s2 .. o.quantity .. "\n"
		end

		local c = "|cff"
		local margin = (o.market - o.reagentprice) / o.market
		if margin < 0 then
			c = c .. "ff0000"
		elseif margin == 0 then
			c = c .. "ffff00"
		else
			c = c .. "00ff00"
		end
		s1 = s1 .. "Profit margin\n"
		s2 = s2 .. c .. string.format("%0.02f", margin * 100) .. "|r%"

		return s1, s2
	end
end

Skillet['SkilletTUJ'] = skilletTUJ
Skillet:RegisterDisplayDetailPlugin("SkilletTUJ")

