// This is my configuration for Phoenix <https://github.com/kasper/phoenix>,
// a super-lightweight OS X window manager that can be configured and
// scripted through Javascript.

Phoenix.set({
  daemon: false,
  openAtLogin: true
});

function showAlert(msg, dur) {
  var sf = Window.focused().screen().frame()
  Modal.build({
    text: msg,
    duration: dur,
    origin: function (mf) {
      return {
        x: sf.x + (sf.width / 2) - mf.width,
        y: sf.y + (sf.height / 2) - mf.height
      }
    }
  }).show();
}

var mNone = [],
  mCmd = ['cmd'],
  mShift = ['shift'],
  mCmdShift = ['cmd', 'shift'],
  nudgePixels = 10,
  padding = 0,
  previousSizes = {};

// Remembers hotkey bindings.
var keys = [];

function bind(key, mods, callback) {
  keys.push(new Key(key, mods, callback));
}

// ############################################################################
// Modal activation
// ############################################################################

// Modal activator
// This hotkey enables/disables all other hotkeys.
var active = false;
Key.on('ä', ['cmd'], function () {
  if (!active) {
    enableKeys();
  } else {
    disableKeys();
  }
});

// These keys end Phoenix mode.
bind('escape', [], function () {
  disableKeys();
});
bind('return', [], function () {
  disableKeys();
});

// ############################################################################
// Bindings
// ############################################################################

// ### General key configurations
//
// Space toggles the focussed between full screen and its initial size and position.
bind('space', mNone, function () {
  Window.focused().setFullScreen(!Window.focused().isFullScreen());
});

// Center window.
bind('c', mNone, cycleCalls(
  toGrid, [
    [0.22, 0.025, 0.56, 0.95],
    [0.1, 0, 0.8, 1],
    [0, 0, 1, 1]
  ]
));

// The cursor keys together with cmd make any window occupy any
// half of the screen.
bind('right', mCmd, cycleCalls(
  toGrid, [
    [0.5, 0, 0.5, 1],
    [0.75, 0, 0.25, 1],
    [0.25, 0, 0.75, 1]
  ]
));

bind('left', mCmd, cycleCalls(
  toGrid, [
    [0, 0, 0.5, 1],
    [0, 0, 0.25, 1],
    [0, 0, 0.75, 1]
  ]
));

bind('down', mCmd, cycleCalls(
  toGrid, [
    [0, 0.6, 0.5, 0.4],
    [0.5, 0.6, 0.5, 0.4],
    [0, 0.6, 1, 0.4]
  ]
));

bind('up', mCmd, cycleCalls(
  toGrid, [
    [0, 0, 0.5, 0.4],
    [0.5, 0, 0.5, 0.4],
    [0, 0, 1, 0.4]
  ]
));

// The cursor keys move the focussed window.
bind('up', mNone, function () {
  Window.focused().nudgeUp(5);
});

bind('right', mNone, function () {
  Window.focused().nudgeRight(5);
});

bind('down', mNone, function () {
  Window.focused().nudgeDown(5);
});

bind('left', mNone, function () {
  Window.focused().nudgeLeft(5);
});

// <SHIFT> + cursor keys grows/shrinks the focussed window.
bind('right', mShift, function () {
  Window.focused().growWidth();
});

bind('left', mShift, function () {
  Window.focused().shrinkWidth();
});

bind('up', mShift, function () {
  Window.focused().shrinkHeight();
});

bind('down', mShift, function () {
  Window.focused().growHeight();
});

bind('right', mCmdShift, function () {
  Window.focused().toPreviousScreen();
});

bind('left', mCmdShift, function () {
  Window.focused().toNextScreen();
});

bind('up', mCmdShift, function () {
  Window.focused().shrinkHeight();
});

bind('down', mCmdShift, function () {
  Window.focused().growHeight();
});

// ############################################################################
// Bindings for specific apps
// ############################################################################

// bind( '1', mNone, function() {
//   var forklift = App.findByTitle('ForkLift').firstWindow();
//   if (forklift) {
//     forklift.toGrid(0.15, 0.1, 0.6, 0.7);
//   }
//  
//   disableKeys();
// });

// Chrome Devtools
//
// When checking HTML/JS in Chrome I want to have my browsing window to the
// East and my Chrome devtools window to the W, the latter not quite on full
// height.
// bind( 'd', mNone, function() {
//   var chrome = App.findByTitle('Google Chrome'),
//   browseWindow = chrome.findWindowNotMatchingTitle('^Developer Tools -'),
//   devToolsWindow = chrome.findWindowMatchingTitle('^Developer Tools -');
//  
//   showAlert( 'Chrome Dev Tools Layout', 0.25 );
//  
//   if ( browseWindow ) {
//   browseWindow.toE();
//   }
//  
//   if ( devToolsWindow ) {
//   devToolsWindow.toGrid( 0, 0, 0.5, 1 );
//   }
//  
//   disableKeys();
// });


// ############################################################################
// Helpers
// ############################################################################

// Cycle args for the function, if called repeatedly
// cycleCalls(fn, [ [args1...], [args2...], ... ])
var lastCall = null;

function cycleCalls(fn, argsList) {
  var argIndex = 0,
    identifier = {};
  return function () {
    if (lastCall !== identifier || ++argIndex >= argsList.length) {
      argIndex = 0;
    }
    lastCall = identifier;
    fn.apply(this, argsList[argIndex]);
  };
}

// Disables all remembered keys.
function disableKeys(quiet) {
  active = false;
  _(keys).each(function (key) {
    key.disable();
  });
  if (!quiet) {
    showAlert("done", 0.5);
  }
}

// Enables all remembered keys.
function enableKeys(quiet) {
  active = true;
  _(keys).each(function (key) {
    key.enable();
  });
  if (!quiet) {
    showAlert("Phoenix", 0.5);
  }
}

// ### Helper methods `Window`
//
// #### Window#toGrid()
//
// This method can be used to push a window to a certain position and size on
// the screen by using four floats instead of pixel sizes.  Examples:
//
//     // Window position: top-left; width: 25%, height: 50%
//     someWindow.toGrid( 0, 0, 0.25, 0.5 );
//
//     // Window position: 30% top, 20% left; width: 50%, height: 35%
//     someWindow.toGrid( 0.3, 0.2, 0.5, 0.35 );
//
// The window will be automatically focussed.  Returns the window instance.
function windowToGrid(window, x, y, width, height, screen) {
  var screenRect = (screen || window.screen()).flippedVisibleFrame();

  window.setFrame({
    x: Math.round(x * screenRect.width) + padding + screenRect.x,
    y: Math.round(y * screenRect.height) + padding + screenRect.y,
    width: Math.round(width * screenRect.width) - (2 * padding),
    height: Math.round(height * screenRect.height) - (2 * padding)
  });

  window.focus();

  return window;
}

function windowGrid(window) {
  var screenRect = window.screen().flippedVisibleFrame(),
    winRect = window.frame();
  return {
    x: Math.round((winRect.x - screenRect.x) / (screenRect.width)),
    y: Math.round((winRect.y - screenRect.y) / (screenRect.height)),
    width: Math.max(1, Math.round(winRect.width / (screenRect.width))),
    height: Math.max(1, Math.round(winRect.height / (screenRect.height)))
  };
}

function toGrid(x, y, width, height) {
  windowToGrid(Window.focused(), x, y, width, height);
}

Window.prototype.toGrid = function (x, y, width, height) {
  windowToGrid(this, x, y, width, height);
};

// Convenience method, doing exactly what it says.  Returns the window
// instance.
Window.prototype.toFullScreen = function () {
  return this.toGrid(0, 0, 1, 1);
};


// Convenience method, pushing the window to the top half of the screen.
// Returns the window instance.
Window.prototype.toN = function () {
  return this.toGrid(0, 0, 1, 0.5);
};

// Convenience method, pushing the window to the right half of the screen.
// Returns the window instance.
Window.prototype.toE = function () {
  return this.toGrid(0.5, 0, 0.5, 1);
};

// Convenience method, pushing the window to the bottom half of the screen.
// Returns the window instance.
Window.prototype.toS = function () {
  return this.toGrid(0, 0.5, 1, 0.5);
};

// Convenience method, pushing the window to the left half of the screen.
// Returns the window instance.
Window.prototype.toW = function () {
  return this.toGrid(0, 0, 0.5, 1);
};


// Stores the window position and size, then makes the window full screen.
// Should the window be full screen already, its original position and size
// is restored.  Returns the window instance.
Window.prototype.toggleFullscreen = function () {
  if (previousSizes[this]) {
    this.setFrame(previousSizes[this]);
    delete previousSizes[this];
  } else {
    previousSizes[this] = this.frame();
    this.toFullScreen();
  }

  return this;
};

// Move the currently focussed window left by [`nudgePixel`] pixels.
Window.prototype.nudgeLeft = function (factor) {
  var win = this,
    frame = win.frame(),
    screenFrame = win.screen().flippedFrame(),
    pixels = nudgePixels * (factor || 1);

  if ((frame.x - screenFrame.x) >= pixels) {
    frame.x -= pixels;
  } else {
    frame.x = screenFrame.x;
  }
  win.setFrame(frame);
};

// Move the currently focussed window right by [`nudgePixel`] pixels.
Window.prototype.nudgeRight = function (factor) {
  var win = this,
    frame = win.frame(),
    screenFrame = win.screen().flippedFrame(),
    maxLeft = win.screen().flippedFrame().width - frame.width,
    pixels = nudgePixels * (factor || 1);

  if ((frame.x - screenFrame.x) < maxLeft - pixels) {
    frame.x += pixels;
  } else {
    frame.x = maxLeft + screenFrame.x;
  }
  win.setFrame(frame);
};

// Move the currently focussed window left by [`nudgePixel`] pixels.
Window.prototype.nudgeUp = function (factor) {
  var win = this,
    frame = win.frame(),
    screenFrame = win.screen().flippedFrame(),
    pixels = nudgePixels * (factor || 1);

  if ((frame.y - screenFrame.y) >= pixels) {
    frame.y -= pixels;
  } else {
    frame.y = screenFrame.y;
  }
  win.setFrame(frame);
};

// Move the currently focussed window right by [`nudgePixel`] pixels.
Window.prototype.nudgeDown = function (factor) {
  var win = this,
    frame = win.frame(),
    screenFrame = win.screen().flippedFrame(),
    maxTop = win.screen().flippedFrame().height - frame.height,
    pixels = nudgePixels * (factor || 1);

  if ((frame.y - screenFrame.y) < maxTop - pixels) {
    frame.y += pixels;
  } else {
    frame.y = maxTop + screenFrame.y;
  }
  win.setFrame(frame);
};

// #### Functions for growing / shrinking the focussed window.

Window.prototype.growWidth = function () {
  this.nudgeLeft(3);

  var win = this,
    frame = win.frame(),
    screenFrame = win.screen().flippedFrame(),
    pixels = nudgePixels * 6;

  if (frame.width < screenFrame.width - pixels) {
    frame.width += pixels;
  } else {
    frame.width = screenFrame.width;
  }

  win.setFrame(frame);
};

Window.prototype.growHeight = function () {
  this.nudgeUp(3);

  var win = this,
    frame = win.frame(),
    screenFrame = win.screen().flippedFrame(),
    pixels = nudgePixels * 6;

  if (frame.height < screenFrame.height - pixels) {
    frame.height += pixels;
  } else {
    frame.height = screenFrame.height;
  }

  win.setFrame(frame);
};

Window.prototype.shrinkWidth = function () {
  var win = this,
    frame = win.frame(),
    screenFrame = win.screen().flippedFrame(),
    pixels = nudgePixels * 6;

  if (frame.width >= pixels * 2) {
    frame.width -= pixels;
  } else {
    frame.width = pixels;
  }

  win.setFrame(frame);

  this.nudgeRight(3);
};

Window.prototype.shrinkHeight = function () {
  var win = this,
    frame = win.frame(),
    screenFrame = win.screen().flippedVisibleFrame(),
    pixels = nudgePixels * 6;

  if (frame.height >= pixels * 2) {
    frame.height -= pixels;
  } else {
    frame.height = pixels;
  }

  win.setFrame(frame);

  this.nudgeDown(3);
};


Window.prototype.toNextScreen = function () {
  this.toScreen(this.screen().nextScreen());
};
Window.prototype.toPreviousScreen = function () {
  this.toScreen(this.screen().previousScreen());
};

Window.prototype.toScreen = function (screen) {
  var win = this,
    frame = win.frame(),
    screenFrame = win.screen().flippedVisibleFrame(),
    nextScreenFrame = screen.flippedVisibleFrame();
  var relatives = [
    (frame.x - screenFrame.x) / screenFrame.width,
    (frame.y - screenFrame.y) / screenFrame.height,
    (frame.width / screenFrame.width),
    (frame.height / screenFrame.height)
  ];
  var newFrame = {
    x: Math.round(relatives[0] * nextScreenFrame.width) + nextScreenFrame.x,
    y: Math.round(relatives[1] * nextScreenFrame.height) + nextScreenFrame.y,
    width: Math.max(1, Math.round(relatives[2] * nextScreenFrame.width)),
    height: Math.max(1, Math.round(relatives[3] * nextScreenFrame.height)),
  }
  win.setFrame(newFrame);
};


// ### Helper methods `App`
//
// Finds the window with a certain title.  Expects a string, returns a window
// instance or `undefined`.  If there are several windows with the same title,
// the first found instance is returned.
App.findByTitle = function (title) {
  return _(this.runningApps()).find(function (app) {
    if (app.title() === title) {
      app.show();
      return true;
    }
  });
};


// Finds the window whose title matches a regex pattern.  Expects a string
// (the pattern), returns a window instance or `undefined`.  If there are
// several matching windows, the first found instance is returned.
App.prototype.findWindowMatchingTitle = function (title) {
  var regexp = new RegExp(title);

  return _(this.visibleWindows()).find(function (win) {
    return regexp.test(win.title());
  });
};


// Finds the window whose title doesn't match a regex pattern.  Expects a
// string (the pattern), returns a window instance or `undefined`.  If there
// are several matching windows, the first found instance is returned.
App.prototype.findWindowNotMatchingTitle = function (title) {
  var regexp = new RegExp(title);

  return _(this.visibleWindows()).find(function (win) {
    return !regexp.test(win.title());
  });
};


// Returns the first visible window of the app or `undefined`.
App.prototype.firstWindow = function () {
  return this.visibleWindows()[0];
};



// ############################################################################
// Init
// ############################################################################

// Initially disable all hotkeys
disableKeys(true);

showAlert("Phoenix loaded…", 0.5);