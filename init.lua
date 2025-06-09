hyper = {"cmd", "ctrl"}
hyper_m1 = {"cmd", "ctrl", "shift"}

laptop_monitor = "Built-in Retina Display"
home_dell = "DELL P2715Q"
ell_asus = "ASUS VP28U"
home_lg = "LG HDR WQHD"

laptop_speakers = "MacBook Pro Speakers"
usb_speakers = "USB Audio Device"
dell_speakers = home_dell
lg_speakers = home_lg
airpods = "Justin’s AirPods Pro"
airpods_work = "Justin’s AirPods Pro - Find My"
irig = "iRig HD 2"

local log = hs.logger.new('justin', 'debug')

-- Copied a lot from this: https://github.com/zzamboni/dot-hammerspoon/blob/master/init.lua
-- Check out https://github.com/xsznix-dotfiles/.hammerspoon/tree/master/.hammerspoon for how to break up

hs.loadSpoon("SpoonInstall")
-- Slow down installs so notifications happen slower
-- spoon.SpoonInstall.use_syncinstall = true

Install = spoon.SpoonInstall

Install:andUse("ReloadConfiguration", { start = true })

-- Keep the computer awake!
-- On by default
hs.caffeinate.set("displayIdle", true)
Install:andUse("Caffeine",
               {
                 start = true,
                 hotkeys = {
                   toggle = { hyper, "1" }
                 }
               }
)

-- Nifty little network stats.
-- Install:andUse("SpeedMenu", { })

-- Make windows have rounded corners...cuz why not?!
Install:andUse("RoundedCorners",
               {
                 start = true,
                 config = {
                   radius = 10
                 }
               }
)

Install:andUse("MountedVolumes",
               {
                 hotkeys = {
                   show = { hyper, "v" }
                 }
               }
)
-- This is crazy slow
-- Install:andUse("Emojis",
--                {
--                  hotkeys = {
--                    toggle = { {"cmd", "ctrl"}, "space" }
--                  }
--                }
-- )

Install:andUse("MiroWindowsManager",
               {
                 config = {
                   GRID = {w = 24, h = 24},
                   fullScreenSizes = { 1, 12/11, 4/3, 2 }
                 },
                 hotkeys = {
                   up = { hyper, "up" },
                   right = { hyper, "right" },
                   down = { hyper, "down" },
                   left = { hyper, "left" },
                   fullscreen = { hyper, "f" }
                 }
               }
)


-- -----------------------------------------------------------------------------
-- Window function(s)


-- Move window to the "other" monitor
function moveToOtherMonitor()
  -- If there's only one screen, no need move.
  local screens = hs.screen.allScreens()

  if #screens == 1 then
    return
  end

  local win = hs.window.focusedWindow()
  -- Debug case where slack returned nil for the above so it was impossible to move it. Hoping an update to it will fix it.
  -- local win2 = hs.window.frontmostWindow()
  -- print("win data")
  -- print(win)
  -- print(win2)

  local otherScreen = hs.fnutils.find(screens, function(screen) return screen ~= win:screen() end)
  win:moveToScreen(otherScreen)
end

hs.hotkey.bind(hyper, "o", moveToOtherMonitor)

-- -----------------------------------------------------------------------------
-- Layouts

-- This is based a lot on this:
-- https://aaronlasseigne.com/2016/02/16/switching-from-slate-to-hammerspoon/ The one area where
-- I've not explored further is around having a big/small layout for each of named layouts. Not sure
-- that is really something I want, but it's on that blog post if I want it.

-- This came through in output in the console. I think it'll help the layout tool find all of the
-- windows with a given name a little bit better.
hs.application.enableSpotlightForNameSearches(true)

positions = {
  maximized = hs.layout.maximized,
  centered = {x=0.15, y=0.15, w=0.7, h=0.7},

  left34 = {x=0, y=0, w=0.34, h=1},
  left50 = hs.layout.left50,
  left66 = {x=0, y=0, w=0.66, h=1},
  left75 = hs.layout.left75,

  right34 = {x=0.66, y=0, w=0.34, h=1},
  right50 = hs.layout.right50,
  right66 = {x=0.34, y=0, w=0.66, h=1},

  upper50 = {x=0, y=0, w=1, h=0.5},
  upper50Left50 = {x=0, y=0, w=0.5, h=0.5},
  upper50Right50 = {x=0.5, y=0, w=0.5, h=0.5},

  lower50 = {x=0, y=0.5, w=1, h=0.5},
  lower50Left50 = {x=0, y=0.5, w=0.5, h=0.5},
  lower50Right50 = {x=0.5, y=0.5, w=0.5, h=0.5},

  messages = {x=0.45, y=0, w=0.55, h=0.9},
  devtools = {x=0.1, y=0.15, w=0.6, h=0.7}
}

layouts = {
  {
    name = "Laptop",
    description = "layout for laptop screen only",
    layout = {
      {"Emacs", nil, laptop_monitor, positions.maximized, nil, nil},
      -- {"IntelliJ IDEA", nil, laptop_monitor, positions.maximized, nil, nil},
      {"Google Chrome", nil, laptop_monitor, positions.maximized, nil, nil},
      -- {"Kiwi for Gmail Lite", nil, laptop_monitor, positions.maximized, nil, nil},
      {"iTerm2", "", laptop_monitor, positions.maximized, nil, nil},
      {"Slack", nil, laptop_monitor, positions.maximized, nil, nil},
      -- {"Spotify", nil, laptop_monitor, positions.maximized, nil, nil},
    }
  },
  {
    name = "External Monitor",
    description = "layout for use with the big external monitor",
    layout = {
      {"Emacs", nil, monitor1, positions.maximized, nil, nil},
      -- {"IntelliJ IDEA", nil, monitor1, positions.maximized, nil, nil},

      {"Google Chrome", nil, monitor1, positions.right66, nil, nil},
      {"Google Chrome", "DevTools", monitor1, positions.devtools, nil, nil},
      -- {"Kiwi for Gmail Lite", nil, monitor1, positions.centered, nil, nil},
      -- {"Databricks", nil, monitor1, positions.centered, nil, nil},
      -- {"AWS", nil, monitor1, positions.centered, nil, nil},

      -- A few alias' for the various tabs I have open and may be on top in my iTerm2
      {"iTerm2", "code", monitor1, positions.left66, nil, nil},
      {"iTerm2", "data", monitor1, positions.left66, nil, nil},
      {"iTerm2", "sbt", monitor1, positions.left66, nil, nil},
      {"iTerm2", "shell", monitor1, positions.left66, nil, nil},
      {"iTerm2", "Staging", monitor1, positions.left75, nil, nil},
      {"iTerm2", "Prod", monitor1, positions.left75, nil, nil},

      -- {"Messages", nil, laptop_monitor, positions.messages, nil, nil},
      {"Slack", nil, laptop_monitor, positions.maximized, nil, nil},
      -- {"Spotify", nil, laptop_monitor, positions.maximized, nil, nil},
      -- {"Spotify", nil, monitor1, positions.centered, nil, nil},
    }
  }
}

currentLayout = null
function applyLayout(layout)
  hs.layout.apply(layout.layout, string.match)
end


-- Show all of this in a chooser
layoutChooser = hs.chooser.new(function(selection)
    if not selection then return end

    applyLayout(layouts[selection.index])
end)
i = 0
layoutChooser:choices(hs.fnutils.imap(layouts, function(layout)
                                        i = i + 1

                                        return {
                                          index=i,
                                          text=layout.name,
                                          subText=layout.description
                                        }
end))
layoutChooser:rows(#layouts)
layoutChooser:width(20)
layoutChooser:subTextColor({red=0, green=0, blue=0, alpha=0.4})

hs.hotkey.bind(hyper, "l", function() layoutChooser:show() end)
-- To test and apply the layout directly upon reload of this file
-- hs.layout.apply(layouts[2].layout, string.match)

-- -----------------------------------------------------------------------------
-- Watch for monitor screen changes and update layout when it does

allScreens = hs.screen.allScreens()
screenwatcher = hs.screen.watcher.new(function()
    -- If we switch to a new screen config, apply the layout
    local newAllScreens = hs.screen.allScreens()
    if allScreens ~= newAllScreens then
      print("New screen configuration detected")
      local names = hs.fnutils.map(newAllScreens, function(e) return e:name() end)
      if #newAllScreens == 1 and hs.fnutils.contains(names, laptop_monitor) then
        print("Back to the laptop layout")
        applyLayout(layouts[1])
      elseif #newAllScreens == 2 and (hs.fnutils.contains(names, home_dell) or hs.fnutils.contains(names, ell_asus)) then
        print("External monitor layout")
        applyLayout(layouts[2])
      else
        print("New, unknown monitor configuration, why don't you set me up!")
        hs.fnutils.each(names, function(name) print("\t" .. name) end)
      end
    end
    allScreens = newAllScreens
end)
screenwatcher:start()

-- -----------------------------------------------------------------------------
-- Watch for audio event changes and (optionally) automatically switch when
-- connected to certain devices.

function useAudio(speakers)
  currentDevice = hs.audiodevice.defaultOutputDevice()
  print("Current device is: " .. currentDevice:name())
  print("Looking for speakers: " .. speakers)
  -- device = hs.audiodevice.findDeviceByName(speakers)
  device = hs.audiodevice.findOutputByName(speakers)
  if (device ~= nil) then
    print("Found the audio device")
    if (currentDevice:name() ~= speakers) then
      print("Not currently using the audio device requested, so let's use it")
      success = device:setDefaultOutputDevice()
      if success ~= true then
        print("Unable to switch to the requested device")
      end
    else
      print("Currently using the requested device, nothing more to do.")
    end
  end
end

-- Provide some nifty url-based hooks to trigger these
-- Test with open -g hammerspoon://changeAudio?device=dell
hs.urlevent.bind(
  "changeAudio",
  function(eventName, params)
    device = params["device"]
    speakers = laptop_speakers
    if device == "usb" then
      speakers = usb_speakers
    elseif device == "dell" then
      speakers = dell_speakers
    elseif device == "lg" then
      speakers = lg_speakers
    elseif device == "airpods" then
      -- todo: need to add connect via bluetooth here too
      speakers = airpods_work
    elseif device == "irig" then
      speakers = irig
    end
    -- hs.alert.show("Changing to audio: " .. device)
    hs.notify.new({title="Changing audio", informativeText="speakers: " .. speakers}):send()
    useAudio(speakers)
  end
)


-- -----------------------------------------------------------------------------
-- Watch for usb device changes and do things when they attach/detach.

-- This requires a more complex solution like unpairing-repairing and main not
-- fully work when the other system is asleep (e.g. can you force pair?) More
-- detail in this thread:
-- https://apple.stackexchange.com/questions/399829/best-way-to-switch-magic-keyboard-and-trackpad-between-work-personal-macs

-- function toggleMagicTrackpad(connected)
--   if connected then
--     hs.notify.new({title="DAS Keyboard", informativeText="Connected, attempting to connect to MagicTrackpad"}):send()
--   else
--     hs.notify.new({title="DAS Keyboard", informativeText="Disconnected, disconnect MagicTrackpad"}):send()
--   end
-- end

-- Install:andUse(
--   "USBDeviceActions",
--   {
--     config = {
--       devices = {
--         ["Das Keyboard"] = { fn = toggleMagicTrackpad }
--       }
--     },
--     start = true
--   }
-- )
-- print("Attached USB devices:")
-- hs.fnutils.each(hs.usb.attachedDevices(), function(device)
--   print("\t" .. device.productName)
-- end)

-- -----------------------------------------------------------------------------
-- Open iTunes and refresh podcasts

function refreshPodcasts()
  script = [[
    tell application "iTunes"
      -- activate
      updateAllPodcasts
    end tell
    ]]
  ok, result = hs.applescript(script)
  hs.notify.new({title="Refreshing podcasts..."}):send()
end

function playUpFirst()
  script = [[
    set PodName to "Up First"
    tell application "iTunes"
      set eps to (first track of playlist "Podcasts" whose album is PodName)
      play eps
    end tell
    ]]
  hs.applescript(script)
end

function quitiTunes()
  hs.applescript('tell application "iTunes" to quit')
end

-- Fast forward/reverse shortcuts
hs.hotkey.bind(hyper, "'", function() hs.itunes.ff() end)
hs.hotkey.bind(hyper, ";", function() hs.itunes.rw() end)

hs.window.animationDuration = 0 -- disable animations
