--多元魔導書廊エトワール
function c115632163.initial_effect(c)
    c:EnableCounterPermit(0x1)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    --Add counter
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e2:SetCode(EVENT_CHAINING)
    e2:SetRange(LOCATION_SZONE)
    e2:SetOperation(aux.chainreg)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e3:SetCode(EVENT_CHAIN_SOLVED)
    e3:SetRange(LOCATION_SZONE)
    e3:SetCondition(c115632163.ctcon)
    e3:SetOperation(c115632163.ctop)
    c:RegisterEffect(e3)
    --atkup
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_UPDATE_ATTACK)
    e4:SetRange(LOCATION_SZONE)
    e4:SetTargetRange(LOCATION_MZONE,0)
    e4:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_SPELLCASTER))
    e4:SetValue(c115632163.atkval)
    c:RegisterEffect(e4)
    --search
    local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e5:SetCode(EVENT_LEAVE_FIELD)
    e5:SetCondition(c115632163.thcon)
    e5:SetTarget(c115632163.thtg)
    e5:SetOperation(c115632163.thop)
    c:RegisterEffect(e5)
    --act in hand
    local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
    c:RegisterEffect(e6)
    --cannot set
    local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_SINGLE)
    e7:SetCode(EFFECT_CANNOT_SSET)
    c:RegisterEffect(e7)
    --remove type
    local e8=Effect.CreateEffect(c)
    e8:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
    e8:SetType(EFFECT_TYPE_SINGLE)
    e8:SetCode(EFFECT_REMOVE_TYPE)
    e8:SetValue(TYPE_QUICKPLAY)
    c:RegisterEffect(e8)
end
function c115632163.ctcon(e,tp,eg,ep,ev,re,r,rp)
    if not re then return false end
    local c=re:GetHandler()
    return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and c:IsSetCard(0x306e) and e:GetHandler():GetFlagEffect(1)>0
end
function c115632163.ctop(e,tp,eg,ep,ev,re,r,rp)
    e:GetHandler():AddCounter(0x1,1)
end
function c115632163.atkval(e,c)
    return e:GetHandler():GetCounter(0x1)*100
end
function c115632163.thcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local ct=c:GetCounter(0x1)
    e:SetLabel(ct)
    return ct>0 and c:IsLocation(LOCATION_GRAVE) and c:IsReason(REASON_DESTROY)
end
function c115632163.filter(c,lv)
    return c:IsLevelBelow(lv) and c:IsRace(RACE_SPELLCASTER) and c:IsAbleToHand()
end
function c115632163.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c115632163.filter,tp,LOCATION_DECK,0,1,nil,e:GetLabel()) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c115632163.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c115632163.filter,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
