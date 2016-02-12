;=============================================================================
;+
; NAME:
;	nv_detect_instrument
;
;
; PURPOSE:
;	Attempts to detect the instrument for a data set by calling the 
;	detectors in the instrument detectors table.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	filinstrumentype = nv_detect_instrument(header, udata, filetype)
;
;
; ARGUMENTS:
;  INPUT:
;	header:		Header from the data file.
;
;	udata:		User data for the detectors.
;
;	filetype:	Filetype from nv_detect_filetype.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	silent:	If set, messages will be suppressed.
;
;  OUTPUT: NONE
;
;
; RETURN: 
;	String giving the instrument, or 'DEFAULT' if none detected.
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
function nv_detect_instrument, label, udata, filetype, silent=silent
@nv_block.common
@nv.include


 ;=====================================================
 ; read the instrument table if it doesn't exist
 ;=====================================================
 if(NOT keyword_set(*nv_state.ins_table_p)) then $
   nv_read_config, 'NV_INS_DETECT', $
              nv_state.ins_table_p, nv_state.ins_detectors_filenames_p
 table = *nv_state.ins_table_p


 ;==============================================================
 ; call instrument detectors of the specified filetype until 
 ; non-null string is returned
 ;==============================================================
 s = size(table)
 n_ins = s[1]
 for i=0, n_ins-1 do $
  begin
   detect_fn = table[i,0]
   ftp = table[i,1]
   if(filetype EQ ftp) then $
    begin
     string = call_function(detect_fn, label, udata)
     if(string NE '') then return, string
    end
  end


 ;==============================================================
 ; Instrument is DEFAULT if none detected
 ;==============================================================
 return, 'DEFAULT'
end
;===========================================================================
