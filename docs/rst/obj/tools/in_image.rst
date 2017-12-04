in\_image.pro
===================================================================================================



























in\_image
________________________________________________________________________________________________________________________





.. code:: IDL

 result = in_image(cd, _image_pts, xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax, slop=slop, corners=corners)



Description
-----------
	Determines which input points lie within an image described by the
	given camera descriptor.










Returns
-------

       Subscripts of points that lie in the image.  -1 if there are none.











+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




cd
-----------------------------------------------------------------------------

*in* 

Camera descriptor.





\_image\_pts
-----------------------------------------------------------------------------






+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _xmin
- xmin 



.. _xmax
- xmax 



.. _ymin
- ymin 



.. _ymax
- ymax 



.. _slop
- slop 



.. _corners
- corners 













History
-------

       Written by:     Spitale





















