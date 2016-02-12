;=============================================================================
;+
; NAME:
;       set_core_name
;
;
; PURPOSE:
;       Sets the object name associated with an object descriptor
;
;
; CATEGORY:
;       NV/LIB/TOOLS
;
;
; CALLING SEQUENCE:
;       set_core_name, ods, name
;
;
; ARGUMENTS:
;  INPUT:
;            ods:       An array of Object descriptors
;
;            name:      string giving the new name
;
;  OUTPUT:
;       NONE
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
pro set_core_name, od, name
 crd = class_extract(od, 'CORE')
 cor_set_name, crd, name
end
;===========================================================================



