-- reload config
hs.hotkey.bind({"alt"}, "R", function()
  hs.reload()
end)
hs.alert.show("Hammerspoon config loaded")

-- slame window to the left or right
function swipeWindowLeft(swipeLeft) 
  local window = hs.window.focusedWindow()
  local frame = window:frame()
  local screen = window:screen()
  local max = screen:frame()

  frame.w = max.w / 2
  frame.h = max.h
  if swipeLeft == true then
    -- swipe the window to the left
    frame.x = max.x
    frame.y = max.y
  else
    -- swipe the window to the right
    frame.x = (max.w / 2)
    frame.y = 0
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
