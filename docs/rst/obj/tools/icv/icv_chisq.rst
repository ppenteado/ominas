icv\_chisq.pro
===================================================================================================



























icv\_chisq
________________________________________________________________________________________________________________________





.. code:: IDL

 result = icv_chisq(dxy, dtheta, fix, cos_alpha, sin_alpha, scan_offsets, scan_pts, axis, norm=norm)



Description
-----------
	Computes chi-squared value for given curve fit parameters.










Returns
-------

	The chi-squared value is returned.


 STATUS:
	Complete.










+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




dxy
-----------------------------------------------------------------------------

*in* 

	Array (2) giving x- and y-offset solution.





dtheta
-----------------------------------------------------------------------------

*in* 

	Scalar giving theta-offset solution.





fix
-----------------------------------------------------------------------------

*in* 

	Array specifying which parameters to fix as
			[dx,dy,dtheta].





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





scan\_offsets
-----------------------------------------------------------------------------

*in* 

Array (n_points) containing offset of best correlation
			at each point on the curve.  Produced by icv_scan_strip.





scan\_pts
-----------------------------------------------------------------------------

*in* 

Array (2, n_points) of image coordinates corresponding
			to each scan offset.





axis
-----------------------------------------------------------------------------

*in* 

	Array (2) giving image coordinates of rotation axis
			in the case of a 3-parameter fit.





+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _norm
- norm *in* 

	If set, the returned value is normalized by dividing
			it by the number of degrees of freedom.














History
-------

 	Written by:	Spitale, 6/1998





















