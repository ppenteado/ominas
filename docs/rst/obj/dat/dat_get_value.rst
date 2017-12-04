dat\_get\_value.pro
===================================================================================================



























dat\_get\_value
________________________________________________________________________________________________________________________





.. code:: IDL

 result = dat_get_value(dd, keyword, @nv_trs_keywords_include.pro, status=status, trs=trs)



Description
-----------
	Calls input translators, supplying the given keyword, and builds
	a list of returned descriptors.










Returns
-------

	Array of descriptors returned from all successful translator calls.
	Descriptors are returned in the same order that the corresponding
	translators were called.  Each translator may produce multiple
	descriptors.


 STATUS:
	Complete










+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




dd
-----------------------------------------------------------------------------

*in* 

	Data descriptors.  Must all have the same instrument
			string.





keyword
-----------------------------------------------------------------------------

*in* 

Keyword to pass to translators, describing the
			requested quantity.





@nv\_trs\_keywords\_include.pro
-----------------------------------------------------------------------------






+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _status
- status 

	0 if at least one translator call was successful,
			-1 otherwise.





.. _trs
- trs *in* 

	Transient argument string.














History
-------

 	Written by:	Spitale
 	Adapted by:	Spitale, 5/2016





















