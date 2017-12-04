pg\_footprint.pro
===================================================================================================



























pg\_footprint
________________________________________________________________________________________________________________________





.. code:: IDL

 result = pg_footprint(cd=cd, bx=bx, dd=dd, gd=gd, clip=clip, sample=sample)



Description
-----------
	Computes the footprint of a camera on a given body.










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




.. _bx
- bx *in* 

Array (n_objects, n_timesteps) of descriptors of objects
		which must be a subclass of BODY.




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

 If set, points are computed only within this many camera
		 fields of view.




.. _sample
- sample *in* 

 Sampling rate; default is 1 pixel.














History
-------

 	Written by:	Spitale, 5/2014





















