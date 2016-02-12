;=============================================================================
;+
; NAME:
;       str_lum
;
;
; PURPOSE:
;       Returns a luminosity for each given star descriptor.
;
;
; CATEGORY:
;       NV/LIB/STR
;
;
; CALLING SEQUENCE:
;       result = str_lum(sd)
;
;
; ARGUMENTS:
;  INPUT:
;       sd:    Array (nt) of star descriptors
;
;  OUTPUT:
;       NONE
;
;
; KEYWORDS:
;         NONE
;
; RETURN:
;       An array (nt) of luminosities.
;
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Haemmerle, 5/1998
;
;-
;=============================================================================
function str_lum, sxp
@nv_lib.include
 sdp = class_extract(sxp, 'STAR')
 nv_notify, sdp, type = 1
 sd = nv_dereference(sdp)
 return, sd.lum
end
;===========================================================================



