pg\_select\_points.pro
===================================================================================================



























pg\_select\_points
________________________________________________________________________________________________________________________





.. code:: IDL

 result = pg_select_points(dd, psym=psym, noverbose=noverbose, color=color, p0=p0, one=one, number=number, cancelled=cancelled, ptd_output=ptd_output)



Description
-----------
	Allows the user to select points in an image using the mouse.










Returns
-------

	Array of image points (2,n).










+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




dd
-----------------------------------------------------------------------------

*in* 

Data descriptor containing the image.





+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _psym
- psym *in* 

		Plotting symbol to use for the points.




.. _noverbose
- noverbose *in* 

	If set, turns off the notification that cursor
			movement is required.




.. _color
- color *in* 

	Color to use for graphics overlays.




.. _p0
- p0 *in* 

	Initial point, instead of user selection.




.. _one
- one *in* 

	If set, the routine will exit after selecting one point.




.. _number
- number *in* 

	If set, each point will be labeled with a number.




.. _cancelled
- cancelled 

Set if routine is caused to return by the cancel button.





.. _ptd\_output
- ptd\_output *in* 

If set, a POINT object is returned instead
			of a points array.








Examples
--------

.. code:: IDL


  To print the coordinates of each point as the user selects them, use:

   can=0 & while(NOT can) do print, pg_select_points(dd, /one, /nov, can=can)


 STATUS:
	Complete










History
-------

 	Written by:	Spitale, 9/2001





















