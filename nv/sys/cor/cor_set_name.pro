;=============================================================================
;+
; NAME:
;	cor_set_name
;
;
; PURPOSE:
;	Replaces the name for each given core descriptor.
;
;
; CATEGORY:
;	NV/LIB/COR
;
;
; CALLING SEQUENCE:
;	cor_set_name, crx, name
;
;
; ARGUMENTS:
;  INPUT: NONE
;	crx:	 Any subclass of CORE.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
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
pro cor_set_name, crxp, name, noevent=noevent
@nv_lib.include
 crdp = class_extract(crxp, 'CORE')
 crd = nv_dereference(crdp)

 crd.name=name

 nv_rereference, crdp, crd

 nv_notify, crdp, type = 0, noevent=noevent
end
;===========================================================================



