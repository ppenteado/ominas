pg\_reflection\_disk.pro
===================================================================================================



























pg\_reflection\_disk
________________________________________________________________________________________________________________________





.. code:: IDL

 result = pg_reflection_disk(object_ptd, cd=cd, od=od, dkx=dkx, dd=dd, gd=gd, nocull=nocull, all_ptd=all_ptd, reveal=reveal, clip=clip, cull=cull)



Description
-----------
	Computes image coordinates of given inertial vectors reflected onto
	surface of the given disk with respect to the given observer.













+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




object\_ptd
-----------------------------------------------------------------------------

*in* 

Array of POINT containing inertial vectors.





+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _cd
- cd *in* 

Array (n_timesteps) of camera descriptors.




.. _od
- od *in* 

Array (n_timesteps) of descriptors of objects
		which must be a subclass of BODY.  These objects are used
		as the source from which points are projected.  If no observer
		descriptor is given, then the camera descriptor in gd is used.
		Only one observer is allowed.




.. _dkx
- dkx *in* 

Array (n_disks, n_timesteps) of descriptors of objects
		which must be a subclass of DISK.




.. _dd
- dd *in* 

Data descriptor containing a generic descriptor to use
		if gd not given.




.. _gd
- gd *in* 

Generic descriptor.  If given, the descriptor inputs
		are taken from this structure if not explicitly given.




.. _nocull
- nocull 



.. _all\_ptd
- all\_ptd 



.. _reveal
- reveal *in* 

 Normally, disks whose opaque flag is set are ignored.
		 /reveal suppresses this behavior.




.. _clip
- clip *in* 

 If set reflection points are cropped to within this many camera
		 fields of view.




.. _cull
- cull *in* 

 If set, POINT objects excluded by the clip keyword
		 are not returned.  Normally, empty POINT objects
		 are returned as placeholders.














History
-------

 	Written by:	Spitale, 1/2002





















