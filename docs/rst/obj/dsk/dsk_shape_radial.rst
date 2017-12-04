dsk\_shape\_radial.pro
===================================================================================================



























dsk\_shape\_radial
________________________________________________________________________________________________________________________





.. code:: IDL

 result = dsk_shape_radial(_a, _e, _dap, ta, _m, _em, _tapm, mm=mm, mii=mii)



Description
-----------
	Computes radii along the edge of a disk using disk elements.










Returns
-------

	Array (nv x nt) of radii computed at each true anomaly on each
	disk.


 STATUS:
	Complete










+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




\_a
-----------------------------------------------------------------------------

*in* 

 Array (nt) of semimajor axis values.





\_e
-----------------------------------------------------------------------------

*in* 

 Array (nt) of eccentricity values.





\_dap
-----------------------------------------------------------------------------

*in* 

 Array (nt) of apsidal shift values.





ta
-----------------------------------------------------------------------------

*in* 

 Array (nv x nt) of true anomalies at which to compute radii.





\_m
-----------------------------------------------------------------------------

*in* 

 Array (nt x nm) of radial wavenumbers.





\_em
-----------------------------------------------------------------------------

*in* 

 Array (nt x nm) of eccentricities for each m.





\_tapm
-----------------------------------------------------------------------------

*in* 

 Array (nt x nm) of true anomalies of periapse for each m.






+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _mm
- mm *in* 

If set, only the radius component for this wavenumber
		is returned.




.. _mii
- mii *in* 

If set, only the radius component with this index
		is returned.














History
-------

 	Written by:	Spitale
 	Adapted by:	Spitale, 5/2016





















