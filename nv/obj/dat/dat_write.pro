;=============================================================================
;+
; NAME:
;	dat_write
;
;
; PURPOSE:
;	Writes a data file of arbitrary format.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	dat_write, filespec, dd
;	dat_write, dd
;
;
; ARGUMENTS:
;  INPUT:
;	filespec:	Array of strings giving file specifications for
;			file to write.  Data descriptor filespec is
;			updated unless /override.
;
;	dd:		Array of data descriptors.  dd can also be given as the
;			first argument, in which case, the file specifications
;			are taken from the filename field of dd.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:
;	filetype:	Overrides data descriptor filetype (and thus the 
;			output function).  Data descriptor filetype is
;			updated unless /override.
;
;	output_fn:	Overrides data descriptor output function.  Data 
;			descriptor output_fn is updated unless /override.
;
;	silent:		If set, dat_write suppresses superfluous printed output
;			and passes the flag to the input function.
;
;	override:	If set, filespec, filetype, and output_fn inputs
;			are used for this call, but not updated in the data
;			descriptor.
;
;
;  OUTPUT: NONE
;
;
; RETURN: NONE
;
;
; PROCEDURE:
;	dat_write expands all file specifications and attempts to write a
;	file corresponding to each given data descriptor.  An error results
;	if the filespec expands to a different number of files than the number
;	of given data descriptors. 
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	dat_read
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 7/1998
; 	Adapted by:	Spitale, 5/2016
;	
;-
;=============================================================================
pro dat_write, arg1, arg2, nodata=nodata, $
		  filetype=_filetype, $
		  output_fn=_output_fn, $
                  silent=silent, override=override
@core.include
; on_error, 1

 if(size(arg1, /type) EQ 11) then $
  begin
   dd = arg1
   filespec = dat_filename(dd)
  end $
 else $
  begin
   dd = arg2
   filespec = arg1
  end

 silent = keyword_set(silent)


 _dd = cor_dereference(dd)

 ;------------------------------
 ; expand filespec
 ;------------------------------
 filenames = ''
 for i=0, n_elements(filespec)-1 do $
  begin
   ff = file_search(filespec[i])
   if(ff[0] NE '') then filenames = append_array(filenames, ff) $
   else filenames = append_array(filenames, filespec[i])
  end

 n_files = n_elements(filenames)
 ndd = n_elements(_dd)

 ;--------------------------------------------------------------------
 ; test for multiple dd per file.  If detected, then all data arrays
 ; are sent to the first filename; the output routine must support
 ; this mechanism
 ;--------------------------------------------------------------------
 multi = 1
 if(n_files EQ ndd) then multi = 0
 if(multi) then filenames = filenames[0]

 ;========================================
 ; write each file
 ;========================================
 for i=0, ndd-1 do $
  begin
   filename = filenames[0]
   if(NOT multi) then filename = filenames[i]
   if(filename EQ '') then nv_message, 'Filename unavailable.'

   ;------------------------------
   ; get filetype
   ;------------------------------
   if(keyword_set(_filetype)) then filetype = _filetype $
   else filetype = _dd[i].filetype
   if(filetype EQ '') then nv_message, 'Filetype unavailable.'

   ;------------------------------
   ; get name of output routine
   ;------------------------------
   if(keyword_set(_output_fn)) then output_fn = _output_fn $
   else dat_lookup_io, filetype, input_fn, output_fn
   if(NOT keyword_set(output_fn)) then output_fn = _dd[i].output_fn

   if(output_fn EQ '') then nv_message, 'No output function available.'

   ;---------------------
   ; write the file
   ;---------------------
   header = ''
   if(ptr_valid(_dd[i].header_dap)) then $
                                 header = data_archive_get(_dd[i].header_dap)
   data = dat_data(_dd[i])
;   data = data_archive_get(_dd[i].data_dap)

   ;- - - - - - - - - - - - - - - - - - - - - -
   ; first transform the data if necessary
   ;- - - - - - - - - - - - - - - - - - - - - -
   data = dat_transform_output(_dd[i], data, header, silent=silent)

   ;- - - - - - - - - - - - - - - - - - - - - -
   ; write data
   ;- - - - - - - - - - - - - - - - - - - - - -
   udata = cor_udata(dd[i])

   write = 1
   if(NOT multi) then $
    begin
     data_out = data 
     header_out = header 
     udata_out = udata
    end $
   else $
    begin
; the output functions are not set up to handle multiple elements, so 
; this crashes...
     data_out = append_array(data_out, nv_ptr_new(data))
     header_out = append_array(header_out, nv_ptr_new(header))
     udata_out = append_array(udata_out, nv_ptr_new(udata))
     if(i NE ndd-1) then write = 0
    end

   if(write) then $
    begin
     if((NOT silent) AND (NOT keyword_set(nodata))) then $
                                nv_message, verb=0.1, 'Writing ' + filename
     call_procedure, output_fn, filename, nodata=nodata, $
                                       data_out, header_out, udata_out
    end

   ;- - - - - - - - - - - - - - - - - - - - - -
   ; update fields if not overridden 
   ;- - - - - - - - - - - - - - - - - - - - - -
   if(NOT keyword_set(override)) then $
    begin
     if(keyword_set(filespec)) then _dd[i].filename = filename
     if(keyword_set(filetype)) then _dd[i].filetype = filetype
     if(keyword_set(output_fn)) then _dd[i].output_fn = output_fn
    end

  end

 if(multi) then nv_ptr_free, [data_out, header_out, udata_out]

 ;--------------------------------------------
 ; register events if not overridden
 ;--------------------------------------------
 if(NOT keyword_set(override)) then $
  begin
   cor_rereference, dd, _dd
   nv_notify, dd, type = 0, noevent=noevent
   nv_notify, /flush, noevent=noevent
  end

end
;===========================================================================
