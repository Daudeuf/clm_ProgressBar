local API_ProgressBar = exports["clm_ProgressBar"]:GetAPI()

RegisterCommand("testbar", function()
    --                              (Type, title, text, numCheckPoints, progress)
    local bar1 = API_ProgressBar.add("BarTimerBar", "CAPTURING", "", 0, 0.33)

    Citizen.CreateThread(function()
        local progress = 0.0

        while true do
            Citizen.Wait(0)
            bar1.Func.lib.BarTimerBar.setProgress(progress)
            progress = progress + 0.001
        end
    end)

    local bar2 = API_ProgressBar.add("CheckpointTimerBar", "BASES", "", 5, 0.0)

    Citizen.CreateThread(function()
        local last = 2
        local current = 1

        while true do
            Citizen.Wait(250)
            bar2.Func.lib.CheckpointTimerBar.setCheckpointState(last, true)
            bar2.Func.lib.CheckpointTimerBar.setCheckpointState(current, false)
            last = current
            current = current - 1
            if current == 0 then current = 5 end
        end
    end)



    local bar3 = API_ProgressBar.add("PlayerTimerBar", "title3", "text", 0, 0.60)


    local bar4 = API_ProgressBar.add("TextTimerBar", "MAP TIME", "00:08", 0, 0.0)



end)