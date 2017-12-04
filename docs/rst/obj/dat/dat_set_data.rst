dat\_set\_data.pro
===================================================================================================



























dat\_set\_data
________________________________________________________________________________________________________________________





.. code:: IDL

 dat_set_data, dd, _data, update=update, noevent=noevent, abscissa=abscissa, sample=sample



Description
-----------
	Replaces the data array associated with a data descriptor.













+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




dd
-----------------------------------------------------------------------------

*in* 

Data descriptor.





\_data
-----------------------------------------------------------------------------

*in* 

New data array.





+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _update
- update *in* 

Update mode flag.  If not given, it will be taken from dd.




.. _noevent
- noevent 



.. _abscissa
- abscissa *in* 

If set, the given array is taken as the abscissa.




.. _sample
- sample 













History
-------

 	Written by:	Spitale, 2/1998
 	Adapted by:	Spitale, 5/2016





















