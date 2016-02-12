;=============================================================================
;+
; NAME:
;       str_globe
;
;
; PURPOSE:
;       Returns a globe descriptor for each given star descriptor.
;
;
; CATEGORY:
;       NV/LIB/STR
;
;
; CALLING SEQUENCE:
;       gbd = str_globe(sd)
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
;       An array (nt) of globe descriptors.
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
function str_globe, sxp
@nv_lib.include
 sdp = class_extract(sxp, 'STAR')
 nv_notify, sdp, type = 1
 sd = nv_dereference(sdp)
 return, sd.gbd
end
;===========================================================================



