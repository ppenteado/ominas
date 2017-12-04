get\_image\_profile.pro
===================================================================================================



























get\_image\_profile
________________________________________________________________________________________________________________________





.. code:: IDL

 result = get_image_profile(im, cd, p, nl, nw, sample, distance=distance, interp=interp, arg_interp=arg_interp, sigma=sigma, image_pts=image_pts)



Description
-----------
	Extracts a profile from a rectangular, but not necessarily axis-aligned,
	image region using interpolation.










Returns
-------

	Array (nl) containing the profile.










+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




im
-----------------------------------------------------------------------------






cd
-----------------------------------------------------------------------------

*in* 

Camera descriptor.





p
-----------------------------------------------------------------------------

*in* 

Array (2,2) of image points giving the start and end points
		for the scan.





nl
-----------------------------------------------------------------------------

*in* 

Number of samples along the scan.





nw
-----------------------------------------------------------------------------

*in* 

Number of samples across the scan.






sample
-----------------------------------------------------------------------------






+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _distance
- distance 

Array (nl) giving the distance along the scan.




.. _interp
- interp *in* 

	Type of interpolation, see image_interp_cam.




.. _arg\_interp
- arg\_interp *in* 

Interpolation argument, see image_interp_cam.




.. _sigma
- sigma 

	Standard deviation across the profile at each sample
			along the profile.





.. _image\_pts
- image\_pts 

Array (2,nl) of image points along the center of
			the scan.














History
-------

       Written by:     Spitale





















