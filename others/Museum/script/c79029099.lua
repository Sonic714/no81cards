--罗德岛·辅助干员-安洁莉娜
function c79029099.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)  
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c79029099.ffilter,3,true)
	--pendulum
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_DESTROYED)
	e0:SetProperty(EFFECT_FLAG_DELAY)
	e0:SetCondition(c79029099.pencon)
	e0:SetTarget(c79029099.pentg)
	e0:SetOperation(c79029099.penop)
	c:RegisterEffect(e0) 
	--disable spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79029099,0))
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_SPSUMMON)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c79029099.dscon)
	e1:SetTarget(c79029099.dstg)
	e1:SetOperation(c79029099.dsop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetCountLimit(1)
	e2:SetTarget(c79029099.negtg)
	e2:SetOperation(c79029099.negop)
	c:RegisterEffect(e2)
	--extra atk
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c79029099.tdtg)
	e3:SetOperation(c79029099.tdop)
	c:RegisterEffect(e3)
	--recover
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCode(EVENT_DRAW)
	e4:SetOperation(c79029099.recop)
	c:RegisterEffect(e4)
end
function c79029099.ffilter(c)
	return c:IsFusionSetCard(0xa908)
end
function c79029099.negfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER) and aux.disfilter1(c)
end
function c79029099.negtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c79029099.negfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c79029099.negfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c79029099.negfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c79029099.negop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("有没有感觉身体变重了？")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029099,2))
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if ((tc:IsFaceup() and not tc:IsDisabled()) or tc:IsType(TYPE_TRAPMONSTER)) and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		if Duel.GetCurrentPhase()==PHASE_STANDBY then
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,2)
		else
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY)
		end
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=e1:Clone()
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			tc:RegisterEffect(e3)
		end
	end
end
function c79029099.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c79029099.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c79029099.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	Debug.Message("处境越是艰难，我们就越不能气馁！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029099,3))
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c79029099.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,nil,1,tp,LOCATION_MZONE)
end
function c79029099.tdop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("请大家一定要小心谨慎！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029099,1))
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=Duel.SelectMatchingCard(tp,aux.TURE,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
	--double atk
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_EXTRA_ATTACK)
	e4:SetValue(1)
	e4:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e4)
end
end
function c79029099.recop(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp then return end
	if Duel.GetFlagEffect(tp,79029099)==0 then 
	Debug.Message("就算不怎么擅长，我也会努力去做的。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029099,0))
	end
	Duel.RegisterFlagEffect(tp,79029099,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_CARD,0,79029099)
	Duel.Recover(tp,1000,REASON_EFFECT)
end
function c79029099.dscon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp) and Duel.GetCurrentChain()==0 and e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c79029099.dstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,eg:GetCount(),0,0)
end
function c79029099.dsop(e,tp,eg,ep,ev,re,r,rp,chk)
	Debug.Message("有没有感觉身体变重了？")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029099,4))
	Duel.NegateSummon(eg)
	Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
end




