--伪理之灵 间桐慎二
function c22022970.initial_effect(c)
	--return
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22022970,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,22022970)
	e1:SetTarget(c22022970.target)
	e1:SetOperation(c22022970.operation)
	c:RegisterEffect(e1)
	--add/ss rock monster
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22022970,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,22022971)
	e2:SetTarget(c22022970.thtg)
	e2:SetOperation(c22022970.thop)
	c:RegisterEffect(e2)
end
function c22022970.filter0(c)
	return c:IsSetCard(0x3ff1) and c:IsFaceup() and c:IsAbleToHand()
end
function c22022970.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c22022970.filter0(chkc) end
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c22022970.filter0,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c22022970.filter0,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c22022970.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end
function c22022970.filter(c,e,tp,check)
	return c:IsLevelBelow(3) and c:IsSetCard(0x6ff1) and (c:IsAbleToHand() or check and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c22022970.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local check=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and c:IsRelateToEffect(e) and c:IsPosition(POS_FACEUP) and c:IsSetCard(0x3ff1)
		return Duel.IsExistingMatchingCard(c22022970.filter,tp,LOCATION_DECK,0,1,nil,e,tp,check)
	end
end
function c22022970.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local check=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsRelateToEffect(e) and c:IsPosition(POS_FACEUP) and c:IsSetCard(0x3ff1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=Duel.SelectMatchingCard(tp,c22022970.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp,check):GetFirst()
	if tc then
		if check and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and (not tc:IsAbleToHand() or Duel.SelectOption(tp,1190,1152)==1) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end