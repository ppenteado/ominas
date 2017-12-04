glb\_reflect.pro
===================================================================================================



























glb\_reflect
________________________________________________________________________________________________________________________





.. code:: IDL

 result = glb_reflect(gbd, v, r, epsilon, niter, hit=hit, miss=miss, all=all, valid=valid)



Description
-----------
	Computes the reflection of rays with GLOBE objects.










Returns
-------

	Array (nv,3,nt) of points in the BODY frame.  Zero
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



.. _all
- all 



.. _valid
- valid 













History
-------

 	Written by:	Spitale, 6/2016





















