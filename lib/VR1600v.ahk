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