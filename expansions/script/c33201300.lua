--魇魔的殂世
VHisc_BeastHell=VHisc_BeastHell or {}
VHisc_Bh=VHisc_Bh or {}
---------------Functions and Filters--------------------

function VHisc_Bh.ck(ec)
	return ec.VHisc_BeastHell
end
---------------Register flip effect---------------
function VHisc_BeastHell.fler(ce,cid,efcate,efpro)
	local cs=_G["c"..cid]
	--flip
	local e0=Effect.CreateEffect(ce)
	e0:SetDescription(aux.Stringid(33201300,1))
	e0:SetCategory(efcate)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e0:SetProperty(efpro)
	e0:SetTarget(cs.fltg)
	e0:SetOperation(cs.flop)
	ce:RegisterEffect(e0)
end


function VHisc_BeastHell.gyer(ce,cid)
	--position
	local e1=Effect.CreateEffect(ce)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,cid)
	e1:SetTarget(VHisc_BeastHell.postg)
	e1:SetOperation(VHisc_BeastHell.posop)
	ce:RegisterEffect(e1)
end
function VHisc_BeastHell.posfilter(c)
	return c:IsFacedown() and c.VHisc_BeastHell
end
function VHisc_BeastHell.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and VHisc_BeastHell.posfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(VHisc_BeastHell.posfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,VHisc_BeastHell.posfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function VHisc_BeastHell.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) and tc:IsFacedown() then
		Duel.ChangePosition(tc,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE)
		if c:IsRelateToEffect(e) then 
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(1-tp,c)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
			e1:SetCondition(VHisc_BeastHell.effcon)
			e1:SetValue(VHisc_BeastHell.efilter)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
			c:RegisterFlagEffect(33201300,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(33201300,3))
		end
	end
end
function VHisc_BeastHell.effcon(e)
	return e:GetHandler():IsFacedown()
end
function VHisc_BeastHell.efilter(e,te)
	return VHisc_Bh.ck(te:GetHandler())
end


function VHisc_BeastHell.hand(ce,cid)
	--position
	local e1=Effect.CreateEffect(ce)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,cid)
	e1:SetCost(VHisc_BeastHell.hsetc)
	e1:SetTarget(VHisc_BeastHell.hsettg)
	e1:SetOperation(VHisc_BeastHell.hsetop)
	ce:RegisterEffect(e1)
end
function VHisc_BeastHell.hsetc(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function VHisc_BeastHell.hsetft(c,e,tp)
	return c.VHisc_BeastHell and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function VHisc_BeastHell.hsettg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(VHisc_BeastHell.hsetft,tp,LOCATION_HAND,0,1,e:GetHandler(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,0)
end
function VHisc_BeastHell.hsetop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,VHisc_BeastHell.hsetft,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE) then
		Duel.BreakEffect()
		local tc=g:GetFirst()
		Duel.ChangePosition(tc,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE)
	end
end
------------------------------------------------------------------------------------------


-------------------------card effect------------------------------

local m=33201300
local cm=_G["c"..m]
if not cm then return end
cm.VHisc_BeastHell=true
function cm.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--lock zones
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_FLIP)
	e1:SetRange(LOCATION_FZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.lztg)
	e1:SetOperation(cm.lzop)
	c:RegisterEffect(e1)
	--flip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(cm.ffcon)
	e2:SetTarget(cm.fftg)
	e2:SetOperation(cm.ffop)
	c:RegisterEffect(e2)
	--ShuffleSetCard
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(cm.sftg)
	e3:SetOperation(cm.sfop)
	c:RegisterEffect(e3)
end

--e1
function cm.lztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end
	local dis=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,0xe000e0)
	Duel.SetTargetParam(dis)
	Duel.Hint(HINT_ZONE,tp,dis)
end
function cm.lzop(e,tp,eg,ep,ev,re,r,rp)
	local zone=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if tp==1 then
		zone=((zone&0xffff)<<16)|((zone>>16)&0xffff)
	end
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_FZONE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetValue(zone)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end

--e2
function cm.ffilter(c,tp)
	return c:IsFacedown() and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)
end
function cm.cfilter(c,tp)
	return c:IsControler(1-tp) and c:GetColumnGroup():IsExists(cm.ffilter,1,nil,tp)
end
function cm.ffcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.fftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,0)
end
function cm.ffop(e,tp,eg,ep,ev,re,r,rp)
	local fg=eg:GetFirst():GetColumnGroup():Filter(cm.ffilter,nil,tp)
	if fg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
		local fc=fg:Select(tp,1,1,nil):GetFirst()
		Duel.ChangePosition(fc,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE)
	end
end

--e3
function cm.sftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_MZONE,0,nil)>1 end
end
function cm.sfop(e,tp,eg,ep,ev,re,r,rp)
	local sfg=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_MZONE,0,nil)
	if sfg:GetCount()>0 then 
		Duel.ShuffleSetCard(sfg)
	end
end
