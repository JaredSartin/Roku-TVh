sub Main()
    m.screen = CreateObject("roSGScreen")
    m.port = CreateObject("roMessagePort")
    m.screen.setMessagePort(m.port)

    username=""
    password=""

    ' TVH_Host="192.168.4.40"
    ' TVH_Port="9981"
    THV_Server = getServer()

    if THV_Server = invalid
        showSettingsScreen()
    else
        m.global = m.screen.getGlobalNode()
        m.global.id = "GlobalNode"
        m.global.addFields({serverPath: THV_Server})

        if (username <> ""  and password <> "")
            auth = CreateObject("roByteArray") 
            auth.FromAsciiString( username +":" + password ) 
            basicAuth = Auth.ToBase64String()
            m.global.addFields({basicAuth: basicAuth})
        end if

        ' Need to show the options screen if no host/port
        showVideoScreen()
    endif
end sub

sub showVideoScreen()
    print "in showVideoScreen"
    scene = m.screen.CreateScene("VideoPlayerScreen")

    m.screen.show()

    while(true)
        msg = wait(0, m.port)
        msgType = type(msg)
        if msgType = "roSGScreenEvent"
            if msg.isScreenClosed() then return
        end if
    end while
end sub

sub showSettingsScreen()
    print "in showSettingsScreen"
    scene = m.screen.CreateScene("SettingsScreen")

    m.screen.show()

    while(true)
        msg = wait(0, m.port)
        msgType = type(msg)
        if msgType = "roSGScreenEvent"
            if msg.isScreenClosed() then return
        end if
    end while
end sub

function getServer() As dynamic
    sec = CreateObject("roRegistrySection", "ServerSettings")
    if sec.Exists("tvhServer") and sec.Exists("tvhPort")
        return "http://"+ sec.Read("tvhServer") + ":" + sec.read("tvhPort")
    endif
    return invalid
end function