;=============================================================================
;+
; NAME:
;	nv_init_descriptor
;
;
; PURPOSE:
;	Creates and initializes a data descriptor.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	dd = nv_init_descriptor()
;
;
; ARGUMENTS:
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:  
;	filename:	Name of data file.
;
;	dim:	Array giving the dimensions of the data array.
;
;	type:	Integer giving the type code of the data array.
;
;	id_string:	Identification string.
;
;	data:	Data array.
;
;	nhist:	Number of past version of the data array to archive.
;		If not given, the environment variable NV_NHIST is
;		used.  If that is not set, then nhist defaults to 1.
;
;	udata:	Pointer to a tag list containing any user data.
;
;	header:	Header array.
;
;	filetype:	Filetype identifier string.  If not given
;			an attempt is made to detect it.
;
;	input_fn:	Name of function to read data file.
;
;	output_fn:	Name of function to write data file.
;
;	keyword_fn:	Name of function to read/write header keywords.
;
;	instrument:	Instrument string.  If not given an
;			attempt is made to detect it.
;
;	input_transforms:	String array giving the names of the
;				input transforms.
;
;	output_transforms:	String array giving the names of the
;				output transforms.
;
;	maintain:	Data maintenance mode.
;
;	compress:	Compression suffix.
;
;	silent:		If set, messages are suppressed.
;
;
;  OUTPUT: NONE
;	input_translators:	String array giving the names of the
;				input translators.
;
;	output_translators:	String array giving the names of the
;				output translators.
;
;
;
; RETURN:
;	Newly created and initialized data descriptor.
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
function nv_init_descriptor, $
	filename=filename, $
	dim=dim, $
	type=type, $
	id_string=id_string, $
	data=data, $
	nhist=nhist, $
	udata=udata, $
	header=header, $
	filetype=filetype, $
	input_fn=input_fn, $
	output_fn=output_fn, $
	keyword_fn=keyword_fn, $
	instrument=instrument, $
	input_translators=input_translators, $
	output_translators=output_translators, $
	input_transforms=input_transforms, $
	output_transforms=output_transforms, $
	maintain=maintain, compress=compress, $
	tab_translators=tab_translators, silent=silent
@nv.include
; on_error, 1

 if(NOT keyword_set(nhist)) then nhist = 1
 _nhist = getenv('NV_NHIST')
 if(keyword_set(_nhist)) then nhist = fix(_nhist)

 dd={data_descriptor}

 ;-----------------------------
 ; handle giving last sibling
 ;-----------------------------
 if(NOT keyword_set(dd.sibling_dd_h)) then dd.sibling_dd_h = handle_create()

 ;-----------------------
 ; filename
 ;-----------------------
 if(keyword_set(filename)) then dd.filename = filename

 ;-----------------------
 ; identification string
 ;-----------------------
 if(keyword_set(id_string)) then dd.id_string = id_string

 ;-----------------------
 ; serial number
 ;-----------------------
 if(NOT keyword_set(dd.sn)) then dd.sn = nv_get_sn()
 if(NOT keyword_set(dd.idp)) then dd.idp = nv_ptr_new(0)

 ;-----------------------
 ; maintain
 ;-----------------------
 if(keyword_set(maintain)) then dd.maintain = maintain

 ;-----------------------
 ; compress
 ;-----------------------
 if(keyword_set(compress)) then dd.compress = compress

 ;-----------------------
 ; dimensions
 ;-----------------------
 if(keyword_set(dim)) then dd.dim_p = nv_ptr_new(dim)

 ;-----------------------
 ; type
 ;-----------------------
 if(keyword_set(type)) then dd.type = type


 ;-----------------------
 ; user data
 ;-----------------------
 if(keyword_set(udata)) then dd.udata_tlp = udata

 ;-----------------------
 ; fn data
 ;-----------------------
 if(NOT keyword_set(dd.sampling_fn_data_p)) then $
                                    dd.sampling_fn_data_p = nv_ptr_new(0)
 if(NOT keyword_set(dd.dim_fn_data_p)) then $
                                    dd.dim_fn_data_p = nv_ptr_new(0)


 ;-----------------------
 ; file properties
 ;-----------------------
 if(keyword_set(filetype)) then dd.filetype=filetype $
 else dd.filetype = nv_detect_filetype(/default)
 if(keyword_set(input_fn)) then dd.input_fn=input_fn
 if(keyword_set(output_fn)) then dd.output_fn=output_fn
 if(keyword_set(keyword_fn)) then dd.keyword_fn=keyword_fn


 ;-----------------------
 ; instrument
 ;-----------------------
 if(keyword_set(instrument)) then dd.instrument=instrument $
 else if(keyword_set(filetype) AND keyword_set(header)) then $
  begin
   dd.instrument = nv_detect_instrument(header, udata, filetype, silent=silent)
   if(dd.instrument EQ '') then $
              nv_message, /continue, $
                     'Unable to detect instrument.', name='nv_init_descriptor'
  end


 ;-----------------------
 ; transforms
 ;-----------------------
 if(keyword_set(input_transforms)) then $
                        dd.input_transforms_p = nv_ptr_new(input_transforms)
 if(keyword_set(output_transforms)) then $
                        dd.output_transforms_p = nv_ptr_new(output_transforms)


 ;-----------------------
 ; translators
 ;-----------------------
 if(keyword_set(dd.instrument)) then $
  begin
   nv_lookup_translators, dd.instrument, tab_translators=tab_translators, $
           input_translators, output_translators, input_keyvals, output_keyvals, $
           silent=silent

   if(input_translators[0] EQ '') then $
        nv_message, /continue, 'No input translators available.', $
                                                    name='nv_init_descriptor' $
   else dd.input_translators_p=nv_ptr_new(input_translators)

   if(output_translators[0] EQ '') then $
       nv_message, /continue, 'No output translators available.', $
                                                    name='nv_init_descriptor' $
   else dd.output_translators_p=nv_ptr_new(output_translators)

   if(keyword_set(input_keyvals)) then $
                   dd.input_keyvals_p = nv_ptr_new(nv_parse_keyvals(input_keyvals))
   if(keyword_set(output_keyvals)) then $
                   dd.output_keyvals_p = nv_ptr_new(nv_parse_keyvals(output_keyvals))
  end


 ;-----------------------
 ; data limits
 ;-----------------------
 dd.max = -1d100
 dd.min = 1d100
 if(defined(data)) then $
  begin
   dd.max = max(data)
   dd.min = min(data)
  end



 ddp = ptrarr(1)
 nv_rereference, ddp, dd


 ;-----------------------
 ; data and header
 ;-----------------------
 if(defined(data)) then $
  begin
   nv_set_data, ddp, data, /silent
   nv_set_nhist, ddp, nhist
  end  
 
 _header = ''
 if(keyword_set(header)) then _header = header
 nv_set_header, ddp, _header



 return, ddp
end
;===========================================================================



