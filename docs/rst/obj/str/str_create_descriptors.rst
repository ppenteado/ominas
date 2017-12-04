str\_create\_descriptors.pro
===================================================================================================



























str\_create\_descriptors
________________________________________________________________________________________________________________________





.. code:: IDL

 result = str_create_descriptors(n, @str__keywords_tree.include, crd=crd, bd=bd, sld=sld, gbd=gbd, sd=sd)



Description
-----------
	Init method for the STAR class.










Returns
-------

       An array (n) of star descriptors.

 STATUS:
       Completed.










+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




n
-----------------------------------------------------------------------------

*in* 

     Number of star descriptors.





@str\_\_keywords\_tree.include
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




.. _sd
- sd *in* 

Star descriptor(s) to initialize, instead of creating new ones.














History
-------

       Written by:     Haemmerle, 5/1998
 	Adapted by:	Spitale, 5/2016





















