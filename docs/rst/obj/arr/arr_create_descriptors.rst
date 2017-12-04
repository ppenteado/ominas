arr\_create\_descriptors.pro
===================================================================================================



























arr\_create\_descriptors
________________________________________________________________________________________________________________________





.. code:: IDL

 result = arr_create_descriptors(n, @arr__keywords_tree.include, crd=crd, ard=ard)



Description
-----------
	Init method for the ARRAY class.










Returns
-------

       An array (n) of array descriptors.

 STATUS:
       Completed.










+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




n
-----------------------------------------------------------------------------

*in* 

     Number of array descriptors.





@arr\_\_keywords\_tree.include
-----------------------------------------------------------------------------






+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _crd
- crd *in* 

Core descriptor(s) to pass to cor_create_descriptors.




.. _ard
- ard *in* 

Station descriptor(s) to initialize, instead of creating new
		ones.














History
-------

       Written by:     Spitale
 	Adapted by:	Spitale, 5/2016





















