dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."utils.lua")
dofile(LockOn_Options.script_path.."Systems/circuitBreakerHandles.lua")

dev = GetSelf()
sensor_data = get_base_data()
Terrain = require('terrain')
update_time_step = 0.01  
make_default_activity(update_time_step)

paramAHRUHeadingError = get_param_handle("AHRU_ERROR_HEADING")
paramAHRURollError    = get_param_handle("AHRU_ERROR_ROLL")
paramAHRUPitchError   = get_param_handle("AHRU_ERROR_PITCH")

-- VSI
paramVSIPitch = get_param_handle("COPILOT_VSI_PITCH")
paramVSIRoll = get_param_handle("COPILOT_VSI_ROLL")
paramVSISlip = get_param_handle("COPILOT_VSI_SLIP")
paramVSIRollCmdBar = get_param_handle("COPILOT_VSI_ROLL_CMD_BAR")
paramVSIPitchCmdBar = get_param_handle("COPILOT_VSI_PITCH_CMD_BAR")
paramVSICollectiveCmdBar = get_param_handle("COPILOT_VSI_COLLECTIVE_CMD_BAR")
paramVSITurnRateInd = get_param_handle("COPILOT_VSI_TURN_RATE_IND")
paramVSITrackErrorInd = get_param_handle("COPILOT_VSI_TRACK_ERROR_IND")
paramVSIGlideSlopeInd = get_param_handle("COPILOT_VSI_GLIDE_SLOPE_IND")

-- VSI FLAGS
paramVSICMDFlag = get_param_handle("COPILOT_VSI_CMD_FLAG")
paramVSIATTFlag = get_param_handle("COPILOT_VSI_ATT_FLAG")
paramVSINAVFlag = get_param_handle("COPILOT_VSI_NAV_FLAG")
paramVSIGSFlag = get_param_handle("COPILOT_VSI_GS_FLAG")

-- HSI
paramHSICompass = get_param_handle("COPILOT_HSI_COMPASS")
paramHSIHdgBug = get_param_handle("COPILOT_HSI_HDGBUG")
paramHSINo1Bug = get_param_handle("COPILOT_HSI_NO1BUG")
paramHSINo2Bug = get_param_handle("COPILOT_HSI_NO2BUG")
paramHSICrsBug = get_param_handle("COPILOT_HSI_CRSBUG")
paramHSICrsDev = get_param_handle("COPILOT_HSI_CRSDEV")
paramHSIVorToFrom = get_param_handle("COPILOT_HSI_VORARROW")
paramHSIDistDrum1 = get_param_handle("COPILOT_HSI_DISTDRUM1")
paramHSIDistDrum2 = get_param_handle("COPILOT_HSI_DISTDRUM2")
paramHSIDistDrum3 = get_param_handle("COPILOT_HSI_DISTDRUM3")
paramHSIDistDrum4 = get_param_handle("COPILOT_HSI_DISTDRUM4")
paramHSICrsDrum1 = get_param_handle("COPILOT_HSI_CRSDRUM1")
paramHSICrsDrum2 = get_param_handle("COPILOT_HSI_CRSDRUM2")
paramHSICrsDrum3 = get_param_handle("COPILOT_HSI_CRSDRUM3")

-- HSI FLAGS
paramHSIHdgFlag = get_param_handle("COPILOT_HSI_HDGFLAG")
paramHSINavFlag = get_param_handle("COPILOT_HSI_NAVFLAG")
paramHSIDistFlag = get_param_handle("COPILOT_HSI_DISTFLAG")

-- Lights
paramCISPDPLRGPSLt      = get_param_handle("LIGHTING_CIS_CPLT_DPLRGPS")
paramCISPVORLt          = get_param_handle("LIGHTING_CIS_CPLT_VOR")
paramCISPILSLt          = get_param_handle("LIGHTING_CIS_CPLT_ILS")
paramCISPBACKCRSLt      = get_param_handle("LIGHTING_CIS_CPLT_BACKCRS")
paramCISPFMHOMELt       = get_param_handle("LIGHTING_CIS_CPLT_FMHOME")
paramCISPTURNRATENORMLt = get_param_handle("LIGHTING_CIS_CPLT_TRNORM")
paramCISPTURNRATEALTLt  = get_param_handle("LIGHTING_CIS_CPLT_TRALT")
paramCISPCRSHDGPLTLt    = get_param_handle("LIGHTING_CIS_CPLT_CRSHDGPLT")
paramCISPCRSHDGCPLTLt   = get_param_handle("LIGHTING_CIS_CPLT_CRSHDGCPLT")
paramCISPVERTGYRONORMLt = get_param_handle("LIGHTING_CIS_CPLT_GYRONORM")
paramCISPVERTGYROALTLt  = get_param_handle("LIGHTING_CIS_CPLT_GYROALT")
paramCISPBRG2ADFLt      = get_param_handle("LIGHTING_CIS_CPLT_BRG2ADF")
paramCISPBRG2VORLt      = get_param_handle("LIGHTING_CIS_CPLT_BRG2VOR")

dofile(LockOn_Options.script_path.."CISP/device/core.lua")

dev:listen_command(device_commands.PilotCISHdgToggle)
dev:listen_command(device_commands.PilotCISNavToggle)
dev:listen_command(device_commands.PilotCISAltToggle)
dev:listen_command(device_commands.CopilotNavGPSToggle)
dev:listen_command(device_commands.CopilotNavVORILSToggle)
dev:listen_command(device_commands.CopilotNavBACKCRSToggle)
dev:listen_command(device_commands.CopilotNavFMHOMEToggle)
dev:listen_command(device_commands.CopilotTURNRATEToggle)
dev:listen_command(device_commands.CopilotCRSHDGToggle)
dev:listen_command(device_commands.CopilotVERTGYROToggle)
dev:listen_command(device_commands.CopilotBRG2Toggle)

-- HSI
dev:listen_command(device_commands.copilotHSIHdgSet)
dev:listen_command(device_commands.copilotHSICrsSet)

cpltHeading = 0
cpltCourse = 0

modeSelPower = false
ahruPower = false

function post_initialize()
    local birth = LockOn_Options.init_conditions.birth_place
    
    if birth == "GROUND_HOT" or birth == "AIR_HOT" then
        paramVSIPitch:set(sensor_data:getPitch() + paramAHRUPitchError:get())
        paramVSIRoll:set(sensor_data:getRoll() + paramAHRURollError:get())
        paramVSISlip:set(sensor_data:getAngleOfSlide() * radian_to_degree)
        local aircraftHeading = 360 - (sensor_data:getHeading() * radian_to_degree)
        paramHSICompass:set(formatCompassDir(aircraftHeading + paramAHRUHeadingError:get()))
    elseif birth == "GROUND_COLD" then
        paramVSIPitch:set(sensor_data:getPitch() + paramAHRUPitchError:get())
        paramVSIRoll:set(sensor_data:getRoll() + paramAHRURollError:get())
        paramVSISlip:set(sensor_data:getAngleOfSlide() * radian_to_degree)
        local aircraftHeading = 360 - (sensor_data:getHeading() * radian_to_degree)
        paramHSICompass:set(formatCompassDir(aircraftHeading + paramAHRUHeadingError:get()))
    end
end

function SetCommand(command,value)
    -- These functions require power
    if modeSelPower then
        if command == device_commands.PilotCISHdgToggle then
            if value > 0 then
                hdgModeOn = true
                navModeOn = false
            else
                hdgModeOn = false
            end
        elseif command == device_commands.PilotCISNavToggle then
            if value > 0 then
                navModeOn = true
                hdgModeOn = false

                -- If switching on ILS, switch on ALT hold as well
                if ilsModeOn then
                    altModeOn = true
                    pilotAltHoldAltitude = sensor_data:getBarometricAltitude()
                    pilotAirspeedHold = sensor_data:getIndicatedAirSpeed()
                end
            else
                navModeOn = false
            end
        elseif command == device_commands.PilotCISAltToggle then
            if altModeOn == false then
                -- Alt hold only engages if vertical speed less than 200fpm
                if (math.abs(sensor_data:getVerticalVelocity()) * msToFpm <= 200) then
                    altModeOn = true
                    pilotAltHoldAltitude = sensor_data:getBarometricAltitude()
                end
            else
                altModeOn = false
            end
        elseif command == device_commands.CopilotNavGPSToggle then
            if value > 0 then
                dplrGpsModeOn = true
            else
                dplrGpsModeOn = false
            end
        elseif command == device_commands.CopilotNavVORILSToggle then
            if vorModeOn or ilsModeOn then
                vorModeOn = false
                ilsModeOn = false
            else
                if validILS then
                    ilsModeOn = true
                    vorModeOn = false
                elseif validVOR then
                    vorModeOn = true
                    ilsModeOn = false
                else
                    vorModeOn = false
                    ilsModeOn = false
                end
            end

            if navModeOn and (ilsModeOn or vorModeOn) then
                if navModeOn then
                    altModeOn = true
                    pilotAltHoldAltitude = sensor_data:getBarometricAltitude()
                    pilotAirspeedHold = sensor_data:getIndicatedAirSpeed()
                end
            end
        elseif command == device_commands.CopilotNavBACKCRSToggle then
            if value > 0 then
                backCrsModeOn = true
            else
                backCrsModeOn = false
            end
        elseif command == device_commands.CopilotNavFMHOMEToggle then
            if value > 0 then
                fmHomeModeOn = true
            else
                fmHomeModeOn = false
            end
        elseif command == device_commands.CopilotTURNRATEToggle then
            if value > 0 then
                turnRateIsAlt = true
            else
                turnRateIsAlt = false
            end
        elseif command == device_commands.CopilotCRSHDGToggle then
            if value > 0 then
                crsHdgIsCplt = true
            else
                crsHdgIsCplt = false
            end
            dev:performClickableAction(device_commands.PilotCRSHDGToggle,value,true)
        elseif command == device_commands.CopilotVERTGYROToggle then
            if value > 0 then
                vertGyroIsAlt = true
            else
                vertGyroIsAlt = false
            end
        elseif command == device_commands.CopilotBRG2Toggle then
            if brg2IsVOR then
                brg2IsVOR = false
            else
                brg2IsVOR = true
            end
        end
    end
    if command == device_commands.copilotHSIHdgSet then
        cpltHeading = formatCompassDir(cpltHeading + sign(value))
    elseif command == device_commands.copilotHSICrsSet then
        cpltCourse = formatCompassDir(cpltCourse + sign(value))
    end
end

function update()
    updateNetworkArgs(GetSelf())
    modeSelPower = paramCB_CPLTMODESEL:get() > 0
    ahruPower = paramCB_AHRUCPLT:get() > 0
    paramHSIHdgBug:set(cpltHeading)
    paramHSICrsBug:set(cpltCourse)
    
    moveGauge(paramHSICrsDrum1, jumpwheel(cpltCourse, 3), 2, update_time_step)
    moveGauge(paramHSICrsDrum2, jumpwheel(cpltCourse, 2), 2, update_time_step)
    moveGauge(paramHSICrsDrum3, jumpwheel(cpltCourse, 1), 2, update_time_step)
    updateCore()
end

need_to_be_closed = false