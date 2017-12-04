cam\_reorient.pro
===================================================================================================



























cam\_reorient
________________________________________________________________________________________________________________________





.. code:: IDL

 cam_reorient, cd0, image_axis, dxy, dtheta, absolute=absolute, n=n, sin_angle=sin_angle, cos_angle=cos_angle



Description
-----------
       Repoints the camera orientiation matrix based on x,y, and theta
	image offsets.













+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




cd0
-----------------------------------------------------------------------------






image\_axis
-----------------------------------------------------------------------------

*in* 

Array (2,1,nt) of image points corresponding to the
			rotation axis for each descriptor.





dxy
-----------------------------------------------------------------------------

*in* 

Array (2,1,nt) of image offsets in x and y.





dtheta
-----------------------------------------------------------------------------






+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _absolute
- absolute *in* 

If set, the dxy argument represents an absolute image
		  position rather than an offset.




.. _n
- n 



.. _sin\_angle
- sin\_angle 



.. _cos\_angle
- cos\_angle 













History
-------

 	Written by:	Spitale, 1/1998
 	Adapted by:	Spitale, 5/2016





















