local Time = CS.UnityEngine.Time
local GameObject = CS.UnityEngine.GameObject

---@class Tips:CS.Akequ.Base.Room
Tips = {}

Tips.time = nil
Tips.tips_time = nil
Tips.string_from_config = ""
Tips.strings = {}
Tips.panel = nil

function Tips:Init()
    if self.main.netEvent.isClient then return end

    self.panel = GameObject.FindObjectOfType(typeof(CS.AdminPanel))

    self.string_from_config = CS.Config.GetString("tips", "<size=20><color=#BBBBBB>Здесь могла быть подсказка</color></size>")
    self.time = CS.Config.GetInt("delta_tips_time", 60)
    self.tips_time = CS.Config.GetInt("tips_time", 5)
    local words = ""
    for i = 1, #self.string_from_config do
        local c = string.sub(self.string_from_config, i, i)
        if c == '|' then
            table.insert(self.strings, words)
            words = ""
        elseif i == #self.string_from_config then
            words = words .. c
            table.insert(self.strings, words)
            words = ""
        else
            words = words .. c
        end
    end
end

function Tips:Update()
    if self.main.netEvent.isServer and #self.strings > 0 then
        self.time = self.time - Time.deltaTime
        if self.time <= 0 then
            self.time = CS.Config.GetInt("delta_tips_time", 60)

            local players = GameObject.FindObjectsOfType(typeof(CS.Player))

            for i = 0, players.Length - 1 do
                local player = players[i]
                if player.playerClass:GetTeamID() == "Spectator" then
                    self.panel:ShowAdminMessage(self.strings[math.floor(CS.UnityEngine.Random.Range(1, #self.strings + 1))], self.tips_time, player)
                end
            end
        end
    end
end
return Tips