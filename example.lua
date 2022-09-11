local API_ProgressBar = exports["clm_ProgressBar"]:GetAPI()

local bar_BarTimerBar
local bar_CheckpointTimerBar
local bar_PlayerTimerBar
local bar_TextTimerBar

RegisterCommand("example_add", function()

    -- Bar TimerBar
    bar_BarTimerBar = API_ProgressBar.add("BarTimerBar", "CAPTURING")

    bar_BarTimerBar.Func.setTitleColor({241, 64, 26, 255})
    bar_BarTimerBar.Func.setHighlightColor({241, 241, 26, 255})

    bar_BarTimerBar.Func.lib.BarTimerBar.setBackgroundColor({26, 241, 222, 255})
    bar_BarTimerBar.Func.lib.BarTimerBar.setForegroundColor({241, 26, 238, 255})

    Citizen.CreateThread(function()
        local progress = 0.0

        while true do
            Citizen.Wait(0)
            bar_BarTimerBar.Func.lib.BarTimerBar.setProgress(progress)
            progress = progress + 0.001
        end
    end)

    -- Checkpoint TimerBar
    bar_CheckpointTimerBar = API_ProgressBar.add("CheckpointTimerBar", "BASES", nil, 5)

    bar_CheckpointTimerBar.Func.setTitleColor({68, 241, 26, 255})
    bar_CheckpointTimerBar.Func.setHighlightColor({241, 166, 26, 255})

    bar_CheckpointTimerBar.Func.lib.CheckpointTimerBar.setColor({26, 241, 160, 255})
    bar_CheckpointTimerBar.Func.lib.CheckpointTimerBar.setInProgressColor({114, 26, 241, 255})
    bar_CheckpointTimerBar.Func.lib.CheckpointTimerBar.setFailedColor({241, 26, 26, 255})

    Citizen.CreateThread(function()
        local old = 3
        local last = 2
        local current = 1

        while true do
            Citizen.Wait(1000)

            bar_CheckpointTimerBar.Func.lib.CheckpointTimerBar.setCheckpointState(old, 2)
            bar_CheckpointTimerBar.Func.lib.CheckpointTimerBar.setCheckpointState(last, 1)
            bar_CheckpointTimerBar.Func.lib.CheckpointTimerBar.setCheckpointState(current, 0)

            old = last
            last = current
            current = current - 1
            if current == 0 then current = 5 end
        end
    end)

    -- Player TimerBar
    bar_PlayerTimerBar = API_ProgressBar.add("PlayerTimerBar", "Clem76", "1st")

    bar_PlayerTimerBar.Func.setTitleColor({241, 199, 26, 255})
    bar_PlayerTimerBar.Func.setHighlightColor({110, 102, 243, 255})

    -- Text TimerBar
    bar_TextTimerBar = API_ProgressBar.add("TextTimerBar", "MAP TIME", "00:08")

    bar_TextTimerBar.Func.setTitleColor({243, 151, 102, 255})
    bar_TextTimerBar.Func.setHighlightColor({243, 243, 102, 255})

    bar_TextTimerBar.Func.lib.TextTimerBar.setText("N0P3")
    bar_TextTimerBar.Func.lib.TextTimerBar.setTextColor({175, 102, 243, 255})
end)

RegisterCommand("example_remove_once", function()
    API_ProgressBar.remove(bar_PlayerTimerBar._id)
end)

RegisterCommand("example_remove_all", function()
    API_ProgressBar.clear()
end)