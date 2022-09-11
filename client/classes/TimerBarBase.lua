exports("TimerBarBase", function(title, text, numCheckpoints, progress, Type)
    local CAS = exports["clm_ProgressBar"]:GetCoordsAndSizes()

    local self = {
        _Type = Type,
        _id = exports["clm_ProgressBar"]:generateRandomString(8),
        _thin = false,
        _color = {255, 255, 255, 255},
        _inProgressColor = {255, 255, 255, 51},
        _failedColor = {0, 0, 0, 255},
        _checkpointStates = {},
        _numCheckpoints = numCheckpoints ~= nil and exports["clm_ProgressBar"]:clamp(numCheckpoints, 0, 16) or nil,
        _title = title,
        _highlightColor = nil,
        _text = text,
        titleDrawParams = {
            font = 0,
            color = {240, 240, 240, 255},
            scale = CAS.titleScale,
            justification = CAS.textJustification.right,
            wrap = CAS.titleWrap
        },
        textDrawParams = {
            font = 0,
            color = {240, 240, 240, 255},
            scale = CAS.textScale,
            justification = CAS.textJustification.right,
            wrap = CAS.textWrap
        },
        CheckpointTimerBar = {
            inProgress = 0,
            completed = 1,
            failed = 2
        },
        _bgColor = {155, 155, 155, 255},
        _fgColor = {240, 240, 240, 255},
        _fgWidth = 0.0,
        _fgX = 0.0,
        progress = progress,
        Func = {}
    }

    self._titleGxtName = "TMRB_TITLE_"..self._id
    AddTextEntry(self._titleGxtName, title)
    self._textGxtName = "TMRB_TEXT_"..self._id
    AddTextEntry(self._textGxtName, text)

    local Func = {
        lib = {
            TextTimerBar = {
                getText = function()
                    return self._text
                end,
        
                getTextColor = function()
                    return self.textDrawParams.color
                end,

                setText = function(value)
                    self._text = value
                    AddTextEntry(self._textGxtName, value)
                end,
        
                setTextColor = function(value)
                    self.textDrawParams.color = exports["clm_ProgressBar"]:getColorFromValue(value)
                end,
        
                setColor = function(value)
                    self.titleColor = value
                    self.textColor = value
                end,

                draw = function(y)
                    self.Func.draw(y)

                    y = y + CAS.textOffset

                    exports["clm_ProgressBar"]:drawTextLabel(self._textGxtName, {CAS.initialX, y}, self.textDrawParams)
                end,

                resetGxt = function()
                    -- nope
                end
            },
            PlayerTimerBar = {
                draw = function(y)
                    self.Func.drawBackground(y)

                    local titleDrawParams = self.titleDrawParams
                    titleDrawParams.scale = CAS.playerTitleScale

                    exports["clm_ProgressBar"]:drawTextLabel(self._titleGxtName, {CAS.initialX, y + CAS.playerTitleOffset}, titleDrawParams)
                    exports["clm_ProgressBar"]:drawTextLabel(self._textGxtName, {CAS.initialX, y + CAS.textOffset}, self.textDrawParams)
                end
            },
            CheckpointTimerBar = {
                getNumCheckpoints = function()
                    return self._numCheckpoints
                end,

                getColor = function()
                    return self._color
                end,

                getInProgressColor = function()
                    return self._inProgressColor
                end,

                getFailedColor = function()
                    return self._failedColor
                end,

                setColor = function(value)
                    self._color = exports["clm_ProgressBar"]:getColorFromValue(value)
                end,

                setInProgressColor = function(value)
                    self._inProgressColor  = exports["clm_ProgressBar"]:getColorFromValue(value)
                end,

                setFailedColor = function(value)
                    self._failedColor  = exports["clm_ProgressBar"]:getColorFromValue(value)
                end,

                setCheckpointState = function(index, newState)
                    if index <= 0 or index > self._numCheckpoints then return end
            
                    self._checkpointStates[index] = newState
                end,

                setAllCheckpointsState = function(newState)
                    for i=1, self._numCheckpoints, 1 do
                        self._checkpointStates[i] = newState
                    end
                end,

                draw = function(y)
                    self.Func.draw(y)

                    y = y + CAS.checkpointOffsetY
                    local cpX = CAS.checkpointBaseX

                    for i=1, self._numCheckpoints, 1 do
                        local drawColor = self._checkpointStates[i] and (self._checkpointStates[i] == self.CheckpointTimerBar.failed and self._failedColor or self._color) or self._inProgressColor
                        DrawSprite("timerbars", "circle_checkpoints", cpX, y, CAS.checkpointWidth, CAS.checkpointHeight, 0.0, drawColor[1], drawColor[2], drawColor[3], drawColor[4])
                        cpX = cpX - CAS.checkpointOffsetX
                    end
                end
            },
            BarTimerBar = {
                getProgress = function()
                    return self._progress
                end,

                getBackgroundColor = function()
                    return self._bgColor
                end,

                getForegroundColor = function()
                    return self._fgColor
                end,

                setProgress = function(value)
                    self._progress = exports["clm_ProgressBar"]:clamp(value, 0.0, 1.0)
                    self._fgWidth = CAS.progressWidth * self._progress
                    self._fgX = (CAS.progressBaseX - CAS.progressWidth * 0.5) + (self._fgWidth * 0.5)
                end,

                setBackgroundColor = function(value)
                    self._bgColor = exports["clm_ProgressBar"]:getColorFromValue(value)
                end,

                setForegroundColor = function(value)
                    self._fgColor = exports["clm_ProgressBar"]:getColorFromValue(value)
                end,

                draw = function(y)
                    self.Func.draw(y)

                    y = y + CAS.barOffset

                    DrawRect(CAS.progressBaseX, y, CAS.progressWidth, CAS.progressHeight, self._bgColor[1], self._bgColor[2], self._bgColor[3], self._bgColor[4]);
                    DrawRect(self._fgX, y, self._fgWidth, CAS.progressHeight, self._fgColor[1], self._fgColor[2], self._fgColor[3], self._fgColor[4]);
                end
            }
        },

        getTitle = function()
            return self._title
        end,

        getTitleColor = function()
            return self.titleDrawParams.color
        end,

        getHighlightColor = function()
            return self._highlightColor
        end,

        setTitle = function(value)
            self._title = value
            AddTextEntry(self._titleGxtName, value)
        end,

        setTitleColor = function(value)
            self.titleDrawParams.color = exports["clm_ProgressBar"]:getColorFromValue(value)
        end,

        setHighlightColor = function(value)
            self._highlightColor = value and exports["clm_ProgressBar"]:getColorFromValue(value) or nil
        end,

        drawBackground = function(y)
            y = y + (self._thin and CAS.bgThinOffset or CAS.bgOffset)

            if self._highlightColor ~= nil then
                DrawSprite("timerbars", "all_white_bg", CAS.bgBaseX, y, CAS.timerBarWidth, self._thin and CAS.timerBarThinHeight or CAS.timerBarHeight, 0.0, self._highlightColor[1], self._highlightColor[2], self._highlightColor[3], self._highlightColor[4])
            end
    
            DrawSprite("timerbars", "all_black_bg", CAS.bgBaseX, y, CAS.timerBarWidth, self._thin and CAS.timerBarThinHeight or CAS.timerBarHeight, 0.0, 255, 255, 255, 140)
        end,

        drawTitle = function(y)
            exports["clm_ProgressBar"]:drawTextLabel(self._titleGxtName, {CAS.initialX, y}, self.titleDrawParams)
        end,

        draw = function(y)
            self.Func.drawBackground(y)
            self.Func.drawTitle(y)
        end,

        InternalDraw = function(y, Type)
            if Type == nil then
                self.Func.draw(y)
            elseif Type == "TextTimerBar" or Type == "PlayerTimerBar" or Type == "CheckpointTimerBar" or Type == "BarTimerBar" then
                self.Func.lib[Type].draw(y)
            end
        end,

        resetGxt = function()
            -- nope
        end
    }

    self.Func = Func

    return self
end)