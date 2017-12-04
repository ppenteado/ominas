pg\_put\_planets.pro
===================================================================================================



























pg\_put\_planets
________________________________________________________________________________________________________________________





.. code:: IDL

 pg_put_planets, dd, trs, @plt__keywords_tree.include, pd=pd, ods=ods, raw=raw



Description
-----------
	Outputs planet descriptors through the translators.



	Translator-dependent.  The data descriptor may be affected.



	Planet descriptors are passed to the translators.  Any planet
	keywords are used to override the corresponding quantities in the
	output descriptors.


 STATUS:
	Complete


 SEE ALSO:
	pg_put_cameras, pg_put_rings, pg_put_stars, pg_put_maps













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





@plt\_\_keywords\_tree.include
-----------------------------------------------------------------------------






+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _pd
- pd *in* 

Planet descriptors to output.

	plt_*:		All planet override keywords are accepted.




.. _ods
- ods 



.. _raw
- raw *in* 

	If set, no aberration corrections are performed.














History
-------

 	Written by:	Spitale, 1998





















