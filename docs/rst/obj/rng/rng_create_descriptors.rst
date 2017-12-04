rng\_create\_descriptors.pro
===================================================================================================



























rng\_create\_descriptors
________________________________________________________________________________________________________________________





.. code:: IDL

 result = rng_create_descriptors(n, @rng__keywords_tree.include, crd=crd, bd=bd, sld=sld, dkd=dkd, rd=rd)



Description
-----------
	Init method for the RING class.










Returns
-------

       An array (n) of ring descriptors.

 STATUS:
       Completed.










+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




n
-----------------------------------------------------------------------------

*in* 

     Number of ring descriptors.





@rng\_\_keywords\_tree.include
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




.. _dkd
- dkd *in* 

Disk descriptor(s) to pass to dsk_create_descriptors.




.. _rd
- rd *in* 

Ring descriptor(s) to initialize, instead of creating new
		ones.














History
-------

       Written by:     Spitale
 	Adapted by:	Spitale, 5/2016





















