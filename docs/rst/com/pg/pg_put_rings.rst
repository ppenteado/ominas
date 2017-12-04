pg\_put\_rings.pro
===================================================================================================



























pg\_put\_rings
________________________________________________________________________________________________________________________





.. code:: IDL

 pg_put_rings, dd, trs, @rng__keywords_tree.include, rd=rd, ods=ods



Description
-----------
	Outputs ring descriptors through the translators.



	Translator-dependent.  The data descriptor may be affected.



	Ring descriptors are passed to the translators.  Any ring
	keywords are used to override the corresponding quantities in the
	output descriptors.


 STATUS:
	Complete


 SEE ALSO:
	pg_put_planets, pg_put_cameras, pg_put_stars, pg_put_maps













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





@rng\_\_keywords\_tree.include
-----------------------------------------------------------------------------






+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _rd
- rd *in* 

Ring descriptors to output.

	rng_*:		All ring override keywords are accepted.




.. _ods
- ods 













History
-------

 	Written by:	Spitale, 1998





















