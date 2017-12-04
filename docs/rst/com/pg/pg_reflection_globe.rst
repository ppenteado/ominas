pg\_reflection\_globe.pro
===================================================================================================



























pg\_reflection\_globe
________________________________________________________________________________________________________________________





.. code:: IDL

 result = pg_reflection_globe(object_ptd, cd=cd, od=od, gbx=gbx, dd=dd, gd=gd, nocull=nocull, reveal=reveal, clip=clip, cull=cull, nosolve=nosolve)



Description
-----------
	Computes image coordinates of the given inertial vectors projected onto
	surface of the given globe with respect to the given observer.










Returns
-------

	Array (n_globes,n_objects) of POINT containing image
	points and the corresponding inertial vectors.


 STATUS:
	Soon to be obsolete.  This program will be merged with pg_reflection_disk
	to make a more general program, which will replace pg_reflection.


 SEE ALSO:
	pg_reflection, pg_reflection_disk, pg_reflection_points










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
		descriptor is given, then the light descriptor in gd is used.
		Only one observer is allowed.




.. _gbx
- gbx *in* 

Array (n_globes, n_timesteps) of descriptors of objects
		which must be a subclass of GLOBE.




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




.. _nosolve
- nosolve *in* 

If set, reflection points are not computed.














History
-------

 	Written by:	Spitale, 6/2016





















