pg\_disk.pro
===================================================================================================



























pg\_disk
________________________________________________________________________________________________________________________





.. code:: IDL

 result = pg_disk(cd=cd, dkx=dkx, dd=dd, gd=gd, clip=clip, cull=cull, inner=inner, outer=outer, npoints=npoints, reveal=reveal, count=count)



Description
-----------
	Computes image points on the inner and outer edges of each given disk
	object at all given time steps.










Returns
-------

	Array (2*n_objects) of POINT containing image points and
	the corresponding inertial vectors.  The output array is arranged as
	[inner, outer, inner, outer, ...] in the order that the disk
	descriptors are given in the dkx argument.


 STATUS:
	Complete










Keywords
--------


.. _cd
- cd *in* 

 Array (n_timesteps) of camera descriptors.




.. _dkx
- dkx *in* 

 Array (n_objects, n_timesteps) of descriptors of objects
		 which must be a subclass of DISK.




.. _dd
- dd *in* 

Data descriptor containing a generic descriptor to use
		if gd not given.

	inner/outer: If either of these keywords are set, then only
	             that edge is computed.




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




.. _inner
- inner 



.. _outer
- outer 



.. _npoints
- npoints *in* 

Number of points to compute around each edge.  Default is
		 1000.




.. _reveal
- reveal *in* 

 Normally, points computed for objects whose opaque flag
		 is set are made invisible.  /reveal suppresses this behavior.




.. _count
- count 

Number of descriptors returned.















History
-------

 	Written by:	Spitale, 2/1998





















