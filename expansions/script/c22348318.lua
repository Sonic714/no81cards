--盾 之 魔 女  夏 莎
local m=22348318
local cm=_G["c"..m]
function cm.initial_effect(c)
	--eff
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22348318,1))
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(2,22348318)
	e1:SetCondition(c22348318.effcon)
	e1:SetTarget(c22348318.efftg)
	e1:SetOperation(c22348318.effop)
	c:RegisterEffect(e1)
	
end
function c22348318.effcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasCategory(CATEGORY_DESTROY+CATEGORY_NEGATE)
end
function c22348318.drfilter(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsDiscardable()
end
function c22348318.remfilter(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsAbleToRemove()
end
function c22348318.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local loc=e:GetActivateLocation()
	local b1=loc==LOCATION_HAND and Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(c22348318.drfilter,tp,LOCATION_HAND,0,1,c) and c:IsDiscardable()
	local b2=loc==LOCATION_GRAVE and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(c22348318.remfilter,tp,LOCATION_GRAVE,0,1,c)
	if chk==0 then return (b1 or b2) and c:GetFlagEffect(22348318)==0 end
	c:RegisterFlagEffect(22348318,RESET_CHAIN,0,1)
	if b1 then
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	elseif b2 then
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	end
end


function c22348318.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_HAND) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local g=Duel.SelectMatchingCard(tp,c22348318.drfilter,tp,LOCATION_HAND,0,1,1,c)
		g:AddCard(c)
		if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)~=0 then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	elseif c:IsLocation(LOCATION_GRAVE) then
		local g=Group.CreateGroup()
		Duel.ChangeTargetCard(ev,g)
		Duel.ChangeChainOperation(ev,c22348318.repop)
		local trg=Duel.GetMatchingGroup(c22348318.remfilter,tp,LOCATION_GRAVE,0,c)
		if trg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsLocation(LOCATION_GRAVE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
				Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local rg=trg:Select(tp,1,1,nil)
			Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
			if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
				e1:SetValue(LOCATION_DECKBOT)
				c:RegisterEffect(e1)
			end
		end
	end
end
function c22348318.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end




