sub init()
    print "in SettingsScreen"

    m.serverSettings = CreateObject("roRegistrySection", "ServerSettings")

    m.inputServer = m.top.findNode("tvhServer")
    m.inputPort = m.top.findNode("tvhPort")
    m.inputUser = m.top.findNode("tvhUser")
    m.inputPassword = m.top.findNode("tvhPassword")
    m.helpText = m.top.findNode("helpText")

    m.keyboard = createObject("roSGNode", "StandardKeyboardDialog")
    m.keyboard.buttons=["OK","Cancel"]

    m.focusableInputs = [
        m.inputServer,
        m.inputPort,
        m.inputUser,
        m.inputPassword,
    ]
    m.currentFocus = 0

    For Each el In m.focusableInputs
        if m.serverSettings.exists(el.id)
            el.text = m.serverSettings.Read(el.id)
        end if
        hideFocus(el)
    End For

    moveFocus(0)
    m.top.setFocus(true)
end sub

function moveFocus(direction) as void
    previousFocusEl = m.focusableInputs[m.currentFocus]
    m.currentFocus = m.currentFocus + direction

    if (m.currentFocus < 0) 
        m.currentFocus = 0
    else if (m.currentFocus >= m.focusableInputs.Count()) 
        m.currentFocus = m.focusableInputs.Count() - 1
    end if

    currentFocusEl = m.focusableInputs[m.currentFocus]

    hideFocus(previousFocusEl)
    showFocus(currentFocusEl)
end function

function showFocus(element) as void
    element.opacity = 1
end function

function hideFocus(element) as void
    element.opacity = 0.5
end function

function activateInteract()
    currentFocusEl = m.focusableInputs[m.currentFocus]

    m.top.dialog = m.keyboard
    m.top.dialog.observeField("buttonSelected","onButtonSelected")

    ' m.keyboard.visible = true
    m.keyboard.text = currentFocusEl.text
    m.keyboard.title = currentFocusEl.hinttext
    m.keyboard.keyboardDomain = currentFocusEl.inputType
    ' m.keyboard.setFocus(true)
    ' m.helptext.visible = false
    end function

    function onButtonSelected()
    if m.top.dialog.buttonSelected = 0
        saveField()
    end if
    m.top.dialog.close = true
end function

function saveField()
    ' m.helpText.visible = true
    ' m.keyboard.visible = false
    ' m.keyboard.setFocus(false)
    m.top.setFocus(true)

    m.focusableInputs[m.currentFocus].text = m.keyboard.text

    m.serverSettings.write(m.focusableInputs[m.currentFocus].id, m.focusableInputs[m.currentFocus].text)
    m.serverSettings.flush()
end function

function onKeyEvent(key as String, press as Boolean) as Boolean
    print "onKeyEvent ";key;" "; press
    if press then
        if key = "up"
            moveFocus(-1)
            return true
        else if key = "down"
            moveFocus(1)
            return true
        else if key = "OK"
            activateInteract()
            return true
        else if key = "back"
            ' print m.keyboard.hasFocus()
        if m.keyboard.focusedChild <> invalid
            saveField()
            return true
        end if
            ' Exit - will main menu save us?
            return true
        end if
    end if
    return false
end function