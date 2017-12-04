dat\_read.pro
===================================================================================================









	Reads a data file of arbitrary format and produces a data descriptor.



	dat_read expands all file specifications and then attempts to detect
	the filetype for each resulting filename using the filetype detectors
	table.  If a filetype is detected, dat_read looks up the I/O functions
	and calls the input function to read the file.  Finally, it calls
	nv_init_descriptor to obtain a data descriptor.


 STATUS:
	Complete


 SEE ALSO:
	dat_write




















History
-------

 	Written by:	Spitale, 2/1998















