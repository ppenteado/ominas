pg\_drag.pro
===================================================================================================



























pg\_drag
________________________________________________________________________________________________________________________





.. code:: IDL

 result = pg_drag(object_ptd, draw=draw, xor_graphics=xor_graphics, dtheta=dtheta, axis_ptd=axis_ptd, sample=sample, move=move, symbol=symbol, silent=silent, color=color, fn=fn, data=data)



Description
-----------
	Allows the user to graphically translate and rotate an array of points
	using the mouse.



	cursor_move is used to perfform the drag.  See that routine for more
	detail.


 STATUS:
	Complete


 SEE ALSO:
	pg_move










Returns
-------

	2-element array giving the drag translation as [dx,dy].










+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




object\_ptd
-----------------------------------------------------------------------------

*in* 

Array (n_objects) of POINT containing the
			image points to be dragged.





+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _draw
- draw 



.. _xor\_graphics
- xor\_graphics *in* 

If set, grahics are drawn using the XOR function.




.. _dtheta
- dtheta 

	Dragged rotation in radians.





.. _axis\_ptd
- axis\_ptd *in* 

POINT containing a single image point
			to be used as the axis of rotation.




.. _sample
- sample *in* 

	Sampling interval for drag graphics.  The input
			points are subsampled at this interval so that the
			dragging can be done smoothly.  Default is 10.




.. _move
- move *in* 

	If set, object_ptd will be modified on return using
			pg_move.




.. _symbol
- symbol *in* 

	If set, the symbol number will be passed to cursor_move
			so something other than a period can be used to mark
			points.




.. _silent
- silent *in* 

	If set, turns off the notification that cursor
                       movement is required.




.. _color
- color *in* 

	Drawing color.  Default is ctyellow.




.. _fn
- fn 



.. _data
- data 













History
-------

 	Written by:	Spitale, 2/1998
      Modified by:     Dyer Lytle, Vance Haemmerle 11/1998





















