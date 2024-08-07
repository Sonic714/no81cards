--超量機獣マグナライガー
local m=15703179
local cm=_G["c"..m]
function cm.initial_effect(c)
    aux.AddCodeList(c,59975920)
    --xyz summon
    aux.AddXyzProcedure(c,nil,5,2)
    c:EnableReviveLimit()
    --cannot attack
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_CANNOT_ATTACK)
    e1:SetCondition(cm.atcon)
    c:RegisterEffect(e1)
    --destroy
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetDescription(aux.Stringid(m,0))
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
    e2:SetCondition(cm.descon1)
    e2:SetCost(cm.descost)
    e2:SetTarget(cm.destg)
    e2:SetOperation(cm.desop)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    e3:SetCondition(cm.descon2)
    c:RegisterEffect(e3)
    --material
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(m,1))
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1)
    e4:SetTarget(cm.mttg)
    e4:SetOperation(cm.mtop)
    c:RegisterEffect(e4)
end
function cm.atcon(e)
    return e:GetHandler():GetOverlayCount()==0
end
function cm.descon1(e,tp,eg,ep,ev,re,r,rp)
    return not e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,59975920)
end
function cm.descon2(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,59975920)
end
function cm.descost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) end
    if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.ofilter(c,e)
    return c:IsCanOverlay() and not c:IsImmuneToEffect(e)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        if c:IsHasEffect(89387017) and c:IsRelateToEffect(e) and cm.ofilter(tc,e) and Duel.SelectYesNo(tp,aux.Stringid(89387017,0)) then
            local og=tc:GetOverlayGroup()
            if og:GetCount()>0 then
                Duel.SendtoGrave(og,REASON_RULE)
            end
            Duel.Overlay(c,tc)
        else
            Duel.Destroy(tc,REASON_EFFECT)
        end
    end
end
function cm.mtfilter(c,e)
    return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsSetCard(0x10dc) and c:IsCanOverlay() and not (e and c:IsImmuneToEffect(e))
end
function cm.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
        and Duel.IsExistingMatchingCard(cm.mtfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
end
function cm.mtop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    local g=Duel.SelectMatchingCard(tp,cm.mtfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,e)
    if g:GetCount()>0 then
        Duel.Overlay(c,g)
    end
end
