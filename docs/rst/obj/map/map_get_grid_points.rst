map\_get\_grid\_points.pro
===================================================================================================



























map\_get\_grid\_points
________________________________________________________________________________________________________________________





.. code:: IDL

 result = map_get_grid_points(lat=lat, lon=lon, nt=nt, scan_lat=scan_lat, scan_lon=scan_lon)



Description
-----------
	Generates a lat/lon grid of points.










Returns
-------

	Array (2,np,nt) of map coordinate points where np is the number of
	scan_lats times the number of scan_lons.


 STATUS:
	Complete
 	Adapted by:	Spitale, 5/2016










Keywords
--------


.. _lat
- lat *in* 

Array giving the latitudes for each constant latitude line.




.. _lon
- lon *in* 

Array giving the longitudes for each constant longitude line.




.. _nt
- nt *in* 

Number of grids to produce.




.. _scan\_lat
- scan\_lat *in* 

Latitudes to scan for each constant longitude line.




.. _scan\_lon
- scan\_lon *in* 

Longitudes to scan for each constant latitude line.














History
-------

 	Written by:	Spitale, 1/1998





















