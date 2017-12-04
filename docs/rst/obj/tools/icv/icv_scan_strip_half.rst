icv\_scan\_strip\_half.pro
===================================================================================================



























icv\_scan\_strip\_half
________________________________________________________________________________________________________________________





.. code:: IDL

 result = icv_scan_strip_half(strip, model, szero, mzero, arg=arg, cc=cc, sigma=sigma, center=center)



Description
-----------
	At each point along an image strip, finds a sharp edge using the
	half-power method.










Returns
-------

	Offset of half-power points at each point on the curve.


 STATUS:
	Complete.










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

Not used.





szero
-----------------------------------------------------------------------------

*in* 

Zero-offset position in the strip.





mzero
-----------------------------------------------------------------------------

*in* 

Not used.





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

 	Written by:	Spitale





















