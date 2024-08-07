--乱躁百裂音「镇」
local cm,m=GetID()
function cm.initial_effect(c)
	--change code
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.chcost)
	e1:SetTarget(cm.chtg)
	e1:SetOperation(cm.chop)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(cm.tgop)
	--c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(TIMING_ATTACK,0x11e0)
	e3:SetCountLimit(1,m-40)
	e3:SetCost(cm.spcost)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetRange(LOCATION_HAND)
	e4:SetCost(cm.spcost2)
	c:RegisterEffect(e4)
end
function cm.lvplus(c)
	if c:GetLevel()>=1 and c:IsType(TYPE_MONSTER) then return c:GetLevel() else return 2 end
end
function cm.filter(c,tp)
	return c:IsCode(11451461) and c:IsFaceup()
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_ONFIELD,nil)
	if c:GetFlagEffect(m-10)==0 and g and #g>0 then
		Duel.Hint(HINT_CARD,0,m)
		c:RegisterFlagEffect(m-10,RESET_CHAIN,0,1)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local tc=g:Select(1-tp,1,1,nil):GetFirst()
		Duel.SendtoGrave(tc,REASON_RULE)
	end
end
function cm.filter2(c,tp)
	return c:IsSetCard(0x97a) and ((c:IsFaceup() and c:IsLocation(LOCATION_ONFIELD)) or (c:IsPublic() and c:IsLocation(LOCATION_HAND)) or c:IsLocation(LOCATION_GRAVE) or c:IsControler(tp)) and c:IsAbleToRemove()
end
function cm.filter22(c,e,tp)
	return c:IsSetCard(0x97a) and ((c:IsFaceup() and c:IsLocation(LOCATION_ONFIELD)) or (c:IsPublic() and c:IsLocation(LOCATION_HAND)) or c:IsLocation(LOCATION_GRAVE) or c:IsControler(tp)) and c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function cm.filter3(c,e,tp)
	return c:IsSetCard(0x97a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.filter4(c)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsType(TYPE_TUNER)
end
function cm.filter5(c)
	return Duel.IsPlayerAffectedByEffect(c:GetControler(),11451461) and ((c:IsOnField() and c:IsStatus(STATUS_EFFECT_ENABLED)) or c:IsLocation(LOCATION_HAND))
end
function cm.filter6(c,e)
	return c:GetFlagEffectLabel(m)==e:GetLabel()
end
function cm.fselect(g,lv,tp)
	return g:GetSum(cm.lvplus)==lv and g:IsExists(cm.filter4,1,nil) and Duel.GetMZoneCount(tp,g)>0
end
function cm.hspcheck(g,lv,tp)
	Duel.SetSelectedCard(g)
	return g:CheckSubGroup(cm.fselect,1,#g,lv,tp)
end
function cm.hspgcheck(lv,tp)
	return function(g,c,mg)
			if g:GetSum(cm.lvplus)<=lv then return true end
			return cm.fselect(g,lv,tp)
		end
end
function cm.CheckGroupRecursiveCapture(bool,sg,g,f,min,max,ext_params)
	local eg=g:Clone()
	if bool then cm.esg=sg:Clone() end
	for c in aux.Next(g-sg) do
		sg:AddCard(c)
		if not Auxiliary.GCheckAdditional or Auxiliary.GCheckAdditional(sg,c,eg,f,min,max,ext_params) then
			if (#sg>=min and #sg<=max and f(sg,table.unpack(ext_params))) then
				for sc in aux.Next(sg-cm.esg) do
					Auxiliary.SubGroupCaptured:Merge(eg:Filter(cm.slfilter,nil,sc))
				end
			end
			if #sg<max then cm.CheckGroupRecursiveCapture(false,sg,eg,f,min,max,ext_params) end
		end
		sg:RemoveCard(c)
		eg:Sub(eg:Filter(cm.slfilter,nil,c))
	end
end
function cm.slfilter(c,sc)
	return cm.lvplus(c)==cm.lvplus(sc)
end
function cm.SelectSubGroup(g,tp,f,cancelable,min,max,...)
	local min=min or 1
	local max=max or #g
	local ext_params={...}
	local sg=Group.CreateGroup()
	local fg=Duel.GrabSelectedCard()
	if #fg>max or min>max or #(g+fg)<min then return nil end
	for tc in aux.Next(fg) do
		fg:SelectUnselect(sg,tp,false,false,min,max)
	end
	sg:Merge(fg)
	local finish=(#sg>=min and #sg<=max and f(sg,...))
	while #sg<max do
		Auxiliary.SubGroupCaptured=Group.CreateGroup()
		cm.CheckGroupRecursiveCapture(true,sg,g,f,min,max,ext_params)
		local cg=Auxiliary.SubGroupCaptured:Clone()
		Auxiliary.SubGroupCaptured:Clear()
		cg:Sub(sg)
		finish=(#sg>=min and #sg<=max and f(sg,...))
		if #cg==0 then break end
		local cancel=not finish and cancelable
		local tc=cg:SelectUnselect(sg,tp,finish,cancel,min,max)
		if not tc then break end
		if not fg:IsContains(tc) then
			if not sg:IsContains(tc) then
				sg:AddCard(tc)
				if #sg==max then finish=true end
			else
				sg:RemoveCard(tc)
			end
		elseif cancelable then
			return nil
		end
	end
	if finish then
		return sg
	else
		return nil
	end
end
function cm.chcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11451461,6))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end
function cm.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
end
function cm.chop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if #tg==0 then return end
	Duel.HintSelection(tg)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11451461,5))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
	e2:SetCode(EFFECT_ADD_CODE)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
	e2:SetValue(11451461)
	tg:GetFirst():RegisterEffect(e2)
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1200) end
	Duel.PayLPCost(tp,1200)
end
function cm.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsPublic() and Duel.GetFlagEffect(tp,11451466)>0 and Duel.CheckLPCost(tp,1200) end
	Duel.ResetFlagEffect(tp,11451466)
	Duel.PayLPCost(tp,1200)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD,nil,tp)
		local sg=Duel.GetMatchingGroup(cm.filter3,tp,LOCATION_DECK,0,nil,e,tp)
		local tg=Group.CreateGroup()
		for sc in aux.Next(sg) do
			aux.GCheckAdditional=cm.hspgcheck(cm.lvplus(sc),tp)
			local tc=mg:CheckSubGroup(cm.hspcheck,1,#mg,cm.lvplus(sc),tp)
			aux.GCheckAdditional=nil
			if tc then return true end
		end
		return false
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,PLAYER_ALL,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(cm.filter22,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD,nil,e,tp)
	local sg=Duel.GetMatchingGroup(cm.filter3,tp,LOCATION_DECK,0,nil,e,tp)
	local tg=Group.CreateGroup()
	for sc in aux.Next(sg) do
		aux.GCheckAdditional=cm.hspgcheck(cm.lvplus(sc),tp)
		local tc=mg:CheckSubGroup(cm.hspcheck,1,#mg,cm.lvplus(sc),tp)
		aux.GCheckAdditional=nil
		if tc then tg:AddCard(sc) end
	end
	if not tg or #tg==0 then return end
	local rg=Group.CreateGroup()
	local tc=tg:GetFirst()
	while not rg or #rg==0 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		tc=tg:Select(tp,1,1,nil):GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		aux.GCheckAdditional=cm.hspgcheck(cm.lvplus(tc),tp)
		rg=cm.SelectSubGroup(mg,tp,cm.hspcheck,true,1,#mg,cm.lvplus(tc),tp)
		aux.GCheckAdditional=nil
	end
	Duel.ConfirmCards(1-tp,rg:Filter(Card.IsFacedown,nil))
	local tg=rg:Filter(cm.filter5,nil)
	if not tg or #tg==0 then
		if Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)>0 then Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) end
	else
		Duel.Hint(HINT_CARD,0,11451461)
		if tg:IsExists(Card.IsControler,1,nil,tp) then Duel.IsPlayerAffectedByEffect(tp,11451461):GetHandler():RegisterFlagEffect(11451468,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(11451461,1)) end
		if tg:IsExists(Card.IsControler,1,nil,1-tp) then Duel.IsPlayerAffectedByEffect(1-tp,11451461):GetHandler():RegisterFlagEffect(11451468,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(11451461,1)) end
		if Duel.Remove(rg,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)>0 then
			local fid=c:GetFieldID()
			local og1=Duel.GetOperatedGroup()
			if og1:IsExists(cm.retfilter2,1,nil,tp,LOCATION_HAND) then Duel.ShuffleHand(tp) end
			if og1:IsExists(cm.retfilter2,1,nil,1-tp,LOCATION_HAND) then Duel.ShuffleHand(1-tp) end
			local og=Group.__band(og1,tg):Filter(cm.rffilter,nil)
			if og and #og>0 then
				for oc in aux.Next(og) do
					oc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
				end
				og:KeepAlive()
				local e1=Effect.CreateEffect(c)
				e1:SetDescription(aux.Stringid(11451461,0))
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e1:SetCode(EVENT_PHASE+PHASE_END)
				e1:SetCountLimit(1)
				e1:SetLabel(fid)
				e1:SetLabelObject(og)
				e1:SetCondition(cm.retcon)
				e1:SetOperation(cm.retop)
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,tp)
			end
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function cm.rffilter(c)
	return c:IsLocation(LOCATION_REMOVED) and not c:IsReason(REASON_REDIRECT)
end
function cm.retfilter2(c,p,loc)
	if (c:IsPreviousLocation(LOCATION_SZONE) and c:GetPreviousTypeOnField()&TYPE_EQUIP>0) or c:IsPreviousLocation(LOCATION_FZONE) then return false end
	return c:IsPreviousControler(p) and c:IsPreviousLocation(loc)
end
function cm.fselect2(g,pft)
	return g:FilterCount(Card.IsPreviousLocation,nil,LOCATION_PZONE)<=pft
end
function cm.returntofield(tc)
	if tc:IsPreviousLocation(LOCATION_FZONE) then
		local p=tc:GetPreviousControler()
		local gc=Duel.GetFieldCard(p,LOCATION_FZONE,0)
		if gc then
			Duel.SendtoGrave(gc,REASON_RULE)
			Duel.BreakEffect()
		end
	end
	if tc:GetPreviousTypeOnField()&TYPE_EQUIP>0 then
		Duel.SendtoGrave(tc,REASON_RULE+REASON_RETURN)
	else
		Duel.ReturnToField(tc)
	end
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(cm.filter6,1,nil,e) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(cm.filter6,nil,e)
	g:DeleteGroup()
	local ft,mg,pft,pmg={},{},{},{}
	ft[1]=Duel.GetLocationCount(tp,LOCATION_MZONE)
	ft[2]=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	ft[3]=Duel.GetLocationCount(tp,LOCATION_SZONE)
	ft[4]=Duel.GetLocationCount(1-tp,LOCATION_SZONE)
	pft[3],pft[4]=0,0
	if Duel.CheckLocation(tp,LOCATION_PZONE,0) then pft[3]=pft[3]+1 end
	if Duel.CheckLocation(tp,LOCATION_PZONE,1) then pft[3]=pft[3]+1 end
	if Duel.CheckLocation(1-tp,LOCATION_PZONE,0) then pft[4]=pft[4]+1 end
	if Duel.CheckLocation(1-tp,LOCATION_PZONE,1) then pft[4]=pft[4]+1 end
	mg[1]=sg:Filter(cm.retfilter2,nil,tp,LOCATION_MZONE)
	mg[2]=sg:Filter(cm.retfilter2,nil,1-tp,LOCATION_MZONE)
	mg[3]=sg:Filter(cm.retfilter2,nil,tp,LOCATION_SZONE)
	mg[4]=sg:Filter(cm.retfilter2,nil,1-tp,LOCATION_SZONE)
	pmg[3]=sg:Filter(cm.retfilter2,nil,tp,LOCATION_PZONE)
	pmg[4]=sg:Filter(cm.retfilter2,nil,1-tp,LOCATION_PZONE)
	for i=1,2 do
		if #mg[i]>ft[i] then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11451461,7))
			local tg=mg[i]:Select(tp,ft[i],ft[i],nil)
			for tc in aux.Next(tg) do cm.returntofield(tc) end
			sg:Sub(tg)
		end
	end
	for i=3,4 do
		if #mg[i]>ft[i] then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11451461,7))
			local ct=math.min(#(mg[i]-pmg[i])+pft[i],ft[i])
			local tg=mg[i]:SelectSubGroup(tp,cm.fselect2,false,ct,ct,pft[i])
			local ptg=tg:Filter(Card.IsPreviousLocation,nil,LOCATION_PZONE)
			for tc in aux.Next(ptg) do cm.returntofield(tc) end
			for tc in aux.Next(tg-ptg) do cm.returntofield(tc) end
			sg:Sub(tg)
		elseif #pmg[i]>pft[i] then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11451461,7))
			local tg=pmg[i]:Select(tp,pft[i],pft[i],nil)
			for tc in aux.Next(tg) do cm.returntofield(tc) end
			sg:Sub(tg)
		end
	end
	local psg=sg:Filter(Card.IsPreviousLocation,nil,LOCATION_PZONE)
	for tc in aux.Next(psg) do cm.returntofield(tc) end
	for tc in aux.Next(sg-psg) do
		if tc:GetPreviousLocation()&LOCATION_ONFIELD>0 then
			cm.returntofield(tc)
		elseif tc:IsPreviousLocation(LOCATION_HAND) then
			Duel.SendtoHand(tc,tc:GetPreviousControler(),REASON_EFFECT)
		end
	end
end