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
;	input_keyvals:	Array giving the keyword/value pairs the from the 
;			translators table, for each input translator.
;
;	output_keyvals:	Array giving the keyword/value pairs the from the 
;			translators table, for each output translator.
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
; dltr_extract
;
;=============================================================================
function dltr_extract, table, instrument, $
      input_translators, output_translators, $
      input_keyvals, output_keyvals

 if(NOT keyword_set(table)) then return, -1

 marker='-'

 instruments = table[*,0]
 w0 = (where(instruments EQ instrument))[0]


 ;================================================================
 ; extract all given translators and keyvals for this instrument
 ;================================================================
 if(w0[0] EQ -1) then return, -1

 w1 = w0
 wn = where(instruments[w0:*] NE marker)
 wc = where(instruments[w0:*] EQ marker)
 if(wc[0] NE -1) then $
  begin
;   if(wn[0] EQ -1) then w1 = w0 + n_elements(wc) $
;   else w1 = w0 + wn[1]-1
   if(n_elements(wn) GT 1) then w1 = w0 + wn[1]-1 $
   else w1 = w0 + n_elements(wc)
  end
;stop

 ww = lindgen(w1-w0+1)+w0

 _input_translators = table[ww,1]
 _output_translators = table[ww,2]

 s = size(table)
 nfields = s[2]
 ninst = s[1]
 if(nfields GT 3) then keyvals = table[ww,3:nfields-1]

 ;================================================================
 ; remove matched instrument from table
 ;================================================================
 ii = indgen(ninst)
 ii = rm_list_item(ii, ww, only=-1) 
 if(ii[0] EQ -1) then table = '' $
 else table = table[ii,*]


 ;================================
 ; filter out any place markers
 ;================================
 w = where(_input_translators NE marker)
 if(w[0] EQ -1) then _input_translators = '' $
 else $
  begin
   _input_translators = _input_translators[w]
   if(keyword_set(keyvals)) then _input_keyvals = strtrim(keyvals[w,*],2)
  end

 w = where(_output_translators NE marker)
 if(w[0] EQ -1) then _output_translators = '' $
 else $
  begin
   _output_translators = _output_translators[w]
   if(keyword_set(keyvals)) then _output_keyvals = strtrim(keyvals[w,*],2)
  end



 ;============================================
 ; add *unique* new translators and keyvals
 ;============================================
; if(keyword_set(_input_translators)) then $
;  begin
;   ww = nwhere(_input_translators, input_translators)
;   w = complement(_input_translators, ww)
;   if(w[0] NE -1) then $
;    begin
;     input_translators = append_array(input_translators, _input_translators[w])
;     if(keyword_set(_input_keyvals)) then $
;               input_keyvals = append_array(input_keyvals, _input_keyvals[w,*])
;    end
;  end

; if(keyword_set(_output_translators)) then $
;  begin
;   ww = nwhere(_output_translators, output_translators)
;   w = complement(_output_translators, ww)
;   if(w[0] NE -1) then $
;    begin
;     output_translators = append_array(output_translators, _output_translators[w])
;     if(keyword_set(_output_keyvals)) then $
;               output_keyvals = append_array(output_keyvals, _output_keyvals[w,*])
;    end
;  end


 ;============================================
 ; add new translators and keyvals
 ;============================================
 input_translators = append_array(input_translators, _input_translators)
 input_keyvals = append_array(input_keyvals, _input_keyvals)
 output_translators = append_array(output_translators, _output_translators)
 output_keyvals = append_array(output_keyvals, _output_keyvals)


 return, 0
end
;=============================================================================



;=============================================================================
; dltr_unique
;
; 
;=============================================================================
pro dltr_unique, translators, keyvals

 n = n_elements(translators)
 mark = bytarr(n)

 for i=0, n-2 do $
  begin
   w = where(translators[i+1:*] EQ translators[i])
   if(w[0] NE -1) then mark[i] = 1
  end

 w = where(mark EQ 0)

 translators = translators[w]
 keyvals = keyvals[w,*]


end
;=============================================================================



;=============================================================================
; dat_lookup_translators
;
; 
;=============================================================================
pro dat_lookup_translators, instrument, $
       input_translators, output_translators, input_keyvals, output_keyvals, $
       tab_translators=tab_translators
@nv_block.common
@core.include

 input_translators = ''
 input_keyvals = ''
 output_translators = ''
 output_keyvals = ''

 ;=====================================================
 ; read the translators table if it doesn't exist
 ;=====================================================
 stat = 0
 if(NOT keyword_set(*nv_state.tr_table_p)) then $
   dat_read_config, 'NV_TRANSLATORS', stat=stat, $
              nv_state.tr_table_p, nv_state.translators_filenames_p
 if(stat NE 0) then $
   nv_message, /con, $
     'No translators table.', $
       exp=['The translators table specifies the names of translators for', $
            'instrument-specific information.  Without this table, OMINAS', $
            'cannot obtain geometry descriptors.']

 table = *nv_state.tr_table_p
 if(NOT keyword_set(table)) then return


 ;==============================================================
 ; lookup the translators
 ;==============================================================
 input_translators = ''
 output_translators = ''


 ;---------------------------------------------------------------------
 ; Add COMMON translators first
 ;---------------------------------------------------------------------
 repeat begin
  status = dltr_extract(table, 'COMMON', $
		input_translators, output_translators, $
		input_keyvals, output_keyvals)
 endrep until status EQ -1

 ;---------------------------------------------------------------------
 ; Match instrument-specific translators
 ;---------------------------------------------------------------------
 status = dltr_extract(table, instrument, $
                input_translators, output_translators, $
                input_keyvals, output_keyvals)

 ;---------------------------------------------------------------------
 ; If no instrument-specific translators, check for DEFAULT translators
 ;---------------------------------------------------------------------
 if(status NE 0) then $
   status = dltr_extract(table, 'DEFAULT', $
                input_translators, output_translators, $
                input_keyvals, output_keyvals) $

 ;---------------------------------------------------------------------
 ; Otherwise, look for more translators for this instrument
 ;---------------------------------------------------------------------
 else $
 repeat begin
  status = dltr_extract(table, instrument, $
                input_translators, output_translators, $
                input_keyvals, output_keyvals)
 endrep until status EQ -1

 nv_message, verb=0.9, 'Built translators table for ' + instrument
 nv_message, verb=0.9, 'Input translators: ' + str_comma_list(input_translators)
 nv_message, verb=0.9, 'Output translators: ' + str_comma_list(output_translators)


 ;---------------------------------------------------------------------
 ; Keep only the latest instance of any redundant translator
 ;---------------------------------------------------------------------
 dltr_unique, input_translators, input_keyvals
 dltr_unique, output_translators, output_keyvals

end
;===========================================================================



