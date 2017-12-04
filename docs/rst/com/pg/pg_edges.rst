pg\_edges.pro
===================================================================================================



























pg\_edges
________________________________________________________________________________________________________________________





.. code:: IDL

 result = pg_edges(dd, threshold=threshold, edge=edge, npoints=npoints, gate=gate, lowpass=lowpass)



Description
-----------
	Scans an image for candidate edge points.



	At each pixel in the image, an activity is computed (see activity.pro).
	Points with activity greater than the threshold value are accepted.


 STATUS:
	Complete


 SEE ALSO:
	pg_cvscan_coeff, pg_cvchisq, pg_ptscan, pg_ptscan_coeff, pg_ptchisq,
	pg_fit, pg_threshold










Returns
-------

	POINT giving the resulting edge points.










+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




dd
-----------------------------------------------------------------------------

*in* 

	Data descriptor





+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _threshold
- threshold *in* 

Minimum activity to accept as an edge point.




.. _edge
- edge *in* 

	Distance from the edge of the image within which
			curve points will not be scanned.  Default is 0.




.. _npoints
- npoints *in* 

Maximum number of points to return.




.. _gate
- gate 



.. _lowpass
- lowpass *in* 

If given, the image is smoothed with a kernel of
			this size.















History
-------

 	Written by:	Spitale, 4/2002





















