;=============================================================================
;+
; NAME:
;       str_ext
;
; PURPOSE:
;       Extracts the substring which is delimited by the given tokens.
;
;
; CATEGORY:
;       UTIL
;
;
; CALLING SEQUENCE:
;       return = str_ext(string, token1, token2, rstring, position=position)
;
;
; ARGUMENTS:
;  INPUT:
;        string:        An input string
;
;        token1:        First token
;
;        token2:        Second token
;
;  OUTPUT:
;       rstring:        Original string minus the part which was extracted
;
;
; KEYWORDS:
;  INPUT:
;       NONE
;
;  OUTPUT:
;      position:        Position at which the string was found
;
;
; RETURN:
;       The extracted string is returned.
;
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
function str_ext, string, token1, token2, rstring, position=position

 rstring=string
 position = -1

 p1=strpos(string, token1)
 p2=strpos(string, token2, p1+1)
 if(p1 EQ -1 OR p2 EQ -1) then return, ''

 position=p1+1
 xstring = strmid(string, p1+1, p2-p1-1)
 rstring = strmid(string, 0, p1) + strmid(string, p2+1, strlen(string)-p1-1)

 return, xstring
end
;=============================================================================
