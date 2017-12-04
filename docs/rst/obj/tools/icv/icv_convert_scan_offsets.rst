icv\_convert\_scan\_offsets.pro
===================================================================================================



























icv\_convert\_scan\_offsets
________________________________________________________________________________________________________________________





.. code:: IDL

 result = icv_convert_scan_offsets(curve_pts, scan_offsets, cos_alpha, sin_alpha)



Description
-----------
	Converts offsets produced by icv_scan_strip to image coordinates.










Returns
-------

	Array (2, n_points) of image coordinates corresponding to each scan
	offset.


 STATUS:
	Complete.










+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




curve\_pts
-----------------------------------------------------------------------------

*in* 

Array (2, n_points) of image points making up the curve.





scan\_offsets
-----------------------------------------------------------------------------

*in* 

Array (n_points) containing offset of best correlation
			at each point on the curve.  Produced by icv_scan_strip.





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













History
-------

 	Written by:	Spitale, 2/1998





















