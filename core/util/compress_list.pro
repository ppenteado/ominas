;=============================================================================
;+
; NAME:
;       compress_list
;
;
; PURPOSE:
;       To compress a list to n elements, removing elements with a value
;       of -1.
;
;
; CATEGORY:
;       UTIL
;
;
; CALLING SEQUENCE:
;       result = compress_list(list, n)
;
;
; ARGUMENTS:
;  INPUT:
;       list:   List to compress.
;
;          n:   Size of the compressed list.
;
;  OUTPUT:
;       NONE
;
; RETURN:
;       The resulting list contains n elements, the first of which are those
;       elements of list which are not -1.
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
function compress_list, list, n

 w = where(list NE -1)
 if(NOT keyword__set(n)) then n = n_elements(w)

 compressed_list = make_array(n, /int, val=-1)

 if(w[0] NE -1) then compressed_list[0:n_elements(w)-1]=list[w]

 return, compressed_list
end
;===========================================================================
