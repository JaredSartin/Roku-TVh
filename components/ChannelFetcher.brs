sub init()
	m.top.functionName = "getChannelList"
end sub

function getChannelList() as void
    print "fetching current programs..."

    response = fetch({
        url: m.global.serverPath + "/api/epg/events/grid?mode=now&sort=channelNumber&limit=9999",
        timeout: 2000,
        method: "GET",
    })
    if response.ok
        m.top.rawChannels = response.text()
    else
        ?"The request failed", response.statusCode, response.text()
        m.top.errorState = response.text()
    end if
end function