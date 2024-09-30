--景元-天戈麾斥-
Duel.LoadScript("c60010000.lua")
local cm,m,o=GetID()
cm.isAvatar=true
function cm.initial_effect(c)
	MTC.AvatarCreate(c,m+1,LOCATION_MZONE)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.drcost)
	e2:SetTarget(cm.drtg)
	e2:SetOperation(cm.drop)
	c:RegisterEffect(e2)
end
function cm.spfil(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:CheckActivateEffect(true,true,false)==nil
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,c)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(cm.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoGrave(g,REASON_SPSUMMON)
end

function cm.drfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGraveAsCost()
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.drfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.drfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,99,nil)
	e:SetLabel(Duel.SendtoGrave(g,REASON_COST))
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummon(tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,1)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local num=99
	local l=e:GetLabel()
	Duel.ConfirmDecktop(tp,l)
	local g=Duel.GetDecktopGroup(tp,l):Filter(cm.spfilter,nil,e,tp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then num=1 end
	if g:GetCount()>0 then
		Duel.SpecialSummon(g:Select(tp,1,num,nil),0,tp,tp,false,false,POS_FACEUP)
	end
end













