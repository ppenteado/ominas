brim.pro
===================================================================================================









	Image browser.



	brim may be run standalone or from within grim.  If no files or data
	descriptors are given, brim first prompts the user to select a list of
	files.  brim then displays thumbnails of all valid files.  Files may be
	selected by clicking with the left mouse button.  By default, the image
	is opened in a new grim window.  Alternate actions may be defined
	through procedures supplied by the caller.


 EXAMPLES:
	To load files into brim using a file-selection widget:

	 IDL> brim


	To load all recognizeable images in the current directory into brim:

	 IDL> brim, '*'


	To browse a set of data descriptors:

	 IDL> dd = dat_read('*')
	 IDL> brim, dd


 STATUS:
	Complete.




















History
-------

 	Written by:	Spitale, 10/2002















