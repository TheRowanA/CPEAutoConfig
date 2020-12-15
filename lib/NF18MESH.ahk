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