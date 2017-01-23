;=============================================================================
;+
; NAME:
;	dat_lookup_io
;
;
; PURPOSE:
;	Looks up the names of the data input and output functions in
;	the I/O table.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	dat_lookup_io, filetype, input_fn, output_fn
;
;
; ARGUMENTS:
;  INPUT:
;	filetype:	Filetype string from dat_detect_filetype.
;
;  OUTPUT:
;	input_fn:	Name of the input function.
;
;	output_fn:	Name of the output function.
;
;
; KEYWORDS:
;  INPUT: 
;	silent:	If set, messages are suppressed.
;
;  OUTPUT: NONE
;
;
; RETURN: NONE
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
;	
;-
;=============================================================================
pro dat_lookup_io, filetype, input_fn, output_fn, keyword_fn, silent=silent
@nv_block.common
@core.include


 ;=====================================================
 ; read the io table if it doesn't exist
 ;=====================================================
 stat = 0
 if(NOT keyword_set(*nv_state.io_table_p)) then $
   dat_read_config, 'NV_IO', stat=stat, $
              nv_state.io_table_p, nv_state.io_filenames_p
 if(stat NE 0) then $
   nv_message, /con, $
     'No I/O table.', $
       exp=['The I/O table specifies the names of data I/O programs.', $
            'Without this table, OMINAS cannot read or write data files.']

 table = *nv_state.io_table_p


 ;==============================================================
 ; lookup the filetype string
 ;==============================================================
 input_fn = ''
 output_fn = ''

 filetypes = table[*,0]
 w = (where(filetypes EQ filetype))[0]


 ;==============================================================
 ; extract all given translators for this instrument
 ;==============================================================
 if(w NE -1) then $
  begin
   input_fn = table[w,1]
   output_fn = table[w,2]
   keyword_fn = table[w,3]
  end


end
;===========================================================================
