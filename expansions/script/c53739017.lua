local m=53739017
local cm=_G["c"..m]
cm.name="沙沼卫士 詹纳萝丝"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(cm.destg)
	e1:SetOperation(cm.desop)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE+CATEGORY_CONTROL)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(cm.rvcon)
	e3:SetTarget(cm.rvtg)
	e3:SetOperation(cm.rvop)
	c:RegisterEffect(e3)
end
function cm.desfilter(c,e,tp,tc)
	return c:IsFacedown() and ((tc:IsLocation(LOCATION_HAND) and Duel.GetMZoneCount(tp,tc)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)) or (tc:IsLocation(LOCATION_GRAVE) and tc:IsAbleToDeck()) or tc:IsLocation(LOCATION_MZONE))
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and cm.desfilter(chkc,e,tp,c) end
	if chk==0 then return Duel.IsExistingTarget(cm.desfilter,tp,LOCATION_ONFIELD,0,1,nil,e,tp,c) and c:GetFlagEffect(m)==0 and not c:IsStatus(STATUS_CHAINING) end
	if c:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) then c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,cm.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp,c)
	if c:IsLocation(LOCATION_HAND) then Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0) end
	if c:IsLocation(LOCATION_MZONE) then Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000) end
	if c:IsLocation(LOCATION_GRAVE) then Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	c:RegisterFlagEffect(m+50,RESET_EVENT+0x8580000+RESET_CHAIN,0,1)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.Destroy(tc,REASON_EFFECT)==0 then return end
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_HAND) then
		if c:GetFlagEffect(m+50)==0 then return end
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		Duel.ConfirmCards(1-tp,c)
	elseif c:IsLocation(LOCATION_MZONE) then
		Duel.Recover(tp,1000,REASON_EFFECT)
	elseif c:IsLocation(LOCATION_GRAVE) then
		if c:GetFlagEffect(m+50)==0 then return end
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	end
end
function cm.rvcon(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabel(e:GetHandler():GetPreviousControler())
	return bit.band(r,REASON_DESTROY)~=0
		and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
		and e:GetHandler():IsPreviousPosition(POS_FACEDOWN)
end
function cm.rvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_GRAVE)
end
function cm.ctfilter(c)
	return c:IsFaceup() and c:IsControlerCanBeChanged() and not c:IsRace(RACE_ROCK)
end
function cm.rvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local batk=c:GetBaseAttack()
	local bdef=c:GetBaseDefense()
	if c:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(bdef)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_BASE_DEFENSE)
		e2:SetValue(batk)
		c:RegisterEffect(e2)
		Duel.SpecialSummonComplete()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,1,nil)
		if #sg>0 and Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)~=0 and res~=0 and rp~=tp and tp==e:GetLabel() and Duel.IsExistingMatchingCard(cm.ctfilter,tp,0,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
			local tc=Duel.SelectMatchingCard(tp,cm.ctfilter,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
			if Duel.GetControl(tc,tp)~=0 then
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_CHANGE_RACE)
				e3:SetValue(RACE_ROCK)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
				tc:RegisterEffect(e3)
			end
		end
	end
end
