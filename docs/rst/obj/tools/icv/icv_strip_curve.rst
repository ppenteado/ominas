icv\_strip\_curve.pro
===================================================================================================



























icv\_strip\_curve
________________________________________________________________________________________________________________________





.. code:: IDL

 result = icv_strip_curve(cd, image, curve_pts, width, nD, cos_alpha, sin_alpha, zero=zero, grid_x=grid_x, grid_y=grid_y)



Description
-----------
	Using Lagrange interpolation, extracts an image strip of a specified
	width centered on the specified curve.










Returns
-------

	Image strip (n_points, nD).


 STATUS:
	Complete










+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




cd
-----------------------------------------------------------------------------

*in* 

	Camera descriptor.





image
-----------------------------------------------------------------------------

*in* 

	Image from which to extract the strip.





curve\_pts
-----------------------------------------------------------------------------

*in* 

Array (2, n_points) of image points making up the curve.





width
-----------------------------------------------------------------------------

*in* 

	Width of the strip in pixels.





nD
-----------------------------------------------------------------------------

*in* 

	Number of samples across the width of the strip.





cos\_alpha
-----------------------------------------------------------------------------

*in* 

Array (n_points) of direction cosines computed by
			icv_compute_directions.





sin\_alpha
-----------------------------------------------------------------------------

*in* 

Array (n_points) of direction sines computed by
			icv_compute_directions.





+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _zero
- zero 



.. _grid\_x
- grid\_x 



.. _grid\_y
- grid\_y 













History
-------

 	Written by:	Spitale, 2/1998





















