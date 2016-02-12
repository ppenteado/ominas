;=============================================================================
;+
; NAME:
;	cor_add_task
;
;
; PURPOSE:
;	Adds a task to the descriptor task list.
;
;
; CATEGORY:
;	NV/LIB/COR
;
;
; CALLING SEQUENCE:
;	cor_add_task, crx, task
;
;
; ARGUMENTS:
;  INPUT:
;	crx:	 Any subclass of CORE.  Only one descriptor may be provided.
;
;	task:	 String giving the name of a program that modified the 
;		 descriptor.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:  NONE
;
;  OUTPUT: NONE
;
;
; RETURN: NONE
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/1998
;	
;-
;=============================================================================
pro cor_add_task, crxp, task
@nv_lib.include
 crdp = class_extract(crxp, 'CORE')
 crd = nv_dereference(crdp)

 n_crd = n_elements(crd)

 for i=0, n_crd-1 do $
  if(n_elements(*crd[i].tasks_p) EQ 1 AND $
                   (*crd[i].tasks_p)[0] EQ '') then *crd[i].tasks_p = task $
  else *crd[i].tasks_p = [*crd[i].tasks_p,task]

 nv_rereference, crdp, crd
 nv_notify, crdp, type=0
 nv_notify, /flush
end
;===========================================================================



