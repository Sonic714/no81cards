--战地之王·加里奥
function c9980520.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsRace,RACE_ROCK),1)
	c:EnableReviveLimit()
	--cannot be link material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--move
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9980520,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c9980520.seqtg)
	e2:SetOperation(c9980520.seqop)
	c:RegisterEffect(e2)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9980520,2))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c9980520.discon)
	e1:SetTarget(c9980520.distg)
	e1:SetOperation(c9980520.disop)
	c:RegisterEffect(e1)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SUMMON_SUCCESS)
	e8:SetOperation(c9980520.sumsuc)
	c:RegisterEffect(e8)
	local e4=e8:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--atkup
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(c9980520.atkval)
	c:RegisterEffect(e5)
end
function c9980520.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980520,3))
end
function c9980520.seqfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_ROCK)
end
function c9980520.seqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9980520.seqfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9980520.seqfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9980520,1))
	Duel.SelectTarget(tp,c9980520.seqfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c9980520.seqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
	Duel.MoveSequence(tc,nseq)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980520,3))
	local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCode(EFFECT_IMMUNE_EFFECT)
		e3:SetValue(c9980520.efilter)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
   end
end
function c9980520.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c9980520.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and ep~=tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c9980520.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c9980520.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980520,3))
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c9980520.atkval(e,c)
	return Duel.GetMatchingGroupCount(Card.IsType,0,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)*400
end