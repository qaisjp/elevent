-- Elevent 1.0
-- Licensed under The MIT License (MIT)
-- Copyright (c) 2013 Qais "qaisjp" Patankar

eventList, renderList = {}, {}
Event = {}

Event.AddEvent = (event) ->
	if (type(event)!="string") or (event=="")
		error "Invalid `event` parameter supplied", 2
	
	if not eventList[event\lower!]
		eventList[event\lower!] = {}
		renderList[event\lower!] = {}

	fn = (...) ->
		for i,v in ipairs renderList[event]
			if eventList[event][v] and eventList[event][v].callback
				eventList[event][v].callback event, ...
	return fn


Event.AddHandler = (event, callback, ref, priority) ->
	if (type(event)!="string") or (event=="")
		error "Invalid `event` parameter supplied", 2
	
	if (type callback) != "function"
		error "Invalid `callback` parameter supplied", 2
	
	event = event\lower!
	priority = tonumber(priority) or 100 -- default frontmost (can be overidden, ofc)
	ref = ref or callback

	-- does event exist?
	if not eventList[event]
		Event.AddEvent event
	
	if eventList[event][ref]
		error "Reference already exists for this event!", 2
	

	eventList[event][ref] = {:callback, :priority}
	table.insert renderList[event], ref
	table.sort renderList[event],
		(a,b) ->
			if not a
				return false
			elseif not b
				return true
			
			ea, eb = eventList[event][a], eventList[event][b]
			if (not ea) or (not eb)
				return true
			
			ea.priority < eb.priority

Event.RemoveHandler = (event, ref) ->
	if not ref
		error "Invalid parameter supplied for `ref`", 2

	if (type(event)~="string") or (event=="")
		error "Invalid `event` parameter supplied", 2 

	event = event\lower!
	if not eventList[event]
		error "Event supplied doesn't exist", 2 

	if not eventList[event][ref] then
		return false

	eventList[event][ref] = nil
	for i,v in ipairs renderList[event]
		if v == ref
			table.remove renderList, i
			break

Event.RemoveAllHandlers = (ref) ->
	if not ref
		error "Invalid parameter supplied for `ref`", 2

	for event, events in pairs eventList
		for eventref in pairs events
			if eventref == ref
				Event.RemoveHandler(event, eventref)

-- This adds the default love events
for i,v in ipairs {
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
}
	love[v] = Event.AddEvent v
Event
