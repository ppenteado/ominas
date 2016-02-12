;=============================================================================
;+
; NAME:
;       add_core_task
;
;
; PURPOSE:
;       Adds a task name to the task list of the CORE superclass.
;
;
; CATEGORY:
;       NV/LIB/TOOLS
;
;
; CALLING SEQUENCE:
;       add_core_task, ods, task
;
;
; ARGUMENTS:
;  INPUT:
;        ods:   Object descriptor
;
;       task:   Name of task
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
pro add_core_task, ods, task

 ;----------------------------
 ; get core descriptor
 ;----------------------------
 crds = class_extract(ods, 'CORE')

 ;----------------------------------
 ; add the task to all descriptors
 ;----------------------------------
 cor_add_task, crds, task


end
;===========================================================================



