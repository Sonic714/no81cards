--人理之诗 幻想大剑·天魔失坠
function c22020820.initial_effect(c)
	aux.AddCodeList(c,22020810)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22020820,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c22020820.eqtg)
	e1:SetOperation(c22020820.eqop)
	c:RegisterEffect(e1)
	--unequip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22020820,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c22020820.sptg)
	e2:SetOperation(c22020820.spop)
	c:RegisterEffect(e2)
	--atk/def
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(2000)
	c:RegisterEffect(e3)
	--attack all
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_ATTACK_ALL)
	e4:SetValue(1)
	c:RegisterEffect(e4)
end
function c22020820.filter(c)
	local ct1,ct2=c:GetUnionCount()
	return c:IsFaceup() and c:IsCode(22020810) and ct2==0
end
function c22020820.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c22020820.filter(chkc) end
	if chk==0 then return e:GetHandler():GetFlagEffect(22020820)==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c22020820.filter,tp,LOCATION_MZONE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c22020820.filter,tp,LOCATION_MZONE,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
	c:RegisterFlagEffect(22020820,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c22020820.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	if not tc:IsRelateToEffect(e) or not c22020820.filter(tc) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	if not Duel.Equip(tp,c,tc,false) then return end
	aux.SetUnionState(c)
end
function c22020820.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(22020820)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	c:RegisterFlagEffect(22020820,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c22020820.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
end