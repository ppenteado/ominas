pg\_select\_region.pro
===================================================================================================



























pg\_select\_region
________________________________________________________________________________________________________________________





.. code:: IDL

 result = pg_select_region(dd, color=color, select_button=select_button, cancel_button=cancel_button, end_button=end_button, silent=silent, p0=p0, autoclose=autoclose, points=points, noclose=noclose, data=data, box=box, image_pts=image_pts)



Description
-----------
	Allows the user to select regions in an image using the mouse.










Returns
-------

	Array of subscripts of all image points which lie within the selected
	region.  -1 is returned if the cancel button is pressed.


 STATUS:
	Complete


 SEE ALSO:
	pg_trim










+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




dd
-----------------------------------------------------------------------------

*in* 

Data descriptor containing an image.





+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _color
- color *in* 

	Color to use for graphics overlays.





.. _select\_button
- select\_button *in* 

Index of button to use as the select button instead
			of the left button (1).




.. _cancel\_button
- cancel\_button *in* 

Index of mouse button to be used as a cancel
			button instead of left+middle, (3).




.. _end\_button
- end\_button *in* 

Index of button to use as the end button instead
			of the right button (4).




.. _silent
- silent *in* 

	If set, turns off the notification that cursor
			movement is required.




.. _p0
- p0 *in* 

	First point of line.  If set, then the routine
			immediately begins to drag from that point until a
			button is released.




.. _autoclose
- autoclose *in* 

If set, the region is automaticaly closed when the
			end button is pressed.




.. _points
- points *in* 

	If set, the selected points are returned instead
			of enclosed indices.




.. _noclose
- noclose 



.. _data
- data 



.. _box
- box *in* 

	If set, a rectanguar region is selected.





.. _image\_pts
- image\_pts 













History
-------

 	Written by:	Spitale, 2/1998





















