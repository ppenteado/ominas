glb\_get\_surface\_normal.pro
===================================================================================================



























glb\_get\_surface\_normal
________________________________________________________________________________________________________________________





.. code:: IDL

 result = glb_get_surface_normal(gbd, globe_pts, noevent=noevent, nonorm=nonorm, body=body)



Description
-----------
	Computes the surface normal of a GLOBE object at the given
	globe position.









Returns
-------

	Array (nv, 3, nt) of surface normals in the BODY frame.


 STATUS:
	Complete










+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




gbd
-----------------------------------------------------------------------------

*in* 

Array (nt) of any subclass of GLOBE descriptors.





globe\_pts
-----------------------------------------------------------------------------






+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _noevent
- noevent 



.. _nonorm
- nonorm *in* 

If set, the returned vectors are not normalized.




.. _body
- body *in* 

If set, the inputs given in the BODY system instead of GLOBE.














History
-------

 	Written by:	Spitale, 1/1998
 	Adapted by:	Spitale, 5/2016





















