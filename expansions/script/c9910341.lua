--神树巫女 上里日向
function c9910341.initial_effect(c)
	--special summon self
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910341+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c9910341.sspcon)
	e1:SetOperation(c9910341.sspop)
	c:RegisterEffect(e1)
	--special summon other monsters
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9910342)
	e2:SetCost(c9910341.spcost)
	e2:SetTarget(c9910341.sptg)
	e2:SetOperation(c9910341.spop)
	c:RegisterEffect(e2)
end
function c9910341.thfilter(c,ft)
	local b1=ft>0
	local b2=c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:GetSequence()<5
	return c:IsAbleToHandAsCost() and (b1 or b2)
end
function c9910341.sspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local b1=ft>0
	local b2=ft>-1 and Duel.IsEnvironment(9910307,PLAYER_ALL,LOCATION_FZONE)
		and Duel.IsExistingMatchingCard(c9910341.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,ft)
	return Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)<Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD) and (b1 or b2)
end
function c9910341.sspop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local b1=ft>0
	local b2=ft>-1 and Duel.IsEnvironment(9910307,PLAYER_ALL,LOCATION_FZONE)
		and Duel.IsExistingMatchingCard(c9910341.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,ft)
	if b2 and (not b1 or Duel.SelectYesNo(tp,aux.Stringid(9910341,0))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectMatchingCard(tp,c9910341.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,ft)
		Duel.SendtoHand(g,nil,REASON_COST)
	end
end
function c9910341.costfilter(c,tp)
	return Duel.GetMZoneCount(tp,c)>0
end
function c9910341.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(REASON_COST,tp,c9910341.costfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(REASON_COST,tp,c9910341.costfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c9910341.spfilter(c,e,tp)
	return (c:IsSetCard(0x3956) or c:IsCode(9910352)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910341.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910341.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c9910341.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9910341.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
