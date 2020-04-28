;===========================================================================
;+
; NAME:
;	tr
;
; PURPOSE:
;	Abbreviation for the transpose() function
;
; CATEGORY:
;       UTIL/ABBREV
;-
;===========================================================================
function tr, x
 if((size(x))[0] EQ 0) then return, x
 return, transpose(x)
end
;===========================================================================
