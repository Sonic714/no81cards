--怒れる嵐の神碑
local m=91030009
local cm=c91030009
function c91030009.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE+TIMING_DRAW_PHASE,TIMING_END_PHASE)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	 return (Duel.GetCurrentPhase()~=PHASE_MAIN1 and Duel.GetCurrentPhase()~=PHASE_MAIN2) or Duel.GetTurnPlayer()~=tp
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x9d3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c,0x60)>0
end
function cm.filter1(c,e,tp)
	return c:IsLevel(4) and c:IsSetCard(0x9d3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.filter2(c,e,tp)
	return c:IsType(TYPE_LINK) and c:IsSetCard(0x9d3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) or  Duel.IsExistingMatchingCard(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,nil,nil) or Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp)   end
	local b1=Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) 
	local b2=Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	local b3=Duel.IsExistingMatchingCard(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,nil,nil)
	 local op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(m,0)},
			{b2,aux.Stringid(m,1)},
			{b3,aux.Stringid(m,2)})
	if op==1 then 
	local g=Duel.SelectTarget(tp,cm.filter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e:SetCategory(CATEGORY_SPECIAL_SUMMON)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)	
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
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(1)>0  then
	 local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and
		 Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_QUICKPLAY)>=3
		and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		local g=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
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
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_QUICKPLAY)
end
function cm.regop1(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabelObject():GetLabel()
	e:GetLabelObject():SetLabel(ct+1)
end
function cm.regop2(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabelObject():GetLabel()
	if ct==0 then ct=1 end
	e:GetLabelObject():SetLabel(ct-1)
end
function cm.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabel()>0
end
function cm.gselect(g,ft)
	local fc=g:FilterCount(Card.IsType,nil,TYPE_FIELD)
	return fc<=1 and aux.dncheck(g) and #g-fc<=ft
end
function cm.setfilter(c)
	return  c:IsType(TYPE_QUICKPLAY) and c:IsSSetable() and c:IsSetCard(0x9d3)
end
function cm.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.setfilter),tp,LOCATION_GRAVE,0,nil)
	local ct=e:GetLabel() 
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if #g==0 or ct==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tg=g:SelectSubGroup(tp,cm.gselect,false,1,math.min(ct,ft),ft)
	if Duel.SSet(tp,tg)==0 then return end
	local tc=tg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(LOCATION_REMOVED)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		tc:RegisterEffect(e1)
		tc=tg:GetNext()
	end
end
function cm.lfilter(c)
	return c:IsLinkSummonable(nil)
end
