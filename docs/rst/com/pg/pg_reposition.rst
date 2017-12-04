pg\_reposition.pro
===================================================================================================



























pg\_reposition
________________________________________________________________________________________________________________________





.. code:: IDL

 pg_reposition, _dv, bx=bx, od=od, ref_bx=ref_bx, dd=dd, gd=gd, toward=toward, away=away, at=at, along=along, absolute=absolute



Description
-----------
	Modifies the body position based on the given offset and observer.



	pg_reposition modifies bx and adds its name to the task list of each given
	descriptor.


 STATUS:
	Complete













+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




\_dv
-----------------------------------------------------------------------------

*in* 

	Array (nv,3,nt) specifying the translation vector.
			The components are assumed to be given wrt to the
			inertial frame unless od is given.  In that case
			dv is interpreted as a vector in the body frame of od.

			For convenience, if dv is given in the nonstandard form
			of a 3-element array, it is reinterpreted as a column
			vector (1,3).

			If ref_bx is given, then dv is interpreted as a distance
			and the direction is constructed from one of the directional
			keywords below.





+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _bx
- bx *in* 

Array (nt) of body descriptors to translate.




.. _od
- od *in* 

Observer descriptor; specifies the body frame for the
		translation vector.




.. _ref\_bx
- ref\_bx *in* 

Body descriptor giving reference position for directional
		keywords.




.. _dd
- dd *in* 

Data descriptor containing a generic descriptor to use
		if gd not given.




.. _gd
- gd *in* 

Generic descriptor.  If given, the descriptor inputs
		are taken from this structure if not explicitly given.




.. _toward
- toward *in* 

Body should be translated toward ref_bx (default).




.. _away
- away *in* 

Body should be translated away from ref_bx.




.. _at
- at *in* 

Body should be placed at the position of ref_bx.




.. _along
- along *in* 

Index of bx axis along which to translate.




.. _absolute
- absolute *in* 


		If set, dv is taken as an absolute position instead of an
		offset.















History
-------

 	Written by:	Spitale, 3/2007





















