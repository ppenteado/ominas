pg\_farfit.pro
===================================================================================================



























pg\_farfit
________________________________________________________________________________________________________________________





.. code:: IDL

 result = pg_farfit(dd, base_ptd, model_ptd, nsamples=nsamples, show=show, bin=bin, max_density=max_density, region=region, sigma=sigma, cc=cc, mcc=mcc, bias=bias, nosearch=nosearch)



Description
-----------
	Searches for the offset (dx,dy) that gives the best agreement between
	two uncorrelated sets of image points.



	pg_farfit is a wrapper for the routine correlate_points.  See the
	documentation for that routine for details on the fitting procedure


 STATUS:
	Complete.


 SEE ALSO:
	pg_edges correlate_points










Returns
-------

	2-element array giving the fit offset as [dx,dy].










+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




dd
-----------------------------------------------------------------------------

*in* 

	Data descriptor.





base\_ptd
-----------------------------------------------------------------------------

*in* 

POINT giving a set of points to fit to.
			This input may be produced by pg_edges, for example.





model\_ptd
-----------------------------------------------------------------------------

*in* 

Array of POINT giving model points (computed
			limb points for example).





+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _nsamples
- nsamples *in* 

Number of samples in each direction in the grid search.
			See image_correlate.




.. _show
- show *in* 

	If specified, the search is displayed in the current
			graphics window.  This value can be specified as a
			2-element array giving the size of the displayed image.




.. _bin
- bin *in* 

	Initial bin size for point densities.  Default is 50
			pixels.




.. _max\_density
- max\_density *in* 

Maximum model point density.  Default = 5.




.. _region
- region *in* 

	Size of region to scan, centered at offset [0,0].  If not
			specified, the entire image is scanned.




.. _sigma
- sigma *in* 

	2-element array giving the width of the correlation
			peak in each direction.




.. _cc
- cc *in* 

	Cross correlation of final result.




.. _mcc
- mcc *in* 

	Corss correlation at the model points.




.. _bias
- bias *in* 

	If given, solutions are biased toward the initial
			guess using a weighting function of the form:

				exp(-r^2/2*bias),

			where r is the distance between from the initial
			guess.




.. _nosearch
- nosearch *in* 

If set, no search is performed.  An offset of [0,0]
			is returned.















History
-------

 	Written by:	Spitale, 4/2002





















