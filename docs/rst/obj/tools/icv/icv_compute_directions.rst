icv\_compute\_directions.pro
===================================================================================================



























icv\_compute\_directions
________________________________________________________________________________________________________________________





.. code:: IDL

 icv_compute_directions, curve_pts, center=center, cos_alpha=cos_alpha, sin_alpha=sin_alpha



Description
-----------
	Computes the normal to a specified curve at every point.



	It is assumed that the curve is closed; if this is not the case, then
	the results will not be meaningful at the endpoints of the curve.



	At each point on the specified curve, the two nearest neighbors are
	used to compute the components of the normal.


 STATUS:
	Complete













+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




curve\_pts
-----------------------------------------------------------------------------

*in* 

Array (2, n_points) of image points making up the curve.





+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _center
- center 



.. _cos\_alpha
- cos\_alpha 



.. _sin\_alpha
- sin\_alpha 













History
-------

 	Written by:	Spitale, 2/1998





















