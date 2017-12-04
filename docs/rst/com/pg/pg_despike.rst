pg\_despike.pro
===================================================================================================



























pg\_despike
________________________________________________________________________________________________________________________





.. code:: IDL

 result = pg_despike(dd, spike_ptd, image=image, scale=scale, n=n, kernel=kernel, noclone=noclone)



Description
-----------
	Removes previously-located spurious features like cosmic-ray hits.



	pg_despike replaces the values of the desired pixels with those
	computed by smoothing the input image using a box filter of size
	'scale' repeatedly, 'n' times.


 STATUS:
	Complete.


 SEE ALSO:
	pg_spikes










Returns
-------

	Data descriptor containing the corrected image.  If /noclone
	is not set, set input data descriptor is modified.










+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




dd
-----------------------------------------------------------------------------

*in* 

	Data descriptor containing the image to be despiked.





spike\_ptd
-----------------------------------------------------------------------------

*in* 

POINT specifying the points to replace;
			typically computed by pg_spikes.





+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _image
- image 

	The corrected image.





.. _scale
- scale *in* 

	Typical size of features to be removed.  Default
			is 10.

	n=n:		Number of timers to repeat the box filter.  Default
			is 5.




.. _n
- n 



.. _kernel
- kernel *in* 

	If set, this kernel is used to weight the replacement
			of all pixels in a box of size scale around each
			spike point, instead of replacing only the spike
			point.  If this is a scalar, then this is taken as the
			width of a Gaussian kernel.




.. _noclone
- noclone 













History
-------

 	Written by:	Spitale, 2/2004





















