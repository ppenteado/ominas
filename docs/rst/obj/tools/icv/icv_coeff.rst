icv\_coeff.pro
===================================================================================================



























icv\_coeff
________________________________________________________________________________________________________________________





.. code:: IDL

 icv_coeff, _cos_alpha, _sin_alpha, scan_offsets, scan_pts, axis, sigma=sigma, M=M, b=b



Description
-----------
	Computes coefficients for the 2- or 3-parameter linear least-square fit.



	Since the fit has been linearized, it can be written as a matrix
	equation:

				Mx = b,

	where x is the 3-element column vector [dx, dy, dtheta] of the
	independent variables. 	This routine computes the matrix M and the
	vector b.  Once these are known, mbfit can be used to solve the
	linear system.  Moreover, since the fit is linear, a simultaneous
	fit can be performed by simply adding together any number of
	coefficient matrices and vectors, which can also be done using
	mbfit.



	The fit associated with these coefficients has been linearized
	and is only valid for small corrections.  For larger corrections,
	this procedure can be iterated.


 STATUS:
	Complete.













+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




\_cos\_alpha
-----------------------------------------------------------------------------

*in* 

Array (n_points) of direction cosines computed by
			icv_compute_directions.





\_sin\_alpha
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


.. _sigma
- sigma *in* 

Uncertainty in each scan_offset.  Defaults to 1.




.. _M
- M 

3x3 matrix of coefficients for the linear fit.




.. _b
- b 

3-element column vector rhs of the linear fit.















History
-------

 	Written by:	Spitale, 2/1998





















