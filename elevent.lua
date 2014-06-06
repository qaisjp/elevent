-- Elevent 1.0
-- Licensed under The MIT License (MIT)
-- Copyright (c) 2013 Qais "qaisjp" Patankar

local eventList, renderList = { }, { }
local Event = { }
Event.AddEvent = function(event)
  if (type(event) ~= "string") or (event == "") then
    error("Invalid `event` parameter supplied", 2)
  end
  if not eventList[event:lower()] then
    eventList[event:lower()] = { }
    renderList[event:lower()] = { }
  end
  local fn
  fn = function(...)
    for i, v in ipairs(renderList[event]) do
      if eventList[event][v] and eventList[event][v].callback then
        eventList[event][v].callback(event, ...)
      end
    end
  end
  return fn
end
Event.AddHandler = function(event, callback, ref, priority)
  if (type(event) ~= "string") or (event == "") then
    error("Invalid `event` parameter supplied", 2)
  end
  if (type(callback)) ~= "function" then
    error("Invalid `callback` parameter supplied", 2)
  end
  event = event:lower()
  priority = tonumber(priority) or 100
  ref = ref or callback
  if not eventList[event] then
    Event.AddEvent(event)
  end
  if eventList[event][ref] then
    error("Reference already exists for this event!", 2)
  end
  eventList[event][ref] = {
    callback = callback,
    priority = priority
  }
  table.insert(renderList[event], ref)
  return table.sort(renderList[event], function(a, b)
    if not a then
      return false
    elseif not b then
      return true
    end
    local ea, eb = eventList[event][a], eventList[event][b]
    if (not ea) or (not eb) then
      return true
    end
    return ea.priority < eb.priority
  end)
end
Event.RemoveHandler = function(event, ref)
  if not ref then
    error("Invalid parameter supplied for `ref`", 2)
  end
  if (type(event) ~= "string") or (event == "") then
    error("Invalid `event` parameter supplied", 2)
  end
  event = event:lower()
  if not eventList[event] then
    error("Event supplied doesn't exist", 2)
  end
  if not eventList[event][ref] then
    return false
  end
  eventList[event][ref] = nil
  for i, v in ipairs(renderList[event]) do
    if v == ref then
      table.remove(renderList, i)
      break
    end
  end
end
Event.RemoveAllHandlers = function(ref)
  if not ref then
    error("Invalid parameter supplied for `ref`", 2)
  end
  for event, events in pairs(eventList) do
    for eventref in pairs(events) do
      if eventref == ref then
        Event.RemoveHandler(event, eventref)
      end
    end
  end
end
for i, v in ipairs({
  "draw",
  "errhand",
  "focus",
  "joystickpressed",
  "joystickreleased",
  "keypressed",
  "keyreleased",
  "load",
  "mousepressed",
  "mousereleased",
  "quit",
  "run",
  "update"
}) do
  love[v] = Event.AddEvent(v)
end
return Event
