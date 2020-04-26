--战车道少女·蔷薇果
function c9910143.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910143)
	e1:SetCost(c9910143.spcost)
	e1:SetTarget(c9910143.sptg)
	e1:SetOperation(c9910143.spop)
	c:RegisterEffect(e1)
	--attack twice
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910143,0))
	e2:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetLabelObject(c)
	e2:SetCondition(c9910143.atcon)
	e2:SetCost(c9910143.atcost)
	e2:SetTarget(c9910143.attg)
	e2:SetOperation(c9910143.atop)
	c:RegisterEffect(e2)
end
function c9910143.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c9910143.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and c:IsAbleToDeck() end
end
function c9910143.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	if tc:IsSetCard(0x952) and tc:IsType(TYPE_MONSTER) then
		if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0
			and not tc:IsForbidden() then
			Duel.DisableShuffleCheck()
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e1=Effect.CreateEffect(c)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			tc:RegisterEffect(e1)
		end
	else
		if not c:IsRelateToEffect(e) then return end
		Duel.SendtoDeck(c,nil,0,REASON_EFFECT)
	end
end
function c9910143.atcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP()
end
function c9910143.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	local c=e:GetLabelObject()
	local g=e:GetHandler():GetOverlayGroup()
	if not g:IsContains(c) then return false end
	g:RemoveCard(c)
	if g:GetCount()==0 or (g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910143,1))) then
		Duel.SendtoGrave(c,REASON_COST)
	elseif Duel.SelectYesNo(tp,aux.Stringid(9910143,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
		local tg=g:Select(tp,1,1,nil)
		if tg:GetCount()>0 then
			Duel.SendtoGrave(tg,REASON_COST)
		end
	else e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST) end
end
function c9910143.atfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:GetEffectCount(EFFECT_EXTRA_ATTACK)==0
end
function c9910143.attg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c9910143.atfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9910143.atfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c9910143.atfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c9910143.atop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
