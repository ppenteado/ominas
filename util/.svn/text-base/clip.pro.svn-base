;=============================================================================
;+
; NAME:
;	clip
;
;
; PURPOSE:
;	Return array with first value clipped off.
;
;
; CATEGORY:
;	UTIL
;
;
; CALLING SEQUENCE:
;	result = clip(array)
;
;
; ARGUMENTS:
;  INPUT:
;	array:	array to be operated on
;
;
; RETURN:
;	If arr is a vector, returns it with the first element clipped off.
;
;
; MODIFICATION HISTORY:
; 	Written by:	Tiscareno
;	
;-
;=============================================================================
function clip,arr

if (size(arr))[0] eq 1 then begin
  return, arr[1:n_elements(arr)-1]
endif else begin
  print, 'Arr not a vector.  No clipping performed.'
  return, arr
endelse

end
