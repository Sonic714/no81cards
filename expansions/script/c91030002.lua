--黄金の雫の神碑
local m=91030002
local cm=c91030002
function c91030002.initial_effect(c)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_END_PHASE+TIMING_DRAW_PHASE,TIMING_END_PHASE)  
	e2:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(cm.con)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	 return (Duel.GetCurrentPhase()~=PHASE_MAIN1 and Duel.GetCurrentPhase()~=PHASE_MAIN2) or Duel.GetTurnPlayer()~=tp
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x9d3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c,0x60)>0
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) or  Duel.IsExistingMatchingCard(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,nil,nil) or Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil)   end
	local b1=Duel.IsExistingMatchingCard(cm.filtern,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	local b3=Duel.IsExistingMatchingCard(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,nil,nil)
	 local op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(m,0)},
			{b2,aux.Stringid(m,1)},
			{b3,aux.Stringid(m,2)})
	if op==1 then 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	e:SetCategory(CATEGORY_TOGRAVE)
	if Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_QUICKPLAY)>=3 then
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,LOCATION_GRAVE+LOCATION_REMOVED)
	end
	e:GetHandler():RegisterFlagEffect(1,RESET_PHASE+PHASE_END,0,1)
	elseif op==2 then
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	e:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e:GetHandler():RegisterFlagEffect(2,RESET_PHASE+PHASE_END,0,1)
	elseif op==3 then
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	e:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e:GetHandler():RegisterFlagEffect(3,RESET_PHASE+PHASE_END,0,1)
	end
end
function cm.filter(c)
return c:IsSetCard(0x9d3) and c:IsAbleToGrave()
end
function cm.filter2(c)
return  c:IsSetCard(0x9d3) and c:IsSSetable() and c:IsType(TYPE_QUICKPLAY)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(1)>0  then
	 local g1=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
	if Duel.SendtoGrave(g1,REASON_EFFECT)~=0 and
		 Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_QUICKPLAY)>=3
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.filter2),tp,LOCATION_GRAVE,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.filter2),tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
		local tc=g:GetFirst()
		 Duel.SSet(tp,tc)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(LOCATION_REMOVED)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		tc:RegisterEffect(e1) end
	end
	c:ResetFlagEffect(1)
	elseif c:GetFlagEffect(2)>0  then
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,0x60)
	c:ResetFlagEffect(2)
	elseif c:GetFlagEffect(3)>0  then
	local g=Duel.SelectMatchingCard(tp,cm.lfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	   if #g>0 then Duel.LinkSummon(tp,g:GetFirst(),nil) end
	c:ResetFlagEffect(3)
	end
	 local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SKIP_M1)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e1:SetTargetRange(1,0)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SKIP_M2)
		Duel.RegisterEffect(e2,tp)
end
function cm.lfilter(c)
	return c:IsLinkSummonable(nil)
end
