--流离之烬羽·琼
local cm,m=GetID()
function cm.initial_effect(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(cm.thcost)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_DISCARD)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	--hint
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetOperation(cm.chkop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e6)
	if not EMBELLER_CHECK then
		EMBELLER_CHECK=true
		--decrease hand limit
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PHASE_START+PHASE_END)
		ge1:SetOperation(cm.limit)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.chkop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if c:IsReason(REASON_DISCARD) then
		c:RegisterFlagEffect(0,RESET_EVENT+0x1f20000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(11451742,0))
	end
end
function cm.limit(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetTurnPlayer()
	local ct=Duel.GetTurnCount()
	local flag=Duel.GetFlagEffectLabel(p,11451731)
	local eset={Duel.IsPlayerAffectedByEffect(p,EFFECT_HAND_LIMIT)}
	local ht=6
	if not flag then return end
	if #eset>0 then
		for _,te in pairs(eset) do
			local val=te:GetValue()
			if aux.GetValueType(val)=="function" then
				--te:SetValue(function(e,c) if Duel.GetTurnCount()==ct then return math.min(0,val(e,c)-flag) else return val(e,c) end end)
				ht=val(te,te:GetHandler())
			elseif aux.GetValueType(val)=="number" then
				--te:SetValue(function(e,c) if Duel.GetTurnCount()==ct then return math.min(0,val-flag) else return val end end)
				ht=val
			end
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_HAND_LIMIT)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(ht-flag)
	e1:SetReset(RESET_PHASE+PHASE_DRAW)
	Duel.RegisterEffect(e1,p)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DISCARD)
	e2:SetLabelObject(e1)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) if bit.band(r,REASON_ADJUST)~=0 then e:GetLabelObject():Reset() e:Reset() end end)
	e2:SetReset(RESET_PHASE+PHASE_DRAW)
	Duel.RegisterEffect(e2,p)
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_HAND_LIMIT)}
	local flag=Duel.GetFlagEffectLabel(tp,11451731) or 0
	local ht=6
	for _,te in pairs(eset) do
		local val=te:GetValue()
		if aux.GetValueType(val)=="function" then
			ht=val(te,te:GetHandler())
		elseif aux.GetValueType(val)=="number" then
			ht=val
		end
	end
	if chk==0 then return ht>=flag+1 end
	--limit
	flag=flag+1
	Duel.ResetFlagEffect(tp,11451731)
	local ct=math.max(math.min(flag+5,15),0)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(11451731,ct))
	e1:SetLabel(flag)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_FLAG_EFFECT+11451731)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.thfilter(c)
	return c:IsSetCard(0x6977) and c:IsAbleToHand() and not c:IsCode(m)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_GRAVE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	end
end
function cm.matfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6977) and c:IsType(TYPE_MONSTER)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(cm.matfilter,tp,LOCATION_MZONE+LOCATION_REMOVED,0,nil)
	if chk==0 then
		local res=Duel.IsExistingMatchingCard(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,1,nil,mg)
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.matfilter),tp,LOCATION_MZONE+LOCATION_REMOVED,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,1,1,nil,mg)
	local tc=g:GetFirst()
	if tc then Duel.XyzSummon(tp,tc,mg,1,99) end
end