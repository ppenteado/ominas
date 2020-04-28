;=============================================================================
;+
; NAME:
;       str_split
;
; PURPOSE:
;       Splits the string into two substrings delimited by the given token.
;
;
; CATEGORY:
;       UTIL
;
;
; CALLING SEQUENCE:
;       return = str_split(string, token)
;
;
; ARGUMENTS:
;  INPUT:
;        string:        An input string
;
;         token:        String delimiter
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
;       Two substrings are returned split at the given token but not
;       including the token.  If the token is not found in the string,
;       the original string is returned.
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale
;
;-
;=============================================================================
function str_split, string, token

 n = strlen(token)
 p = strpos(string, token)
 if(p EQ -1) then return, string

 s = strarr(2)

 s[0] = strmid(string, 0, p)
 s[1] = strmid(string, p+n, strlen(string)-p-1)


 return, s
end
;=============================================================================
