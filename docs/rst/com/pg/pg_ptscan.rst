pg\_ptscan.pro
===================================================================================================



























pg\_ptscan
________________________________________________________________________________________________________________________





.. code:: IDL

 result = pg_ptscan(dd, object_ptd, model=model, radius=radius, width=width, edge=edge, ccmin=ccmin, gdmax=gdmax, smooth=smooth, show=show, wmod=wmod, wpsf=wpsf, median=median, chisqmax=chisqmax, cc_out=cc_out, round=round, spike=spike)



Description
-----------
	Attempts to find points of highest correlation with a given model
	centered near given features in an image.



	Currently does not work for multiple time steps, only considers
	one point per given POINT.



	For each visible object, a section of the image of size width +
       the size of the model is extracted and sent to routine ptloc to
       find the pixel offset with the highest correlation with the given
       model.










Returns
-------

	An array of type POINT giving the detected position for
       each object.  The correlation coeff value for each detection is
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




.. _radius
- radius *in* 

	Width outside of which to exclude detections whose
			offset varies too far from the most frequent offset.
			Detections with offsets outside this radius receive
			correlation coefficients of zero.




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




.. _smooth
- smooth *in* 

	If given, the input image is smoothed using
			this width before any further processing.




.. _show
- show 



.. _wmod
- wmod *in* 

	x, ysize of default gaussian model.




.. _wpsf
- wpsf *in* 

	Half-width of default gaussian psf model.




.. _median
- median *in* 

	If given, the input image is filtered using
			a median filter of this width before any further
			processing.




.. _chisqmax
- chisqmax *in* 

Max chisq between the model and the image.




.. _cc\_out
- cc\_out 



.. _round
- round 



.. _spike
- spike 







Examples
--------

.. code:: IDL

	To find stellar positions with a correlation higher than 0.6...

       star_ptd=pg_center(bx=sd, gd=gd) & pg_hide, star_ptd, gd=gd, /rm
       ptscan_ptd=pg_ptscan(dd, star_ptd, edge=30, width=40, ccmin=0.6)

 SEE ALSO:
	pg_ptfarscan

 STATUS:
	Complete.










History
-------

 	Written by:	Haemmerle, 5/1998
	Modified:	Spitale 9/2002 -- added twice model width to search
			width.





















