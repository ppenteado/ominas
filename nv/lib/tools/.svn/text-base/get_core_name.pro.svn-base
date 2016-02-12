;=============================================================================
;+
; NAME:
;       get_core_name
;
;
; PURPOSE:
;       Returns the object name associated with an object descriptor
;
;
; CATEGORY:
;       NV/LIB/TOOLS
;
;
; CALLING SEQUENCE:
;       result = get_core_name(ods)
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
;       An array of names.
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
function get_core_name, ods
 crds = class_extract(ods, 'CORE')
 return, cor_name(crds)
end
;===========================================================================



