get\_ring\_profile\_outline.pro
===================================================================================================



























get\_ring\_profile\_outline
________________________________________________________________________________________________________________________





.. code:: IDL

 result = get_ring_profile_outline(cd, dkd, points, rad=rad, lon=lon, xlon=xlon, dir=dir, nrad=nrad, nlon=nlon, slope=slope, inertial=inertial)



Description
-----------
       Generates an outline of a ring sector.









Returns
-------

       Output is set of image points (x,y) defining the outline of the
       ring sector.









+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




cd
-----------------------------------------------------------------------------

*in* 

Camera descriptor.





dkd
-----------------------------------------------------------------------------






points
-----------------------------------------------------------------------------

*in* 

Array (2,2) of image points defining corners of the sector.





+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _rad
- rad *in* 

Array of disk radii for sector




.. _lon
- lon *in* 

Array of disk longitudes for sector




.. _xlon
- xlon 



.. _dir
- dir 



.. _nrad
- nrad *in* 

Number of points in the radial direction.




.. _nlon
- nlon *in* 

Number of points in the longitudinal direction.




.. _slope
- slope 



.. _inertial
- inertial 

Inertial vectors corresponding to the ring sector
			outline points.















History
-------

       Written by:     Vance Haemmerle & Joe Spitale, 6/1998





















