pg\_station.pro
===================================================================================================



























pg\_station
________________________________________________________________________________________________________________________





.. code:: IDL

 result = pg_station(cd=cd, std=std, gbx=gbx, dkx=dkx, bx=bx, dd=dd, gd=gd, clip=clip, cull=cull)



Description
-----------
	Computes image points for given station descriptors.










Returns
-------

	Array (n_objects) of POINT containing image points and
	the corresponding inertial vectors.


 STATUS:
	Complete










Keywords
--------


.. _cd
- cd *in* 

Array (n_timesteps) of camera descriptors.




.. _std
- std *in* 

Array (n_objects, n_timesteps) of descriptors of objects
		that must be a subclass of STATION.




.. _gbx
- gbx *in* 

Array (n_xd, n_timesteps) of descriptors of objects
		that must be a subclass of GLOBE.




.. _dkx
- dkx *in* 

Array (n_xd, n_timesteps) of descriptors of objects
		that must be a subclass of DISK.




.. _bx
- bx *in* 

Array (n_xd, n_timesteps) of descriptors of objects
		that must be a subclass of BODY, instead of gbx or dkx.




.. _dd
- dd *in* 

Data descriptor containing a generic descriptor to use
		if gd not given.




.. _gd
- gd *in* 

Generic descriptor.  If given, the descriptor inputs
		are taken from this structure if not explicitly given.




.. _clip
- clip *in* 

 If set points are computed only within this many camera
		 fields of view.




.. _cull
- cull *in* 

 If set, POINT objects excluded by the clip keyword
		 are not returned.  Normally, empty POINT objects
		 are returned as placeholders.















History
-------

 	Written by:	Spitale, 10/2012





















