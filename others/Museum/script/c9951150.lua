--妖妖梦·幻想乡成立之日
function c9951150.initial_effect(c)
   --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9951150+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c9951150.target)
	e1:SetOperation(c9951150.activate)
	c:RegisterEffect(e1)
end
function c9951150.spfilter(c,e,tp)
	return c:IsSetCard(0x3bd2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9951150.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0,nil)<Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE,nil)
		and Duel.IsExistingMatchingCard(c9951150.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c9951150.setfilter(c)
	return c:IsSetCard(0x3bd2) and c:IsType(TYPE_SPELL) and c:IsSSetable()
end
function c9951150.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE,nil)-Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0,nil)
	if ft>0 and ct>0 then
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		ct=math.min(ct,ft)
		local g=Duel.GetMatchingGroup(c9951150.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,ct)
		if sg and Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)>0
			and Duel.GetLP(tp)<=Duel.GetLP(1-tp)-2000
			and Duel.IsExistingMatchingCard(c9951150.setfilter,tp,LOCATION_DECK,0,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(9951150,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local tg=Duel.SelectMatchingCard(tp,c9951150.setfilter,tp,LOCATION_DECK,0,1,1,nil)
			Duel.SSet(tp,tg)
		end
	end
	if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c9951150.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9951150.splimit(e,c)
	return not c:IsSetCard(0x3bd2)
end

