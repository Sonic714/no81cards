--战车道少女·阿银
dofile("expansions/script/c9910100.lua")
function c9910137.initial_effect(c)
	--special summon
	QutryZcd.SelfSpsummonEffect(c,0,true,nil,true,nil,true,nil)
	--xyzlv
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_XYZ_LEVEL)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetCondition(c9910137.lvcon)
	e2:SetValue(c9910137.xyzlv)
	c:RegisterEffect(e2)
end
function c9910137.lvcon(e)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_MZONE) or c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS 
end
function c9910137.xyzlv(e,c,rc)
	return 0x60000+e:GetHandler():GetLevel()
end
