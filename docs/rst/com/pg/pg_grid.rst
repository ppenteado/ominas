pg\_grid.pro
===================================================================================================



























pg\_grid
________________________________________________________________________________________________________________________





.. code:: IDL

 result = pg_grid(cd=cd, gbx=gbx, dkx=dkx, bx=bx, dd=dd, gd=gd, lat=lat, lon=lon, nlat=nlat, nlon=nlon, flat=flat, flon=flon, npoints=npoints, clip=clip, cull=cull, slat=slat, slon=slon, count=count)



Description
-----------
	Computes image points on a surface coordinate grid.










Returns
-------

	Array of POINT containing image points and the corresponding inertial
	vectors.


 STATUS:
	Complete










Keywords
--------


.. _cd
- cd *in* 

Array (n_timesteps) of camera descriptors.




.. _gbx
- gbx *in* 

Array (n_objects, n_timesteps) of descriptors of objects
		that must be a subclass of GLOBE.




.. _dkx
- dkx *in* 

Array (n_objects, n_timesteps) of descriptors of objects
		that must be a subclass of DISK.




.. _bx
- bx *in* 

Array (n_objects, n_timesteps) of descriptors of objects
		that must be a subclass of BODY.




.. _dd
- dd *in* 

Data descriptor containing a generic descriptor to use
		if gd not given.




.. _gd
- gd *in* 

Generic descriptor.  If given, the descriptor inputs
		are taken from this structure if not explicitly given.




.. _lat
- lat *in* 

Array giving grid-line latitudes in radians.




.. _lon
- lon *in* 

Array giving grid-line longitudes in radians.




.. _nlat
- nlat *in* 

Number of equally-spaced latitude lines to generate if keyword
		lat not given.  Default is 12.




.. _nlon
- nlon *in* 

Number of equally-spaced longitude lines to generate if keyword
		lon not given.  Default is 12.




.. _flat
- flat *in* 

This reference latitude line will be one of the latitude lines generated
		if nlat is specified.  Default is zero.




.. _flon
- flon *in* 

This reference longitude line will be one of the longitude lines generated
		if nlon is specified.  Default is zero.




.. _npoints
- npoints *in* 

Number of points to compute in each latitude or longitude line,
		 per 2*pi radians; default is 360.




.. _clip
- clip *in* 

 If set points are computed only within this many camera
		 fields of view.




.. _cull
- cull *in* 

 If set, POINT objects excluded by the clip keyword
		 are not returned.  Normally, empty POINT objects
		 are returned as placeholders.




.. _slat
- slat *in* 

Latitudes to compute on each longitude circle.




.. _slon
- slon *in* 

Longitudes to compute on each latitude circle.





.. _count
- count 

Number of descriptors returned.















History
-------

 	Written by:	Spitale, 2/1998





















