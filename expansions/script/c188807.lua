--盖理的枯蛾·厄尔特
function c188807.initial_effect(c)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(188807,2))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,188807)
	e1:SetTarget(c188807.sptg)
	e1:SetOperation(c188807.spop)
	c:RegisterEffect(e1)
	--link summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(188807,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,088807)
	e2:SetCondition(c188807.lkcon)
	e2:SetTarget(c188807.lktg)
	e2:SetOperation(c188807.lkop)
	c:RegisterEffect(e2)
end
function c188807.ckfil(c)
	return (c:IsSetCard(0x3f38) and c:IsType(TYPE_MONSTER) and not c:IsCode(188807)) or c:IsCode(15000700)
end
function c188807.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and eg:IsExists(c188807.ckfil,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c188807.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=0
	if c:IsLocation(LOCATION_GRAVE) then 
	op=1
	end
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and op==1 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
	end
end
function c188807.lkcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c188807.spfil(c,e,tp,rc)
	return c:IsCode(188808) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SPECIAL+188807,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,rc,c)>0
end
function c188807.lktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	local b=#mg==mg:GetClassCount(Card.GetAttribute) and #mg==mg:GetClassCount(Card.GetRace) and e:GetHandler():IsReleasable() and Duel.IsExistingMatchingCard(c188807.spfil,tp,LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler()) 
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,nil,nil) or b end
	if b then
		e:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON)
		e:SetLabel(1)
	else e:SetLabel(0) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c188807.lkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(c188807.spfil,tp,LOCATION_EXTRA,0,nil,e,tp,c)
	local g2=Duel.GetMatchingGroup(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,nil,nil)
	if e:GetLabel()==1 and c:IsRelateToEffect(e) and c:IsReleasable() and #g1>0 and Duel.SelectYesNo(tp,aux.Stringid(188807,1)) then
		if Duel.Release(e:GetHandler(),REASON_EFFECT)~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g1:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	elseif #g2>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g2:Select(tp,1,1,nil)
		Duel.LinkSummon(tp,sg:GetFirst(),nil,c)
	end
end
