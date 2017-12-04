dsk\_get\_inner\_disk\_points.pro
===================================================================================================



























dsk\_get\_inner\_disk\_points
________________________________________________________________________________________________________________________





.. code:: IDL

 result = dsk_get_inner_disk_points(dkd, n_points, ta=ta, disk_pts=disk_pts)



Description
-----------
	Computes points on the inner edge of a disk.










Returns
-------

	Array (np x 3 x nt) of points on the outer edge of each disk,
	in disk body coordinates.


 STATUS:
	Complete










+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




dkd
-----------------------------------------------------------------------------

*in* 

 Array (nt) of any subclass of DISK.





n\_points
-----------------------------------------------------------------------------






+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _ta
- ta *in* 

True anomalies for the points.  Default is the full circle.




.. _disk\_pts
- disk\_pts 













History
-------

 	Written by:	Spitale
 	Adapted by:	Spitale, 5/2016





















