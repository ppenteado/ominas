pg\_put\_maps.pro
===================================================================================================



























pg\_put\_maps
________________________________________________________________________________________________________________________





.. code:: IDL

 pg_put_maps, dd, trs, @map__keywords_tree.include, md=md



Description
-----------
	Outputs map descriptors through the translators.



	Translator-dependent.  The data descriptor may be affected.



	Map descriptors are passed to the translators.  Any map
	keywords are used to override the corresponding quantities in the
	output descriptors.


 STATUS:
	Complete


 SEE ALSO:
	pg_put_planets, pg_put_rings, pg_put_stars, pg_put_cameras













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





@map\_\_keywords\_tree.include
-----------------------------------------------------------------------------






+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _md
- md *in* 

Map descriptors to output.

	map_*:		All map override keywords are accepted.














History
-------

 	Written by:	Spitale, 1998





















