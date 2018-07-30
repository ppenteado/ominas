;=============================================================================
; dat_table_extract
;
;=============================================================================
function ___dat_table_extract, table, match, $
      input_items, output_items, $
      input_keyvals, output_keyvals

 if(NOT keyword_set(table)) then return, -1

 marker='-'

 matches = table[*,0]
 w0 = (where(matches EQ match))[0]


 ;================================================================
 ; extract all given items and keyvals for this match
 ;================================================================
 if(w0[0] EQ -1) then return, -1

 w1 = w0
 wn = where(matches[w0:*] NE marker)
 wc = where(matches[w0:*] EQ marker)
 if(wc[0] NE -1) then $
  begin
;   if(wn[0] EQ -1) then w1 = w0 + n_elements(wc) $
;   else w1 = w0 + wn[1]-1
   if(n_elements(wn) GT 1) then w1 = w0 + wn[1]-1 $
   else w1 = w0 + n_elements(wc)
  end
;stop

 ww = lindgen(w1-w0+1)+w0

 _input_items = table[ww,1]
 _output_items = table[ww,2]

 s = size(table)
 nfields = s[2]
 ninst = s[1]
 if(nfields GT 3) then keyvals = table[ww,3:nfields-1]

 ;================================================================
 ; remove matched match from table
 ;================================================================
 ii = indgen(ninst)
 ii = rm_list_item(ii, ww, only=-1) 
 if(ii[0] EQ -1) then table = '' $
 else table = table[ii,*]


 ;================================
 ; filter out any place markers
 ;================================
 w = where(_input_items NE marker)
 if(w[0] EQ -1) then _input_items = '' $
 else $
  begin
   _input_items = _input_items[w]
   if(keyword_set(keyvals)) then _input_keyvals = strtrim(keyvals[w,*],2)
  end

 w = where(_output_items NE marker)
 if(w[0] EQ -1) then _output_items = '' $
 else $
  begin
   _output_items = _output_items[w]
   if(keyword_set(keyvals)) then _output_keyvals = strtrim(keyvals[w,*],2)
  end



 ;============================================
 ; add new items and keyvals
 ;============================================
 input_items = append_array(input_items, _input_items)
 input_keyvals = append_array(input_keyvals, _input_keyvals)
 output_items = append_array(output_items, _output_items)
 output_keyvals = append_array(output_keyvals, _output_keyvals)


 return, 0
end
;=============================================================================



;=============================================================================
; dat_table_extract
;
;=============================================================================
function dat_table_extract, table, match, ncol, keyvals=keyvals

 if(NOT keyword_set(table)) then return, ''

 marker='-'

 matches = table[*,0]
 w0 = (where(matches EQ match))[0]


 ;================================================================
 ; extract all given items and keyvals for this match
 ;================================================================
 if(w0[0] EQ -1) then return, ''

 w1 = w0
 wn = where(matches[w0:*] NE marker)
 wc = where(matches[w0:*] EQ marker)
 if(wc[0] NE -1) then $
  begin
   if(n_elements(wn) GT 1) then w1 = w0 + wn[1]-1 $
   else w1 = w0 + n_elements(wc)
  end

 ww = lindgen(w1-w0+1)+w0

 items = table[ww,1:ncol]

 s = size(table)
 nfields = s[2]
 ninst = s[1]
 if(nfields GT ncol+1) then keyvals = table[ww,ncol+1:nfields-1]


 ;================================================================
 ; remove matched match from table
 ;================================================================
 ii = indgen(ninst)
 ii = rm_list_item(ii, ww, only=-1) 
 if(ii[0] EQ -1) then table = '' $
 else table = table[ii,*]


 ;================================
 ; filter out any place markers
 ;================================
 items = strtrim(strep_char(items, '-', ' '), 2)


 ;================================
 ; reduce keyvals
 ;================================
; keyvals = str_cull(keyvals)


 return, items
end
;=============================================================================


