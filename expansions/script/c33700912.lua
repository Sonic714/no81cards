--战争吼叫
function c33700912.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_DRAW)
	e1:SetCondition(c33700912.condition)
	e1:SetTarget(c33700912.target)
	e1:SetOperation(c33700912.activate)
	c:RegisterEffect(e1)	
end
function c33700912.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and not Duel.CheckPhaseActivity()
end
function c33700912.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,3000)
end
function c33700912.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Damage(tp,3000,REASON_EFFECT)>0 and Duel.Draw(p,d,REASON_EFFECT)>0 then
		Duel.BreakEffect()
	if Duel.GetCurrentPhase()~=PHASE_END then
			if Duel.GetCurrentPhase()==PHASE_DRAW then 
				Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_DRAW,RESET_PHASE+PHASE_END,1)
				Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
				Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
				Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_BATTLE,RESET_PHASE+PHASE_END,1)
				Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_CANNOT_BP)
				e1:SetTargetRange(0,1)
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,Duel.GetTurnPlayer())
			elseif Duel.GetCurrentPhase()==PHASE_STANDBY then
				Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
				Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
				Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_BATTLE,RESET_PHASE+PHASE_END,1)
				Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_CANNOT_BP)
				e1:SetTargetRange(0,1)
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,Duel.GetTurnPlayer())
			elseif Duel.GetCurrentPhase()==PHASE_MAIN1 then	
				Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
				Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_BATTLE,RESET_PHASE+PHASE_END,1)
				Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_CANNOT_BP)
				e1:SetTargetRange(0,1)
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,Duel.GetTurnPlayer())
			elseif Duel.GetCurrentPhase()==PHASE_BATTLE then		
				Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_BATTLE,RESET_PHASE+PHASE_END,1)
				Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
			elseif Duel.GetCurrentPhase()==PHASE_MAIN2 then		
				Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
			end
		end
	end
end