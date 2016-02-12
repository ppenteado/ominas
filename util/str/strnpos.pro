;=============================================================================
;+
; NAME:
;       strnpos
;
; PURPOSE:
;       Finds every occurrence of the given character token within the given 
;	string.
;
;
; CATEGORY:
;       UTIL
;
;
; CALLING SEQUENCE:
;       return = strnpos(string, token)
;
;
; ARGUMENTS:
;  INPUT:
;        string:        An input string
;
;         token:        Character to match
;
;  OUTPUT:
;       NONE
;
;
; KEYWORDS:
;       NONE
;
;
; RETURN:
;       Array giving the position of every occurrence of the token within
;	the string.  -1 if not found.
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale; 2/2002
;
;-
;=============================================================================
function strnpos, string, tokens

 bs = byte(string)
 bt = transpose(byte(tokens))

 return, n_where(bt, bs)
end
;=============================================================================
