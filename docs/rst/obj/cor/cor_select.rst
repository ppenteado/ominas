cor\_select.pro
===================================================================================================



























cor\_select
________________________________________________________________________________________________________________________





.. code:: IDL

 result = cor_select(crx, key, indices=indices, rm=rm, noevent=noevent, name=name, class=class, exclude_name=exclude_name, exclude_class=exclude_class)



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

 Array of keys to select.





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



.. _exclude\_name
- exclude\_name 



.. _exclude\_class
- exclude\_class 













History
-------

 	Written by:	Spitale, 1/1998
 	Rewritten by:	Spitale, 4/2016





















