--闪耀的放课后 五色的笑颜
function c28361833.initial_effect(c)
	--Synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x283),aux.FilterBoolFunction(Card.IsSetCard,0x283),2)
	c:EnableReviveLimit()
	--synchro level
	local ge0=Effect.CreateEffect(c)
	ge0:SetType(EFFECT_TYPE_SINGLE)
	ge0:SetCode(EFFECT_SYNCHRO_LEVEL)
	ge0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	ge0:SetRange(0xff)
	ge0:SetValue(c28361833.synclv)
	--effect gain
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetTargetRange(0xff,0)
	e0:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x286))
	e0:SetLabelObject(ge0)
	c:RegisterEffect(e0)
	--hokura power
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c28361833.valcheck)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c28361833.regcon)
	e3:SetOperation(c28361833.regop)
	e3:SetLabelObject(e2) 
	c:RegisterEffect(e3)
c28361833.shinycounter=true
end
function c28361833.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x283)
end
function c28361833.synclv(e,c)
	local lv=aux.GetCappedLevel(e:GetHandler())
	if c:IsCode(28361833) then return (2<<16)+lv
	else
		return lv
	end
end
function c28361833.valcheck(e,c)
	local val=c:GetMaterial():GetClassCount(Card.GetAttribute)
	e:SetLabel(val)
end
function c28361833.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetLabelObject():GetLabel()~=0
end
function c28361833.regop(e,tp,eg,ep,ev,re,r,rp)
	local vt=e:GetLabelObject():GetLabel()
	local c=e:GetHandler()
	if vt>=2 then
		--to hand
		local e0=Effect.CreateEffect(c)
		e0:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
		e0:SetType(EFFECT_TYPE_IGNITION)
		e0:SetRange(LOCATION_MZONE)
		e0:SetCountLimit(1)
		e0:SetTarget(c28361833.thtg)
		e0:SetOperation(c28361833.thop)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e0)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(28361833,5))
	end
	if vt>=3 then
		--battle indes
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(1)
		c:RegisterEffect(e1)
		--atk
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetValue(vt*400)
		c:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e3)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(28361833,0))
	end
	if  vt>=4 then
		--effect indes
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e4:SetRange(LOCATION_MZONE)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		e4:SetValue(1)
		c:RegisterEffect(e4)
		--cannot target
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e5:SetRange(LOCATION_MZONE)
		e5:SetReset(RESET_EVENT+RESETS_STANDARD)
		e5:SetValue(aux.tgoval)
		c:RegisterEffect(e5)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(28361833,1))
	end
	if vt>=5 then
		local e6=Effect.CreateEffect(c)
		e6:SetDescription(aux.Stringid(28361833,3))
		e6:SetCategory(CATEGORY_NEGATE+CATEGORY_COUNTER)
		e6:SetType(EFFECT_TYPE_QUICK_O)
		e6:SetCode(EVENT_CHAINING)
		e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
		e6:SetRange(LOCATION_MZONE)
		e6:SetCountLimit(1)
		e6:SetCondition(c28361833.discon)
		e6:SetTarget(aux.nbtg)
		e6:SetOperation(c28361833.disop)
		e6:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e6)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(28361833,2))   
	end
end
function c28361833.discon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsCanAddCounter(0x1283,1) and rp==1-tp and Duel.IsChainNegatable(ev)
end
function c28361833.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and e:GetHandler():IsRelateToEffect(e) and e:GetHandler():IsFaceup() then
		e:GetHandler():AddCounter(0x1283,1)
	end
end
function c28361833.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x283)
end
function c28361833.thfilter(c)
	return c:IsSetCard(0x283) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c28361833.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28361833.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c28361833.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c28361833.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #tg>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
	if false and Duel.SelectYesNo(tp,aux.Stringid(28361833,4)) then
		Duel.Recover(tp,500,REASON_EFFECT)
	end
end
