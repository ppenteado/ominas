;=============================================================================
;+
; NAME:
;	dat_keyword_value
;
;
; PURPOSE:
;	Looks up a keyword in the data descriptor-stored keyword/value pairs.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	value = dat_keyword_value(dd, keyword)
;
;
; ARGUMENTS:
;  INPUT:
;	dd:		Data descriptor.  If an array, only the first element is 
;			considered.
;
;	keyword:	Keyword to look up.
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
;	Value string associated with the given keyword.  Note that transient
;	keyword/value pairs take precedence.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
; 	Adapted by:	Spitale, 5/2016
;	
;-
;=============================================================================



;=============================================================================
; dkv_match
;
;=============================================================================
pro dkv_match, kv, i, keyword, value=value

 if(NOT ptr_valid((*kv.keywords_p)[i])) then return
 if(NOT ptr_valid((*kv.values_p)[i])) then return

 keywords = (*(*kv.keywords_p)[i])
 values = (*(*kv.values_p)[i])
;print, keywords

 w = where(strupcase(keywords) EQ strupcase(keyword))

 if(w[0] EQ -1) then return

 value = values(w[0])
end
;=============================================================================



;=============================================================================
; dkv_parse
;
;=============================================================================
function dkv_parse, value

 ;---------------------------
 ; arrays delimited by ';'
 ;---------------------------
 value = str_nsplit(value, ';')
 if(n_elements(value) EQ 1) then value = value[0]

 return, value
end
;=============================================================================



;=============================================================================
; dat_keyword_value
;
;=============================================================================
function dat_keyword_value, keyword, $
         transient_keyvals, keyvals, input_fns, output_fns
@core.include

 ;----------------------------------------------------------------------
 ; first look for transient keyval match
 ;----------------------------------------------------------------------
 if(keyword_set(transient_keyvals)) then $
                dkv_match, transient_keyvals, 0, keyword, value=value
 if(n_elements(value) NE 0) then return, dkv_parse(value)

 ;----------------------------------------------------------------------
 ; if no transient keyval match, then match regular keyvals
 ;----------------------------------------------------------------------
 if(NOT keyword_set(keyvals)) then return, ''

 ;----------------------------------------
 ; determine input or output translator
 ;----------------------------------------
 i = dat_caller(input_fns)
 if(i[0] EQ -1) then i = dat_caller(output_fns)
 if(i EQ -1) then return, ''

 ;-----------------
 ; match keyval 
 ;-----------------
 dkv_match, keyvals, i, keyword, value=value
 if(NOT keyword_set(value)) then value = ''


 return, dkv_parse(value)
end
;=============================================================================
