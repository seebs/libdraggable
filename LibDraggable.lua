--[[ LibDraggable
  Library.LibDraggable.draggify(window)
]]--

if not Library then Library = {} end
local Draggable = {}
if not Library.LibDraggable then Library.LibDraggable = Draggable end

Draggable.DebugLevel = 0
Draggable.Version = "VERSION"

function Draggable.debug(level, text, ...)
  if (level <= Draggable.DebugLevel) then
    print(string.format(text or 'nil', ...))
  end
end

function Draggable.printf(text, ...)
  print(string.format(text or 'nil', ...))
end

Draggable.windows = {}

function Draggable.draggify(window, callback)
  newtab = { dragging = false, x = 0, y = 0 }
  Draggable.windows[window] = newtab
  newtab.mousemove = window:GetBorder().Event.MouseMove
  newtab.leftup = window:GetBorder().Event.LeftUp
  newtab.leftupoutside = window:GetBorder().Event.LeftUpoutside
  newtab.callback = callback
  window:GetBorder().Event.LeftDown = function(...) Draggable.leftdown(window, ...) end
  window:GetBorder().Event.MouseMove = function(...) Draggable.mousemove(window, ...) end
  window:GetBorder().Event.LeftUp = function(...) Draggable.leftup(window, ...) end
  window:GetBorder().Event.LeftUpoutside = function(...) Draggable.leftupoutside(window, ...) end
  Draggable.windows[window] = newtab
end

function Draggable.leftdown(window, ...)
  local win = Draggable.windows[window]
  if not win then
    Draggable.windows[window] = { dragging = false, x = 0, y = 0 }
    win = Draggable.windows[window]
  end
  win.dragging = true
  win.win_x = window:GetLeft()
  win.win_y = window:GetTop()
  win.ev_x = Inspect.Mouse().x
  win.ev_y = Inspect.Mouse().y
end

function Draggable.mousemove(window, ...)
  local event, x, y = ...
  local win = Draggable.windows[window]
  if win and win.dragging then
    local win = Draggable.windows[window]
    local new_x = win.win_x + x - win.ev_x
    local new_y = win.win_y + y - win.ev_y
    window:SetPoint("TOPLEFT", UIParent, "TOPLEFT", new_x, new_y)
    if win.callback then
      win.callback(window, new_x, new_y)
    end
  else
    if win and win.mousemove then
      win.mousemove(...)
    end
  end
end

function Draggable.leftup(window, ...)
  local win = Draggable.windows[window]
  if win then
    if not win.dragging then
      if win.leftup then
        win.leftup(...)
      end
    end
    win.dragging = false
    win.ev_x = nil
    win.ev_y = nil
  end
end

function Draggable.leftupoutside(window, ...)
  local win = Draggable.windows[window]
  if win then
    if not win.dragging then
      if win.leftupoutside then
        win.leftupoutside(...)
      end
    end
    win.dragging = false
    win.ev_x = nil
    win.ev_y = nil
  end
end
