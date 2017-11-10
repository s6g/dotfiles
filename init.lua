-- reload config on file change
function reloadConfig(files)
    doReload = false
    for _,file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end
myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.alert.show("Hammerspoon Config loaded")

function fullScreenPrimary(primary) 
  local window = hs.window.focusedWindow()
  local frame = window:frame()
  -- local screen = window:screen()
  local screen = hs.screen:primaryScreen()
  if primary == false then
    screen = screen:next()
  end
  local screenFrame = screen:frame()

  frame.w = screenFrame.w
  frame.h = screenFrame.h
  frame.x = screenFrame.x
  frame.y = screenFrame.y

  window:setFrame(frame)
end

-- push up/down
hs.hotkey.bind({"alt"}, "1", function()
    fullScreenPrimary(false)
end)

hs.hotkey.bind({"alt"}, "2", function()
    fullScreenPrimary(true)
end)

-- fullscreen
hs.hotkey.bind({"alt"}, "F", function()
  local window = hs.window.focusedWindow()
  local frame = window:frame()
  local screen = window:screen()
  local screenFrame = screen:frame()

  frame.w = screenFrame.w
  frame.h = screenFrame.h
  frame.x = screenFrame.x
  frame.y = screenFrame.y

  window:setFrame(frame)
end)
-- slame window to the left or right
function swipeWindowLeft(swipeLeft) 
  local window = hs.window.focusedWindow()
  local frame = window:frame()
  local screen = window:screen()
  local screenFrame = screen:frame()

  frame.w = screenFrame.w / 2
  frame.h = screenFrame.h
  frame.y = screenFrame.y
  if swipeLeft == true then
    -- swipe the window to the left
    frame.x = screenFrame.x
  else
    -- swipe the window to the right
    frame.x = screenFrame.x + screenFrame.w / 2
  end
  window:setFrame(frame)
end 

hs.hotkey.bind({"alt"}, "Left", function()
  swipeWindowLeft(true)
end)

hs.hotkey.bind({"alt"}, "Right", function()
  swipeWindowLeft(false)
end)

-- WiFi connections
previousSSID = hs.wifi.currentNetwork()
homeSSID = "home"

function ssidChangedCallback()
    currentSSID = hs.wifi.currentNetwork()
    
    if currentSSID == homeSSID and previousSSID ~= currentSSID then
       -- we just got home
      hs.alert.show("Welcome to home network")
    else
      hs.alert.show("Connected to " .. currentSSID .. " WiFI network ")
    end 
end

wifiWatcher = hs.wifi.watcher.new(ssidChangedCallback)
wifiWatcher:start()
