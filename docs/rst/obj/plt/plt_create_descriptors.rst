plt\_create\_descriptors.pro
===================================================================================================



























plt\_create\_descriptors
________________________________________________________________________________________________________________________





.. code:: IDL

 result = plt_create_descriptors(n, @plt__keywords_tree.include, crd=crd, bd=bd, sld=sld, gbd=gbd, pd=pd)



Description
-----------
	Init method for the PLANET class.










Returns
-------

       An array (n) of planet descriptors.

 STATUS:
       Completed.










+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




n
-----------------------------------------------------------------------------

*in* 

     Number of planet descriptors.





@plt\_\_keywords\_tree.include
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




.. _sld
- sld *in* 

Solid descriptor(s) to pass to sld_create_descriptors.




.. _gbd
- gbd *in* 

Globe descriptor(s) to pass to glb_create_descriptors.




.. _pd
- pd *in* 

Planet descriptor(s) to initialize, instead of creating new ones.














History
-------

 	Written by:	Spitale, 1/1998
 	Adapted by:	Spitale, 5/2016





















