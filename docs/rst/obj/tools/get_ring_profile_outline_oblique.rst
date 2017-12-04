get\_ring\_profile\_outline\_oblique.pro
===================================================================================================



























get\_ring\_profile\_outline\_oblique
________________________________________________________________________________________________________________________





.. code:: IDL

 result = get_ring_profile_outline_oblique(cd, dkx, points, point, dir=dir, nrad=nrad, nlon=nlon)



Description
-----------
       Generates an outline of an oblique ring sector.









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

Array (2,2) of image points defining corners at opposite ends
		on one side of the sector.





point
-----------------------------------------------------------------------------

*in* 

Image point defining and third corner.





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





















