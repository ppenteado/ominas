glb\_reflect.pro
===================================================================================================



























glb\_reflect
________________________________________________________________________________________________________________________





.. code:: IDL

 result = glb_reflect(gbd, v, r, epsilon, niter, hit=hit, miss=miss, near=near, far=far, all=all, valid=valid)



Description
-----------
	Computes the reflection of rays with GLOBE objects.










Returns
-------

	Array (2*nv,3,nt) of points in the BODY frame, where
	int_pts[0:nv-1,*,*] correspond to the near-side reflections
	and int_pts[nv:2*nv-1,*,1] correspond to the far side.  Zero
	vector is returned for points with no solution.


 STATUS:
	Not well tested










+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




gbd
-----------------------------------------------------------------------------

*in* 

Array (nt) of any subclass of GLOBE descriptors.





v
-----------------------------------------------------------------------------

*in* 

Array (nv,3,nt) giving observer positions in the BODY frame.





r
-----------------------------------------------------------------------------

*in* 

Array (nv,3,nt) giving point positions in the BODY frame.





epsilon
-----------------------------------------------------------------------------

*in* 

Controls the precision of the iteration.  Default
			is 1d-3.





niter
-----------------------------------------------------------------------------

*in* 

Maximum number of iterations, default is 1000






+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _hit
- hit 



.. _miss
- miss 



.. _near
- near *in* 

If set, near-side reflections are computed.  This is the default.




.. _far
- far *in* 

	If set, far-side reflections are computed.




.. _all
- all 



.. _valid
- valid 













History
-------

 	Written by:	Spitale, 6/2016





















