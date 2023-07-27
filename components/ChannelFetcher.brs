sub init()
	m.top.functionName = "getChannelList"
end sub

function getChannelList() as void
    print "fetching current programs..."
    xfer = CreateObject("roUrlTransfer")
    xfer.SetUrl(m.global.serverPath + "/api/epg/events/grid?mode=now&sort=channelNumber&limit=9999")
    if (m.BasicAuth <> invalid)
        xfer.AddHeader("Authorization", "Basic " + m.BasicAuth ) 
    end if

    channelsRaw = xfer.GetToString()
	m.top.rawChannels = channelsRaw
end function