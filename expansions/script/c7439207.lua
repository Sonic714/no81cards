--派对狂欢穆克拉
local m=7439207
local cm=_G["c"..m]

cm.named_with_party_time=1

function cm.Party_time(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_party_time
end

function cm.initial_effect(c)
	--token
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(cm.sptg2)
	e1:SetOperation(cm.spop2)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCondition(cm.spcon)
	e5:SetTarget(cm.sptg)
	e5:SetOperation(cm.spop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e6)
end
function cm.spfilter1(c,e,tp)
	return cm.Party_time(c) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (c:IsLocation(LOCATION_HAND) or (c:IsLevelBelow(3) and c:IsLocation(LOCATION_DECK) and not Duel.IsExistingMatchingCard(cm.spfilter2,c:GetOwner(),LOCATION_MZONE,0,1,nil)))
end
function cm.spfilter2(c)
	return c:IsFaceup() and c:IsLevelAbove(5)
end
function cm.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if not Duel.IsExistingMatchingCard(cm.spfilter2,e:GetHandler():GetOwner(),LOCATION_MZONE,0,1,nil) then 
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,e:GetHandler():GetOwner(),LOCATION_HAND+LOCATION_DECK)
	else
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,e:GetHandler():GetOwner(),LOCATION_HAND)
	end
end
function cm.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(c:GetOwner(),LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,c:GetOwner(),HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(c:GetOwner(),cm.spfilter1,c:GetOwner(),LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,c:GetOwner())
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,c:GetOwner(),c:GetOwner(),false,false,POS_FACEUP)
	end
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=false
	local b2=false
	local b3=false
	--[[if re and re:GetHandler() then
		b1=(re:GetHandler():GetControler()==1-c:GetOwner())
	end
	if c:GetReasonCard() then
		b2=(c:GetReasonCard():GetControler()==1-c:GetOwner())
	end
	if c:GetReasonEffect() and c:GetReasonEffect():GetHandler() then
		b3=(c:GetReasonEffect():GetHandler():GetControler()==1-c:GetOwner())
	end]]
	return (c:GetReasonPlayer()==1-c:GetOwner() or b1 or b2 or b3) and (not (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE))
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
