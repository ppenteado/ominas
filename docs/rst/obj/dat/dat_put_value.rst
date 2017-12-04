dat\_put\_value.pro
===================================================================================================



























dat\_put\_value
________________________________________________________________________________________________________________________





.. code:: IDL

 dat_put_value, dd, keyword, value, @nv_trs_keywords_include.pro, trs=trs, status=status



Description
-----------
	Calls output translators, supplying the given keyword and value.













+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




dd
-----------------------------------------------------------------------------

*in* 

	Data descriptor.





keyword
-----------------------------------------------------------------------------

*in* 

Keyword to pass to translators, describing the
			requested quantity.





value
-----------------------------------------------------------------------------

*in* 

	Value to write through the translators.





@nv\_trs\_keywords\_include.pro
-----------------------------------------------------------------------------






+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _trs
- trs *in* 

	Transient argument string.




.. _status
- status 

	0 if at least one translator call was successful,
			-1 otherwise.















History
-------

 	Written by:	Spitale
 	Adapted by:	Spitale, 5/2016





















