--玉桂·花信
function c16372008.initial_effect(c)
	--can not diseffect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,16372008)
	e1:SetCondition(c16372008.con)
	e1:SetCost(c16372008.cost)
	e1:SetTarget(c16372008.tg)
	e1:SetOperation(c16372008.op)
	c:RegisterEffect(e1)
	--setself
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCountLimit(1,16372008+100)
	e2:SetCondition(c16372008.setscon)
	e2:SetCost(c16372008.costoath)
	e2:SetTarget(c16372008.setstg)
	e2:SetOperation(c16372008.setsop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,16372008)
	e3:SetCondition(c16372008.spcon)
	e3:SetCost(c16372008.costoath)
	e3:SetTarget(c16372008.sptg)
	e3:SetOperation(c16372008.spop)
	c:RegisterEffect(e3)
	local e33=e3:Clone()
	e33:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e33)
	Duel.AddCustomActivityCounter(16372008,ACTIVITY_SPSUMMON,c16372008.counterfilter)
end
function c16372008.counterfilter(c)
	return c:IsRace(RACE_PLANT)
end
function c16372008.costoath(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(16372008,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c16372008.splimitoath)
	Duel.RegisterEffect(e1,tp)
end
function c16372008.splimitoath(e,c)
	return not c:IsRace(RACE_PLANT)
end
function c16372008.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c16372008.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost()
		and Duel.GetCustomActivityCount(16372008,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c16372008.splimitoath)
	Duel.RegisterEffect(e1,tp)
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function c16372008.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,16372008)==0 end
end
function c16372008.op(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_DISEFFECT)
	e1:SetValue(c16372008.effectfilter)
		Duel.RegisterFlagEffect(tp,16372008,RESET_PHASE+PHASE_END,0,1)
	if Duel.GetCurrentPhase()==PHASE_MAIN1 then
		e1:SetReset(RESET_PHASE+PHASE_MAIN1)
		Duel.RegisterFlagEffect(tp,16372008,RESET_PHASE+PHASE_MAIN1,0,1)
	else
		e1:SetReset(RESET_PHASE+PHASE_MAIN2)
		Duel.RegisterFlagEffect(tp,16372008,RESET_PHASE+PHASE_MAIN2,0,1)
	end
	Duel.RegisterEffect(e1,tp)
end
function c16372008.effectfilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	local tc=te:GetHandler()
	return tc:IsRace(RACE_PLANT) and Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_LOCATION)==LOCATION_MZONE
end
function c16372008.setscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c16372008.setstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c16372008.setsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
	if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
		local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		c:RegisterEffect(e1)
	end
end
function c16372008.filter(c,e,tp)
	return c:IsFaceup() and c:IsRace(RACE_PLANT) and e:GetHandler():GetColumnGroup():IsContains(c)and c:IsLevelAbove(1)
		and Duel.IsExistingMatchingCard(c16372008.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,c:GetLevel())
end
function c16372008.spfilter(c,e,tp,lv)
	return c:IsRace(RACE_PLANT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevel(lv)
end
function c16372008.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c16372008.filter,1,nil,e,tp)
		and e:GetHandler():GetType()==TYPE_SPELL+TYPE_CONTINUOUS
end
function c16372008.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c16372008.filter,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c16372008.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c16372008.filter,nil,e,tp)
	local sc=g:GetFirst()
	if #g>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		sc=g:Select(tp,1,1,nil)
	end
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c16372008.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,sc:GetLevel()):GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end