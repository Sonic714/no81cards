--魔惧会指挥 基里安
local m=40009665
local cm=_G["c"..m]
cm.named_with_Diablotherhood=1
function cm.Diablotherhood(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Diablotherhood
end
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,1,2)
	c:EnableReviveLimit()
	--spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,0))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,40009666)
	e6:SetCondition(cm.actcon)
	e6:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local mg=Duel.GetMatchingGroup(Card.IsAbleToDeckOrExtraAsCost,tp,LOCATION_REMOVED,0,nil)
		if chk==0 then return mg:GetCount()>=3 end
		local g=mg:Select(tp,3,3,nil)
		Duel.SendtoDeck(g,nil,2,REASON_COST)
	end)
	e6:SetTarget(cm.sptg)
	e6:SetOperation(cm.spop)
	c:RegisterEffect(e6)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.spcon1)
	e1:SetCost(cm.spcost1)
	e1:SetTarget(cm.sptg1)
	e1:SetOperation(cm.spop1)
	c:RegisterEffect(e1)	
end
function cm.dfilter(c)
	return c:IsFaceup() and c:IsCode(40010230)
end
function cm.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,40009560)>0 or Duel.IsExistingMatchingCard(cm.dfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.spfilter(c,e,tp)
	return cm.Diablotherhood(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function cm.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.spfilter1(c,e,tp)
	return c:IsCode(40009560) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter1,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function cm.spop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter1,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
