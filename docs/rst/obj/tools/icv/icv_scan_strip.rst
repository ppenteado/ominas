icv\_scan\_strip.pro
===================================================================================================



























icv\_scan\_strip
________________________________________________________________________________________________________________________





.. code:: IDL

 result = icv_scan_strip(strip, model, szero, mzero, cc=cc, sigma=sigma, algorithm=algorithm, arg=arg)



Description
-----------
	At each point along an image strip, determines the point at which
	some criterion is optimized, depending on an externally-supplied
	function.



	This program is a wrapper for a number of functions that use various
	algorithms determined by the 'algorithm' keyword.


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


.. _cc
- cc 



.. _sigma
- sigma 



.. _algorithm
- algorithm 



.. _arg
- arg 













History
-------

 	Written by:	Spitale, 2/1998





















