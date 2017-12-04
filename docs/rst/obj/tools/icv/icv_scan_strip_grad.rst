icv\_scan\_strip\_grad.pro
===================================================================================================



























icv\_scan\_strip\_grad
________________________________________________________________________________________________________________________





.. code:: IDL

 result = icv_scan_strip_grad(strip, model, szero, mzero, arg=arg, cc=cc, sigma=sigma, norm=norm)



Description
-----------
	At each point along an image strip, finds a sharp edge using the
	maximum-gradient method.










Returns
-------

	Offset of maximum gradient points at each point on the curve.


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

Not used, hardwired to 0.9999999d.




.. _sigma
- sigma 

Offset uncertainty for each point on the curve, computed as
		one half of the half-width of the gradient peak.





.. _norm
- norm *in* 

If set, only the absolute value of the gradient is evaluated.














History
-------

 	Written by:	Spitale





















