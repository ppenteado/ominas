surface\_image\_bounds.pro
===================================================================================================



























surface\_image\_bounds
________________________________________________________________________________________________________________________





.. code:: IDL

 surface_image_bounds, cd, bx, slop=slop, border_pts_im=border_pts_im, latmin=latmin, latmax=latmax, lonmin=lonmin, lonmax=lonmax, status=status



Description
-----------
	Computes latitude / longitude ranges visible in an image.













+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




cd
-----------------------------------------------------------------------------

*in* 

     Camera descriptor





bx
-----------------------------------------------------------------------------

*in* 

     Object descriptor (subclass of BODY)






+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _slop
- slop *in* 

Amount, in pixels, by which to expand the image size
		considered in the calcultaion.




.. _border\_pts\_im
- border\_pts\_im 

Image points on the border of the image defined by cd.




.. _latmin
- latmin 

Minimum latitude covered in image




.. _latmax
- latmax 

Maximum latitude covered in image




.. _lonmin
- lonmin 

Minimum longitude covered in image




.. _lonmax
- lonmax 

Maximum longitude covered in image





.. _status
- status 






















