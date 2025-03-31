local Language = {
    ["EN"] = {
        
    }
}

Language.Lang = "EN"
function ChangeLanguage(lang)
    Language.Lang = "EN"
end

function GetLanguage(name)
    return Language[Language.Lang][name]
end