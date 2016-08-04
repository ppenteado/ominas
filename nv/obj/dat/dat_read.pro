;=============================================================================
;+
; NAME:
;	dat_read
;
;
; PURPOSE:
;	Reads a data file of arbitrary format and produces a data descriptor.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	dd = dat_read(filespec [, data, header])
;
;
; ARGUMENTS:
;  INPUT:
;	filespec:	Array of strings giving file specifications for
;			file to read.
;
;  OUTPUT:
;	data:		Data array from the last file read.  This is provided
;			as a convenience when reading single files so that
;			it is not necessary to call dat_data to get the array.
;
;	header:		Header array from the last file read.  This is provided
;			as a convenience when reading single files so that
;			it is not necessary to call dat_header to get the array.
;
;
; KEYWORDS:
;  INPUT:
;	filetype:	Overrides automatic filetype detection.
;
;	input_fn:	Overrides input function lookup.
;
;	output_fn:	Overrides output function lookup.
;
;	tab_translators:	Name of translators table to use instead of 
;				that given by the environment variable
;				NV_TRANSLATORS.  If no path is given, then the
;				file is assumed to reside in the same directory
;				as the translator named by the NV_TRANSLATORS
;				environment variable.
;
;	input_translator:	Use this input translator name instead of
;				looking it up in the table.
;
;	output_translator:	Use this output translator name instead of
;				looking it up in the table.
;
;	instrument:	Use this instrument name instead of attempting to 
;			detect it.
;
;	silent:		If set, dat_read suppresses superfluous printed output
;			and passes the flag to the input function.
;
;	sample:		Vector giving the sampling indices in the input data 
;			file.  This parameter is passed through to the input 
;			function, which may choose to ignore it.
;
;	extensions:	If given, these extensions are attempted for each file.
;			If a file with the extension is not found, then the next
;			extension is tried until no extensions are left to try.
;			If no extensions work, then the raw filename is attemtped.
;
;
;  OUTPUT: NONE
;
;
;  ENVIRONMENT VARIABLES:
;	NV_TRANSLATORS:		Name(s) of the translators table(s) to use unless 
;				overridden by the tab_translators keyword.
;				Multiple table names are delimited with ':'.
;
;	NV_FTP_DETECT:		Name(s) of the filetype detectors table(s).		
;				Multiple table names are delimited with ':'.
;
;	NV_IO:			Name(s) of the I/O table(s).		
;				Multiple table names are delimited with ':'.
;
;	NV_INS_DETECT:		Name(s) of the instrument detectors table(s).			
;				Multiple table names are delimited with ':'.
;
;
; RETURN:
;	Array of data descriptors - one for each file resulting from the
;	expansion of the given file specifications.
;
;
; PROCEDURE:
;	dat_read expands all file specifications and then attempts to detect
;	the filetype for each resulting filename using the filetype detectors
;	table.  If a filetype is detected, dat_read looks up the I/O functions
;	and calls the input function to read the file.  Finally, it calls
;	nv_init_descriptor to obtain a data descriptor.  
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	dat_write
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 2/1998
;	
;-
;=============================================================================
function dat_read, filespec, data, header, $
		  filetype=_filetype, $
		  input_fn=_input_fn, $
		  output_fn=_output_fn, $
		  keyword_fn=_keyword_fn, $
		  instrument=_instrument, $
		  input_translators=input_translators, $
		  output_translators=output_translators, $
		  input_transforms=input_transforms, $
		  output_transforms=output_transforms, $
                  tab_translators=tab_translators, $
;                  tab_transforms=tab_transforms, $
                  maintain=maintain, compress=compress, $
                  silent=silent, sample=sample, nodata=nodata, $
		  name=_name, nhist=nhist, $
		  extensions=extensions
@core.include

; on_error, 1

 if(NOT keyword_set(maintain)) then maintain = 0
 nodata = keyword_set(nodata)
 silent = keyword_set(silent)
 force = keyword_set(force)

 ;------------------------------
 ; expand filespec
 ;------------------------------
 filenames = file_search(filespec)

 ;========================================
 ; create data descriptors for each file
 ;========================================
 dds = 0
 for i=0, n_elements(filenames)-1 do $
  begin
   instrument = ''
   _filename = filenames[i]

   ;---------------------------------------------
   ; try extensions
   ;---------------------------------------------
   filename = ''
   if(keyword_set(extensions)) then $
    begin
     ii = 0
     while((ii LT n_elements(extensions)) AND (NOT keyword_set(filename))) do $
      begin
       dot = '.'
       if(strmid(extensions[ii], 0, 1) EQ '.') then dot = ''
       filename = file_search(_filename + dot + extensions[ii])
       ii = ii + 1
      end
    end
   if(NOT keyword_set(filename)) then filename = _filename


   ;------------------------------
   ; get names of io routines
   ;------------------------------
   if(NOT keyword_set(_filetype)) then $
                 filetype = dat_detect_filetype(filename, silent=silent, action=action) $
   else filetype = _filetype

   read = 0
   if(NOT keyword_set(action)) then read = 1 $
   else if(action NE 'IGNORE') then read = 1

   if(read) then $
    begin
     if(filetype EQ '') then $
            nv_message, 'Unable to detect filetype.', name='dat_read', /con $
     else $
      begin
      ;------------------------
      ; look up I/O functions
      ;------------------------
      if(NOT keyword_set(_input_fn) OR NOT keyword__set(_output_fn)) then $
                   dat_lookup_io, filetype, input_fn, output_fn, keyword_fn, silent=silent

       if(keyword_set(_input_fn)) then input_fn = _input_fn
       if(keyword_set(_output_fn)) then output_fn = _output_fn
       if(keyword_set(_keyword_fn)) then keyword_fn = _keyword_fnfn

       if(output_fn EQ '') then $
         if(NOT silent) then $
           nv_message, /continue, 'No output function available.', name='dat_read'
       if(input_fn EQ '') then $
                     nv_message, 'No input function available.', name='dat_read'

       ;-----------------------------------------
       ; read the header, and data parameters
       ;-----------------------------------------
       _udata = 0
       if(NOT silent) then print, 'Reading ' + filename
       _data = call_function(input_fn, filename, $
                       _header, _udata, _dim, _type, _min, _max, $
                                            /nodata, /silent, sample=sample)
;       if(NOT defined(_type)) then $
;        begin
;         nv_message, /con, name='dat_read', $
;                   'WARNING: Type code not determined, converting to byte.'
;         _type = 1
;        end

       ;---------------------------------
       ; check for multiple data arrays
       ;---------------------------------
       multi = 0
       nn = 1
       if(size(_dim, /type) EQ 10) then $
        begin
         multi = 1
         nn = n_elements(_dim)
        end

       ;---------------------------------
       ; loop over all data arrays 
       ;---------------------------------
       for j=0, nn-1 do $
        begin
         if(multi) then $
          begin
           if(keyword_set(_header)) then header = *_header[j]
           if(keyword_set(_udata)) then udata = *_udata[j]
           dim = *_dim[j]
           type = _type[j]
           min = _min[j]
           max = _max[j]
          end $
         else $
          begin
           if(keyword_set(_header)) then header = _header
           if(keyword_set(_udata)) then udata = _udata
           dim = _dim
           type = _type
           min = _min
           max = _max
          end 


         ;-----------------------
         ; instrument
         ;-----------------------
         if(NOT keyword_set(_instrument)) then  $
          begin
           if(keyword_set(filetype) AND keyword_set(header)) then $
            begin
             instrument = dat_detect_instrument(header, udata, filetype, silent=silent)
             if(instrument EQ '') then $
               nv_message, /continue,'Unable to detect instrument.', name='dat_read'
            end 
          end $
         else instrument = _instrument


         ;---------------------------------
         ; transforms
         ;--------------------------------- 
         if(keyword_set(instrument)) then $
          begin
           dat_lookup_transforms, instrument, tab_transforms=tab_transforms, $
             _input_transforms, _output_transforms, silent=silent

           if(NOT defined(input_transforms)) then $
                                         input_transforms = _input_transforms
           if(NOT defined(output_transforms)) then $
                                         output_transforms = _output_transforms
          end


         ;---------------------------------
         ; use base filename as id string
         ;---------------------------------
         if(keyword_set(_name)) then name = _name[i] $
         else split_filename, _filename, dir, name
    
         ;------------------------
         ; create data descriptor
         ;------------------------
         dd = dat_create_descriptors(1, $
		filename=filename, $
		min=min, $
		max=max, $
		dim=dim, $
		type=type, $
		name=name, $
		nhist=nhist, $
		udata=udata, $
		header=header, $
		filetype=filetype, $
		input_fn=input_fn, $
		output_fn=output_fn, $
		keyword_fn=keyword_fn, $
		instrument=instrument, $
		input_transforms=input_transforms, $
		output_transforms=output_transforms, $
		input_translators=input_translators, $
		output_translators=output_translators, $
		maintain=maintain, $
		compress=compress, $
                tab_translators=tab_translators, silent=silent $
	      )


         ;------------------------
         ; get data if requested
         ;------------------------
         if(arg_present(data)) then dat_load_data, dd, data=data


         ;------------------------
         ; add descriptor to list
         ;------------------------
         dds = append_array(dds, dd)
        end
      end
    end
  end


 return, dds
end
;===========================================================================




