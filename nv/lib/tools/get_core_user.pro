;=============================================================================
;+
; NAME:
;       get_core_user
;
;
; PURPOSE:
;       Returns the user associated with an object descriptor
;
;
; CATEGORY:
;       NV/LIB/TOOLS
;
;
; CALLING SEQUENCE:
;       result = get_core_user(ods)
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
;       An array of users.
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
function get_core_user, ods
 crds=class_extract(ods, 'CORE')
 return, cor_user(crds)
end
;===========================================================================



