local m=53734018
local cm=_G["c"..m]
cm.name="心解青缀的即兴"
cm.Snnm_Ef_Rst=true
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	SNNM.AllEffectReset(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(cm.tgtg)
	e2:SetOperation(cm.tgop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCost(cm.cost)
	e3:SetTarget(cm.tg)
	e3:SetOperation(cm.op)
	c:RegisterEffect(e3)
	SNNM.AozoraDisZoneGet(c)
end
function cm.tgfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x3536) and c:IsAbleToGrave() and not c:IsCode(m) and (c:GetActivateEffect() or c.aozora_field_effect)
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if not tc or Duel.SendtoGrave(tc,REASON_EFFECT)==0 or not tc:IsLocation(LOCATION_GRAVE) then return end
	local c=e:GetHandler()
	if tc:GetActivateEffect() then
		local te1=tc:GetActivateEffect():Clone()
		te1:SetDescription(aux.Stringid(m,0))
		te1:SetType(EFFECT_TYPE_IGNITION)
		te1:SetRange(LOCATION_SZONE)
		te1:SetCountLimit(1)
		te1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
		c:RegisterEffect(te1)
	end
	if tc.aozora_field_effect then
		local te=tc.aozora_field_effect
		local dest,cat,con,cost,tg,op=te:GetDescription(),te:GetCategory(),te:GetCondition(),te:GetCost(),te:GetTarget(),te:GetOperation()
		local te2=Effect.CreateEffect(c)
		if dest then te2:SetDescription(dest) end
		if cat then te2:SetCategory(cat) end
		te2:SetType(EFFECT_TYPE_IGNITION)
		te2:SetRange(LOCATION_SZONE)
		te2:SetCountLimit(1)
		if con then te2:SetCondition(con) end
		if cost then te2:SetCost(cost) end
		if tg then te2:SetTarget(tg) end
		if op then te2:SetOperation(op) end
		te2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
		c:RegisterEffect(te2)
	end
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,700) end
	Duel.PayLPCost(tp,700)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return SNNM.DisMZone(tp)&0x1f>0 end
	local zone=SNNM.DisMZone(tp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
	local z=Duel.SelectField(tp,1,LOCATION_MZONE,0,(~zone)|0xe000e0)
	Duel.Hint(HINT_ZONE,tp,z)
	e:SetLabel(z)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local z=e:GetLabel()
	local dis=SNNM.DisMZone(tp)
	if z==0 or z&dis==0 then return end
	SNNM.ReleaseMZone(e,tp,z)
end
