dsk\_shape\_vertical.pro
===================================================================================================



























dsk\_shape\_vertical
________________________________________________________________________________________________________________________





.. code:: IDL

 result = dsk_shape_vertical(a, ta, l, il, taanl, dkd=dkd, ll=ll, lii=lii)



Description
-----------
	Computes elevations along the edge of a disk using disk elements.










Returns
-------

	Array (nt x nta) of elevations computed at each true anomaly on each
	disk.


 STATUS:
	Complete










+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




a
-----------------------------------------------------------------------------

*in* 

 Array (nt) of semimajor axis values.





ta
-----------------------------------------------------------------------------

*in* 

 Array (nta) of true anomalies at which to compute elevations.





l
-----------------------------------------------------------------------------

*in* 

 Array (nt) of vertical wavenumbers.





il
-----------------------------------------------------------------------------

*in* 

 Array (nt) of inclinations for each l.





taanl
-----------------------------------------------------------------------------

*in* 

 Array (nt) of true anomalies of ascending node for each l.






+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _dkd
- dkd 



.. _ll
- ll *in* 

If set, only the elevation component for this wavenumber
		is returned.




.. _lii
- lii *in* 

If set, only the elevation component with this index
		is returned.














History
-------

 	Written by:	Spitale
 	Adapted by:	Spitale, 5/2016





















