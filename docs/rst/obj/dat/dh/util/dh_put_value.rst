dh\_put\_value.pro
===================================================================================================









	Sets the value of a specified keyword.



	See procedure below; 'utime' and 'history' keywords are modified.



	The data is appended to the top of the specified section of the detached
	header using the given object index and a history index that is one
	greater than the current value found in the detached header for this
	keyword.  The value of the 'utime' keyword corresponding to this history
	index is modified to reflect the current time.  If this history index is
	greater than that given by the 'history' keyword, then that value is
	modified as well.

	If 'value' is an array, then each element is written on a different line
	using the keyword with the same object index, history index, and
	comment, but whose element indices reflect the order that the data
	appear in the array.

	If 'value' is of string type, then each entry is enclosed in quotes.








Examples
___________

.. code:: IDL

	The following commands:

		IDL> val=[7,6,5,4,3]
		IDL> dh_put_value, dh, 'test_key', val

	produce the following detached header:

	 history = -1 / Current history value
	 <updates>
	 utime = 2451022.404086 / Julian day of update - Mon Jul 27 9:41:53 1998
	 test_key(0) = 7
	 test_key(1) = 6
	 test_key(2) = 5
	 test_key(3) = 4
	 test_key(4) = 3



 STATUS:
	Complete


 SEE ALSO:
	dh_get_value, dh_rm_value
















History
-------

 	Written by:	Spitale, 7/1998
	Added 'section' keyword: Spitale; 11/2001















