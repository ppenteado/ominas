pg\_ptcntrd.pro
===================================================================================================



























pg\_ptcntrd
________________________________________________________________________________________________________________________





.. code:: IDL

 result = pg_ptcntrd(dd, object_ptd, model=model, width=width, edge=edge, ccmin=ccmin, gdmax=gdmax)



Description
-----------
	Attempts to find points of highest correlation with a given model
	centered near given features in an image, then returns the centroid.



	xx



	Currently does not work for multiple time steps.



	For each visible object, a section of the image of size width +
       the size of the model is extracted and sent to routine ptloc to
       find the pixel offset with the highest correlation with the given
       model. Then call astrolib routine cntrd to return centroid.










Returns
-------

	An array of type POINT giving the detected position for
       each object.  The correlation coeff values for each detection is
       saved in the data portion of POINT with tag 'scan_cc'.
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

	Array (n_pts) of POINT giving the points.
			Only the image coordinates of the points need to be
			specified.





+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _model
- model *in* 

         Point spread model to be used in correlation.  If
                       not given a default gaussian is used.




.. _width
- width *in* 

         Width to search around expected point location.  If
                       not given, a default width of 20 pixels is used.




.. _edge
- edge *in* 

          Distance from edge from which to ignore points.  If
                       not given, an edge distance of 0 is used.




.. _ccmin
- ccmin *in* 

         If given, points are discarded if the correlation
                       is below this value.




.. _gdmax
- gdmax *in* 

         If given, points are discarded if the gradiant of
                       the correlation function is higher than this value.








Examples
--------

.. code:: IDL

	To find stellar positions with a correlation higher than 0.6...

       star_ptd=pg_center(bx=sd, gd=gd) & pg_hide, star_ptd, gd=gd, /rm
       ptscan_ptd=pg_ptscan(dd, star_ptd, edge=30, width=40, ccmin=0.6)

 SEE ALSO:
	ptscan, pg_ptscan

 STATUS:
	Complete.










History
-------

 	Written by:	Haemmerle, 5/1998





















