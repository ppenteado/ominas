icv\_scan\_strip\_model.pro
===================================================================================================



























icv\_scan\_strip\_model
________________________________________________________________________________________________________________________





.. code:: IDL

 result = icv_scan_strip_model(strip, model, szero, mzero, arg=arg, cc=cc, sigma=sigma, center=center)



Description
-----------
	At each point along an image strip, determines the subpixel offset at
	which the correlation coefficient between a specified model and the
	image is maximum.



	At every point on the curve, a correlation coefficient is computed
	for every offset at which the model completely overlays the strip.
	In other words, the model is swept across the strip.

	At each point, Lagrange interpolation is used on the three correlations
	surrounding the correlation peak to find the subpixel offset of maximum
	correlation.


 STATUS:
	Complete.










Returns
-------

	Offset of best correlation at each point on the curve.










+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




strip
-----------------------------------------------------------------------------

*in* 

Image strip (n_points,ns) to be scanned.  Output from
		icv_strip_curve ns must be even.





model
-----------------------------------------------------------------------------

*in* 

Model (n_points,nm) to correlate with strip at each point
		on the curve.  Must have nm < ns.





szero
-----------------------------------------------------------------------------

*in* 

Zero-offset position in the strip.





mzero
-----------------------------------------------------------------------------

*in* 

Zero-offset position in the model.





+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _arg
- arg 



.. _cc
- cc 



.. _sigma
- sigma 



.. _center
- center 













History
-------

 	Written by:	Spitale, 2/1998





















