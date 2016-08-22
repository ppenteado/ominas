;=============================================================================
; ominas_data::init
;
;=============================================================================
function ominas_data::init, ii, crd=crd0, dd=dd0, $
@data__keywords.include
end_keywords
@core.include

 void = self->ominas_core::init(ii, crd=crd0, $
@core__keywords.include
end_keywords)
 if(keyword_set(dd0)) then struct_assign, dd0, self

 self.abbrev = 'DAT'

 if(NOT keyword_set(nhist)) then nhist = 1
 _nhist = getenv('NV_NHIST')
 if(keyword_set(_nhist)) then nhist = fix(_nhist)

 ;-----------------------
 ; filename
 ;-----------------------
 if(keyword_set(filename)) then self.filename = filename

 ;-----------------------
 ; maintain
 ;-----------------------
 if(keyword_set(maintain)) then self.maintain = maintain

 ;-----------------------
 ; compress
 ;-----------------------
 if(keyword_set(compress)) then self.compress = compress

 ;-----------------------
 ; type
 ;-----------------------
 if(keyword_set(type)) then self.type = type

 ;-----------------------
 ; gff
 ;-----------------------
 if(keyword_set(gff)) then self.gffp = nv_ptr_new(gff)

 ;-----------------------
 ; file properties
 ;-----------------------
 if(keyword_set(filetype)) then self.filetype=filetype $
 else self.filetype = dat_detect_filetype(/default)
 if(keyword_set(input_fn)) then self.input_fn=input_fn
 if(keyword_set(output_fn)) then self.output_fn=output_fn
 if(keyword_set(keyword_fn)) then self.keyword_fn=keyword_fn


 ;-----------------------
 ; instrument
 ;-----------------------
 if(keyword_set(instrument)) then self.instrument=instrument $
 else if(keyword_set(filetype) AND keyword_set(header)) then $
  begin
   self.instrument = dat_detect_instrument(header, udata, filetype, silent=silent)
   if(self.instrument EQ '') then $
              nv_message, /continue, $
                     'Unable to detect instrument.', name='data_descriptor::init'
  end


 ;-----------------------
 ; translators
 ;-----------------------
 if(keyword_set(self.instrument)) then $
  begin
   dat_lookup_translators, self.instrument, tab_translators=tab_translators, $
           input_translators, output_translators, input_keyvals, output_keyvals, $
           silent=silent

   if(input_translators[0] EQ '') then $
        nv_message, /continue, 'No input translators available.', $
                                                    name='nv_init_descriptor' $
   else self.input_translators_p=nv_ptr_new(input_translators)

   if(output_translators[0] EQ '') then $
       nv_message, /continue, 'No output translators available.', $
                                                    name='nv_init_descriptor' $
   else self.output_translators_p=nv_ptr_new(output_translators)

   if(keyword_set(input_keyvals)) then $
                   self.input_keyvals_p = nv_ptr_new(dat_parse_keyvals(input_keyvals))
   if(keyword_set(output_keyvals)) then $
                   self.output_keyvals_p = nv_ptr_new(dat_parse_keyvals(output_keyvals))
  end



 ;---------------------------------
 ; handle giving last sibling
 ;---------------------------------
 if(NOT keyword_set(self.sibling_dd_h)) then self.sibling_dd_h = handle_create()

 ;---------------------------------
 ; dimensions
 ;---------------------------------
 if(keyword_set(dim)) then self.dim_p = nv_ptr_new(dim)


 ;-----------------------
 ; cache size
 ;-----------------------
 if(keyword_set(cache)) then self.cache = cache $
 else self.cache = dat_cache()


 ;---------------------------------
 ; transforms
 ;---------------------------------
 if(keyword_set(input_transforms)) then $
		      self.input_transforms_p = nv_ptr_new(input_transforms)
 if(keyword_set(output_transforms)) then $
                        self.output_transforms_p = nv_ptr_new(output_transforms)



 ;-----------------------
 ; data limits
 ;-----------------------
 self.max = -1d100
 self.min = 1d100

 if(defined(min)) then self.min = min
 if(defined(max)) then self.max = max

 if(defined(data)) then $
  begin
   self.max = max(data)
   self.min = min(data)
  end
 

 ;-----------------------
 ; data and header
 ;-----------------------
 dap = self.sample_dap
 data_archive_set, dap, -1, nhist=nhist
 self.sample_dap = dap

 dap = self.order_dap
 data_archive_set, dap, -1, nhist=nhist
 self.order_dap = dap

 if(defined(data)) then dat_set_data, self, data, abscissa=abscissa, /silent


 dat_set_nhist, self, nhist


 _header = ''
 if(keyword_set(header)) then _header = header
 dat_set_header, self, _header


 return, 1
end
;=============================================================================



;=============================================================================
;+
; NAME:
;	ominas_data__define
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
;	data_dap:	Pointer to data archive containing the data 
;			and nhist past versions.
;
;	abscissa_dap:	Pointer to data archive containing the abscissa 
;			and nhist past versions.
;
;	dap_index:	Index of archived data to use.  
;
;	max:		Maximum data value.
;
;	min:		Minimum data value.
;
;	cache:		Max cache size data array.  Used to deterine whether 
;			to load / unload data samples.  -1 means infinite.
;
;	dim_p:	Pointer to array giving data dimensions.
;
;	type:	Data type code.
;
;	filename:	Name of data file.
;
;	filetype:	Filetype string determined by dat_detect_filetype.
;
;	input_transforms_p:	Pointer to list of input transform 
;				functions determined by dat_lookup_transforms.
;
;	output_transforms_p:	Pointer to list of output transform 
;				functions determined by dat_lookup_transforms.
;
;	input_fn:	Name of function to read data file.
;
;	output_fn:	Name of function to write data file.
;
;	keyword_fn:	Name of function to read/write header keywords.
;
;	instrument:	Instrument string from dat_detect_instrument.
;
;	input_translators_p:	Pointer to list of input translator 
;				functions determined by dat_lookup_translators.
;
;	output_translators_p:	Pointer to list of output translator 
;				functions determined by dat_lookup_translators.
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
;				on the samples given to dat_data():
;
;				function sampling_fn, dd, samples, data
;
;	dim_fn:			Optional function to cause dat_dim() to report
;				dimensions other than those stored in the
;				data descriptor:
;
;				function dim_fn, dd, data
;
;	compress:	Compression suffix.  The full name of the 
;			compression function is dat_compress_data_<suffix>.
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
;				  1: Clone a new descriptor 
;				     and leave original dd
;				     unchanged.
;
;	sibling_dd_h:	Handle giving dd spawned as a result of writing to 
;			this descriptor while update = 1.  Handle is used 
;			to protect this dd from nv_free.
;;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/1998
; 	Adapted by:	Spitale, 5/2016
;	
;-
;=============================================================================
pro ominas_data__define


 struct = $
    { ominas_data, inherits ominas_core, $
	data_dap:		nv_ptr_new(), $	; Pointer to the data archive
	abscissa_dap:		nv_ptr_new(), $	; Pointer to the abscissa archive
	sample_dap:		nv_ptr_new(), $	; Pointer to the sample archive
	order_dap:		nv_ptr_new(), $	; Pointer to the sample load order
	header_dap:		nv_ptr_new(), $	; Pointer to the generic header archive
        dap_index:		0, $		; data archive index

	cache:			0l, $		; Max. cache size for data array (Mb)
						;  Doesn't apply to maintenance 0

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
	dim_fn:			'', $		; Optional dimension function.

	gffp:			nv_ptr_new(), $	; GFF pointer

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

	sibling_dd_h:		0l $		; Handle giving dd spawned as a result
						;  of writing to this descriptor
						;  while update = 1.
						;  Handle is used to protect that dd
						;  from nv_free.

    }


end
;===========================================================================


