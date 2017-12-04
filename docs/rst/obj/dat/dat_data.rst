dat\_data.pro
===================================================================================================



























dat\_data
________________________________________________________________________________________________________________________





.. code:: IDL

 result = dat_data(dd, samples=samples, current=current, slice=slice, nd=nd, true=true, noevent=noevent, abscissa=abscissa)



Description
-----------
	Returns the data array associated with a data descriptor.










Returns
-------

	The data array associated with the data descriptor.


 STATUS:
	Complete


 SEE ALSO:
	dat_set_data










+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




dd
-----------------------------------------------------------------------------

*in* 

Data descriptor.





+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _samples
- samples *in* 

 Output sample indices for /current.





.. _current
- current *in* 

 If set, the current loaded samples are returned.  In this
		  case, the sample indices are returned in the "samples"
		  keyword.




.. _slice
- slice *in* 

  Slice coordinates.




.. _nd
- nd *in* 

      If set, the samples input is taken to be an ND coordinate
	          rather than a 1D subscript.  DAT_DATA can normally tell
	          the difference automatically, but there is an ambiguity
	          if a single ND point is requested.  In that case, DAT_DATA
	          interprets that as an array of 1D subscripts, unless /nd
	          is set.




.. _true
- true *in* 

    If set, the actual data array is returned, even if there is
	          a sampling function.




.. _noevent
- noevent 



.. _abscissa
- abscissa *in* 

The abscissa is returned in this array.














History
-------

 	Written by:	Spitale, 2/1998
 	Adapted by:	Spitale, 5/2016





















