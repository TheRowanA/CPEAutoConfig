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