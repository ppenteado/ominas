;=============================================================================
;+
; NAME:
;	dat_detect_instrument
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
;	filinstrumentype = dat_detect_instrument(header, udata, filetype)
;
;
; ARGUMENTS:
;  INPUT:
;	header:		Header from the data file.
;
;	udata:		User data for the detectors.
;
;	filetype:	Filetype from dat_detect_filetype.
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
function dat_detect_instrument, label, udata, filetype, silent=silent
@nv_block.common
@core.include


 ;=====================================================
 ; read the instrument table if it doesn't exist
 ;=====================================================
 stat = 0
 if(NOT keyword_set(*nv_state.ins_table_p)) then $
   dat_read_config, 'NV_INS_DETECT', stat=stat, $
              nv_state.ins_table_p, nv_state.ins_detectors_filenames_p
 if(stat NE 0) then $
   nv_message, name='dat_detect_instrument', $
     'No instrument table.', /con, $
       exp=['The instrument table specifies the names of instrument detector functions.', $
            'Without this table, OMINAS cannot determine which translators to use.']

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
