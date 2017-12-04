pg\_shadow\_points.pro
===================================================================================================



























pg\_shadow\_points
________________________________________________________________________________________________________________________





.. code:: IDL

 pg_shadow_points, object_ptd, shadow_ptd, cd=cd, od=od, bx=bx, gd=gd, nocull=nocull, edge=edge, nosolve=nosolve, clip=clip, cull=cull



Description
-----------
	Determines whether each given point is shadowed by the given object.



	Shadowed points are flagged as invisible.


 STATUS:



 SEE ALSO:
	pg_shadow, pg_shadow_globe, pg_shadow_disk













+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




object\_ptd
-----------------------------------------------------------------------------

*in* 

Array of POINT containing inertial vectors
			to shadow.





shadow\_ptd
-----------------------------------------------------------------------------






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




.. _bx
- bx *in* 

Array (nbx, n_timesteps) of descriptors of objects
		which must be a subclass of BODY describing the shadowing
		bodies.




.. _gd
- gd *in* 

Generic descriptor.  If given, the cd and bx inputs
		are taken from the corresponding fields of this structure
		instead of from those keywords.




.. _nocull
- nocull 



.. _edge
- edge *in* 

 If set, only points near the edge of the shadow are returned.




.. _nosolve
- nosolve 



.. _clip
- clip *in* 

 If set shadow points are cropped to within this many camera
		 fields of view.




.. _cull
- cull *in* 

 If set, POINT objects excluded by the clip keyword
		 are not returned.  Normally, empty POINT objects
		 are returned as placeholders.














History
-------

 	Written by:	Spitale, 9/2012





















