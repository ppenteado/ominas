;=============================================================================
;+
; NAME:
;	data_descriptor__define
;
;
; PURPOSE:
;	Structure defining the data descriptor.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	N/A 
;
;
; FIELDS:
;	id_string:	Identification string.  Typically the filename.
;
;	sn:	Serial number.  This functionality has been replaced
;		by the ID pointer, but it is still maintained.
;
;	idp:	ID pointer.  This pointer is unique to the descriptor
;		and can be used for identification.
;
;	data_dap:	Pointer to data archive containing the data 
;			and nhist past versions.
;
;	dap_index:	Index of archived data to use.  
;
;	max:		Maximum data value.
;
;	min:		Minimum data value.
;
;	dim_p:	Pointer to array giving data dimensions.
;
;	type:	Data type code.
;
;	filename:	Name of data file.
;
;	filetype:	Filetype string determined by nv_detect_filetype.
;
;	input_transforms_p:	Pointer to list of input transform 
;				functions determined by nv_lookup_transforms.
;
;	output_transforms_p:	Pointer to list of output transform 
;				functions determined by nv_lookup_transforms.
;
;	input_fn:	Name of function to read data file.
;
;	output_fn:	Name of function to write data file.
;
;	keyword_fn:	Name of function to read/write header keywords.
;
;	instrument:	Instrument string from nv_detect_instrument.
;
;	input_translators_p:	Pointer to list of input translator 
;				functions determined by nv_lookup_translators.
;
;	output_translators_p:	Pointer to list of output translator 
;				functions determined by nv_lookup_translators.
;
;	input_keyvals_p:	Keyword/value pairs for input translators.
;
;	output_keyvals_p:	Keyword/value pairs for output translators.
;
;	transient_keyvals_p:	Transient keyword/value pairs found in the 
;				translator argument string.
;
;	last_translator:	Description of last translator called.
;
;	sampling_fn:		Optional function to perform a transformation
;				on the samples given to nv_data():
;
;				function sampling_fn, dd, samples, data
;
;	sampling_fn_data_p:	Pointer to data for sampling_fn.
;
;	dim_fn:			Optional function to cause nv_dim() to report
;				dimensions other than those stored in the
;				data descriptor:
;
;				function dim_fn, dd, data
;
;	dim_fn_data_p:		Pointer to data for dim_fn.
;
;	compress:	Compression suffix.  The full name of the 
;			compression function is nv_compress_data_<suffix>.
;
;	compress_data_p:	Data for compression function.
;
;	maintain:	Data maintenance mode:
;				  0: load initially
;				  1: load when needed; retain
;				     only ndd data descriptor
;				     arrays in memory.
;				  2: Load when needed, but
; 				     do not retain.
;
;	update:		Data update mode:
;				 -1: Locked; applies to data, header,
;				     and udata.
;				  0: Normal
;				  1: Clone off a new descriptor 
;				     and leave original dd
;				     unchanged.
;
;	sibling_dd_h:	Handle giving dd spawned as a result of writing to 
;			this descriptor while update = 1.  Handle is used 
;			to protect this dd from nv_free.
;
;	udata_tlp:	Pointer to tag list containing user data.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/1998
;	
;-
;=============================================================================
pro data_descriptor__define

 struct = $
    { data_descriptor, $
	id_string:		'', $		; Identification string
	sn:			0l, $		; Descriptor serial number

	idp:			nv_ptr_new(), $	; id_ptr
	data_dap:		nv_ptr_new(), $	; Pointer to the data archive
	header_dap:		nv_ptr_new(), $	; Pointer to the generic header archive
        dap_index:		0, $		; data archive index
	max:			0d, $		; Maximum data value
	min:			0d, $		; Minimum data value

	dim_p:			nv_ptr_new(), $	; data dimensions
	type:			0b, $		; data type

	filename:		'', $		; Name of source file.
	filetype:		'', $		; Filetype string
	input_transforms_p:	nv_ptr_new(), $	; Input transform function
	output_transforms_p:	nv_ptr_new(), $	; Output transform function
	input_fn:		'', $		; Function to read file
	output_fn:		'', $		; Function to write file
	keyword_fn:		'', $		; Function toread/write header keywords
	instrument:		'', $		; Instrument string
	input_translators_p:	nv_ptr_new(), $	; Names of input translators
	output_translators_p:	nv_ptr_new(), $	; Names of output translators
	input_keyvals_p:	nv_ptr_new(), $	; Keyvals for input translators
	output_keyvals_p:	nv_ptr_new(), $	; Keyvals for output translators
	transient_keyvals_p:	nv_ptr_new(), $	; Keyvals parsed per-command
	last_translator:	lonarr(2), $	; Description of last translator
						; called
	sampling_fn:		'', $		; Optional sampling function.
	sampling_fn_data_p:	ptr_new(), $	
	dim_fn:			'', $		; Optional dimension function.
	dim_fn_data_p:		ptr_new(), $	

;	segment:		{nv_seg_struct}, $

	compress:		'', $		; Data compression function suffix
	compress_data_p:	nv_ptr_new(), $

	maintain:		0b, $		; Data maintenance mode:
						;  0: load initially
						;  1: load when needed; retain
						;     only ndd data descriptor
						;     arrays in memory.
						;  2: Load when needed, but
						;     do not retain.

	update:			0, $		; Data update mode:
						; -1: Locked; applies to data, header,
						;     and udata.
						;  0: Normal
						;  1: Clone a new descriptor 
						;     and leave original dd
						;     unchanged.

	sibling_dd_h:		0l, $		; Handle giving dd spawned as a result
						;  of writing to this descriptor
						;  while update = 1.
						;  Handle is used to protect that dd
						;  from nv_free.

	udata_tlp:		nv_ptr_new() $	; Pointer to user data
    }


end
;===========================================================================


