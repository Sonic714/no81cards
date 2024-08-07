--觅迹人法术 葱郁之灵
function c9911507.initial_effect(c)
	--spsummon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9911507+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c9911507.sprcon)
	e1:SetOperation(c9911507.sprop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9911507,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9911508)
	e2:SetCondition(c9911507.thcon1)
	e2:SetCost(c9911507.thcost)
	e2:SetTarget(c9911507.thtg1)
	e2:SetOperation(c9911507.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(9911507,1))
	e3:SetCode(EVENT_BECOME_TARGET)
	e3:SetCondition(c9911507.thcon2)
	e3:SetTarget(c9911507.thtg2)
	c:RegisterEffect(e3)
end
function c9911507.costfilter(c,tp)
	return not c:IsForbidden() and c:IsSetCard(0x5952) and c:GetType()==TYPE_CONTINUOUS+TYPE_SPELL and c:CheckUniqueOnField(tp)
end
function c9911507.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c9911507.costfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,tp)
end
function c9911507.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c9911507.costfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	if tc and Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(LOCATION_REMOVED)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		tc:RegisterEffect(e1,true)
	end
end
function c9911507.thcon1(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	local b1=Duel.IsPlayerAffectedByEffect(tp,9911506) and rc:IsControler(1-tp)
	local b2=Duel.IsPlayerAffectedByEffect(tp,9911511) and re:IsActiveType(TYPE_MONSTER) and bit.band(loc,LOCATION_HAND)~=0
	return b2 or ((b1 or rc:IsSetCard(0x5952)) and bit.band(loc,LOCATION_ONFIELD)~=0)
end
function c9911507.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c9911507.deckfilter(c,tp)
	return c:IsSetCard(0x5952) and c:IsType(TYPE_MONSTER) and c:IsReleasable()
		and Duel.IsExistingMatchingCard(c9911507.thfilter,tp,LOCATION_DECK,0,1,c)
end
function c9911507.thfilter(c)
	return c:IsSetCard(0x5952) and c:IsAbleToHand()
end
function c9911507.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	local fe=Duel.IsPlayerAffectedByEffect(tp,9911520)
	local b0=fe and Duel.IsExistingMatchingCard(c9911507.deckfilter,tp,LOCATION_DECK,0,1,nil,tp)
	local g=Duel.GetMatchingGroup(c9911507.thfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then
		if e:GetLabel()~=0 then
			e:SetLabel(0)
			return c:IsAbleToRemoveAsCost() and rc:IsRelateToEffect(re) and #g>0 and (rc:IsReleasable() or b0)
		else
			return #g>0
		end
	end
	if e:GetLabel()~=0 then
		e:SetLabel(0)
		Duel.Remove(c,POS_FACEUP,REASON_COST)
		if b0 and Duel.SelectYesNo(tp,aux.Stringid(9911520,1)) then
			Duel.Hint(HINT_CARD,0,9911520)
			fe:UseCountLimit(tp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local dg=Duel.SelectMatchingCard(tp,c9911507.deckfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
			Duel.Release(dg,REASON_COST)
			Duel.SendtoGrave(dg,REASON_RELEASE+REASON_COST)
		else
			Duel.Release(rc,REASON_COST)
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9911507.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9911507.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c9911507.tgcfilter1(c,check,re)
	if not c:IsOnField() or not c:IsRelateToEffect(re) then return false end
	local b0=c:IsFaceup() and c:IsSetCard(0x5952)
	return (b0 and c:IsControler(tp)) or (not b0 and check)
end
function c9911507.thcon2(e,tp,eg,ep,ev,re,r,rp)
	local check=Duel.IsPlayerAffectedByEffect(tp,9911509)
	return eg:FilterCount(c9911507.tgcfilter1,nil,check,re)>0
end
function c9911507.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local check=Duel.IsPlayerAffectedByEffect(tp,9911509)
	local sg=eg:Filter(c9911507.tgcfilter1,nil,check,re)
	local fe=Duel.IsPlayerAffectedByEffect(tp,9911520)
	local b0=fe and Duel.IsExistingMatchingCard(c9911507.deckfilter,tp,LOCATION_DECK,0,1,nil,tp)
	local g=Duel.GetMatchingGroup(c9911507.thfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then
		if e:GetLabel()~=0 then
			e:SetLabel(0)
			return c:IsAbleToRemoveAsCost() and #g>0 and (sg:FilterCount(Card.IsReleasable,nil,re)>0 or b0)
		else
			return #g>0
		end
	end
	if e:GetLabel()~=0 then
		e:SetLabel(0)
		Duel.Remove(c,POS_FACEUP,REASON_COST)
		if b0 and Duel.SelectYesNo(tp,aux.Stringid(9911520,1)) then
			Duel.Hint(HINT_CARD,0,9911520)
			fe:UseCountLimit(tp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local dg=Duel.SelectMatchingCard(tp,c9911507.deckfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
			Duel.Release(dg,REASON_COST)
			Duel.SendtoGrave(dg,REASON_RELEASE+REASON_COST)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local rg=sg:FilterSelect(tp,Card.IsReleasable,1,1,nil)
			Duel.Release(rg,REASON_COST)
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
