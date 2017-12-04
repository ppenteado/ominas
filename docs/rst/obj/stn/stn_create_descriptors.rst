stn\_create\_descriptors.pro
===================================================================================================



























stn\_create\_descriptors
________________________________________________________________________________________________________________________





.. code:: IDL

 result = stn_create_descriptors(n, @stn__keywords_tree.include, crd=crd, bd=bd, std=std)



Description
-----------
	Init method for the STATION class.










Returns
-------

       An array (n) of station descriptors.

 STATUS:
       Completed.










+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




n
-----------------------------------------------------------------------------

*in* 

     Number of station descriptors.





@stn\_\_keywords\_tree.include
-----------------------------------------------------------------------------






+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _crd
- crd *in* 

Core descriptor(s) to pass to cor_create_descriptors.




.. _bd
- bd *in* 

Body descriptor(s) to pass to bod_create_descriptors.




.. _std
- std *in* 

Station descriptor(s) to initialize, instead of creating new
		ones.














History
-------

       Written by:     Spitale
 	Adapted by:	Spitale, 5/2016





















