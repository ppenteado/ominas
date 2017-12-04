cor\_create\_descriptors.pro
===================================================================================================



























cor\_create\_descriptors
________________________________________________________________________________________________________________________





.. code:: IDL

 result = cor_create_descriptors(n, @cor__keywords.include, crd=crd)



Description
-----------
	Init method for the CORE class.










Returns
-------

	Newly created or or freshly initialized core descriptors depending
	on the presence of the crd keyword.


 STATUS:
	Complete










+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




n
-----------------------------------------------------------------------------

*in* 

 Number of descriptors to create.





@cor\_\_keywords.include
-----------------------------------------------------------------------------






+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _crd
- crd *in* 

Core descriptor(s) to initialize, instead of creating a new one.














History
-------

 	Written by:	Spitale, 1/1998
 	Adapted by:	Spitale, 5/2016





















