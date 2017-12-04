get\_image\_border\_pts.pro
===================================================================================================



























get\_image\_border\_pts
________________________________________________________________________________________________________________________





.. code:: IDL

 result = get_image_border_pts(cd, corners=corners, center=center, crop=crop, sample=sample, aperture=aperture)



Description
-----------
	Computes points around the edge of an image.










Returns
-------

	Array (2,np) of image points on the image border.  np is computed
	such that points are spaced by one pixel.










+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




cd
-----------------------------------------------------------------------------

*in* 

Camera descripor.





+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _corners
- corners 



.. _center
- center 



.. _crop
- crop 



.. _sample
- sample 



.. _aperture
- aperture 













History
-------

       Written by:     Spitale





















