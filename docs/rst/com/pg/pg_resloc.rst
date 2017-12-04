pg\_resloc.pro
===================================================================================================



























pg\_resloc
________________________________________________________________________________________________________________________





.. code:: IDL

 result = pg_resloc(dd, edge=edge, model=model, ccmin=ccmin, gdmax=gdmax, nom_ptd=nom_ptd, radius=radius)



Description
-----------
	Scans an image for candidate reseau marks.



	A correlation map is computed across image.  Candidates reseau marks
	are identified as local maxima in the correlation map by accepting
	points where the correlation is above the specified threshold and
	where the gradient of the correlation map is below the specified
	threshold.


 STATUS:
	Complete


 SEE ALSO:
	pg_resfit, modloc










Returns
-------

	Points structure containing the image coordinates of each candidiate
	reseau mark and the corresponding correlation coefficients.  If not
	marks are found, zero is returned.










+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




dd
-----------------------------------------------------------------------------

*in* 

Data descriptor containing the image to scan.





+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _edge
- edge *in* 

 Distance from edge within which points are ignored.




.. _model
- model *in* 

 2-D array giving a model of the reseau image.  Default model
		is an inverted Gaussian.




.. _ccmin
- ccmin *in* 

 Minimum correlation coefficient to accept.  Default is 0.8 .




.. _gdmax
- gdmax *in* 

 Maximum gradiant of correlation coefficient to accept.
		Default is 0.25




.. _nom\_ptd
- nom\_ptd *in* 

If given, reseau marks are searched for only within the
		given radius about each nominal point.




.. _radius
- radius *in* 

Radius about no_ptd to search.  Default is ten pixels.














History
-------

 	Written by:	Spitale, 1998





















