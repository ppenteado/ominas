pg\_put\_cameras.pro
===================================================================================================



























pg\_put\_cameras
________________________________________________________________________________________________________________________





.. code:: IDL

 pg_put_cameras, dd, trs, @cam__keywords_tree.include, cd=cd



Description
-----------
	Outputs camera descriptors through the translators.



	Translator-dependent.  The data descriptor may be affected.



	Camera descriptors are passed to the translators.  Any camera
	keywords are used to override the corresponding quantities in the
	output descriptors.


 STATUS:
	Complete


 SEE ALSO:
	pg_put_planets, pg_put_rings, pg_put_stars, pg_put_maps













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





@cam\_\_keywords\_tree.include
-----------------------------------------------------------------------------






+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _cd
- cd *in* 

Camera descriptors to output.

	cam_*:		All camera override keywords are accepted.














History
-------

 	Written by:	Spitale, 1998





















