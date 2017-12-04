dsk\_get\_edge\_elevation.pro
===================================================================================================



























dsk\_get\_edge\_elevation
________________________________________________________________________________________________________________________





.. code:: IDL

 result = dsk_get_edge_elevation(dkd, ta, inner=inner, outer=outer, one_to_one=one_to_one, noevent=noevent)



Description
-----------
	Computes elevations along the edge of a disk.










Returns
-------

	Array (nt x nta) of elevations computed at each true anomaly on each
	disk.


 STATUS:
	Complete










+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




dkd
-----------------------------------------------------------------------------

*in* 

 Array (nt) of any subclass of DISK.





ta
-----------------------------------------------------------------------------

*in* 

 Array (nta) of true anomalies at which to compute elevations.






+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _inner
- inner *in* 

If set, the inner edge is used.




.. _outer
- outer *in* 

If set, the outer edge is used.




.. _one\_to\_one
- one\_to\_one 



.. _noevent
- noevent 













History
-------

 	Written by:	Spitale
 	Adapted by:	Spitale, 5/2016





















