LibDraggable exists to make windows draggable.

HOW IT WORKS:
	window:GetBorder().Event.MouseMove = YourMouseMoveFunction
	window:GetBorder().Event.LeftUp = YourLeftUpFunction
	Library.LibDraggable.dragify(window, callback)

LibDraggable checks for mousedowns in the border of the window
(as in window:GetBorder()).  If it has detected one, but hasn't
detected a LeftUp event, it intercepts mousemoves.  If no dragging
is happening, it will pass events on to the previous values of
MouseMove and LeftUp, though I don't know why you'd care.

If you provide a callback function, it'll be called as
	callback(window, x, y)

whenever there's a move.
