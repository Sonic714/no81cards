--ネクロの多元魔導書
function c115262868.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(1,115262868+EFFECT_COUNT_CODE_OATH)
    e1:SetTarget(c115262868.target)
    e1:SetOperation(c115262868.operation)
    c:RegisterEffect(e1)
    --act in hand
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
    c:RegisterEffect(e2)
    --cannot set
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_CANNOT_SSET)
    c:RegisterEffect(e3)
    --remove type
    local e4=Effect.CreateEffect(c)
    e4:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_REMOVE_TYPE)
    e4:SetValue(TYPE_QUICKPLAY)
    c:RegisterEffect(e4)
end

function c115262868.cfilter(c,e,tp)
    return c:IsRace(RACE_SPELLCASTER) and c:GetLevel()>0 and c:IsAbleToRemoveAsCost()
        and Duel.IsExistingTarget(c115262868.spfilter,tp,LOCATION_GRAVE,0,1,c,e,tp)
end
function c115262868.cffilter(c)
    return c:IsSetCard(0x306e) and c:IsType(TYPE_SPELL) and not c:IsPublic()
end
function c115262868.spfilter(c,e,tp)
    return c:IsRace(RACE_SPELLCASTER) and c:GetLevel()>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c115262868.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c115262868.spfilter(chkc,e,tp) end
    if chk==0 then
        return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
            and Duel.IsExistingMatchingCard(c115262868.cfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
            and Duel.IsExistingMatchingCard(c115262868.cffilter,tp,LOCATION_HAND,0,1,e:GetHandler())
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local rg=Duel.SelectMatchingCard(tp,c115262868.cfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    e:SetLabel(rg:GetFirst():GetLevel())
    Duel.Remove(rg,POS_FACEUP,REASON_COST)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
    local cg=Duel.SelectMatchingCard(tp,c115262868.cffilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
    Duel.ConfirmCards(1-tp,cg)
    Duel.ShuffleHand(tp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c115262868.spfilter,tp,LOCATION_GRAVE,0,1,1,rg:GetFirst(),e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c115262868.eqlimit(e,c)
    return c==e:GetLabelObject()
end
function c115262868.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e)
        and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK)~=0 then
        c:CancelToGrave()
        --levelup
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_EQUIP)
        e1:SetCode(EFFECT_UPDATE_LEVEL)
        e1:SetValue(e:GetLabel())
        e1:SetReset(RESET_EVENT+0x1fe0000)
        c:RegisterEffect(e1)
        Duel.Equip(tp,c,tc)
        Duel.SpecialSummonComplete()
        --Add Equip limit
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_EQUIP_LIMIT)
        e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
        e2:SetReset(RESET_EVENT+0x1fe0000)
        e2:SetLabelObject(tc)
        e2:SetValue(c115262868.eqlimit)
        c:RegisterEffect(e2)
    end
end
