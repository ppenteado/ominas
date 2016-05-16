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
; 	Adapted by:	Spitale, 5/2016
;
;-
;=============================================================================
function str_lum, sd, noevent=noevent
@core.include

 nv_notify, sd, type = 1, noevent=noevent
 _sd = cor_dereference(sd)
 return, _sd.lum
end
;===========================================================================



