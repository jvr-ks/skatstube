/*
 *********************************************************************************
 * 
 * skatstube.ahk
 * 
 * Version -> appVersion
 * 
 * Copyright (c) 2020 jvr.de. All rights reserved.
 *
 *********************************************************************************
*/

/*
 *********************************************************************************
 * 
 * MIT License
 * 
 * 
 * Copyright (c) 2020 jvr.de. All rights reserved.
 
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies 
 * of the Software, and to permit persons to whom the Software is furnished to do
 * so, subject to the following conditions:

 * The above copyright notice and this permission notice shall be included in all 
 * copies or substantial portions of the Software.

 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
 * UTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN 
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
  *********************************************************************************
*/

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
#SingleInstance force
#Persistent

FileEncoding, UTF-8-RAW

#Include, Lib\ahk_common.ahk

OwnPID := DllCall("GetCurrentProcessId")

tipOffsetDeltaX := -300

SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
wrkDir := A_ScriptDir . "\"

appName := "Skatstube"
appVersion := "0.075"
app := appName . " " . appVersion

CoordMode, Mouse, Client
CoordMode, Tooltip, Screen

menuEntriesArr := []
isSelected := 1

stopme := false

activeWin := 0

;Pre start chat
chatfield1PosX := 0
chatfield1PosY := 0

chatfield2PosX := 0
chatfield2PosY := 0

chatfield3PosX := 0
chatfield3PosY := 0

clickhammerDelayDefault := 600
clickhammerDelay := clickhammerDelayDefault

delta := 5 ; mousemove sensivity (pixel)

wrkDir := A_ScriptDir . "\"

iniFile := wrkDir . "skatstube.ini"

entriesFile1 := wrkDir . "skatstube1.txt"
entriesFile2 := wrkDir . "skatstube2.txt"
entriesFile3 := wrkDir . "skatstube3.txt"

holdtime := 4000
holdtimeShort := 2000

linesInListMaxDefault := 30
linesInListMax := linesInListMaxDefault

menuHotkeyDefault := "!g"
menuHotkey := menuHotkeyDefault

exitHotkeyDefault := "+!g"
exitHotkey := exitHotkeyDefault

listWidthDefault := 800
listWidth := listWidthDefault

dpiScale := "on"

fontDefault := "Calibri"
font := fontDefault

fontsizeDefault := 11
fontsize := fontsizeDefault

linesInListMaxDefault := 30
linesInListMax := linesInListMaxDefault

notepadPathDefault := "C:\Program Files\Notepad++\notepad++.exe"
notepadpath := notepadPathDefault

alarmScriptDefault := "alarm.hkb"
alarmScript := alarmScriptDefault

MarkInsertPoints := false

spacer := "------------------------------------"

msgDefault := ""

; *** Param
hasParams := A_Args.Length()
if (hasParams == 1){
	if(A_Args[1] = "remove")
	exit()
}

if (hasParams == 1) {
	iniFile := A_Args[1]
}

starthidden := true

readIni()

mainWindow(starthidden)

if (starthidden){
	hktext := hotkeyToText(menuHotkey)
	tipTopTime("Gestarted " . app . ", Hotkey ist: " . hktext, 4000)
}

return
;-------------------------------- mainWindow --------------------------------
mainWindow(hide := false) {
	global wrkDir
	global appName
	global app
	global appVersion
	global entriesFile1
	global entriesFile2
	global entriesFile3
	global chatfield1PosX
	global chatfield1PosY
	global chatfield2PosX
	global chatfield2PosY
	global chatfield3PosX
	global chatfield3PosY
	global iniFile
	global menuEntriesArr
	global menuHotkey
	global fontsize
	global font
	global listWidth
	global linesInListMax
	global LV1
	global spacer
	global isSelected
	global msgDefault
	global OwnPID
	global MarkInsertPoints

	msgDefault := "Open " . appName . " hotkey: " . hotkeyToText(menuHotkey ) . ", Edit entry: [Shift] + [Click]"
	
	xStart := 8
	yStart := 3
	deltaX := 100
	deltaY := yStart + 22
	xStart1 := xStart + deltaX
	xStart2 := xStart1 + deltaX
	xStart3 := xStart2 + deltaX

	Menu, Tray, UseErrorLevel   ; This affects all menus, not just the tray.

	Menu, MainMenu, DeleteAll
	Menu, MainMenuEdit, DeleteAll
	
	Menu, MainMenuEdit,Add,Datei "%entriesFile1%" mit Editor bearbeiten,editTxtFile1
	Menu, MainMenuEdit,Add,Datei "%entriesFile2%" mit Editor bearbeiten,editTxtFile2
	Menu, MainMenuEdit,Add,Datei "%entriesFile3%" mit Editor bearbeiten,editTxtFile3
	Menu, MainMenuEdit,Add,Config-Datei: "%iniFile%" with Editor bearbeiten,editiniFile

	marker1 := " "
	marker2 := " "
	marker3 := " "
	color := "White"
	
	switch isSelected
	{
		case 1:
			color := "White"
		case 2:
			color := "Green"
		case 3:
			color := "Blue"
	}
	
	Menu, MainMenu, NoDefault
	Menu, MainMenu, Add,Inhalte bearbeiten,:MainMenuEdit
	Menu, MainMenu, Add,Position erfassen,getInputCoordinates
	Menu, MainMenu, Add,Clickhammer starten,clickhammerRun
	Menu, MainMenu, Add,Inhalts-Alarm,alarmIfchanged
	
	Menu, MainMenu, Add,Kill %appName% App!,exit
	
	Gui, guiMain:New,+E0x08000000 +OwnDialogs +LastFound HwndhMain +dpiScale, %app%
	Gui, guiMain:Font, s%fontsize%, %font%
	
	Gui, guiMain:Color, %color%
	
	Gui,guiMain:Add,button,gSelectSet1 x%xStart% y%yStart%,%marker1% Select Set &1
	Gui,guiMain:Add,button,gSelectSet2 x%xStart1% y%yStart%,%marker2% Select Set &2
	Gui,guiMain:Add,button,gSelectSet3 x%xStart2% y%yStart%,%marker3% Select Set &3

	if (isSelected == 1){
		menuEntriesArr := []
		Loop, read, %entriesFile1%
		{
			if (A_LoopReadLine != "") {
				s := A_LoopReadLine
				if (A_LoopReadLine == "_spacer_")
					s := spacer
					
				menuEntriesArr.push(s)
			}
		}
	} 
	if (isSelected == 2){
		menuEntriesArr := []
		Loop, read, %entriesFile2%
		{
			if (A_LoopReadLine != "") {
				s := A_LoopReadLine
				if (A_LoopReadLine = "_spacer_")
					s := spacer
					
				menuEntriesArr.push(s)
			}
		}
	}
	
	if (isSelected == 3){
		menuEntriesArr := []
		Loop, read, %entriesFile3%
		{
			if (A_LoopReadLine != "") {
				s := A_LoopReadLine
				if (A_LoopReadLine = "_spacer_")
					s := spacer
					
				menuEntriesArr.push(s)
			}
		}
	}
	
	Gui, guiMain:Add,Text,x%xStart3% yp+0,Position markieren
	chk := MarkInsertPoints ? "checked" : ""
	Gui, guiMain:Add,CheckBox,vMarkInsertPoints gmarkInsertPoint xp+120 yp+0 %chk%
	
	linesInList := Min(linesInListMax,menuEntriesArr.length())
	
	Gui, guiMain:Add, ListView, x%xStart% yp+%deltaY% r%linesInList% w%listWidth% gLVCommands vLV1 AltSubmit -Multi, |Text
	
	for index, element in menuEntriesArr
	{
		LV_Add("",index,element)
	}
	
	LV_ModifyCol(1,"Auto Integer")
	LV_ModifyCol(2,"Auto Text")
	
	Gui, guiMain:Add, StatusBar,,
	
	checkVersionFromGithub()
	
	Gui, guiMain:Menu, MainMenu	
	
	if (!hide){
		setTimer,registerWindow,-500
		setTimer,checkFocus,3000

		Gui, guiMain:Show, Autosize
	}
	
	removeMessage()
	
	GuiControl, Font, LV1
	
	return
}

;------------------------------ markInsertPoint ------------------------------
markInsertPoint(){
	global MarkInsertPoints
	global isSelected
	global chatfield1PosX
	global chatfield1PosY
	global chatfield2PosX
	global chatfield2PosY
	global chatfield3PosX
	global chatfield3PosY

	Gui, guiMain:Submit, nohide
	
	if (MarkInsertPoints){
		if (isSelected == 1)
			tooltip,<- Text-Position1, chatfield1PosX + 10, chatfield1PosY,8
		
		if (isSelected == 2)
			tooltip,<- Text-Position2, chatfield2PosX + 10, chatfield2PosY,8
		
		if (isSelected == 3)
			tooltip,<- Text-Position3, chatfield3PosX + 10, chatfield3PosY,8
	} else {
		tooltip,,,,8
	}
	
	return
}
;---------------------------------- readIni ----------------------------------
readIni(){
	global wrkDir
	global chatfield1PosX
	global chatfield1PosY
	global chatfield2PosX
	global chatfield2PosY
	global chatfield3PosX
	global chatfield3PosY
	global iniFile
	global menuHotkey
	global menuHotkeyDefault
	global exitHotkey
	global exitHotkeyDefault
	global notepadpath
	global notepadpathDefault
	global fontDefault
	global font
	global fontsizeDefault
	global fontsize
	global listWidthDefault
	global listWidth
	global linesInListMax
	global linesInListMaxDefault
	global clickhammerDelayDefault
	global clickhammerDelay
	global alarmScriptDefault
	global alarmScript
	
	IniRead, chatfield1PosX, %iniFile%, coordinates, chatfield1PosX, 0
	IniRead, chatfield1PosY, %iniFile%, coordinates, chatfield1PosY, 0

	IniRead, chatfield2PosX, %iniFile%, coordinates, chatfield2PosX, 0
	IniRead, chatfield2PosY, %iniFile%, coordinates, chatfield2PosY, 0
	
	IniRead, chatfield3PosX, %iniFile%, coordinates, chatfield3PosX, 0
	IniRead, chatfield3PosY, %iniFile%, coordinates, chatfield3PosY, 0
	
	IniRead, menuHotkey, %iniFile%, hotkeys, menuhotkey , %menuhotkeyDefault%
	if (InStr(menuHotkey, "off") > 0){
		s := StrReplace(menuHotkey, "off" , "")
		Hotkey, %s%, showCentered, off
	} else {
		Hotkey, %menuHotkey%, showCentered
	}

	IniRead, exitHotkey, %iniFile%, hotkeys, exithotkey , %exithotkeyDefault%
	if (InStr(exitHotkey, "off") > 0){
		s := StrReplace(exitHotkey, "off" , "")
		Hotkey, %s%, exit, off
	} else {
		Hotkey, %exitHotkey%, exit
	}
	
	IniRead, notepadpath, %iniFile%, notepad, notepadpath, %notepadpathDefault%
	
	IniRead, font, %iniFile%, config, font, %fontDefault%
	IniRead, fontsize, %iniFile%, config, fontsize, %fontsizeDefault%
	
	IniRead, listWidth, %iniFile%, config, listWidth, %listWidthDefault%
	IniRead, linesInListMax, %iniFile%, config, linesInListMax, %linesInListMaxDefault%
	
	IniRead, clickhammerDelay, %iniFile%, config, clickhammerDelay, %clickhammerDelayDefault%
	
	IniRead, alarmScript, %iniFile%, config, alarmScript, %alarmScriptDefault%
}
;****************************** registerWindow ******************************
registerWindow(){
	global activeWin
	
	activeWin := WinActive("A")

	return
}
;******************************** checkFocus ********************************
checkFocus(){
	global activeWin

	h := WinActive("A")
	if (activeWin != h){
		hideWindow()
	}
	
	return
}

;******************************** refreshGui ********************************
refreshGui(){
	global wrkDir
	global appName
	global menuEntriesArr
	global isSelected
	global entriesFile1
	global entriesFile2
	global entriesFile3
	global spacer

	if (isSelected == 1){
		menuEntriesArr := []
		Loop, read, %entriesFile1%
		{
			if (A_LoopReadLine != "") {
				s := A_LoopReadLine
				if (A_LoopReadLine == "_spacer_")
					s := spacer
					
				menuEntriesArr.push(s)
			}
		}
	} 
	if (isSelected == 2){
		menuEntriesArr := []
		Loop, read, %entriesFile2%
		{
			if (A_LoopReadLine != "") {
				s := A_LoopReadLine
				if (A_LoopReadLine = "_spacer_")
					s := spacer
					
				menuEntriesArr.push(s)
			}
		}
	}
	
	if (isSelected == 3){
		menuEntriesArr := []
		Loop, read, %entriesFile3%
		{
			if (A_LoopReadLine != "") {
				s := A_LoopReadLine
				if (A_LoopReadLine = "_spacer_")
					s := spacer
					
				menuEntriesArr.push(s)
			}
		}
	}
	
	LV_Delete()
	
	for index, element in menuEntriesArr
	{
		LV_Add("",index,element)
	}
	
	color := "White"
	
	switch isSelected
	{
		case 1:
			color := "White"
		case 2:
			color := "Green"
		case 3:
			color := "Blue"
	}
	
	Gui, guiMain:Color, %color%
	
	return
}
; *********************************** showWindow ******************************
showWindow(){
	setTimer,checkFocus,3000
	setTimer,registerWindow,-500
	Gui, guiMain:Show, Autosize
	
	return
}
;********************************* hideWindow *********************************
hideWindow(){
	setTimer,checkFocus,delete
	Gui,guiMain:Hide

	return
}
;---------------------------- showWindowRefreshed ----------------------------
showWindowRefreshed(){
	global appName
	global menuHotkey
	global msgDefault
	global OwnPID

	readIni()
	showWindow()
	refreshGui()
	
	removeMessage()
	
	return
}
;******************************** LVCommands ********************************
LVCommands(){
	if (A_GuiEvent == "Normal"){
		doSendInput(A_EventInfo) 
	}

	return
}
;******************************** doSendInput ********************************
doSendInput(index) {
	global wrkDir
	global entriesFile1
	global entriesFile2
	global entriesFile3
	global chatfield1PosX
	global chatfield1PosY
	global chatfield2PosX
	global chatfield2PosY
	global chatfield3PosX
	global chatfield3PosY
	global menuEntriesArr
	global holdtime
	global isSelected
	
	MouseGetPos, oldPosX, oldPosY
	
	hideWindow()
	
	mspeed := 5
		
	ks := getKeyboardState()
	switch ks
	{	
	case 0:
		if (isSelected == 1){
			MouseMove, chatfield1PosX, chatfield1PosY, %mspeed%
			MouseClick, Left
		}

		if (isSelected == 2){
			MouseMove, chatfield2PosX, chatfield2PosY, %mspeed%
			MouseClick, Left
		}
		if (isSelected == 3){
			MouseMove, chatfield3PosX, chatfield3PosY, %mspeed%
			MouseClick, Left
		}
		s := menuEntriesArr[index]
		pos := RegExMatch(s,"O)\[(.*?)\]", match) ; check if command

		if (pos > 0){
			entry := match.1
			
			Switch entry
			{
				Case "timer60/5":
					clipboard := "Bitte 1 Minute Pause ..."
					Send, ^v{Enter}
					sleep,5000
					if (getkeystate("Escape","P")=1){
						MouseMove, oldPosX, oldPosY, 0
						return
					}
							
					Loop, 11 
					{
						clipboard := "Pause (1 min), noch: "  . 60 - (5 * A_Index) . " s"
						Send, ^v{Enter}
						sleep,5000
						if (getkeystate("Escape","P")=1)
							Break
					}	
					clipboard := "Pause beendet, danke fuer die Geduld, weiter geht's!"
					Send, ^v{Enter}
				Case "timer120/5":
					clipboard := "Bitte 2 Minuten Pause ..."
					Send, ^v{Enter}
					sleep,5000
					if (getkeystate("Escape","P")=1){
						MouseMove, oldPosX, oldPosY, 0
						return
					}
						
					Loop, 23 
					{
						clipboard := "Pause (1 min), noch: "  . 120 - (5 * A_Index) . " s"
						Send, ^v{Enter}
						sleep,5000
						if (getkeystate("Escape","P")=1)
							Break
					}	
					clipboard := "Pause beendet, danke fuer die Geduld, weiter geht's!"
					Send, ^v{Enter}
				Default:
					file := entry . ".txt"

					Loop, read, %file% 
					{
						clipboard := A_LoopReadLine
						Send, ^v{Enter}
						sleep,100
					}
			}

		} else {
			s := menuEntriesArr[index]
			clipboard := s
			
			if (SubStr(s, 0 , 1) != "_") {
				Send, ^v{Enter}
			} else {
				Clipboard := StrReplace(Clipboard, "_")
				Send, ^v
			}
		}
		
	
	case 8:
		;*** Shift ***

		InputBox,inp,Edit command,,,,100,,,,,%s%
		
		if (ErrorLevel){
			showHint("Canceled!",2000)
		} else {
			;save new command
			menuEntriesArr[index] := inp
			
			content := ""
			
			l := menuEntriesArr.Length()
			
			for index, element in menuEntriesArr
			{
				content := content . element . "`n"
			}
			if (isSelected == 1){
				FileCopy, %entriesFile1%, %entriesFile1%.saved.txt
				FileDelete, %entriesFile1%
				showHint("Backup Datei erzeugt: " . wrkDir . entriesFile1 . ".saved.txt !",holdtime)
				FileAppend, %content%, %entriesFile1%, UTF-8-Raw
			}
			if (isSelected == 2){
				FileCopy, %entriesFile2%, %entriesFile2%.saved.txt
				FileDelete, %entriesFile2%
				showHint("Backup Datei erzeugt: " . wrkDir . entriesFile2 . ".saved.txt !",holdtime)
				FileAppend, %content%, %entriesFile2%, UTF-8-Raw
			}
			if (isSelected == 3){
				FileCopy, %entriesFile3%, %entriesFile3%.saved.txt
				FileDelete, %entriesFile3%
				showHint("Backup Datei erzeugt: " . wrkDir . entriesFile3 . ".saved.txt !",holdtime)
				FileAppend, %content%, %entriesFile3%, UTF-8-Raw
			}
		}
		showWindowRefreshed()
	}
	
	showWindow()
	
	MouseMove, oldPosX, oldPosY, 0
	
	return
}
;**************************** getInputCoordinates ****************************
getInputCoordinates() {
	global chatfield1PosX
	global chatfield1PosY
	global chatfield2PosX
	global chatfield2PosY
	global chatfield3PosX
	global chatfield3PosY
	global iniFile
	global isSelected
	
	hideWindow()
	
	setTimer,tipTopclose,3000
	
	if (isSelected == 1){
		MouseMove, chatfield1PosX, chatfield1PosY, 0
		showHint("Bitte den Cursor ueber das Eingabefeld 1 bewegen (innerhalb von 5 Sekunden), falls er sich nicht schon dort befindet!", 5000)
		sleep, 5000
		MouseGetPos, chatfield1PosX, chatfield1PosY
		IniWrite, %chatfield1PosX%, %iniFile%, coordinates, chatfield1PosX
		IniWrite, %chatfield1PosY%, %iniFile%, coordinates, chatfield1PosY
		If ( !ErrorLevel ) {
			showHint("Position gespeichert!", 2000)
		} else {
			showHint("Fehler, Position konnte nicht gespeichert werden!", 2000)
		}
		sleep, 1000
	} 
	if (isSelected == 2){
		MouseMove, chatfield2PosX, chatfield2PosY, 0
		showHint("Bitte den Cursor ueber das Eingabefeld 2 bewegen (innerhalb von 5 Sekunden), falls er sich nicht schon dort befindet!", 5000)
		sleep, 5000
		MouseGetPos , chatfield2PosX, chatfield2PosY
		IniWrite, %chatfield2PosX%, %iniFile%, coordinates, chatfield2PosX
		IniWrite, %chatfield2PosY%, %iniFile%, coordinates, chatfield2PosY
		If ( !ErrorLevel ) {
			showHint("Position gespeichert!", 2000)
		} else {
			showHint("Fehler, Position konnte nicht gespeichert werden!", 2000)
		}	
	}
	if (isSelected == 3){
		MouseMove, chatfield3PosX, chatfield3PosY, 0
		showHint("Bitte den Cursor ueber das Eingabefeld 3 bewegen (innerhalb von 5 Sekunden), falls er sich nicht schon dort befindet!", 5000)
		sleep, 5000
		MouseGetPos , chatfield3PosX, chatfield3PosY
		IniWrite, %chatfield3PosX%, %iniFile%, coordinates, chatfield3PosX
		IniWrite, %chatfield3PosY%, %iniFile%, coordinates, chatfield3PosY
		If ( !ErrorLevel ) {
			showHint("Position gespeichert!", 2000)
		} else {
			showHint("Fehler, Position konnte nicht gespeichert werden!", 2000)
		}	
	}
	showWindow()
	
	return
}
;******************************** editTxtFile1 ********************************
editTxtFile1() {
	global wrkDir
	global notepadpath
	global iniFile
	global isSelected
	global entriesFile1

	removeMessage()
	IniRead, notepadpath, %iniFile%, notepad, notepadpath, "C:\Program Files\Notepad++\notepad++.exe"
	f := notepadpath . " " . entriesFile1
	runWait %f%,,max
	removeMessage()
	
	showWindowRefreshed()
	return
}
;******************************** editTxtFile2 ********************************
editTxtFile2() {
	global wrkDir
	global notepadpath
	global iniFile
	global isSelected
	global entriesFile2

	showMessage("", "Bitte den Editor schliessen!")
	IniRead, notepadpath, %iniFile%, notepad, notepadpath, "C:\Program Files\Notepad++\notepad++.exe"
	f := notepadpath . " " . entriesFile2
	runWait %f%,,max
	removeMessage()
	
	showWindowRefreshed()
	return
}
;******************************** editTxtFile3 ********************************
editTxtFile3() {
	global wrkDir
	global notepadpath
	global iniFile
	global isSelected
	global entriesFile3
	
	showMessage("", "Bitte den Editor schliessen!")
	IniRead, notepadpath, %iniFile%, notepad, notepadpath, "C:\Program Files\Notepad++\notepad++.exe"
	f := notepadpath . " " . entriesFile3
	runWait %f%,,max
	removeMessage()
	
	showWindowRefreshed()
	return
}
;******************************** editiniFile ********************************
editiniFile() {
	global wrkDir
	global iniFile
	global notepadpath
	
	showMessage("", "Bitte den Editor schliessen!")
	f := notepadpath . " " . iniFile
	showMessage("", "Please close the editor to refresh the menu!")
	runWait %f%,,max
	removeMessage()

	showWindowRefreshed()

	return
}
;***************************** getKeyboardState *****************************
; in Lib
;*********************************** exit ***********************************
exit() {
	global app
	showHint("""" . app . """ beendet und aus dem Speicher entfernt!", 3000)
	
	ExitApp
}
;************************************ run ************************************
showCentered(){
	global iniFile

	WinGetPos, winTopL_x, winTopL_y, width, height, A
	winCenter_x := winTopL_x + width/2
	MouseMove, winCenter_x - 500, 50, 0
	
	showWindowRefreshed()

	return
}
;****************************** clickhammerRun ******************************
clickhammerRun(){
	global stopme
	global delta
	global clickhammerDelay
	
	static oldPosX
	static oldPosY
	
	hideWindow()
	
	showHint("Please position cursor within 5 sec! [Mousemove] to exit", 5000)
	sleep, 5000
	stopme := false
	
	Loop {
		MouseGetPos, oldPosX, oldPosY
		MouseClick, Left
		Tooltip,<- Clickhammer is activ here!,,,,,9
		sleep, %clickhammerDelay%
		Tooltip,,,,,,9
		;showHint("Click!", 200)
		MouseGetPos, newPosX, newPosY

		if (newPosX > (oldPosX + delta) or newPosX < (oldPosX - delta) or newPosY > (oldPosY + delta) or newPosY < (oldPosY - delta)){
			GetKeyState, state, Shift
			if (state != "D") {
				Tooltip,<- Clickhammer stopped!,,,,,9
				showHint("Mouse moved with no Shift, exit Clickhammer!", 3000)
				sleep, 2000
				;showHint(format("Mouse moved  deltaX: {:d} deltaY: {:d} ", oldPosX - newPosX, oldPosY - newPosY), 20000)
				stopme := true
				break
			}
		}
		
	} Until stopme
	
	showHint("Exit Clickhammer!", 2000)
	Tooltip,,,,,,9
	
	sleep, 1000
	
	return
}
;******************************** SelectSet1 ********************************
SelectSet1(){
	global isSelected
		
	isSelected :=  1
	showWindowRefreshed()
	markInsertPoint()
	
	return
}
;******************************** SelectSet2 ********************************
SelectSet2(){
	global isSelected
		
	isSelected :=  2
	showWindowRefreshed()
	markInsertPoint()
	
	return
}
;******************************** SelectSet3 ********************************
SelectSet3(){
	global isSelected
		
	isSelected :=  3
	showWindowRefreshed()
	markInsertPoint()
	
	return
}

;------------------------------ alarmIfChanged ------------------------------
alarmIfChanged(){
	global wrkDir
	global alarmScript
	
	sampleTimeDelay := 4000
		
	hideWindow()
	msg := "Maus auf die Position bewegen (innerhalb von 5 Sekunden)!"
	ToolTip, %msg%,,,9
	sleep, 5000
	MouseGetPos, posX, posY
	meanValueInitial := sampleArea(posX, posY, 10, 10)
	msg := "Position: posX: " . posX . " posY: " . posY . " fixiert, " . "[" .  meanValueInitial . "]"
	ToolTip, %msg%,,,9
	sleep, 3000
	
	sampleLoop:
	Loop
	{
		meanValueNew := sampleArea(posX, posY, 10, 10)
		if (meanValueNew != meanValueInitial){
			msg := "Alarm, da " . "[" .  meanValueNew . "]" . " != " . "[" . meanValueInitial . "]"
			ToolTip, %msg%,,,9
			
			if (FileExist(wrkDir . alarmScript)){
				SoundPlay, %wrkDir%alarm.mp3
				Run, %wrkDir%%alarmScript%
				sleep,3000
			} else {
				SoundPlay, %wrkDir%alarm.mp3,1
			}
			break sampleLoop
		} else {
			if (getkeystate("Escape","P") == 1){
				msg := "Alarm beendet!"
				showMessage("", msg)
				ToolTip, %msg%,,,9
				showWindow()
				break sampleLoop
			}
			msg := "Konstant, Abbruch: ESCAPE-Taste halten!"
			ToolTip, %msg%,,,9
			sleep, %sampleTimeDelay%
		}
	}
	ToolTip,,,,9

	return
}
;-------------------------------- sampleArea --------------------------------
sampleArea(posX, posY, deltaX, deltaY){

	CoordMode, Mouse, Client
	
	samplepoints := Floor(deltaX * deltaY)

	sumR := 0
	sumG := 0
	sumB := 0
		
	xpos := Floor(posX - deltaX/2)
	ypos := Floor(posY - deltaY/2)

	Loop, %deltaY%
	{
		y := ypos + A_Index
		
		Loop, %deltaX%
		{
			x := xpos + A_Index
			
			PixelGetColor, cl, %x%, %y%, Alt RGB
			
			cs := SubStr(cl, 3)
			rR := BaseToDec(SubStr(cs,1,2), 16)
			rG := BaseToDec(SubStr(cs,3,2), 16)
			rB := BaseToDec(SubStr(cs,5,2), 16)
			
			sumR := rR + sumR
			sumG := rG + sumG
			sumB := rB + sumB
		}
	}
	sumR := Floor(sumR/samplepoints)
	sumG := Floor(sumG/samplepoints)
	sumB := Floor(sumB/samplepoints)
		
	meanValue := Format("{1:02X}{2:02X}{3:02X}",sumR,sumG,sumB)
	
	return meanValue
}

