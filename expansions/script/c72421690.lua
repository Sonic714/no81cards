--迈拉的稳定元素
function c72421690.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c72421690.target)
	e1:SetOperation(c72421690.activate)
	c:RegisterEffect(e1)
end
function c72421690.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,59) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(59)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,59)
end
function c72421690.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
