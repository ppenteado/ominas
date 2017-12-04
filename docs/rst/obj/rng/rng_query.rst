rng\_query.pro
===================================================================================================



























rng\_query
________________________________________________________________________________________________________________________





.. code:: IDL

 rng_query, xd, @rng__keywords_tree.include, condition=condition, cat=cat, noevent=noevent



Description
-----------
	Returns the fields associated with a RING object.  This is a
	convenient way of getting multiple fields in one call, and only a
	single event is generated.













+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




xd
-----------------------------------------------------------------------------






@rng\_\_keywords\_tree.include
-----------------------------------------------------------------------------






+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _condition
- condition *in* 

Structure specifing a mask and a condition with which to
			match flag values.  The structure must contain the fields
			MASK and STATE.  MASK is a bitmask to test against
			the flags field of the POINT object, and STATE
			is either PS_TRUE and PS_FALSE.  Note that in this case,
			the values will be returned as a list, with no separation
			into nv and nt dimensions.




.. _cat
- cat *in* 

	If set, arrays from mulitple input objets are
			concatenated.

	<condition>:	All of the predefined conditions (e.g. /visible) are
			accepted; see pnt_condition_keywords.include.




.. _noevent
- noevent *in* 

If set, no event is generated.














History
-------

 	Written by:	Spitale, 2/2017





















