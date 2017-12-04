cor\_select.pro
===================================================================================================



























cor\_select
________________________________________________________________________________________________________________________





.. code:: IDL

 result = cor_select(crx, key, indices=indices, rm=rm, noevent=noevent, name=name, class=class)



Description
-----------
	Selects descriptors based on given criteria.










Returns
-------

	All descriptors in crx whose parameters match the given key.
	0 if no matches found.


 STATUS:
	Complete










+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




crx
-----------------------------------------------------------------------------

*in* 

 Array of descriptors of any subclass of CORE.





key
-----------------------------------------------------------------------------

*in* 

 Array of key to select.





+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _indices
- indices 



.. _rm
- rm 



.. _noevent
- noevent 



.. _name
- name 



.. _class
- class 













History
-------

 	Written by:	Spitale, 1/1998
 	Rewritten by:	Spitale, 4/2016





















