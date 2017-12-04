glb\_intersect.pro
===================================================================================================



























glb\_intersect
________________________________________________________________________________________________________________________





.. code:: IDL

 result = glb_intersect(gbd, view_pts, ray_pts, hit=hit, miss=miss, near=near, far=far, discriminant=discriminant, nosolve=nosolve, valid=valid)



Description
-----------
	Computes the intersection of rays with GLOBE objects.










Returns
-------

	Array (2*nv,3,nt) of points in the BODY frame, where
	int_pts[0:nv-1,*,*] correspond to the near-side intersections
	and int_pts[nv:2*nv-1,*,1] correspond to the far side.  Zero
	vector is returned for points with no solution.


 STATUS:
	Complete










+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




gbd
-----------------------------------------------------------------------------

*in* 

	Array (nt) of any subclass of GLOBE descriptors.





view\_pts
-----------------------------------------------------------------------------

*in* 

Array (nv,3,nt) giving ray origins in the BODY frame.





ray\_pts
-----------------------------------------------------------------------------

*in* 

Array (nv,3,nt) giving ray directions in the BODY frame.






+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _hit
- hit *in* 

Array giving the indices of rays that hit the object.




.. _miss
- miss *in* 

Array giving the indices of rays that miss the object.




.. _near
- near *in* 

If set, only the "near" points are returned.  More specifically,
		these points correspond to the nearest along the ray from the
		observer to the globe.  If the observer is exterior, these are
		the nearest interesections to the observer; if the observer is
		interior, these intersections are behind the observer.




.. _far
- far *in* 

If set, only the "far" points are returned.  See above; if the
		observer is exterior, these are the furthest interesections from
		the observer; if the observer is interior, these intersections
		are in front of the observer.




.. _discriminant
- discriminant 

Discriminant of the quadriatic equation used to
			determine the intersections.





.. _nosolve
- nosolve *in* 

If set, the intersections are not computed, though the
		 discrimiant is.




.. _valid
- valid *in* 

Array in which each element indicates whether the object
		was hit.














History
-------

 	Written by:	Spitale, 1/1998
 	Adapted by:	Spitale, 5/2016





















