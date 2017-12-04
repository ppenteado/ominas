pg\_cvscan.pro
===================================================================================================



























pg\_cvscan
________________________________________________________________________________________________________________________





.. code:: IDL

 result = pg_cvscan(dd, object_ptd, algorithm=algorithm, cd=cd, bx=bx, gd=gd, model_p=model_p, mzero=mzero, dir=dir, width=width, edge=edge, arg=arg, scan_ptd=scan_ptd)



Description
-----------
	Attempts to find points of highest correlation with a given model along
	curves in an image.



	Currently does not work for multiple time steps.



	Normal sines and cosines are computed using icv_compute_directions.
	These directions are input to icv_strip_curve along with the image
	in order to extract an image strip to be scanned.  icv_scan_strip is
	then used to find the optimum scan offsets and icv_convert_scan_offsets
	is used to obtain image coordinates corresponding to each scan offset.
	See the documentation for each of those routines for more details.










Returns
-------

	Array (n_curves) of POINT objects containing resulting image points,
	as well as additional scan data to be used by pg_cvscan_coeff and
	possibly other programs.  The scan data is as follows:

		 tag			 description
	 	-----			-------------
		scan_cos		Cosine of normal at each point.
		scan_sin		Sine of normal at each point.
		scan_offsets		Raw offsets from computed curve.
		scan_cc			Correlation coefficient for each scanned
					point.
		scan_sigma		Scan offset uncertainties.
		scan_model_xpts		Model points corresponding to each
		scan_model_ypts		 scanned point










+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




dd
-----------------------------------------------------------------------------

*in* 

	Data descriptor





object\_ptd
-----------------------------------------------------------------------------






+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _algorithm
- algorithm *in* 

Name of alrogithm to use to detect the edge.
			Choices are 'MODEL', 'GRAD', and 'HALF'.
			Default is 'MODEL'.




.. _cd
- cd 



.. _bx
- bx 



.. _gd
- gd 



.. _model\_p
- model\_p *in* 

Array (n_curves) of pointers to model arrays.  Each
			model array has dimensions (n_points,nm), where n_points
			is the number of points in the curve and nm is the
			number of points in the model.  Thus, a model may be
			specified for each point on the curve.  Default
			model is edge_model_atan().




.. _mzero
- mzero *in* 

	Array (n_curves) or (n_curves,n_points) of zero-point
			offsets for each model in model_p.  mzero must be
			specified if model_p is given.




.. _dir
- dir *in* 

	If given the scan will be performed in this direction
			instead of normal to the curve.  Must be a 2-element
			unit vector.




.. _width
- width *in* 

	Number of pixels to scan on either side of the curve.
			Default is 20.




.. _edge
- edge *in* 

	Distance from the edge of the image within which
			curve points will not be scanned.  Default is 0.




.. _arg
- arg *in* 

	Argument passed to the edge detection routine.
			For the GRAD algorithm, this argument specifies
			whether each edge is interior (arg=1) or
			exterior (arg=0).




.. _scan\_ptd
- scan\_ptd *in* 

If given, these previously scanned points are updated
			to be consistent with the given data points.  The image
			is not scanned.








Examples
--------

.. code:: IDL

	The following command scans for a limb in the image contained in the
	given data descriptor, dd:

	scan_ptd = pg_cvscan(dd, limb_ptd, width=40, edge=20)

	In this call, limb_ptd is a POINT containing computed limb
	points.


 STATUS:
	Complete


 SEE ALSO:
	pg_cvscan_coeff, pg_cvchisq, pg_ptscan, pg_ptscan_coeff, pg_ptchisq,
	pg_fit, pg_threshold










History
-------

 	Written by:	Spitale, 2/1998





















