pg\_ptfarscan.pro
===================================================================================================



























pg\_ptfarscan
________________________________________________________________________________________________________________________





.. code:: IDL

 result = pg_ptfarscan(dd, name=name, model=model, edge=edge, ccmin=ccmin, gdmax=gdmax, smooth=smooth, wmod=wmod, wpsf=wpsf, sky=sky, nsig=nsig, median=median, mask=mask, extend=extend, nmax=nmax, chifit=chifit)



Description
-----------
	Attempts to find all occurrences of a model in an image.










Returns
-------

	An array of type POINT giving the detected position for
       each object.  The correlation coeff value for each detection is
       saved in the data portion of POINT with tag 'scan_cc'.


 SEE ALSO:
	pg_ptscan

 STATUS:
	Complete.










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


.. _name
- name 



.. _model
- model *in* 

         Point spread model to be used in correlation.  If
                       not given a default gaussian is used.




.. _edge
- edge *in* 

          Distance from edge from which to ignore points.  If
                       not given, an edge distance of 0 is used.




.. _ccmin
- ccmin *in* 

         Minimum correlation to consider in search.  Default
			is 0.8.




.. _gdmax
- gdmax *in* 

         If given, points where the gradient of the
                       correlation function is higher than this value
			are not considered in the search.




.. _smooth
- smooth *in* 

	If given, the input image is smoothed using
			this width before any further processing.




.. _wmod
- wmod *in* 

	x, ysize of default gaussian model.




.. _wpsf
- wpsf *in* 

	Half width of default gaussian psf model.




.. _sky
- sky *in* 

	If set, it is assumed that the image contains only
			point sources and sky.  Any object more than nsig
			standard deviations above the image mean are
			selected as candidates.




.. _nsig
- nsig *in* 

	For use with the /sky option, standard deviation
			threshold for detecting point sources.




.. _median
- median *in* 

	If given, the input image is filtered using
			a median filter of this width before any further
			processing.




.. _mask
- mask *in* 

	If set, an attempt is made to mask out extended
			objects before performing the scan




.. _extend
- extend *in* 

	If nonzero, star masks are extended by this
			many pixels in all directions.




.. _nmax
- nmax *in* 

	Max. number of point sources to return.  If more
			are found, nsig is raised until thiws is satisified.




.. _chifit
- chifit 













History
-------

 	Written by:	Spitale 2/2004





















