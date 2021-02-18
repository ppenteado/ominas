;=============================================================================
;+
; NAME:
;	dat_lookup_translators
;
;
; PURPOSE:
;	Looks up the names of the data input and output tranlators in
;	the translators table.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	dat_lookup_translators, instrument, input_translators, output_translators
;
;
; ARGUMENTS:
;  INPUT:
;	instrument:	Instrument string from dat_detect_instrument.
;
;  OUTPUT:
;	input_translators:	Array giving the names of the input translator 
;				functions.
;
;	output_translators:	Array giving the names of the output translator 
;				functions.
;
;	keyvals:	Array giving the keyword/value pairs the from the 
;			translators table, for each input translator.
;
;
; KEYWORDS:
;  INPUT: NONE
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



;=============================================================================
; dlt_unique
;
;=============================================================================
pro dlt_unique, input_translators, output_translators, keyvals

 n = n_elements(input_translators)
 mark = bytarr(n)

 for i=0, n-2 do $
  begin
   w = where(input_translators[i+1:*] EQ input_translators[i])
   if(w[0] NE -1) then mark[i] = 1
  end

 w = where(mark EQ 0)

 input_translators = input_translators[w]
 output_translators = output_translators[w]
 keyvals = keyvals[w,*]


end
;=============================================================================



;=============================================================================
; dat_lookup_translators
;
;=============================================================================
pro dat_lookup_translators, instrument, $
       input_translators, output_translators, keyvals, $
       tab_translators=tab_translators
@nv_block.common
@core.include

 input_translators = ''
 output_translators = ''
 keyvals = ''

 ;=====================================================
 ; read the translators table if it doesn't exist
 ;=====================================================
 stat = 0
 if(NOT keyword_set(*nv_state.trs_table_p)) then $
   dat_read_config, 'OMINAS_TRANSLATOR_TABLE', stat=stat, $
                      nv_state.trs_table_p, nv_state.translators_filenames_p
 if(stat NE 0) then $
   nv_message, /con, $
     'No translators table.', $
       exp=['The translators table specifies the names of translators for', $
            'instrument-specific information.  Without this table, OMINAS', $
            'cannot obtain geometry descriptors.']

 table = *nv_state.trs_table_p
 if(NOT keyword_set(table)) then return


 ;==============================================================
 ; lookup the translators
 ;==============================================================

 ;---------------------------------------------------------------------
 ; Add COMMON translators first
 ;---------------------------------------------------------------------
 repeat begin
  status = dat_trs_table_extract(table, 'COMMON', $
		input_translators, output_translators, keyvals)
 endrep until status EQ -1

 ;---------------------------------------------------------------------
 ; Match instrument-specific translators
 ;---------------------------------------------------------------------
 status = dat_trs_table_extract(table, instrument, $
                input_translators, output_translators, keyvals)

 ;---------------------------------------------------------------------
 ; If no instrument-specific translators, check for DEFAULT translators
 ;---------------------------------------------------------------------
 if(status NE 0) then $
   status = dat_trs_table_extract(table, 'DEFAULT', $
                input_translators, output_translators, keyvals) $

 ;---------------------------------------------------------------------
 ; Otherwise, look for more translators for this instrument
 ;---------------------------------------------------------------------
 else $
 repeat begin
  status = dat_trs_table_extract(table, instrument, $
                     input_translators, output_translators, keyvals)
 endrep until status EQ -1

 nv_message, verb=0.8, 'Built translators table for ' + instrument
 nv_message, verb=0.8, 'Input translators: ' + str_comma_list(input_translators)
 nv_message, verb=0.8, 'Output translators: ' + str_comma_list(output_translators)


 ;---------------------------------------------------------------------
 ; Keep only the latest instance of any redundant input translator
 ;---------------------------------------------------------------------
 dlt_unique, input_translators, output_translators, keyvals

end
;===========================================================================



