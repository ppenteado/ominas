dh\_rm\_value.pro
===================================================================================================



























dh\_rm\_value
________________________________________________________________________________________________________________________





.. code:: IDL

 dh_rm_value, dh, keyword, n_match=n_match, all_match=all_match, all_object=all_object, all_history=all_history, count=count, object_index=object_index, history_index=history_index, prefix=prefix



Description
-----------
	Deletes a specified keyword/value pair.













+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




dh
-----------------------------------------------------------------------------

*in* 

	String giving the detached header.





keyword
-----------------------------------------------------------------------------

*in* 

String giving the keyword to be deleted.





+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _n\_match
- n\_match *in* 

Maximum number of matches to return.  If not given,
			all matches are returned.




.. _all\_match
- all\_match *in* 

If set, match all occurrences.




.. _all\_object
- all\_object *in* 

If set, match all object indices.  If not set, then
			match only object index 0.




.. _all\_history
- all\_history *in* 

If set, match all history indices.  If not set,
			then only the highest history index is matched.




.. _count
- count 

	Integer giving the numebr of keywords matched.





.. _object\_index
- object\_index *in* 

If given, then match only this object index.




.. _history\_index
- history\_index *in* 

If given, then match only this history index.




.. _prefix
- prefix *in* 

	If set, then match any keyword which begins with the
			given keyword string instead of requiring an exact
			match.














History
-------

 	Written by:	Spitale, 7/1998





















