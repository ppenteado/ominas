get\_ring\_profile\_outline\_perp.pro
===================================================================================================



























get\_ring\_profile\_outline\_perp
________________________________________________________________________________________________________________________





.. code:: IDL

 result = get_ring_profile_outline_perp(cd, dkx, points, dir=dir, nrad=nrad, nlon=nlon)



Description
-----------
       Generates an outline of a ring sector perpendicular to the
	image-projected radial direction.









Returns
-------

       Array of image points defining the outline of the sector.










+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




cd
-----------------------------------------------------------------------------

*in* 

Camera descriptor.





dkx
-----------------------------------------------------------------------------






points
-----------------------------------------------------------------------------

*in* 

Array (2,2) of image points defining corners of the sector.





+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _dir
- dir 



.. _nrad
- nrad *in* 

Number of points in the radial direction.




.. _nlon
- nlon *in* 

Number of points in the longitudinal direction.














History
-------

       Written by:     Spitale, 8/2006





















