sub init()
    print "in VideoPlayerScreen"
    m.Video = m.top.findNode("Video")

    m.activeChannel = getResumeChannel()

	m.channelFetcher = CreateObject("roSGNode", "ChannelFetcher")
	m.channelFetcher.ObserveField("rawChannels", "onChannelsFetched")
	m.channelFetcher.control = "RUN"
end sub

function onChannelsFetched() as void
	m.channels = ParseJSON(m.channelFetcher.rawChannels).entries
    changeChannel(m.activeChannel)
end function

function changeChannel(channelIndex) as void
    m.activeChannel = channelIndex

    m.Video.visible = "true"
    m.Video.control = "play"
    m.Video.setFocus(true)

    channelDetails = m.channels[m.activeChannel]
    if channelDetails = Invalid
        m.activeChannel = 0
        channelDetails = m.channels[m.activeChannel]
    endif

    setResumeChannel(m.activeChannel)

    ContentNode = CreateObject("roSGNode", "ContentNode")
    ContentNode.url = m.global.serverPath + "/stream/channel/" + channelDetails.channelUuid
    ContentNode.Live = true
    ContentNode.Title = channelDetails.title
    ContentNode.SecondaryTitle = channelDetails.channelNumber.ToStr() + " - " + channelDetails.channelName

    m.Video.content = ContentNode
    m.Video.control = "play"
end function

function onKeyEvent(key as String, press as Boolean) as Boolean
  print "onKeyEvent ";key;" "; press
  if press then
    if key = "up" or key = "right"
        if m.activeChannel = m.channels.Count() - 1
            changeChannel(0)
        else
            changeChannel(m.activeChannel + 1)
        end if
        return true
    else if key = "down" or key = "left"
        if m.activeChannel = 0
            changeChannel(m.channels.Count() - 1)
        else
            changeChannel(m.activeChannel - 1)
        end if
        return true
    end if
  end if
  return false
end function

function getResumeChannel() As integer
    sec = CreateObject("roRegistrySection", "TunerSettings")
    if sec.Exists("PreviousChannel")
        return sec.Read("PreviousChannel").ToInt()
    endif
    return 0
end function

function setResumeChannel (channelIndex As integer) As Void
    sec = CreateObject("roRegistrySection", "TunerSettings")
    sec.Write("PreviousChannel", channelIndex.ToStr())
    sec.Flush()
end function