glb\_intersect.pro
===================================================================================================



























glb\_intersect
________________________________________________________________________________________________________________________





.. code:: IDL

 result = glb_intersect(gbd, view_pts, _ray_pts, hit=hit, miss=miss, back_pts=back_pts, discriminant=discriminant, nosolve=nosolve, score=score, epsilon=epsilon)



Description
-----------
	Computes the intersection of rays with GLOBE objects.










Returns
-------

	Array (nv,3,nt) of points in the BODY frame corresponding to the
	first intersections with the ray.  Zero vector is returned for points
	with no solution, including those behind the viewer.


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





\_ray\_pts
-----------------------------------------------------------------------------

*in* 

Array (nv,3,nt) giving ray directions in the BODY frame.






+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _hit
- hit 

Array giving the indices of rays that hit the object in
		the forward direction.




.. _miss
- miss 

Array giving the indices of rays that miss the object.




.. _back\_pts
- back\_pts 


		Array (nv,3,nt) of additional intersections in order of distance
		from the observer.





.. _discriminant
- discriminant 

Discriminant of the quadriatic equation used to
			determine the intersections.




.. _nosolve
- nosolve *in* 

If set, the intersections are not computed, though the
		 discriminant is.




.. _score
- score 

Array in which each element indicates the number of forward hits.




.. _epsilon
- epsilon 













History
-------

 	Written by:	Spitale, 1/1998
 	Adapted by:	Spitale, 5/2016





















