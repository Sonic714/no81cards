--终结与开始 鹿目圆香
function c60151611.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c60151611.mfilter,3,2)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	local e11=Effect.CreateEffect(c)
	e11:SetCategory(CATEGORY_RECOVER+CATEGORY_ATKCHANGE)
	e11:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCode(EVENT_CHAIN_ACTIVATING)
	e11:SetOperation(c60151611.disop)
	c:RegisterEffect(e11)
	--addown
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60151611,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,60151611)
	e1:SetCost(c60151611.adcost)
	e1:SetTarget(c60151611.adtg)
	e1:SetOperation(c60151611.adop)
	c:RegisterEffect(e1)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(60151601,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCondition(c60151611.condition)
	e5:SetTarget(c60151611.target)
	e5:SetOperation(c60151611.operation)
	c:RegisterEffect(e5)
	--pendulum
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_EXTRA)
	e4:SetCountLimit(1,6011611)
	e4:SetCost(c60151611.cost)
	e4:SetCondition(c60151611.spcon)
	e4:SetTarget(c60151611.pentg)
	e4:SetOperation(c60151611.penop)
	c:RegisterEffect(e4)
end
c60151611.pendulum_level=3
function c60151611.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and re:IsActivated() and rc:IsSetCard(0xcb25)
end
function c60151611.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if e:GetHandler():IsLocation(LOCATION_EXTRA) then
		if chk==0 then return Duel.GetLocationCountFromEx(tp)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	else
		if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	end
end
function c60151611.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		if c:GetSummonLocation()==LOCATION_EXTRA then
			
		end
		c:RegisterFlagEffect(60151611,RESET_EVENT+RESETS_STANDARD,0,1)
	end
end
function c60151611.mfilter(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c60151611.afilter(c)
	return c:IsFaceup() and c:IsSetCard(0xcb25) and c:IsType(TYPE_MONSTER)
end
function c60151611.disop(e,tp,eg,ep,ev,re,r,rp)
	if not (re:IsActiveType(TYPE_MONSTER) and re:IsActivated()) then return end
	Duel.Hint(HINT_CARD,0,60151611)
	Duel.Recover(tp,300,REASON_EFFECT)
	local g=Duel.GetMatchingGroup(c60151611.afilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(100)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c60151611.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c60151611.filter(c)
	return c:IsFaceup()
end
function c60151611.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60151611.filter,tp,0,LOCATION_MZONE,1,nil) end
end
function c60151611.adop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c60151611.filter,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-(math.abs(Duel.GetLP(0)-Duel.GetLP(1))))
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
	if Duel.GetLP(tp)<Duel.GetLP(1-tp) then
		Duel.Recover(tp,(math.abs(Duel.GetLP(0)-Duel.GetLP(1)))/2,REASON_EFFECT)
	end
end
function c60151611.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFaceup()
end
function c60151611.cfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsAbleToGraveAsCost()
end
function c60151611.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60151611.cfilter,tp,LOCATION_EXTRA,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c60151611.cfilter,tp,LOCATION_EXTRA,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function c60151611.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c60151611.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end