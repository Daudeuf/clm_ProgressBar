**CLM ProgressBar - Standalone**

Hello, today I make available to everyone a port of TimerBar 2 created by Rootcause on RageMP for FiveM.

Original link: https://github.com/root-cause/ragemp-timerbars

**Installation**

1. Download the script. (https://github.com/Daudeuf/clm_TimerBar)
2. Extract wherever you want into your resources.
3. Add `ensure clm_ProgressBar`

**To use**

*Example*
```
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
```

*API*
```
Func.getTitle() -- Return the title
Func.getTitleColor() -- Return the title color
Func.getHighlightColor() -- Return the title highlight color
Func.setTitle(String) -- Set the title
Func.setTitleColor({R, G, B, A}) -- Set the title color
Func.setHighlightColor({R, G, B, A}) -- Set the highlight color

Func.lib.TextTimerBar.getText() -- Return the text of the bar
Func.lib.TextTimerBar.getTextColor() -- Return the color of the text
Func.lib.TextTimerBar.setText(String) -- Set the text of the bar
Func.lib.TextTimerBar.setTextColor({R, G, B, A}) -- Set the color of the text

Func.lib.CheckpointTimerBar.getNumCheckpoints() -- Return the quantity of checkpoints
Func.lib.CheckpointTimerBar.getColor() -- Return the base color of a point
Func.lib.CheckpointTimerBar.getInProgressColor() -- Return the InProgress color of a point
Func.lib.CheckpointTimerBar.getFailedColor() -- Return the failed color of a point
Func.lib.CheckpointTimerBar.setColor({R, G, B, A}) -- Set the base color of a point
Func.lib.CheckpointTimerBar.setInProgressColor({R, G, B, A}) -- Set the InProgress color of a point
Func.lib.CheckpointTimerBar.setFailedColor({R, G, B, A}) -- Set the failed color of a point
Func.lib.CheckpointTimerBar.setCheckpointState(Index, State) -- Set the state of a checkpoint [ InProgress = 0, Completed = 1, Failed = 2 ]
Func.lib.CheckpointTimerBar.setAllCheckpointsState(State) -- Set the state of all checkpoints [ InProgress = 0, Completed = 1, Failed = 2 ]

Func.lib.BarTimerBar.getProgress() -- Return current bar progress percentage
Func.lib.BarTimerBar.getBackgroundColor() -- Return color of bar
Func.lib.BarTimerBar.getForegroundColor() -- Return color of empty bar
Func.lib.BarTimerBar.setProgress(Number) -- Set the current bar progress percentage [ min = 0.0, max = 1.0 ]
Func.lib.BarTimerBar.setBackgroundColor({R, G, B, A}) -- Set the bar color
Func.lib.BarTimerBar.setForegroundColor({R, G, B, A}) -- Set the empty bar color
```
