pg\_get\_cameras.pro
===================================================================================================



























pg\_get\_cameras
________________________________________________________________________________________________________________________





.. code:: IDL

 result = pg_get_cameras(arg1, arg2, @cam__keywords_tree.include, cd=cd, od=od, pd=pd, _extra=_extra, override=override, verbatim=verbatim, default_orient=default_orient, no_default=no_default, count=count)



Description
-----------
	Obtains a camera descriptor for the given data descriptor.



	If /override, then a camera descriptor is created and initialized
	using the specified values.  Otherwise, the descriptor is obtained
	through the translators.  Note that if /override is not used,
	values (except cam_name) can still be overridden by specifying
	them as keyword parameters.  If cam_name is specified, then
	only descriptors corresponding to those names will be returned.











Returns
-------

	Array of camera descriptors, 0 if an error occurs.










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





@cam\_\_keywords\_tree.include
-----------------------------------------------------------------------------






+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _cd
- cd *in* 

	Input camera descriptors; used by some translators.




.. _od
- od 



.. _pd
- pd 



.. _\_extra
- \_extra 



.. _override
- override *in* 

Create a data descriptor and initilaize with the
			given values.  Translators will not be called.




.. _verbatim
- verbatim *in* 

If set, the descriptors requested using cam_name
			are returned in the order requested.  Otherwise, the
			order is determined by the translators.




.. _default\_orient
- default\_orient *in* 

Default orientation matrix to use if camera
			orientation is not available.  If not specified,
			the identity matrix is used.


	CAMERA Keywords
	---------------
	All CAMERA override keywords are accepted.  See cam__keywords.include.
	If 'name' is specified, then only descriptors with those names are
	returned.

	DATA Keywords
	-------------
	All DATA override keywords are accepted.  See dat__keywords.include.




.. _no\_default
- no\_default 



.. _count
- count 

Number of descriptors returned















History
-------

 	Written by:	Spitale, 1998
	Modified:	Spitale, 8/2001





















