;=============================================================================
;+
; NAME:
;	dat_detect_instrument
;
;
; PURPOSE:
;	Attempts to detect the instrument for a data set by calling the 
;	detectors in the instrument detectors table.  Detectors that 
; 	crash are ignored and a warning is issued.  This behavior is disabled 
;	if $OMINAS_DEBUG is set.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	instrument = dat_detect_instrument(dd)
;
;
; ARGUMENTS:
;  INPUT:
;	dd:		Data descriptor.  
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: NONE
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
function dat_detect_instrument, dd
 dat_sort_detectors, instrument_detectors=instrument_detectors
 return, dat_detect(dd, instrument_detectors, null='DEFAULT')
end
;=============================================================================



;=============================================================================
function _dat_detect_instrument, dd
@nv_block.common
@core.include

 ;=====================================================
 ; read the instrument table if it doesn't exist
 ;=====================================================
 stat = 0
 if(NOT keyword_set(*nv_state.ins_table_p)) then $
   dat_read_config, 'OMINAS_INSTRUMENT_TABLE', stat=stat, $
             nv_state.ins_table_p, nv_state.ins_detectors_filenames_p
 if(stat NE 0) then $
   nv_message, $
     'No instrument table.', /con, $
       exp=['The instrument table specifies the names of instrument detector functions.', $
            'Without this table, OMINAS cannot determine which translators to use.']

 table = *nv_state.ins_table_p


 ;==============================================================
 ; Call instrument detectors until non-null string is returned.
 ;
 ; Crashes in the detectors are handled by issuing a warning and 
 ; contnuing to the next detector.
 ;==============================================================
 catch_errors = NOT keyword_set(nv_getenv('OMINAS_DEBUG'))
 s = size(table)
 n_ins = s[1]
 for i=0, n_ins-1 do $
  begin
   detect_fn = table[i,0]
   nv_message, verb=0.8, 'Calling detector ' + detect_fn

   if(NOT catch_errors) then err = 0 $
   else catch, err

   if(err EQ 0) then string = call_function(detect_fn, dd) $
   else nv_message, /warning, $
           'Instrument detector ' + strupcase(detect_fn) + ' crashed; ignoring.'
   catch, /cancel

   if(keyword_set(string)) then nv_message, verb=0.8, string + ' detected.'
   if(keyword_set(string)) then return, string
  end


 ;==============================================================
 ; Instrument is DEFAULT if none detected
 ;==============================================================
 nv_message, verb=0.8, 'No instrument detected; setting to DEFAULT.'
 return, 'DEFAULT'
end
;===========================================================================
