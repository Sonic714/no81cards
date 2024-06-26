--梦幻暗物质
xpcall(function() dofile("expansions/script/c20000000.lua") end,function() dofile("script/c20000000.lua") end)
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,20000050)
	fuef.S(c,EFFECT_EQUIP_LIMIT):PRO("CD"):VAL("val1")
	fuef.A(c):CAT("EQ"):PRO("TG+CTG"):Func("tg2,op2")
	fuef.F(c,EFFECT_TO_GRAVE_REDIRECT):PRO("IG+AR+SET"):RAN("S"):TRAN("A+A"):Func(LOCATION_REMOVED,"tg3")
	fuef.E(c,EFFECT_PIERCE):VAL(1)(EFFECT_IMMUNE_EFFECT):Func("val5,con5")
end
--e1
function cm.val1(e,c)
	return c:IsCode(20000050)
end
--e2
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=fugf.GetFilter(tp,"M","IsCod+TgChk+IsFaceup",{50,e})
	if chkc then return g:IsContains(chkc) end
	if chk==0 then return #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	fugf.SelectTg(tp,"M","IsCod+TgChk+IsFaceup",{50,e})
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() and c:CheckUniqueOnField(tp) then
		Duel.Equip(tp,c,tc)
	end
end
--e3
function cm.tg3(e,c)
	return c:GetOwner()~=e:GetHandlerPlayer() and c:IsReason(REASON_DESTROY) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
--e4
function cm.val5(e,te)
	return te:GetOwner():GetBaseAttack() < e:GetOwner():GetBaseAttack()
end
function cm.con5(e)
	local ph=Duel.GetCurrentPhase()
	return not (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
end
