pg\_cntrd.pro
===================================================================================================



























pg\_cntrd
________________________________________________________________________________________________________________________





.. code:: IDL

 result = pg_cntrd(dd, object_ptd, fwhm=fwhm, edge=edge, sigmin=sigmin)



Description
-----------
	Calculates the centroids centered near given features in
	an image.



	Currently does not work for multiple time steps.



	For each visible object, a centroid is calcualted using the
	astronlib cntrd routine.


 SEE ALSO:
	ptscan, pg_ptscan, pg_ptcntrd

 STATUS:
	Complete.










Returns
-------

	An array of type POINT objects giving the detected position for
       each object.  The max values for each detection is
       saved in the data portion of object with tag 'scan_cc'.
       The x and y offset from the given position is also saved.










+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




dd
-----------------------------------------------------------------------------

*in* 

	Data descriptor





object\_ptd
-----------------------------------------------------------------------------

*in* 

	Array (n_pts) of POINT objects giving the points.
			Only the image coordinates of the points need to be
			specified.





+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _fwhm
- fwhm *in* 

          Full-Width Half-maximum to use around expected point
                       location.  If not given, a default fwhm of 2 pixels
                       is used.




.. _edge
- edge *in* 

          Distance from edge from which to ignore points.  If
                       not given, an edge distance of 0 is used.




.. _sigmin
- sigmin *in* 

          If given, points are discarded if the sigma above
                       the mean for the centroid pixel is below this value.















History
-------

 	Written by:	Haemmerle, 2/1999





















