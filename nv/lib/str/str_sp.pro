;=============================================================================
;+
; NAME:
;       str_sp
;
;
; PURPOSE:
;       Returns a spectral type for each given star descriptor.
;
;
; CATEGORY:
;       NV/LIB/STR
;
;
; CALLING SEQUENCE:
;       result = str_sp(sd)
;
;
; ARGUMENTS:
;  INPUT:
;       sd:    Array (t) of star descriptors
;
;  OUTPUT:
;       NONE
;
;
; KEYWORDS:
;         NONE
;
; RETURN:
;       An array (nt) of spectral types which is a three character string.
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
function str_sp, sxp
@nv_lib.include
 sdp = class_extract(sxp, 'STAR')
 nv_notify, sdp, type = 1
 sd = nv_dereference(sdp)
 return, sd.sp
end
;===========================================================================



