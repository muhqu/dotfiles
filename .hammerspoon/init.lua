

hs.loadSpoon("ReloadConfiguration"):start()

log = hs.logger.new('init','debug')

-- CapsLock key is mapped to cmd + ctrl + shift + alt via Karabiner.
-- https://pqrs.org/osx/karabiner/index.html
capsLock = {'cmd','ctrl','shift','alt'}

helpShown = false
function showHelp() 
	hs.alert.closeAll()
	helpShown = true
	hs.alert([[
Global Key Bindings

⇪ h			Toggle Help
⇪ u			Type current Browser URL
⇪ …			Toggle Apps:
				  i - iTerm2, c - VS Code, g - GitX, 
				  m - Mail, o - Outlook, n - Notes,
				  b - Browser (Google Chrome)

⌘ ä			Toggle Window Manage Mode

In Window Manage Mode:

←/→/↑/↓		Move window
c				Cycle center
space			Toggle fullscreen
⌘ ←/→		Cycle ¼ ½ ¾ left/right
⌘ ↑/↓		Cycle upper/lower left/right
⇧ ⌘ ←/→		Move to screen
esc			Quit mode]], 999999)
end

function hideHelp() 
	if helpShown then
		hs.alert.closeAll()
		helpShown = false
	end
end

function initialize()
	
	k = hs.hotkey.modal.new("cmd", "ä")
	function k:entered()
		hs.alert.closeAll()
		hideHelp()
		hs.alert("Manage Windows (h - help)", 999999)
	end
	function k:exited()
		hs.alert.closeAll()
		hs.alert'Done'
	end
	k:bind("cmd", "ä", function()
		k:exit()
	end)
	k:bind('', 'escape', function()
		k:exit()
	end)
	k:bind('', 'h', function()
		if not helpShown then
			showHelp()
		else
			hideHelp()
			hs.alert("Manage Windows (h - help)", 999999)
		end
	end)

	-- Space toggles the focussed between full screen and its initial size and position.
	k:bind({}, 'SPACE', function()
	  local win = hs.window.focusedWindow()
	  win:setFullScreen(not win:isFullScreen())
	end)

	-- Center window.
	k:bind({}, 'c', cycleCalls(chWinFrameFract,{
	    {0.22, 0.025, 0.56, 0.95},
	    {0.1, 0, 0.8, 1},
	    {0, 0, 1, 1}
	}))

	-- The cursor keys together with cmd make any window occupy any
	-- half of the screen.
	k:bind({"cmd"}, 'RIGHT', cycleCalls(chWinFrameFract,{
	    {0.5, 0, 0.5, 1},
	    {0.75, 0, 0.25, 1},
	    {0.25, 0, 0.75, 1}
	}))
	k:bind({"cmd"}, 'LEFT', cycleCalls(chWinFrameFract,{
	    {0, 0, 0.5, 1},
	    {0, 0, 0.25, 1},
	    {0, 0, 0.75, 1}
	}))
	k:bind({"cmd"}, 'UP', cycleCalls(chWinFrameFract,{
	    {0, 0, 0.5, 0.4},
	    {0.5, 0, 0.5, 0.4},
	    {0, 0, 1, 0.4}
	}))
	k:bind({"cmd"}, 'DOWN', cycleCalls(chWinFrameFract,{
	    {0, 0.6, 0.5, 0.4},
	    {0.5, 0.6, 0.5, 0.4},
	    {0, 0.6, 1, 0.4}
	}))

	k:bind({'shift','cmd'},  'LEFT',  function() 
	  hs.window.focusedWindow():moveOneScreenWest()
	end)
	k:bind({'shift','cmd'},  'RIGHT', function()
	  hs.window.focusedWindow():moveOneScreenEast()
	end)

	k:bind('', 'UP',    pnr(function() chWinFrame(  0,-10, 0, 0) end))
	k:bind('', 'DOWN',  pnr(function() chWinFrame(  0, 10, 0, 0) end))
	k:bind('', 'LEFT',  pnr(function() chWinFrame(-10,  0, 0, 0) end))
	k:bind('', 'RIGHT', pnr(function() chWinFrame( 10,  0, 0, 0) end))

	k:bind('shift', 'UP',    pnr(function() chWinFrame(  0,-10,  0, 10) end))
	k:bind('shift', 'DOWN',  pnr(function() chWinFrame(  0,  0,  0, 10) end))
	k:bind('shift', 'LEFT',  pnr(function() chWinFrame(-10,  0, 10,  0) end))
	k:bind('shift', 'RIGHT', pnr(function() chWinFrame(  0,  0, 10,  0) end))

	k:bind('ctrl',  'UP',    pnr(function() chWinFrame(  0, 10,  0,-10) end))
	k:bind('ctrl',  'DOWN',  pnr(function() chWinFrame(  0,  0,  0,-10) end))
	k:bind('ctrl',  'LEFT',  pnr(function() chWinFrame( 10,  0,-10,  0) end))
	k:bind('ctrl',  'RIGHT', pnr(function() chWinFrame(  0,  0,-10,  0) end))

	-- Other Key Bindings
	h = hs.hotkey.modal.new(capsLock, 'h')
	function h:entered() showHelp() end
	function h:exited() hideHelp() end
	h:bind(capsLock, 'h', function() h:exit() end)
	h:bind('', 'escape', function() h:exit() end)

	hs.hotkey.bind(capsLock, 'u', function() typeCurrentBrowserURL() end)
		
	hs.hotkey.bind(capsLock, 'i', function() toggleApp("iTerm2") end)
	hs.hotkey.bind(capsLock, 'c', function() toggleApp("Code") end)
	hs.hotkey.bind(capsLock, 'b', function() toggleApp("Google Chrome") end)
	hs.hotkey.bind(capsLock, 'g', function() toggleApp("GitX") end)
	hs.hotkey.bind(capsLock, 'm', function() toggleApp("Mail") end)
	hs.hotkey.bind(capsLock, 'o', function() toggleApp("Microsoft Outlook") end)
	hs.hotkey.bind(capsLock, 'n', function() toggleApp("Notes") end)

end

-- Make the alerts look nicer.
hs.alert.defaultStyle.strokeColor =  {white = 1, alpha = 0.5}
hs.alert.defaultStyle.fillColor =  {white = 0.05, alpha = 0.75}
hs.alert.defaultStyle.radius = 6
hs.alert.defaultStyle.textColor = {white = 1, alpha = 1}
hs.alert.defaultStyle.textSize = 18
hs.alert.defaultStyle.textStyle = {}

-- Disable the slow default window animations.
hs.window.animationDuration = 0

-- press and repeat
function pnr(fn) return fn, nil, fn end

function chWinFrame(fx, fy, fw, fh)
  local win = hs.window.focusedWindow()
  local f = win:frame()

  f.x = f.x + fx
  f.y = f.y + fy
  f.w = f.w + fw
  f.h = f.h + fh
  win:setFrame(f)
end

function chWinFrameFract(fx, fy, fw, fh)
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local sf = screen:frame()

  f.x = fx * sf.w + sf.x
  f.y = fy * sf.h + sf.y
  f.w = fw * sf.w
  f.h = fh * sf.h
  win:setFrame(f)
end


function unpack(t, i)
  i = i or 1
  if t[i] ~= nil then
    return t[i], unpack(t, i + 1)
  end
end

function cycleCalls(fn, args)
	local i = 1
	return function()
		fn(unpack(args[i]))
		i = (i == #args) and 1 or i +1
	end
end

initialize()

hs.loadSpoon('RoundedCorners'):start()



-- Rather than switch to Chrome, copy the current URL, switch back to the previous app and paste,
-- This is a function that fetches the current URL from Chrome and types it
function typeCurrentBrowserURL()
	script = [[
	tell application "Google Chrome" to return URL of active tab of first window
	]]
	ok, result = hs.applescript(script)
	if (ok) then
		hs.eventtap.keyStrokes(result)
	end
end


-- Callback function for application events
function applicationWatcher(appName, eventType, app)
	if (eventType == hs.application.watcher.activated) then
		if (appName == "Finder") then
			-- Bring all Finder windows forward when one gets activated
			app:selectMenuItem({"Window", "Bring All to Front"})
		end
	end
end
hs.application.watcher.new(applicationWatcher):start()


-- toggleApp() uses application:activate to switch between an app and the
-- previously active app. It only brings the main window (or last active window)
-- to foreground, instead of the system task switcher (cmd+tab), which brings
-- all application windows to foreground.
previousApp = hs.application.frontmostApplication()
function toggleApp(appName)
	local app = hs.appfinder.appFromName(appName)
	local currentApp = hs.application.frontmostApplication();
	if not app then
		hs.application.launchOrFocus(appName)
	elseif not app:isFrontmost() then
		app:activate();
	else
		previousApp:activate();
	end
	previousApp = currentApp;
end


-- 
-- Auto Close the annoying "Disk Not Ejected Properly" Notifications
--
function clearEjectNotifications()
	hs.osascript.applescript([[
		tell application "System Events"
			tell process "NotificationCenter"
				set windowCount to count windows
				repeat with i from windowCount to 1 by -1
					set notifTitle to value of static text 1 of window i
					-- set notifDescription to value of static text 2 of scroll area 1 of window i
					-- log notifDescription
					-- if notifTitle is "Disk Not Ejected Properly" and notifDescription contains "LaCie" then
					if notifTitle is "Disk Not Ejected Properly" then
						click button "Close" of window i
					end if
				end repeat
			end tell
		end tell
	]])
end
hs.distributednotifications.new(function(name, object, userInfo)
	print(string.format("NOTIF: %s", hs.inspect({name, object, userInfo}, {newline=" ",indent=""})))
	if (name == "com.apple.sharedfilelist.change" and object == "com.apple.LSSharedFileList.FavoriteVolumes") then
		clearEjectNotifications()
	end
end):start()


function notify(message)
	hs.notify.new({title="Hammerspoon", informativeText=message}):send()
end

notify'configuration loaded! 🎉'

