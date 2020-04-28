;=============================================================================
;+
; NAME:
;       strnpos
;
; PURPOSE:
;       Finds first occurrence of a character other than the given character 
;	token within the given string.
;
;
; CATEGORY:
;       UTIL
;
;
; CALLING SEQUENCE:
;       return = strxpos(string, token)
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
;       Position of first occurence.  -1 if not found.
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale; 9/2008
;
;-
;=============================================================================
function strxpos, string, token

 bs = byte(string)
 bt = (byte(token))[0]

 return, (where(bs NE bt))[0]
end
;=============================================================================
