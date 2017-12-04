image\_interp\_cam.pro
===================================================================================================



























image\_interp\_cam
________________________________________________________________________________________________________________________





.. code:: IDL

 result = image_interp_cam(image, grid_x, grid_y, args, cd=cd, valid=valid, k=k, interp=interp, kmax=kmax, mask=mask, zmask=zmask)



Description
-----------
       Extracts a region from an image using the desired interpolation,
	accouting for the camera point-spread function is applicable.










Returns
-------

       Array of interpolated points at the (grid_x, grid_y) points.











+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




image
-----------------------------------------------------------------------------

*in* 

Image array.





grid\_x
-----------------------------------------------------------------------------

*in* 

The grid of x positions for interpolation





grid\_y
-----------------------------------------------------------------------------

*in* 

The grid of y positions for interpolation





args
-----------------------------------------------------------------------------

*in* 

Arguments to pass to the interpolation function.





+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _cd
- cd 



.. _valid
- valid 



.. _k
- k 



.. _interp
- interp 



.. _kmax
- kmax 



.. _mask
- mask 



.. _zmask
- zmask 













History
-------

       Written by:     Spitale





















