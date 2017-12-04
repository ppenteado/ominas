pg\_get\_maps.pro
===================================================================================================



























pg\_get\_maps
________________________________________________________________________________________________________________________





.. code:: IDL

 result = pg_get_maps(arg1, arg2, @map__keywords_tree.include, md=md, gbx=gbx, dkx=dkx, bx=bx, _extra=_extra, override=override, verbatim=verbatim, count=count)



Description
-----------
	Obtains a map descriptor for the given data descriptor.



	If /override, then a map descriptor is created and initialized
	using the specified values.  Otherwise, the descriptor is obtained
	through the translators.  Note that if /override is not used,
	values (except name) can still be overridden by specifying
	them as keyword parameters.  If name is specified, then
	only descriptors corresponding to those names will be returned.











Returns
-------

	Array of map descriptors, 0 if an error occurs.










+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




arg1
-----------------------------------------------------------------------------

*in* 

Data descriptor or transient translator argument.  In the
		latter case, a string containing keywords and values to be
		passed directly to the translators as if they appeared as
		arguments in the translators table.  Keywords passed using
		this mechanism take precedence over keywords appearing in
		the translators table.  If no data descriptor is given,
		one may be constructed using DATA keywords (see below).  The
		newly created data descriptor is freed unless this argument
		is an undefined named variable, in which case the new
		descriptor is returned in this variable.





arg2
-----------------------------------------------------------------------------

*in* 

Transient translator argument, if present.





@map\_\_keywords\_tree.include
-----------------------------------------------------------------------------






+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _md
- md *in* 

	Input map descriptors; used by some translators.




.. _gbx
- gbx 



.. _dkx
- dkx 



.. _bx
- bx 



.. _\_extra
- \_extra 



.. _override
- override *in* 

Create a data descriptor and initilaize with the
			given values.  Translators will not be called.




.. _verbatim
- verbatim *in* 

If set, the descriptors requested using name
			are returned in the order requested.  Otherwise, the
			order is determined by the translators.




.. _count
- count 

Number of descriptors returned















History
-------

 	Written by:	Spitale, 1998
	Modified:	Spitale, 8/2001





















