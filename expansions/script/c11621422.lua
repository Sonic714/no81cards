--桃源乡的乐不思蜀
local m=11621422
local cm=_G["c"..m]
function c11621422.initial_effect(c)
	aux.AddCodeList(c,11621403)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)	
end
function cm.cfilter1(c)
	return c:IsSetCard(0x5220) and c:IsFaceup() and c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER)
end
function cm.cfilter2(c)
	return c:IsCode(11621403) and c:IsFaceup() and c:IsControler(c:GetOwner())
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local TY1=TYPE_MONSTER 
	if Duel.IsExistingMatchingCard(cm.cfilter2,tp,0,LOCATION_MZONE,1,nil) then
		TY1=TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP
	end
	return rp~=tp and re:IsActiveType(TY1) and Duel.IsChainNegatable(ev) and Duel.IsExistingMatchingCard(cm.cfilter1,tp,LOCATION_MZONE,0,1,nil)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local ec=re:GetHandler()
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		ec:CancelToGrave()
		Duel.SendtoDeck(ec,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end