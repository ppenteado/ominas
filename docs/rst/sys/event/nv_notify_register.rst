nv\_notify\_register.pro
===================================================================================================



























nv\_notify\_register
________________________________________________________________________________________________________________________





.. code:: IDL

 nv_notify_register, _xd, handler, type, data=data, scalar_data=scalar_data, compress=compress



Description
-----------
	Register descriptor event handlers.



	nv_notify_block


 STATUS:
	Complete


 SEE ALSO:
	nv_notify_unregister













+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




\_xd
-----------------------------------------------------------------------------

*in* 

	Array of descriptors.





handler
-----------------------------------------------------------------------------

*in* 

Name of event handler functions.  If only one element,
			then this function will be registered for every given
			descriptor.  Otherwise must have the same number of
			elements as xd.





type
-----------------------------------------------------------------------------

*in* 

	Type of data event to respond to:
			 0 - set value
			 1 - get value
			0 is default.  If only one element, then this type
			will be registered for every given descriptor.
			Otherwise must have the same number of elements as xd.





+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _data
- data *in* 

	Arbitrary user data to associate with events on these
			descriptors.  A pointer to this data is allocated and
			returned in the 'data_p' field of the event structure.
			Note that only one descriptor xd may be specified
			per call when using this argument.




.. _scalar\_data
- scalar\_data *in* 

Scalar user data to associate with events on these
			descriptors.  This data is returned in the 'data'
			field of the event structure.




.. _compress
- compress *in* 

Event compression flag.














History
-------

 	Written by:	Spitale, 6/2002





















