local m=82224051
local cm=_G["c"..m]
cm.name="深洋猎手"
function cm.initial_effect(c)
	--xyz summon  
	aux.AddXyzProcedure(c,nil,3,3)  
	c:EnableReviveLimit() 
	--cannot target  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)  
	e1:SetValue(aux.tgoval)  
	c:RegisterEffect(e1)
	--destroy replace  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)  
	e2:SetCode(EFFECT_DESTROY_REPLACE)  
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetTarget(cm.reptg)  
	c:RegisterEffect(e2)  
end
function cm.xmfilter(c,tp,e)
	return c:IsCanOverlay(tp) and not c:IsStatus(STATUS_DESTROY_CONFIRMED) and not c:IsImmuneToEffect(e)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()  
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
		and Duel.IsExistingMatchingCard(cm.xmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c,tp,e) end  
	if Duel.SelectEffectYesNo(tp,c,96) then  
		local g=Duel.GetMatchingGroup(cm.xmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c,tp,e)  
		if g:GetCount()>0 then  
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)  
			local sg=g:Select(tp,1,1,nil)  
			Duel.HintSelection(sg)  
			local tc=sg:GetFirst()
			local og=tc:GetOverlayGroup()
			if og:GetCount()>0 then
				Duel.SendtoGrave(og,REASON_RULE)
			end
			tc:CancelToGrave()
			Duel.Overlay(c,Group.FromCards(tc))
		end 
		return true  
	else
		return false
	end  
end  