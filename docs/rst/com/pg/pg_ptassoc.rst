pg\_ptassoc.pro
===================================================================================================



























pg\_ptassoc
________________________________________________________________________________________________________________________





.. code:: IDL

 result = pg_ptassoc(scan_ptd, model_ptd, assoc_model_ptd, radius=radius, dxy=dxy, maxcount=maxcount)



Description
-----------
	Associates points between two arrays by searching for the most
	frequent offset between the two.



	Points are associated by searching for the most frequent offset
	between scan points and model points.


 STATUS:
	Complete


 SEE ALSO:
	pg_cvscan, pg_cvscan_coeff, pg_ptscan, pg_ptscan_coeff,
	pg_cvchisq, pg_ptchisq, pg_threshold










Returns
-------

	POINT containing an associated scan point for each output
	model point in assoc_model_ptd.










+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




scan\_ptd
-----------------------------------------------------------------------------

*in* 

POINT(s) containing first array, typically
			an array of candidate points detected in an image.





model\_ptd
-----------------------------------------------------------------------------

*in* 

POINT(s) containing the second array, typically
			an array of computed model points.





assoc\_model\_ptd
-----------------------------------------------------------------------------






+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _radius
- radius 



.. _dxy
- dxy 



.. _maxcount
- maxcount 













History
-------

 	Written by:	Spitale, 3/2004





















