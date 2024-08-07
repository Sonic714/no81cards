--魔 骸 魂 鸟  乌
local m=22348285
local cm=_G["c"..m]
function cm.initial_effect(c)
	--dd
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1)
	e2:SetTarget(c22348285.ddtg)
	e2:SetOperation(c22348285.ddop)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22348285,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
--  e3:SetCountLimit(1,22348285)
	e3:SetCondition(c22348285.dscon)
	e3:SetTarget(c22348285.dstg)
	e3:SetOperation(c22348285.dsop)
	c:RegisterEffect(e3)
	--Destroy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_ONFIELD)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(c22348285.descon2)
	e4:SetOperation(c22348285.desop2)
	c:RegisterEffect(e4)
	--Destroy
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_LEAVE_FIELD_P)
	e5:SetOperation(c22348285.checkop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetOperation(c22348285.desop)
	e6:SetLabelObject(e5)
	c:RegisterEffect(e6)
end
function c22348285.ddtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
end
function c22348285.ddop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c)
	local tc=g:GetFirst()
	if c:IsRelateToEffect(e) and tc then
		c:SetCardTarget(tc)
	end
end
function c22348285.checkop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsDisabled() then
		e:SetLabel(1)
	else e:SetLabel(0) end
end
function c22348285.desop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject():GetLabel()~=0 then return end
	local g=e:GetHandler():GetCardTarget()
	local tg=g:Filter(Card.IsLocation,nil,LOCATION_ONFIELD)
	if tg:GetCount()>0 then
		Duel.Destroy(tg,REASON_EFFECT)
	end
end
function c22348285.descon2(e,tp,eg,ep,ev,re,r,rp)
	local tg=e:GetHandler():GetCardTarget()
	local gc=Group.__band(eg,tg)
	return gc:GetCount()>0
end
function c22348285.desop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end




function c22348285.dscon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousControler(tp) and not (c:IsReason(REASON_EFFECT) and rp==tp and re:IsActivated())
end
function c22348285.filter(c)
	return c:IsSetCard(0x670a) and c:IsType(TYPE_TRAP+TYPE_SPELL) and c:IsSSetable()
end
function c22348285.dstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348285.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c22348285.dsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c22348285.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SSet(tp,g)~=0
			and c:IsRelateToEffect(e)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK)
			and Duel.SelectYesNo(tp,aux.Stringid(22348285,1)) then
			Duel.BreakEffect()
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_ATTACK)
		end
	end
end



