;=============================================================================
;+
; NAME:
;	dat_parse_keyvals
;
;
; PURPOSE:
;	Parses an array strings containing keyword=value pairs.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	kv = dat_parse_keyvals(keyvals)
;
;
; ARGUMENTS:
;  INPUT:
;	keyvals:	Array of strings of the form <keyword>=<value>.
;
;  OUTPUT:
;
;
; KEYWORDS:
;  INPUT: NONE
;
;  OUTPUT: 
;	keywords:	Array of keywords.
;
;
; RETURN: 
;	Array of type keyval_struct containing the parsed keywords
;	and values.  One element per input array element.
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
function dat_parse_keyvals, keyvals, keywords=keywords
@core.include

 if(NOT keyword_set(keyvals)) then return, ''

 s = size(keyvals)
 ntran = s[1]
 max_nkey = s[2]

 kv = {keyval_struct}
 kv.keywords_p = nv_ptr_new(ptrarr(ntran))
 kv.values_p = nv_ptr_new(ptrarr(ntran))

 for i=0, ntran-1 do $
  begin
   w = where(keyvals[i,*] NE '')
 
   if(w[0] NE -1) then $
    begin
     nkey = n_elements(w)
     (*kv.keywords_p)[i] = nv_ptr_new(strarr(nkey))
     (*kv.values_p)[i] = nv_ptr_new(strarr(nkey))
     for j=0, nkey-1 do $
      begin
       dat_parse_keyval, keyvals[i,j], keyword, value
       keywords = append_array(keywords, keyword)

       (*(*kv.keywords_p)[i])[j] = keyword
       (*(*kv.values_p)[i])[j] = value
      end
    end
  end


; return, nv_ptr_new(kv)
 return, kv
end
;=============================================================================
