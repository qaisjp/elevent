Elevent
=======

Elevent is the easiest event system for Love2d, get rid of that file full of calls and put your draw code where it should be.

This library streamlines the event system to allow multiple callbacks to be applied to a single master callback, prioritised by numbers and grouped by string.

It's super easy to get started, just check out the documentation below! The documentation is incomplete :(


Documentation
=============

`.AddEvent`
----------
`function .AddEvent(string eventName)`
AddEvent is the callback system creator, elevent automatically calls this function to apply the default love master callbacks to the system.

### Returns
It returns a function, this function must be the value of the master callback which is called by the library or love.

### Syntax
`eventName` (string, required): eventName is the name of the event, this identifies what callback needs to be applied to a master callback.

### Example
This example applies the love.draw master callback to elevent.

	function love.load()
		elevent = require "elevent"
		love.draw = elevent.AddEvent("draw")
  	end
  	
  	
`.AddHandler`
----------
`nil .AddHandler(string event, function callback, mixed ref, float priority)`
AddHandler applies a callback to a master callback, this is the main function of elevent.

### Syntax
`event` (string, required): event is the name of the event, this identifies what master callback the callback needs to be applied to.

`callback` (function, required): this identifies what callback needs to be applied to the master callback

`ref` (mixed, optional, default=callback): this identifies what reference needs to be used in order to remove the callback.

`priority` (float, optional, default=100): this sets the priority in which the event needs to be executed

    		
