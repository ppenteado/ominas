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
pro cor_set_name, crd, name, noevent=noevent
@core.include
 _crd = cor_dereference(crd)

 _crd.name=name

 cor_rereference, crd, _crd

 nv_notify, crd, type = 0, noevent=noevent
end
;===========================================================================
