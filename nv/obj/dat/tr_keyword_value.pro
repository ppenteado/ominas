;=============================================================================
;+
; NAME:
;	tr_keyword_value
;
;
; PURPOSE:
;	Looks up a keyword in the data descriptor stored keyword/value pairs.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	value = tr_keyword_value(dd, keyword)
;
;
; ARGUMENTS:
;  INPUT:
;	dd:		Data descriptor.
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
; trkv_match
;
;=============================================================================
pro trkv_match, kv, i, keyword, value=value

 if(NOT ptr_valid((*kv.keywords_p)[i])) then return
 if(NOT ptr_valid((*kv.values_p)[i])) then return

 keywords = (*(*kv.keywords_p)[i])
 values = (*(*kv.values_p)[i])

 w = where(keywords EQ keyword)

 if(w[0] EQ -1) then return

 value = values(w[0])
end
;=============================================================================



;=============================================================================
; trkv_parse
;
;=============================================================================
function trkv_parse, value

 ;---------------------------
 ; arrays delimited by ';'
 ;---------------------------
 value = str_nsplit(value, ';')
 if(n_elements(value) EQ 1) then value = value[0]

 return, value
end
;=============================================================================



;=============================================================================
; tr_keyword_value
;
;=============================================================================
function tr_keyword_value, dd, keyword
@core.include

 _dd = cor_dereference(dd)

 ;----------------------------------------------------------------------
 ; first look for transient keyval match
 ;----------------------------------------------------------------------
 if(ptr_valid(_dd.transient_keyvals_p)) then $
                trkv_match, *_dd.transient_keyvals_p, 0, keyword, value=value
 if(n_elements(value) NE 0) then return, trkv_parse(value)


 ;----------------------------------------------------------------------
 ; if no transient keyval match, then match regular keyvals
 ;----------------------------------------------------------------------
 if(NOT ptr_valid(_dd.input_keyvals_p)) then return, ''

 ;----------------------------------------
 ; determine input or output translator
 ;----------------------------------------
 i = _dd.last_translator[0]
 io = _dd.last_translator[1]

 if(io EQ 0) then kv = *_dd.input_keyvals_p $
 else kv = *_dd.output_keyvals_p

 ;-----------------
 ; match keyval 
 ;-----------------
 trkv_match, kv, i, keyword, value=value
 if(NOT keyword_set(value)) then value = ''


 return, trkv_parse(value)
end
;=============================================================================
