--深海的引导
function c29016278.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c29016278.target)
	e1:SetOperation(c29016278.activate)
	c:RegisterEffect(e1)
end
function c29016278.filter1(c)
	return c:IsRace(RACE_FISH) and c:IsSetCard(0x87af) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c29016278.filter2(c)
	return c:IsSetCard(0x67af) and c:IsType(TYPE_TRAP) and c:IsAbleToHand()
end
function c29016278.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29016278.filter1,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c29016278.filter2,tp,LOCATION_DECK,0,1,nil) and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c29016278.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT+REASON_DISCARD)~=1 then return false end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c29016278.filter1,tp,LOCATION_DECK,0,1,1,nil)
	local g1=Duel.SelectMatchingCard(tp,c29016278.filter2,tp,LOCATION_DECK,0,1,1,nil)
	g1:Merge(g1,g)
	if g1:GetCount()==2 then
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
