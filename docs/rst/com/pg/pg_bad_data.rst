pg\_bad\_data.pro
===================================================================================================



























pg\_bad\_data
________________________________________________________________________________________________________________________





.. code:: IDL

 result = pg_bad_data(dd, dropout=dropout, sat=sat, mask=mask, extend=extend, edge=edge, subscripts=subscripts)



Description
-----------
	Locates areas of bad data values like saturation and dropouts.










Returns
-------

	POINT objects containing the detected bad points.


 STATUS:
	Complete


 SEE ALSO:
	pg_spikes










+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




dd
-----------------------------------------------------------------------------

*in* 

	Data descriptor containing the image to be despiked.





+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _dropout
- dropout *in* 

Value to use for dropouts.  Default is 0




.. _sat
- sat *in* 

	If given, value above which to flag as saturated,
			inclusive.




.. _mask
- mask *in* 

	Byte image of the same size as the input image
			in which nonzero pixel values indicate locations
			where problems should not be flagged.




.. _extend
- extend *in* 

	Number of pixels away from masked pixels before
			locations may be flagged as spikes.




.. _edge
- edge *in* 

	Regions closer than this to the edge of the image
			will be ignored.  Default is 0.




.. _subscripts
- subscripts 

Subscript of each bad point.















History
-------

 	Written by:	Spitale, 7/2013





















