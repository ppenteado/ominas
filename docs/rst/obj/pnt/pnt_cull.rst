pnt\_cull.pro
===================================================================================================



























pnt\_cull
________________________________________________________________________________________________________________________





.. code:: IDL

 result = pnt_cull(_ptd, @pnt_condition_keywords.include, nofree=nofree, condition=condition)



Description
-----------
	Cleans out an array of POINT objects by removing POINT objects that are
	empty, or whose points all fail the specified conditions.










Returns
-------

	Array POINT objects, or 0 if all were empty.











+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




\_ptd
-----------------------------------------------------------------------------

*in* 

Array of POINT objects.





@pnt\_condition\_keywords.include
-----------------------------------------------------------------------------






+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _nofree
- nofree *in* 

	If set, invalid POINT object are not freed.




.. _condition
- condition 













History
-------

  Spitale, 11/2015; 	Adapted from pgs_cull





















