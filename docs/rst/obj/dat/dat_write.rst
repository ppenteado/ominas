dat\_write.pro
===================================================================================================



























dat\_write
________________________________________________________________________________________________________________________





.. code:: IDL

 dat_write, arg1, arg2, nodata=nodata, filetype=filetype, output_fn=output_fn, override=override



Description
-----------
	Writes a data file of arbitrary format.



	dat_write expands all file specifications and attempts to write a
	file corresponding to each given data descriptor.  An error results
	if the filespec expands to a different number of files than the number
	of given data descriptors.


 STATUS:
	Complete


 SEE ALSO:
	dat_read













+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




arg1
-----------------------------------------------------------------------------






arg2
-----------------------------------------------------------------------------






+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _nodata
- nodata 



.. _filetype
- filetype *in* 

Overrides data descriptor filetype (and thus the
			output function).  Data descriptor filetype is
			updated unless /override.




.. _output\_fn
- output\_fn *in* 

Overrides data descriptor output function.  Data
			descriptor output_fn is updated unless /override.




.. _override
- override *in* 

If set, filespec, filetype, and output_fn inputs
			are used for this call, but not updated in the data
			descriptor.















History
-------

 	Written by:	Spitale, 7/1998
 	Adapted by:	Spitale, 5/2016





















