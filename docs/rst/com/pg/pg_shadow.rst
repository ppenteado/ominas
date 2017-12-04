pg\_shadow.pro
===================================================================================================



























pg\_shadow
________________________________________________________________________________________________________________________





.. code:: IDL

 result = pg_shadow(object_ptd, cd=cd, od=od, dkx=dkx, gbx=gbx, bx=bx, dd=dd, gd=gd, reveal=reveal, clip=clip, nocull=nocull, all=all, epsilon=epsilon, nosolve=nosolve)



Description
-----------
	Computes image coordinates of given inertial vectors projected onto
	surface of the given disks and globes with respect to the given
	observer.  Returns only the closest shadow point for each objoect
	point.










Returns
-------

	Array (n_disks,n_objects) of POINT containing image
	points and the corresponding inertial vectors.


 STATUS:
	Soon to be replaced by a new program that merges pg_shadow_globe and
	pg_shadow_disk.  The API for the new routine may be slightly different.


 SEE ALSO:
	pg_shadow_disk, pg_shadow_globe, pg_shadow_points










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




.. _dkx
- dkx *in* 

Array (n_disks, n_timesteps) of descriptors of objects
		which must be a subclass of DISK.




.. _gbx
- gbx *in* 

Array (n_globes, n_timesteps) of descriptors of objects
		which must be a subclass of GLOBE.




.. _bx
- bx *in* 

Array (n_disks, n_timesteps) of descriptors of objects
		which must be a subclass of BODY.




.. _dd
- dd *in* 

Data descriptor containing a generic descriptor to use
		if gd not given.

	  All other keywords are passed directly to pg_shadow_globe
	  and pg_shadow_disk and are documented with those programs.




.. _gd
- gd *in* 

Generic descriptor.  If given, the descriptor inputs
		are taken from this structure if not explicitly given.




.. _reveal
- reveal 



.. _clip
- clip 



.. _nocull
- nocull 



.. _all
- all 



.. _epsilon
- epsilon 



.. _nosolve
- nosolve 













History
-------

 	Written by:	Spitale, 1/2002





















