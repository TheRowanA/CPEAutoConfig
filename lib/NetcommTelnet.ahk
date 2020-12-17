
EnableNetcommTELNET()
{
	/*
		The following is a work around that re-enables TELNET in Netcomm routers, due to new firmware update disabling TELNET By default.
		This is done by using DOM functions over http to scoure and tigger html and JavaScript Events.
	*/
	
	while !(HTTPCheck("192.168.20.1", 80) = "Connected")
	{
		Sleep, 2000
		if (HTTPCheck("192.168.20.1", 80) = "Connected")
		{
			Break
		}
	}
	Sleep, 4000
	
	global ChromeInst := new Chrome("ChromeProfile",, "-headless")
	global PageInst := ChromeInst.GetPage()
	PageInst.Call("Network.enable")
	PageInst.Call("Page.navigate", {"url": "http://192.168.20.1/login.html"})
	PageInst.Call("Network.setUserAgentOverride", {"userAgent": "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36"})
	PageInst.WaitForLoad()
	RootNode := PageInst.Call("DOM.getDocument").root
	uidNode := PageInst.Call("DOM.querySelector", {"nodeId": RootNode.nodeId, "selector": "#loginSkip > fieldset > div:nth-child(1) > input[name=loginID]"})
	PageInst.Call("DOM.setAttributeValue", {"nodeId": uidNode.nodeId, "name": "value", "value": "admin"})
	
	passNode := PageInst.Call("DOM.querySelector", {"nodeId": RootNode.nodeId, "selector": "#loginSkip > fieldset > div:nth-child(2) > input[name=loginPWD]"})
	PageInst.Call("DOM.setAttributeValue", {"nodeId": passNode.nodeId, "name": "value", "value": "admin"})
	Sleep, 100
	
	PageInst.Evaluate("document.querySelector('body > div.container > div > button').click();")
	Sleep, 4000
	
	PageInst.Call("Page.navigate", {"url": "http://192.168.20.1/access-control.html"})
	PageInst.WaitForLoad()
	
	RootNode := PageInst.Call("DOM.getDocument").root
	NameNode := PageInst.Call("DOM.querySelector", {"nodeId": RootNode.nodeId, "selector": "head > script:nth-child(10)"})
	getJS := PageInst.Call("DOM.getOuterHTML", {"nodeId": NameNode.nodeId})
	msgNode := getJS.outerHTML
	findKey := InStr(getJS.outerHTML, "sessionKey", true)
	getKey := SubStr(getJS.outerHTML, findKey, 25)
	nSessionKey := Trim(getKey, OmitChars := "sessionKey= ';")
	nSessionKey := RTrim(nSessionKey, OmitChars := "sessionKey= ';")
	Sleep, 300
	
	PageInst.Call("Page.navigate", {"url": "http://192.168.20.1/scsrvcntr.cmd?action=apply&servicelist=HTTP=1,0,80,80,;HTTPS=1,0,443,443,;TELNET=1,0,23,23,;SSH=0,0,22,22,;FTP=1,0,21,21,;TFTP=0,0,69,69,;ICMP=1,0,0,0,;SNMP=0,0,161,161,;SAMBA=0,0,445,445,;&sessionKey=" + nSessionKey})
	PageInst.WaitForLoad()
	Sleep, 3000
	
	PageInst.Call("Browser.close")
	PageInst.Disconnect()
	PageInst.Kill()
	
	return
}

