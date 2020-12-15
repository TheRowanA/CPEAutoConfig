#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include Chrome.ahk ; Incudes Chrome API
#Include lib\NetcommTelnet.ahk ; Telnet Enabler lib
#SingleInstance,Force

; Sets Compiler options

version := "0.2.5", company := "HISP"

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


; Configuration Logic

R6020PPPoE()
{
	
	; Depreciated
	
	/*
		Progress, 10
		ChromeInst := new Chrome("ChromeProfile")
		PageInst := ChromeInst.GetPage()
		PageInst.Call("Page.navigate", {"url": "http://192.168.1.1/BRS_netgear_success.html"})
		PageInst.WaitForLoad()
		sleep, 4000
		while !(PageInst := ChromeInst.GetPageBy("Title", "192.168.1.1/BRS_netgear_success.html"))
		{
			
			PageInst.Call("Page.reload")
			PageInst.WaitForLoad()
			if (PageInst := ChromeInst.GetPageBy("Title", "192.168.1.1/BRS_netgear_success.html"))
			{
				Progress, 30
				Break
			}
			sleep, 6000
		}
		
		
		
		Sleep, 1000
		
		PageInst.Call("Page.navigate", {"url": "http://192.168.1.1/BAS_ATM_pppoe.htm&wan_index=null"})
		Progress, 40
		
		Sleep, 400
		Send, {Enter}
		sleep, 2000
		CoordMode, Mouse, Relative
		Click, 22, 163
		sleep, 500
		Click, 795, 265
		Clipboard := clipPPPoEName
		sleep, 500
		Send, ^a
		Send, {BS}
		Send, ^v
		Click, 50, 50 ;rnd click
		Click, 795, 290
		sleep, 300
		Clipboard := clipPPPoEPass
		sleep, 500
		Send, ^a
		Send, {BS}
		Send, ^v
		Click, 640, 114
		sleep, 1500
		Progress, 55
		
		PageInst.Call("Page.navigate", {"url": "http://192.168.1.1/WAN_wan.htm&todo=cfg_init"})
		Progress, 65
		
		Sleep, 1000
		PixelGetColor, disSIPALG, 21, 329
		if !(disSIPALG = 0xFF7500)
		{
			Click, 21, 331
		}
		Click, 896, 293
		Click, 555, 110
		sleep, 1500
		
		PageInst.Call("Page.navigate", {"url": "http://192.168.1.1/setup.cgi?todo=logout"})
		Progress, 75
		Sleep, 1000
		Progress, 100
		Sleep, 500
		PageInst.Call("Browser.close")
		PageInst.Disconnect()
	*/
	
	; Reworte for TELNET
	
	Progress, 10
	global ChromeInst := new Chrome("ChromeProfile")
	global PageInst := ChromeInst.GetPage()
	PageInst.Call("Page.navigate", {"url": "http://192.168.1.1/setup.cgi?todo=debug"})
	PageInst.WaitForLoad()
	sleep, 4000
	while !(PageInst := ChromeInst.GetPageBy("Title", "192.168.1.1/setup.cgi?todo=debug"))
	{
		
		PageInst.Call("Page.reload")
		PageInst.WaitForLoad()
		sleep, 7000
	}
	Sleep, 600
	Progress, 30
	Send, {Enter}
	sleep, 400
	PageInst.Call("Page.navigate", {"url": "http://192.168.1.1/BRS_netgear_success.html"})
	PageInst.WaitForLoad()
	Sleep, 1000
	PageInst.Call("Browser.close")
	PageInst.Disconnect()
	PageInst.Kill()
	Progress, 50
	
	Run telnet.exe 192.168.1.1
	Sleep, 1000
	Send, admin{ENTER}
	Sleep, 1000
	Send, password{ENTER}
	Sleep, 1000
	Send, nvram set wan_mode=pppoe & nvram set pppoe_username=%clipPPPoEName% & nvram set pppoe_password=%clipPPPoEPass% & nvram set config_state=succeed & nvram set brs_rus_wizard_used=0 & nvram set dis_sip_alg=1 & nvram set nat_filter=open & nvram commit{ENTER}
	Progress, 90
	Sleep, 6000
	Send, killall utelnetd{ENTER}
	Progress, 100
	Sleep, 100
	Send, exit{ENTER}
	
}


VR1600vWANPPPoE()
{
	Progress, 10
	global ChromeInst := new Chrome("ChromeProfile")
	global PageInst := ChromeInst.GetPage()
	PageInst.Call("Page.navigate", {"url": "http://192.168.1.1/"})
	PageInst.WaitForLoad()
	sleep, 4000
	while !(PageInst := ChromeInst.GetPageBy("Title", "Archer VR1600v"))
	{
		
		PageInst.Call("Page.reload")
		PageInst.WaitForLoad()
		if (PageInst := ChromeInst.GetPageBy("Title", "Archer VR1600v"))
		{
			Break
		}
		sleep, 5000
	}
	Progress, 30
	
	CoordMode, Mouse, Relative
	Sleep, 500
	Clipboard := "admin"
	Click, 449, 316
	Send, ^v
	Click, 449, 359
	Send, ^v
	sleep, 500
	Click, 449, 413
	sleep, 500
	Click, 595, 524 ;remove crapbox
	sleep, 4000
	Progress, 45
	Click, 483, 147
	sleep, 1500
	Click, 113, 289
	sleep, 550
	Click, 113, 334
	sleep, 500
	Click, 616, 292 ;DDL
	sleep, 500
	Click, 616, 401
	sleep, 400
	Click, 616, 335 ;name
	Clipboard := clipPPPoEName
	sleep, 500
	Send, ^a
	Send, {BS}
	Send, ^v
	Click, 616, 374 ;pass
	Clipboard := clipPPPoEPass
	Sleep, 500
	Send, ^a
	Send, {BS}
	Send, ^v
	Click, 820, 600 ;rnd click
	Progress, 65
	Click, 616, 406 ;pass 2
	Send, ^a
	Send, {BS}
	Send, ^v
	sleep, 500
	Click, 820, 600 ;rnd click
	sleep, 400
	Click, 897, 884 ;save
	Sleep, 6000
	Progress, 100
	Sleep, 500
	PageInst.Call("Browser.close")
	PageInst.Disconnect()
	
	
	
}


VR1600vVDSLIPoE()
{
	Progress, 10
	global ChromeInst := new Chrome("ChromeProfile")
	global PageInst := ChromeInst.GetPage()
	PageInst.Call("Page.navigate", {"url": "http://192.168.1.1/"})
	PageInst.WaitForLoad()
	sleep, 4000
	while !(PageInst := ChromeInst.GetPageBy("Title", "Archer VR1600v"))
	{
		
		PageInst.Call("Page.reload")
		PageInst.WaitForLoad()
		if (PageInst := ChromeInst.GetPageBy("Title", "Archer VR1600v"))
		{
			Break
		}
		sleep, 5000
	}
	Progress, 30
	
	CoordMode, Mouse, Relative
	Sleep, 500
	Clipboard := "admin"
	Click, 449, 316
	Send, ^v
	Click, 449, 359
	Send, ^v
	sleep, 500
	Click, 449, 413
	sleep, 500
	Click, 595, 524 ;remove crapbox
	sleep, 4000
	PageInst.WaitForLoad()
	Progress, 50
	Click, 483, 147
	sleep, 1500
	Click, 113, 289
	sleep, 550
	Click, 113, 289
	Sleep, 550
	PixelGetColor, hasExisting, 932, 334
	if (hasExisting = 0xD6CB4A)
	{
		Click, 899, 249
		Sleep, 100
		Click, 604, 499
		sleep, 1700
	}
	Click, 864, 253 ;Add
	Sleep, 1000
	Progress, 70
	Click, 631, 530
	sleep, 100
	Click, 631, 602
	sleep, 500
	Click, 820, 600 ;rnd click
	Sleep, 300
	Send, {PgDn}
	sleep, 1000
	Click, 860, 880
	Progress, 100
	Sleep, 6500
	
	
	PageInst.Call("Browser.close")
	PageInst.Disconnect()

	
}

VR1600vVDSLPPPoE()
{
	Progress, 10
	global ChromeInst := new Chrome("ChromeProfile")
	global PageInst := ChromeInst.GetPage()
	PageInst.Call("Page.navigate", {"url": "http://192.168.1.1/"})
	PageInst.WaitForLoad()
	sleep, 4000
	while !(PageInst := ChromeInst.GetPageBy("Title", "Archer VR1600v"))
	{
		
		PageInst.Call("Page.reload")
		PageInst.WaitForLoad()
		if (PageInst := ChromeInst.GetPageBy("Title", "Archer VR1600v"))
		{
			Break
		}
		sleep, 5000
	}
	Progress, 30
	
	CoordMode, Mouse, Relative
	Sleep, 500
	Clipboard := "admin"
	Click, 449, 316
	Send, ^v
	Click, 449, 359
	Send, ^v
	sleep, 500
	Click, 449, 413
	sleep, 500
	Click, 595, 524 ;remove crapbox
	sleep, 5000
	Progress, 50
	Click, 483, 147
	sleep, 1500
	Click, 113, 289
	sleep, 1000
	Click, 113, 289
	Sleep, 550
	PixelGetColor, hasExisting, 932, 334
	if (hasExisting = 0xD6CB4A)
	{
		Click, 899, 249
		Sleep, 100
		Click, 604, 499
		sleep, 1700
	}
	Click, 864, 253 ;Add
	Sleep, 1000
	Progress, 70
	Click, 556, 567 ;name
	Clipboard := clipPPPoEName
	sleep, 500
	Send, ^a
	Send, {BS}
	Send, ^v
	Click, 556, 604 ;pass
	Clipboard := clipPPPoEPass
	Sleep, 500
	Send, ^a
	Send, {BS}
	Send, ^v
	Click, 820, 600 ;rnd click
	Click, 556, 637
	Send, ^a
	Send, {BS}
	Send, ^v
	sleep, 500
	Click, 820, 600 ;rnd click
	Sleep, 400
	Send, {PgDn}
	sleep, 1000
	Click, 860, 883
	Progress, 100
	Sleep, 6500
	
	
	
	PageInst.Call("Browser.close")
	PageInst.Disconnect()
	PageInst.Kill()
	
	
}

R6020IPoE()
{
	
	; Depreciated
	
	/*
		Progress, 50
		ChromeInst := new Chrome("ChromeProfile")
		PageInst := ChromeInst.GetPage()
		PageInst.Call("Page.navigate", {"url": "http://192.168.1.1/BRS_netgear_success.html"})
		PageInst.WaitForLoad()
		sleep, 4000
		while !(PageInst := ChromeInst.GetPageBy("Title", "192.168.1.1/BRS_netgear_success.html"))
		{
			
			PageInst.Call("Page.reload")
			PageInst.WaitForLoad()
			sleep, 10000
		}
		
		Progress, 100
		Sleep, 1000
		
		PageInst.Call("Browser.close")
		PageInst.Disconnect()
	*/
	
	; Rewrote for TELNET
	
	Progress, 10
	global ChromeInst := new Chrome("ChromeProfile", "http://192.168.1.1/setup.cgi?todo=debug")
	global PageInst := ChromeInst.GetPage()
	PageInst.Call("Page.navigate", {"url": "http://192.168.1.1/setup.cgi?todo=debug"})
	PageInst.WaitForLoad()
	sleep, 4000
	while !(PageInst := ChromeInst.GetPageBy("Title", "192.168.1.1/setup.cgi?todo=debug"))
	{
		
		PageInst.Call("Page.reload")
		PageInst.WaitForLoad()
		sleep, 7000
	}
	Sleep, 600
	Progress, 30
	Send, {Enter}
	sleep, 400
	PageInst.Call("Page.navigate", {"url": "http://192.168.1.1/BRS_netgear_success.html"})
	PageInst.WaitForLoad()
	Sleep, 1000
	PageInst.Call("Browser.close")
	PageInst.Disconnect()
	PageInst.Kill()
	Progress, 50
	
	Run telnet.exe 192.168.1.1
	Sleep, 1000
	Send, admin{ENTER}
	Sleep, 1000
	Send, password{ENTER}
	Sleep, 1000
	Send, nvram set wan_mode=dhcpc & nvram set pppoe_username= & nvram set pppoe_password= & nvram set config_state=succeed & nvram set brs_rus_wizard_used=0 & nvram set dis_sip_alg=1 & nvram set nat_filter=open & nvram commit{ENTER}
	Progress, 90
	Sleep, 6000
	Send, killall utelnetd{ENTER}
	Progress, 100
	Sleep, 100
	Send, exit{ENTER}
}

NF18ACVWANIPoE()
{
	
	Run, telnet.exe 192.168.20.1 23 -f %A_WorkingDir%\telnet.log
	WinWait, % "Telnet 192.168.20.1"
	FileReadLine, telnetout, %A_WorkingDir%\telnet.log, 1
	while !(telnetout = "NF18ACV")
	{
		Sleep, 5000
		FileReadLine, telnetout, %A_WorkingDir%\telnet.log, 1
		WinGet, telnetCount, Count, % "Telnet 192.168.20.1"
		if (telnetCount = 0)
		{
			Run, telnet.exe 192.168.20.1 23 -f %A_WorkingDir%\telnet.log
			WinWait, % "Telnet 192.168.20.1"
		}
		
		if (telnetout = "NF18ACV")
		{
			Break
		}
	}
	
	Sleep, 1000
	Send, admin{ENTER}
	Sleep, 1000
	Send, admin{ENTER}
	Sleep, 1000
	if !(isNetcommSkip = 1)
	{
		Send, wan delete service ppp0.1{ENTER}
		Sleep, 7000
		Send, wan delete service eth4.1{ENTER}
		Sleep, 7000
	}
	Send, wan add interface eth eth4{ENTER}
	Sleep, 7000
	Send, wan add service eth4 --protocol ipoe --service hisp-ipoe-ewan --firewall enable --nat enable{Enter}
	Sleep, 7000
	Send, exit{ENTER}exit(ENTER)
	
}

NF18ACVWANPPPoE()
{
	
	Run, telnet.exe 192.168.20.1 23 -f %A_WorkingDir%\telnet.log
	WinWait, % "Telnet 192.168.20.1"
	FileReadLine, telnetout, %A_WorkingDir%\telnet.log, 1
	while !(telnetout = "NF18ACV")
	{
		Sleep, 5000
		FileReadLine, telnetout, %A_WorkingDir%\telnet.log, 1
		WinGet, telnetCount, Count, % "Telnet 192.168.20.1"
		if (telnetCount = 0)
		{
			Run, telnet.exe 192.168.20.1 23 -f %A_WorkingDir%\telnet.log
			WinWait, % "Telnet 192.168.20.1"
		}
		
		if (telnetout = "NF18ACV")
		{
			Break
		}
	}
	
	Sleep, 1000
	Send, admin{ENTER}
	Sleep, 1000
	Send, admin{ENTER}
	Sleep, 1000
	if !(isNetcommSkip = 1)
	{
		
		Send, wan delete service ppp0.1{ENTER}
		Sleep, 7000
		Send, wan delete service eth4.1{ENTER}
		Sleep, 7000
	}
	Send, wan add interface eth eth4{ENTER}
	Sleep, 7000
	Send, wan add service eth4 --protocol pppoe --username %clipPPPoEName% --password %clipPPPoEPass% --service hisp-pppoe-ewan --firewall enable --nat enable{Enter}
	Sleep, 7000
	Send, exit{ENTER}exit(ENTER)
	
}

NF18ACVVDSLIPoE()
{
	
	Progress, 10
	Run, telnet.exe 192.168.20.1 23 -f %A_WorkingDir%\telnet.log
	WinWait, % "Telnet 192.168.20.1"
	FileReadLine, telnetout, %A_WorkingDir%\telnet.log, 1
	while !(telnetout = "NF18ACV")
	{
		Sleep, 5000
		FileReadLine, telnetout, %A_WorkingDir%\telnet.log, 1
		WinGet, telnetCount, Count, % "Telnet 192.168.20.1"
		if (telnetCount = 0)
		{
			Run, telnet.exe 192.168.20.1 23 -f %A_WorkingDir%\telnet.log
			WinWait, % "Telnet 192.168.20.1"
		}
		
		if (telnetout = "NF18ACV")
		{
			Progress, 50
			Break
		}
	}
	
	Sleep, 1000
	Send, admin{ENTER}
	Sleep, 1000
	Send, admin{ENTER}
	Sleep, 1000
	if !(isNetcommSkip = 1)
	{
		Send, wan delete service ptm0.1{ENTER}
		Sleep, 3000
		Send, wan delete service ppp0.1{ENTER}
		Sleep, 7000
		Send, wan delete interface ptm ptm0 --priority high{ENTER}
		Sleep, 3000
		Send, wan delete service eth4.1{ENTER}
		Sleep, 7000
	}
	Send, wan add interface ptm ptm0 --priority both --vlanMux enable --qos enable{ENTER}
	Sleep, 7000
	Send, wan add service ptm0/0_1_1 --protocol ipoe --service hisp-ipoe-vdsl --firewall enable --nat enable{Enter}
	Progress, 100
	Sleep, 7000
	Send, exit{ENTER}exit(ENTER)
	
}

NF18ACVVDSLPPPoE()
{
	
	Run, telnet.exe 192.168.20.1 23 -f %A_WorkingDir%\telnet.log
	WinWait, % "Telnet 192.168.20.1"
	FileReadLine, telnetout, %A_WorkingDir%\telnet.log, 1
	while !(telnetout = "NF18ACV")
	{
		Sleep, 5000
		FileReadLine, telnetout, %A_WorkingDir%\telnet.log, 1
		WinGet, telnetCount, Count, % "Telnet 192.168.20.1"
		if (telnetCount = 0)
		{
			Run, telnet.exe 192.168.20.1 23 -f %A_WorkingDir%\telnet.log
			WinWait, % "Telnet 192.168.20.1"
		}
		
		if (telnetout = "NF18ACV")
		{
			Break
		}
	}
	
	Sleep, 1000
	Send, admin{ENTER}
	Sleep, 1000
	Send, admin{ENTER}
	Sleep, 1000
	if !(isNetcommSkip = 1)
	{
		Send, wan delete service ptm0.1{ENTER}
		Sleep, 3000
		Send, wan delete service ppp0.1{ENTER}
		Sleep, 7000
		Send, wan delete interface ptm ptm0 --priority high{ENTER}
		Sleep, 3000
		Send, wan delete service eth4.1{ENTER}
		Sleep, 7000
	}
	Send, wan add interface ptm ptm0 --priority both --vlanMux enable --qos enable{ENTER}
	Sleep, 7000
	Send, wan add service ptm0/0_1_1 --protocol pppoe --username %clipPPPoEName% --password %clipPPPoEPass% --service hisp-pppoe-vdsl --firewall enable --nat enable{Enter}
	Sleep, 7000
	Send, exit{ENTER}exit(ENTER)
	
}

NL1901ACVWANIPoE()
{
	
	Run, telnet.exe 192.168.20.1 23 -f %A_WorkingDir%\telnet.log
	WinWait, % "Telnet 192.168.20.1"
	FileReadLine, telnetout, %A_WorkingDir%\telnet.log, 1
	while !(telnetout = "NL1901ACV")
	{
		Sleep, 5000
		FileReadLine, telnetout, %A_WorkingDir%\telnet.log, 1
		WinGet, telnetCount, Count, % "Telnet 192.168.20.1"
		if (telnetCount = 0)
		{
			Run, telnet.exe 192.168.20.1 23 -f %A_WorkingDir%\telnet.log
			WinWait, % "Telnet 192.168.20.1"
		}
		
		if (telnetout = "NL1901ACV")
		{
			Break
		}
	}
	
	Sleep, 1000
	Send, admin{ENTER}
	Sleep, 1000
	if (StrLen(snNL1901ACV) != 0)
	{
		Send, %snNL1901ACV%{ENTER}
		Sleep, 1000
		Send, passwd{ENTER}
		Sleep, 700
		Send, admin{ENTER}
		Sleep, 700
		Send, %snNL1901ACV%{ENTER}
		Sleep, 700
		Send, admin{ENTER}
		Sleep, 700
		Send, admin{ENTER}
	}
	else
	{
		Send, admin{ENTER}
	}
	Sleep, 1000
	if !(isNetcommSkip = 1)
	{
		Send, wan delete service ppp0.1{ENTER}
		Sleep, 7000
		Send, wan delete service eth4.1{ENTER}
		Sleep, 7000
	}
	Send, wan add interface eth eth4{ENTER}
	Sleep, 7000
	Send, wan add service eth4 --protocol ipoe --service hisp-ipoe-ewan --firewall enable --nat enable{Enter}
	Sleep, 7000
	Send, exit{ENTER}exit(ENTER)
	
}

NL1901ACVWANPPPoE()
{
	
	Run, telnet.exe 192.168.20.1 23 -f %A_WorkingDir%\telnet.log
	WinWait, % "Telnet 192.168.20.1"
	FileReadLine, telnetout, %A_WorkingDir%\telnet.log, 1
	while !(telnetout = "NL1901ACV")
	{
		Sleep, 5000
		FileReadLine, telnetout, %A_WorkingDir%\telnet.log, 1
		WinGet, telnetCount, Count, % "Telnet 192.168.20.1"
		if (telnetCount = 0)
		{
			Run, telnet.exe 192.168.20.1 23 -f %A_WorkingDir%\telnet.log
			WinWait, % "Telnet 192.168.20.1"
		}
		
		if (telnetout = "NL1901ACV")
		{
			Break
		}
	}
	
	Sleep, 1000
	Send, admin{ENTER}
	Sleep, 1000
	if (StrLen(snNL1901ACV) != 0)
	{
		Send, %snNL1901ACV%{ENTER}
		Sleep, 1000
		Send, passwd{ENTER}
		Sleep, 700
		Send, admin{ENTER}
		Sleep, 700
		Send, %snNL1901ACV%{ENTER}
		Sleep, 700
		Send, admin{ENTER}
		Sleep, 700
		Send, admin{ENTER}
	}
	else
	{
		Send, admin{ENTER}
	}
	Sleep, 1000
	if !(isNetcommSkip = 1)
	{
		Send, wan delete service ppp0.1{ENTER}
		Sleep, 7000
		Send, wan delete service eth4.1{ENTER}
		Sleep, 7000
	}
	Send, wan add interface eth eth4{ENTER}
	Sleep, 7000
	Send, wan add service eth4 --protocol pppoe --username %clipPPPoEName% --password %clipPPPoEPass% --service hisp-pppoe-ewan --firewall enable --nat enable{Enter}
	Sleep, 7000
	Send, exit{ENTER}exit(ENTER)
}

NL1901ACVVDSLIPoE()
{
	
	Run, telnet.exe 192.168.20.1 23 -f %A_WorkingDir%\telnet.log
	WinWait, % "Telnet 192.168.20.1"
	FileReadLine, telnetout, %A_WorkingDir%\telnet.log, 1
	while !(telnetout = "NL1901ACV")
	{
		Sleep, 5000
		FileReadLine, telnetout, %A_WorkingDir%\telnet.log, 1
		WinGet, telnetCount, Count, % "Telnet 192.168.20.1"
		if (telnetCount = 0)
		{
			Run, telnet.exe 192.168.20.1 23 -f %A_WorkingDir%\telnet.log
			WinWait, % "Telnet 192.168.20.1"
		}
		
		if (telnetout = "NL1901ACV")
		{
			Break
		}
	}
	
	Sleep, 1000
	Send, admin{ENTER}
	Sleep, 1000
	if (StrLen(snNL1901ACV) != 0)
	{
		Send, %snNL1901ACV%{ENTER}
		Sleep, 1000
		Send, passwd{ENTER}
		Sleep, 700
		Send, admin{ENTER}
		Sleep, 700
		Send, %snNL1901ACV%{ENTER}
		Sleep, 700
		Send, admin{ENTER}
		Sleep, 700
		Send, admin{ENTER}
	}
	else
	{
		Send, admin{ENTER}
	}
	Sleep, 1000
	if !(isNetcommSkip = 1)
	{
		Send, wan delete service ptm0.1{ENTER}
		Sleep, 3000
		Send, wan delete service ppp0.1{ENTER}
		Sleep, 7000
		Send, wan delete interface ptm ptm0 --priority high{ENTER}
		Sleep, 3000
		Send, wan delete service eth4.1{ENTER}
		Sleep, 7000
	}
	Send, wan add interface ptm ptm0 --priority both --vlanMux enable --qos enable{ENTER}
	Sleep, 7000
	Send, wan add service ptm0/0_1_1 --protocol ipoe --service hisp-ipoe-vdsl --firewall enable --nat enable{Enter}
	Sleep, 7000
	Send, exit{ENTER}exit(ENTER)
}

NL1901ACVVDSLPPPoE()
{
	
	Run, telnet.exe 192.168.20.1 23 -f %A_WorkingDir%\telnet.log
	WinWait, % "Telnet 192.168.20.1"
	FileReadLine, telnetout, %A_WorkingDir%\telnet.log, 1
	while !(telnetout = "NL1901ACV")
	{
		Sleep, 5000
		FileReadLine, telnetout, %A_WorkingDir%\telnet.log, 1
		WinGet, telnetCount, Count, % "Telnet 192.168.20.1"
		if (telnetCount = 0)
		{
			Run, telnet.exe 192.168.20.1 23 -f %A_WorkingDir%\telnet.log
			WinWait, % "Telnet 192.168.20.1"
		}
		
		if (telnetout = "NL1901ACV")
		{
			Break
		}
	}
	
	Sleep, 1000
	Send, admin{ENTER}
	Sleep, 1000
	if (StrLen(snNL1901ACV) != 0)
	{
		Send, %snNL1901ACV%{ENTER}
		Sleep, 1000
		Send, passwd{ENTER}
		Sleep, 700
		Send, admin{ENTER}
		Sleep, 700
		Send, %snNL1901ACV%{ENTER}
		Sleep, 700
		Send, admin{ENTER}
		Sleep, 700
		Send, admin{ENTER}
	}
	else
	{
		Send, admin{ENTER}
	}
	Sleep, 1000
	if !(isNetcommSkip = 1)
	{
		Send, wan delete service ptm0.1{ENTER}
		Sleep, 3000
		Send, wan delete service ppp0.1{ENTER}
		Sleep, 7000
		Send, wan delete interface ptm ptm0 --priority high{ENTER}
		Sleep, 3000
		Send, wan delete service eth4.1{ENTER}
		Sleep, 7000
	}
	Send, wan add interface ptm ptm0 --priority both --vlanMux enable --qos enable{ENTER}
	Sleep, 7000
	Send, wan add service ptm0/0_1_1 --protocol pppoe --username %clipPPPoEName% --password %clipPPPoEPass% --service hisp-pppoe-vdsl --firewall enable --nat enable{Enter}
	Sleep, 7000
	Send, exit{ENTER}exit(ENTER)
}


NF18MESHWANIPoE()
{
	; TODO
	
	Run, telnet.exe 192.168.20.1 23 -f %A_WorkingDir%\telnet.log
	WinWait, % "Telnet 192.168.20.1"
	FileReadLine, telnetout, %A_WorkingDir%\telnet.log, 1
	while !(telnetout = "NF18ACV")
	{
		Sleep, 5000
		FileReadLine, telnetout, %A_WorkingDir%\telnet.log, 1
		WinGet, telnetCount, Count, % "Telnet 192.168.20.1"
		if (telnetCount = 0)
		{
			Run, telnet.exe 192.168.20.1 23 -f %A_WorkingDir%\telnet.log
			WinWait, % "Telnet 192.168.20.1"
		}
		
		if (telnetout = "NF18ACV")
		{
			Break
		}
	}
	
	Sleep, 1000
	Send, admin{ENTER}
	Sleep, 1000
	Send, admin{ENTER}
	Sleep, 1000
	if !(isNetcommSkip = 1)
	{
		Send, wan delete service ppp0.1{ENTER}
		Sleep, 7000
		Send, wan delete service eth4.1{ENTER}
		Sleep, 7000
	}
	Send, wan add interface eth eth4{ENTER}
	Sleep, 7000
	Send, wan add service eth4 --protocol ipoe --service hisp-ipoe-ewan --firewall enable --nat enable{Enter}
	Sleep, 7000
	Send, exit{ENTER}exit(ENTER)
	
}

NF18MESHWANPPPoE()
{
	; TODO
}

NF18MESHVDSLIPoE()
{
	; TODO
}

NF18MESHVDSLPPPoE()
{
	; TODO
}

C6IPoE()
{
	; TODO
}

C6PPPoE()
{
	; TODO
}

class VoIPConfig
{
	; TODO
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
