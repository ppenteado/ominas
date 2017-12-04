pnt\_points.pro
===================================================================================================



























pnt\_points
________________________________________________________________________________________________________________________





.. code:: IDL

 result = pnt_points(ptd0, @pnt_condition_keywords.include, segments=segments, sample=sample, cat=cat, condition=condition, noevent=noevent)



Description
-----------
	Returns the points associated with a POINT object.










Returns
-------

	The points associated with the POINT object, or zero.


 STATUS:
	Complete


 SEE ALSO:
	pnt_set_points











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


.. _segments
- segments 

Subscripts in the output array denoting segments in the
			(assumed) continuous curve due to the point selection
			conditions.





.. _sample
- sample *in* 

	Sampling interval in the nv direction.  Default is 1.

	<condition>:	All of the predefined conditions (e.g. /visible) are
			accepted; see pnt_condition_keywords.include.




.. _cat
- cat *in* 

	If set, arrays from multiple input objects are
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





















