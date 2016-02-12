;=============================================================================
;+
; NAME:
;       get_core_tasks
;
;
; PURPOSE:
;       Returns the tasks associated with an object descriptor
;
;
; CATEGORY:
;       NV/LIB/TOOLS
;
;
; CALLING SEQUENCE:
;       result = get_core_tasks(ods)
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
;       An array of tasks.
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
function get_core_tasks, od
 crd = class_extract(od, 'CORE')
 return, cor_tasks(crd)
end
;===========================================================================



