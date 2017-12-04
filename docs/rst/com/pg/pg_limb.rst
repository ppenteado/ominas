pg\_limb.pro
===================================================================================================



























pg\_limb
________________________________________________________________________________________________________________________





.. code:: IDL

 result = pg_limb(cd=cd, od=od, gbx=gbx, dd=dd, gd=gd, clip=clip, cull=cull, npoints=npoints, epsilon=epsilon, reveal=reveal, count=count)



Description
-----------
	Computes image points on the limb of each given globe object.



	By definition, the surface normal at a point on the limb of a body is
	perpendicular to a vector from the observer to that same point, so the
	dot product of the two vectors is zero.  This program uses an iterative
	scheme to find points onthe surface at which this dot product is less
	than epsilon.










Returns
-------

	Array (n_objects) of POINT containing image
	points and the corresponding inertial vectors.










Keywords
--------


.. _cd
- cd *in* 

 Array (n_timesteps) of camera descriptors.




.. _od
- od *in* 

 Array (n_timesteps) of descriptors of objects
		 which must be a subclass of BODY.  These objects are used
		 as the observer from which limb is computed.  If no observer
		 descriptor is given, the camera descriptor is used.




.. _gbx
- gbx *in* 

 Array (n_objects, n_timesteps) of descriptors of objects
		 which must be a subclass of GLOBE.




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




.. _npoints
- npoints *in* 

Number of points to compute.  Default is 1000.




.. _epsilon
- epsilon *in* 

Maximum angular error in the result.  Default is 1e-3.




.. _reveal
- reveal *in* 

 Normally, points computed for objects whose opaque flag
		 is set are made invisible.  /reveal suppresses this behavior.




.. _count
- count 

Number of descriptors returned.









Examples
--------

.. code:: IDL

	The following command computes points on the planet which lie on the
	terminator:

	term_ptd = pg_limb,(cd=cd, gbx=pd, od=sd)

	In this call, pd is a planet descriptor, cd is a camera descriptor,
	and sd is a star descriptor (i.e., the sun).


 STATUS:
	Complete










History
-------

 	Written by:	Spitale, 1/1998





















