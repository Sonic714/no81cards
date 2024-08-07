local m=53799237
local cm=_G["c"..m]
cm.name="越限武装"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,PLAYER_ALL,LOCATION_MZONE)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local dg1=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,1-tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TODECK)
	local dg2=Duel.SelectMatchingCard(1-tp,Card.IsAbleToDeck,tp,LOCATION_MZONE,0,1,1,nil)
	dg1:Merge(dg2)
	Duel.HintSelection(dg1)
	Duel.SendtoDeck(dg1,nil,2,REASON_EFFECT)
end
