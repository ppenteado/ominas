pnt\_data.pro
===================================================================================================



























pnt\_data
________________________________________________________________________________________________________________________





.. code:: IDL

 result = pnt_data(ptd0, @pnt_condition_keywords.include, tags=tags, sample=sample, cat=cat, condition=condition, noevent=noevent)



Description
-----------
	Returns the point-by-point data associated with a POINT object.










Returns
-------

	The point-by-point data associated with the POINT object.


 STATUS:
	Complete


 SEE ALSO:
	pnt_set_data











+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




ptd0
-----------------------------------------------------------------------------






@pnt\_condition\_keywords.include
-----------------------------------------------------------------------------






+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _tags
- tags *in* 

If given, data arrays are returned only for these tags,
		and are arranged in this order.




.. _sample
- sample *in* 

	Sampling interval in the nv direction.  Default is 1.

	<condition>:	All of the predefined conditions (e.g. /visible) are
			accepted; see pnt_condition_keywords.include.




.. _cat
- cat *in* 

	If set, arrays from mulitple input objets are
			concatenated.




.. _condition
- condition *in* 

Structure specifing a mask and a condition with which to
			match flag values.  The structure must contain the fields
			MASK and STATE.  MASK is a bitmask to test against
			the flags field of the POINT object, and STATE
			is either PS_TRUE and PS_FALSE.  Note that in this case,
			the values will be returned as a list, with no separation
			into nv and nt dimensions.




.. _noevent
- noevent *in* 

If set, no event is generated.














History
-------

 	Written by:	Spitale, 11/2015





















