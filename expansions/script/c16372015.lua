--启灵元神·夏日风情
function c16372015.initial_effect(c)
	aux.AddCodeList(c,16372004,16372005,16372006)
	c:EnableReviveLimit()
	--special summon rule
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c16372015.sprcon)
	e0:SetTarget(c16372015.sprtg)
	e0:SetOperation(c16372015.sprop)
	c:RegisterEffect(e0)
	--tograve
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,16372015)
	e1:SetTarget(c16372015.tgtg)
	e1:SetOperation(c16372015.tgop)
	c:RegisterEffect(e1)
	--setself
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCountLimit(1,16372015+100)
	e2:SetCondition(c16372015.setscon)
	e2:SetTarget(c16372015.setstg)
	e2:SetOperation(c16372015.setsop)
	c:RegisterEffect(e2)
	--revive
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c16372015.spellcon)
	e3:SetCost(c16372015.spcost2)
	e3:SetTarget(c16372015.sptg2)
	e3:SetOperation(c16372015.spop2)
	c:RegisterEffect(e3)
end
c16372015.spchecks=aux.CreateChecks(Card.IsCode,{16372004,16372005,16372006})
function c16372015.sprfilter(c,tp)
	return c:IsFaceup() and c:IsAbleToGraveAsCost()
end
function c16372015.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c16372015.sprfilter,tp,LOCATION_ONFIELD,0,nil)
	return g:CheckSubGroupEach(c16372015.spchecks,aux.mzctcheck,tp)
end
function c16372015.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c16372015.sprfilter,tp,LOCATION_ONFIELD,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroupEach(tp,c16372015.spchecks,true,aux.mzctcheck,tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c16372015.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoGrave(g,REASON_SPSUMMON)
	g:DeleteGroup()
end
function c16372015.tgfilter(c)
	return c:IsFaceup() and c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS
end
function c16372015.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c16372015.tgfilter,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectTarget(tp,c16372015.tgfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g1,2,0,0)
end
function c16372015.cfilter(c,tp)
	return c:IsPreviousControler(tp) and c:GetOriginalType()&0x1>0 and c:IsSetCard(0xdc1) and c:IsLocation(LOCATION_GRAVE)
end
function c16372015.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 and Duel.SendtoGrave(tg,REASON_EFFECT)>0 then
		if tg:IsExists(c16372015.cfilter,1,nil,tp)
			and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(16372015,0)) then
			local tg2=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
			Duel.SendtoGrave(tg2,REASON_EFFECT)
		end
	end
end
function c16372015.setscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c16372015.setstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c16372015.setsop(e,tp,eg,ep,ev,re,r,rp)
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
function c16372015.spellcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetType()==TYPE_SPELL+TYPE_CONTINUOUS
end
function c16372015.cfilter2(c)
	return c:IsAbleToGraveAsCost() and c:IsSetCard(0xdc1) and c:GetOriginalType()&TYPE_MONSTER>0
end
function c16372015.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c16372015.cfilter2,tp,LOCATION_SZONE,0,3,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c16372015.cfilter2,tp,LOCATION_SZONE,0,3,3,c)
	Duel.SendtoGrave(g,REASON_COST)
end
function c16372015.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c16372015.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end