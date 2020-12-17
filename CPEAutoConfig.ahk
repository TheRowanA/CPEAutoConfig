#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include Chrome.ahk ; Incudes Chrome API
#Include lib\NetcommTelnet.ahk ; Telnet Enabler lib
#Include lib\NF18ACV.ahk
#Include lib\NL1901ACV.ahk
#Include lib\NF18MESH.ahk
#Include lib\R6020.ahk
#Include lib\VR1600v.ahk
#Include lib\C6.ahk
#SingleInstance,Force

; Sets Compiler options

version := "0.2.5a", company := "HISP"

;@Ahk2Exe-Let version = %A_PriorLine~U)^(.+"){1}(.+)".*$~$2%

;@Ahk2Exe-Let company = %A_PriorLine~U)^(.+"){3}(.+)".*$~$2%

;@Ahk2Exe-ExeName %U_company%_%A_ScriptName~\.[^\.]+$%_%U_version%.exe%

;@Ahk2Exe-SetCompanyName %U_company%
;@Ahk2Exe-SetVersion %U_version%
;@Ahk2Exe-SetName HISP_CPEAutoConfig

I_Icon = %A_WorkingDir%\HISPIcon.ico ; Gets and sets Application Icon when Compiling
ICON [I_Icon]


; Gui Init
Gui_Init:
Hotkey, Escape, EscExit, On
Clipboard := ""
global clipPPPoEName := "NoData"
global clipPPPoEPass := "NoData"
global isNetcommSkip := 0
global snNL1901ACV
Gui, New, ,CPE Auto Config - %version%
Gui, Add, Text,, Equipment Model:
Gui, Add, DropDownList, vEModel gEModel, R6020||VR1600v|NF18MESH|NF18ACV|NL1901ACV
Gui, Add, Text,, WAN Interface:
Gui, Add, DropDownList, vWInterface, EWAN||VDSL|ADSL
Gui, Add, Text,, Protocol:
Gui, Add, Radio, vProtocol gProtocol, PPPoE
Gui, Add, Radio, gProtocol Checked, IPoE
Gui, Add, Text,, PPPoE Username:
Gui, Add, Edit, vPPPoEName w210
Gui, Add, Text,, PPPoE Password:
Gui, Add, Edit, vPPPoEPass w210
GuiControl, Disable, PPPoEName
GuiControl, Disable, PPPoEPass
GuiControl, Disable, WInterface
Gui, Add,Button, Default w80 y+20, OK
Gui, Add, Checkbox, vNetcommSkip y30 x150, % "Skip Netcomm Service Cleanup?"
GuiControl, Disable, NetcommSkip
Gui, Show, w350 h300


return

EModel:
GuiControlGet, wType, , EModel 
if (wType = "C6")
{
	GuiControl, ChooseString, WInterface, EWAN
	GuiControl, Disable, WInterface
	GuiControl, Disable, NetcommSkip
	return
}
else if (wType = "R6020")
{
	GuiControl, ChooseString, WInterface, EWAN
	GuiControl, Disable, WInterface
	GuiControl, Disable, NetcommSkip
	return
}
else if (wType = "NF18ACV" || wType = "NL1901ACV" || wType = "NF18MESH")
{
	GuiControl, Enable, WInterface
	GuiControl, Enable, NetcommSkip
	return
}
else
{
	GuiControl, Enable, WInterface
	GuiControl, Disable, NetcommSkip
	return
}



Protocol:
GuiControlGet, isIPoE, , Protocol
if (isIPoE = 0)
{
	GuiControl, Disable, PPPoEName
	GuiControl, Disable, PPPoEPass
	return
}
else
{
	GuiControl, Enable, PPPoEName
	GuiControl, Enable, PPPoEPass
	return
}




ButtonOK:
GuiControlGet, isNetcommSkip,, NetcommSkip
GuiControlGet, clipPPPoEName,, PPPoEName
GuiControlGet, clipPPPoEPass,, PPPoEPass
GuiControlGet, getProtocol,, Protocol
GuiControlGet, getEquipment,, EModel
GuiControlGet, getInterface,, WInterface
Gui,Submit
FileCreateDir, ChromeProfile
Progress, M Y0 w200, % "", % "Configuring Equipment" , % "Please Wait"

if (getProtocol != 0)
{
	if (clipPPPoEName = "" || clipPPPoEPass = "")
	{
		Progress, off
		MsgBox,,Info, % "Both PPPoE fields must contain data to continue"
		Goto, Gui_Init
	}
}


if (getEquipment = "R6020" && getProtocol = 0)
{
	R6020IPoE()
}
else if (getEquipment = "R6020" && getProtocol != 0)
{
	R6020PPPoE()
}
else if (getEquipment = "VR1600v" && getProtocol = 0 && getInterface = "VDSL")
{
	VR1600vVDSLIPoE()
}
else if (getEquipment = "VR1600v" && getProtocol != 0 && getInterface = "VDSL")
{
	VR1600vVDSLPPPoE()
}
else if (getEquipment = "VR1600v" && getProtocol != 0 && getInterface = "EWAN")
{
	VR1600vWANPPPoE()
}
else if (getEquipment = "VR1600v" && getProtocol = 0 && getInterface = "EWAN")
{
	; TODO add VR1600vWANIPoE function
	Progress, off
	MsgBox,,Info, % "VR1600v Modem-Routers are already configured to IPoE WAN by default."
	Goto, Gui_Init
	
}
else if (getEquipment = "NF18ACV" && getProtocol = 0 && getInterface = "EWAN")
{
	NF18ACVWANIPoE()
}
else if (getEquipment = "NF18ACV" && getProtocol != 0 && getInterface = "EWAN")
{
	NF18ACVWANPPPoE()
}
else if (getEquipment = "NF18ACV" && getProtocol = 0 && getInterface = "VDSL")
{
	NF18ACVVDSLIPoE()
}
else if (getEquipment = "NF18ACV" && getProtocol != 0 && getInterface = "VDSL")
{
	NF18ACVVDSLPPPoE()
}
else if (getEquipment = "NL1901ACV" && getProtocol = 0 && getInterface = "EWAN")
{
	InputBox, snNL1901ACV, % "Info", % "The NL1901ACV requires the serial number located on the back of the Equipment to be entered for first time setup. `n`nLeave blank if the password has already been set to 'admin'"
	NL1901ACVWANIPoE()
}
else if (getEquipment = "NL1901ACV" && getProtocol != 0 && getInterface = "EWAN")
{
	InputBox, snNL1901ACV, % "Info", % "The NL1901ACV requires the serial number located on the back of the Equipment to be entered for first time setup. `n`nLeave blank if the password has already been set to 'admin'"
	NL1901ACVWANPPPoE()
}
else if (getEquipment = "NL1901ACV" && getProtocol = 0 && getInterface = "VDSL")
{
	InputBox, snNL1901ACV, % "Info", % "The NL1901ACV requires the serial number located on the back of the Equipment to be entered for first time setup. `n`nLeave blank if the password has already been set to 'admin'"
	NL1901ACVVDSLIPoE()
}
else if (getEquipment = "NL1901ACV" && getProtocol != 0 && getInterface = "VDSL")
{
	InputBox, snNL1901ACV, % "Info", % "The NL1901ACV requires the serial number located on the back of the Equipment to be entered for first time setup. `n`nLeave blank if the password has already been set to 'admin'"
	NL1901ACVVDSLPPPoE()
}
else if (getEquipment = "NF18MESH" && getProtocol = 0 && getInterface = "EWAN")
{
	EnableNetcommTELNET()
	NF18MESHWANIPoE()
}
else
{
	Progress, off
	MsgBox,,ERROR, % "Fatal Selection Error! `nProgram will now Terminate."
	ExitApp
	return
}

PingCheck(url, timeout)
{
	pingLogFile := "ping.log"
	Runwait, %A_ComSpec% /c ping -w %timeout% %url%>%pingLogFile%,, Hide
	fileread , StrTemp, pingLogFile
	if RegExMatch(StrTemp, "Received = (\d+)", received)
	{
		FileDelete, pingLogFile
		return received
	}
	else
	{
		return 0
	}
}


HTTPCheck(url, port)
{
	Run, telnet.exe %url% %port% -f %A_WorkingDir%\HTTPCheck.log,, , telnetPID
	WinWait, ahk_pid %telnetPID%
	Sleep, 2000
	ControlSend,, {ENTER} {ENTER}, ahk_pid %telnetPID%
	FileReadLine, StrTemp, %A_WorkingDir%\HTTPCheck.log, 1
	if (StrTemp != "HTTP/1.1 400 Bad Request")
	{
		Sleep, 7000
		WinClose, ahk_pid %telnetPID%
		FileDelete, %A_WorkingDir%\HTTPCheck.log
		return received
	}
	else
	{
		WinClose, ahk_pid %telnetPID%
		FileDelete, %A_WorkingDir%\HTTPCheck.log
		return "Connected"
	}
}




Progress, off
Goto, Gui_Init

EscExit:
PageInst.Call("Browser.close")
PageInst.Disconnect()
PageInst.Kill()
WinClose, % "Telnet 192.168.1.1"
WinClose, % "Telnet 192.168.20.1"
Sleep, 500
ExitApp

GuiEscape:
ExitApp

GuiClose:
ExitApp
