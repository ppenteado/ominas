;=============================================================================
;+
; NAME:
;       str_nsplit
;
; PURPOSE:
;       Splits the string into substrings delimited by the given token.
;
;
; CATEGORY:
;       UTIL
;
;
; CALLING SEQUENCE:
;       return = str_nsplit(string, token)
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
;       Array of substrings.  If the token is not found in the string,
;       the original string is returned.
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
function str_nsplit, string, token

;if(n_elements(string) EQ 2) then stop
;if(keyword_set(string)) then if(strpos(string, 'MIMAS') NE -1) then stop
 p = strnpos(string, token)
 if(p[0] EQ -1) then return, [strtrim(string,2)]

 n = n_elements(p) + 1
 result = strarr(n)

 pp = [-1, p, strlen(string)]

 i=0l
 while i LT n do $
  begin
   result[i] = strtrim(strmid(string, pp[i]+1, pp[i+1]-pp[i]-1), 2)
   i = i + 1l
  end

 return, result
end
;=============================================================================
