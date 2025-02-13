--猛犸的墓场马甲
function c49811441.initial_effect(c)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,49811441)
	e2:SetCondition(c49811441.spcon)
	e2:SetCost(c49811441.spcost)
	e2:SetTarget(c49811441.sptg)
	e2:SetOperation(c49811441.spop)
	c:RegisterEffect(e2)
end
function c49811441.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.IsPlayerCanSpecialSummon(tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c49811441.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c49811441.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c49811441.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,e:GetHandler(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK)
end
function c49811441.spfilter(c,e,tp)
	return c:IsCode(40374923) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c49811441.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c49811441.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) then
			local c=e:GetHandler()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_DELAY)
			e1:SetCode(EVENT_SPSUMMON_SUCCESS)
			e1:SetCondition(c49811441.sgcon1)
			e1:SetOperation(c49811441.sgop1)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
			e3:SetCode(EVENT_SPSUMMON_SUCCESS)
			e3:SetCondition(c49811441.regcon)
			e3:SetOperation(c49811441.regop)
			e3:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e3,tp)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
			e3:SetCode(EVENT_CHAIN_SOLVED)
			e3:SetCondition(c49811441.sgcon2)
			e3:SetOperation(c49811441.sgop2)
			e3:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e3,tp)
			if not tc:IsType(TYPE_NORMAL) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetCode(EFFECT_CANNOT_ACTIVATE)
				e1:SetTargetRange(1,0)
				e1:SetValue(c49811441.limit)
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,tp)
			end
		end
	end
end
function c49811441.limit(e,re,tp)
	return not re:GetHandler():IsLocation(LOCATION_GRAVE)
end
function c49811441.sgcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c49811441.sgspfilter,1,nil,1-tp,re) and not Duel.IsChainSolving() and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3
end
function c49811441.sgop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,49811441)
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	local tc=Group.FilterSelect(g,tp,c49811441.sgfilter,1,1,nil):GetFirst()
	Duel.DisableShuffleCheck()
	Duel.SendtoGrave(tc,REASON_EFFECT)
	Duel.DisableShuffleCheck()
	Duel.SortDecktop(tp,tp,2)
	for i=1, 2 do
		local mg=Duel.GetDecktopGroup(tp,1)
		Duel.MoveSequence(mg:GetFirst(),SEQ_DECKBOTTOM)
	end
end
function c49811441.sgspfilter(c,sp,re)
	if re then
		local rc=re:GetHandler()
		return c:IsSummonPlayer(sp) and not rc:IsType(TYPE_SPELL+TYPE_TRAP)
	else
		return c:IsSummonPlayer(sp)
	end
end
function c49811441.sgfilter(c)
	return c:IsAbleToGrave()
end
function c49811441.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c49811441.sgspfilter,1,nil,1-tp,re) and Duel.IsChainSolving() and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3
end
function c49811441.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,49811441,RESET_CHAIN,0,1)
end
function c49811441.sgcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,49811441)>0
end
function c49811441.sgop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,49811441)
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	local tc=Group.FilterSelect(g,tp,c49811441.sgfilter,1,1,nil):GetFirst()
	Duel.DisableShuffleCheck()
	Duel.SendtoGrave(tc,REASON_EFFECT)
	Duel.DisableShuffleCheck()
	Duel.SortDecktop(tp,tp,2)
	for i=1, 2 do
		local mg=Duel.GetDecktopGroup(tp,1)
		Duel.MoveSequence(mg:GetFirst(),SEQ_DECKBOTTOM)
	end
	Duel.ResetFlagEffect(tp,49811441)
end