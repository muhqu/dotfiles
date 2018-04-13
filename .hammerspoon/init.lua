
function initialize()

	k = hs.hotkey.modal.new("cmd", "ä")
	function k:entered()
		hs.alert.closeAll()
		hs.alert'Manage Windows'
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

hs.loadSpoon("ReloadConfiguration"):start()
hs.loadSpoon('RoundedCorners'):start()

hs.alert'Hammerspoon loaded…'

