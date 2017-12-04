pg\_put\_stars.pro
===================================================================================================



























pg\_put\_stars
________________________________________________________________________________________________________________________





.. code:: IDL

 pg_put_stars, dd, trs, @str__keywords_tree.include, sd=sd, ods=ods



Description
-----------
	Outputs star descriptors through the translators.



	Translator-dependent.  The data descriptor may be affected.



	CameStarra descriptors are passed to the translators.  Any star
	keywords are used to override the corresponding quantities in the
	output descriptors.


 STATUS:
	Complete


 SEE ALSO:
	pg_put_planets, pg_put_rings, pg_put_cameras, pg_put_maps













+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




dd
-----------------------------------------------------------------------------

*in* 

Data descriptor.





trs
-----------------------------------------------------------------------------

*in* 

String containing keywords and values to be passed directly
		to the translators as if they appeared as arguments in the
		translators table.  These arguments are passed to every
		translator called, so the user should be aware of possible
		conflicts.  Keywords passed using this mechanism take
		precedence over keywords appearing in the translators table.





@str\_\_keywords\_tree.include
-----------------------------------------------------------------------------






+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _sd
- sd *in* 

Star descriptors to output.

	str_*:		All star override keywords are accepted.




.. _ods
- ods 













History
-------

 	Written by:	Spitale, 1998





















