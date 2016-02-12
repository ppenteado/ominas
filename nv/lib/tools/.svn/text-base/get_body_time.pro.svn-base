;=============================================================================
;+
; NAME:
;       get_body_time
;
;
; PURPOSE:
;       Return time associated with a body descriptor
;
;
; CATEGORY:
;       NV/LIB/TOOLS
;
;
; CALLING SEQUENCE:
;       result = get_body_time(ods)
;
;
; ARGUMENTS:
;  INPUT:
;            ods:       An array of Object descriptors
;
;  OUTPUT:
;       NONE
;
; RETURN:
;       An array of times.
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
function get_body_time, ods
 bds=class_extract(ods, 'BODY')
 return, bod_time(bds)
end
;===========================================================================



