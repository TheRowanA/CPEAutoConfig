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
