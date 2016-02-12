;=============================================================================
;+
; NAME:
;       degen
;
; PURPOSE:
;       Removes degenerate trailing dimensions.
;
;
; CATEGORY:
;       UTIL
;
;
; CALLING SEQUENCE:
;       result = degen(array)
;
;
; ARGUMENTS:
;  INPUT:
;       array:  An array.
;
;  OUTPUT:
;       NONE
;
;
; RETURN:
;       Array, with any trailing dimensions of length 1 removed.
;
;
; SIDE EFFECTS:
;	The input array is modified.
;
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale; 6/2002
;
;-
;=============================================================================
function degen, array

 s = size(array)

 ndim = s[0]
 dim = s[1:ndim]

; result = array

 i = ndim
 repeat $
  begin
   i = i - 1
;   if(dim[i] EQ 1) then result = reform(result, dim[0:i-1], /over)
   if(dim[i] EQ 1) then array = reform(array, dim[0:i-1], /over)
  endrep until(dim[i] NE 1)


; return, result
 return, array
end
;=============================================================================
