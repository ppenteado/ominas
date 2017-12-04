dsk\_get\_edge\_radius.pro
===================================================================================================



























dsk\_get\_edge\_radius
________________________________________________________________________________________________________________________





.. code:: IDL

 result = dsk_get_edge_radius(dkd, ta, inner=inner, outer=outer, time=time, noevent=noevent)



Description
-----------
	Computes radii along the edge of a disk.










Returns
-------

	Array (nv x nt) of radii computed at each true anomaly on each
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

 Array (nv x nt) of true anomalies at which to compute radii.





+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _inner
- inner *in* 

If set, the inner edge is used.




.. _outer
- outer *in* 

If set, the outer edge is used.




.. _time
- time 



.. _noevent
- noevent 













History
-------

 	Written by:	Spitale
 	Adapted by:	Spitale, 5/2016





















