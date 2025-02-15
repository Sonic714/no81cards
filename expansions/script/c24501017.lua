--神威骑士团出击！
function c24501017.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,24501017)
	e1:SetCost(c24501017.cost)
	--e1:SetTarget(c24501017.target)
	e1:SetOperation(c24501017.activate)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,24501018)
	e2:SetCondition(c24501017.discon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c24501017.distg)
	e2:SetOperation(c24501017.disop)
	c:RegisterEffect(e2)
end
function c24501017.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,c,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,c,tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function c24501017.activate(e,tp,eg,ep,ev,re,r,rp)
	local s=Duel.SelectOption(tp,aux.Stringid(24501017,0),aux.Stringid(24501017,1))
	if s==0 then
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetType(EFFECT_TYPE_FIELD)
		e0:SetCode(EFFECT_SET_POSITION)
		e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e0:SetTargetRange(LOCATION_MZONE,0)
		e0:SetTarget(c24501017.postg)
		e0:SetValue(POS_FACEUP_DEFENSE)
		e0:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,1)
		Duel.RegisterEffect(e0,tp)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(c24501017.postg)
		e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,1)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetValue(c24501017.efilter)
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e3:SetTargetRange(LOCATION_MZONE,0)
		e3:SetTarget(c24501017.postg)
		e3:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,1)
		Duel.RegisterEffect(e3,tp)
	else
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetType(EFFECT_TYPE_FIELD)
		e0:SetCode(EFFECT_SET_POSITION)
		e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e0:SetTargetRange(LOCATION_MZONE,0)
		e0:SetTarget(c24501017.postg)
		e0:SetValue(POS_FACEUP_ATTACK)
		e0:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,1)
		Duel.RegisterEffect(e0,tp)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x501))
		e1:SetValue(c24501017.atkval)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,1)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e2:SetTargetRange(LOCATION_MZONE,0)
		e2:SetTarget(c24501017.postg)
		e2:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,1)
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_PIERCE)
		e3:SetTargetRange(LOCATION_MZONE,0)
		e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x501))
		e3:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,1)
		Duel.RegisterEffect(e3,tp)
	end
end
function c24501017.postg(e,c)
	return c:IsSetCard(0x501)
end
function c24501017.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer() and re:IsActivated()
end
function c24501017.atkval(e,c)
	return c:GetAttack()*2
end
function c24501017.cfilter(c)
	return c:IsSetCard(0x501) and c:IsOnField() and c:IsFaceup()
end
function c24501017.discon(e,tp,eg,ep,ev,re,r,rp)
	local ex1,tg1=Duel.GetOperationInfo(ev,CATEGORY_TOHAND)
	local ex2,tg2=Duel.GetOperationInfo(ev,CATEGORY_TODECK)
	return (ex1 and tg1 and tg1:IsExists(c24501017.cfilter,1,nil))
		or (ex2 and tg2 and tg2:IsExists(c24501017.cfilter,1,nil))
end
function c24501017.relfilter(c)
	return c:IsSetCard(0x501) and c:IsOnField() and c:IsType(TYPE_SYNCHRO)
end
function c24501017.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup()
	if chk==0 then return Duel.CheckReleaseGroup(tp,c24501017.relfilter,1,nil,lg) end
	local g=Duel.SelectReleaseGroup(tp,c24501017.relfilter,1,1,nil,lg)
	Duel.Release(g,REASON_COST)
end
function c24501017.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsChainNegatable(ev) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c24501017.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
