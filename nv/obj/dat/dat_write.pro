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
;
;
; ARGUMENTS:
;  INPUT:
;	filespec:	Array of strings giving file specifications for
;			file to write.
;
;	dd:		Array of data descriptors.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:
;	filetype:	Overrides data descriptor filetype (and thus the 
;			output function).
;
;	output_fn:	Overrides data descriptor output function.
;
;	verbose:	If set, message are enabled.
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
pro dat_write, filespec, dd, nodata=nodata, $
		  filetype=_filetype, $
		  output_fn=_output_fn, $
                  verbose=verbose
@core.include

; on_error, 1
 _dd = cor_dereference(dd)

 ;------------------------------
 ; expand filespec
 ;------------------------------
; filenames = findfile1(filespec)
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

   ;------------------------------
   ; get filetype
   ;------------------------------
   if(keyword_set(_filetype)) then filetype = _filetype $
   else filetype = _dd[i].filetype
   if(filetype EQ '') then nv_message, $
                                    'Filetype unavailable.', name='dat_write'

   ;------------------------------
   ; get name of output routine
   ;------------------------------
   if(keyword_set(_output_fn)) then output_fn = _output_fn $
   else dat_lookup_io, filetype, input_fn, output_fn
   if(NOT keyword_set(output_fn)) then output_fn = _dd[i].output_fn

   if(output_fn EQ '') then $
        nv_message, 'No output function available.', name='dat_write'

   ;---------------------
   ; write the file
   ;---------------------
   header = ''
   if(ptr_valid(_dd[i].header_dap)) then $
                                 header = data_archive_get(_dd[i].header_dap)
   data = data_archive_get(_dd[i].data_dap)

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
     if(keyword_set(verbose)) then print, 'Writing ' + filename + '.'
     call_procedure, output_fn, filename, nodata=nodata, $
                                       data_out, header_out, udata_out
    end

  end

 if(multi) then nv_ptr_free, [data_out, header_out, udata_out]

end
;===========================================================================
