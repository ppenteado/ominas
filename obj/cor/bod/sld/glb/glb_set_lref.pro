;===========================================================================
;+
; NAME:
;	glb_set_lref
;
;
; PURPOSE:
;       Replaces the longitude system reference for each given globe
;       descriptor.
;
;
; CATEGORY:
;	NV/LIB/GLB
;
;
; CALLING SEQUENCE:
;	glb_set_lref, gbd, lref
;
;
; ARGUMENTS:
;  INPUT: 
;	gbd:	 Array (nt) of any subclass of GLOBE descriptors.
;
;	lref:	 String array (nt) of new longitude system names.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: NONE
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
; 	Adapted by:	Spitale, 5/2016
;	
;-
;===========================================================================
pro glb_set_lref, gbd, lref, noevent=noevent
@core.include
 
 _gbd = cor_dereference(gbd)

 _gbd.lref=lref

 cor_rereference, gbd, _gbd
 nv_notify, gbd, type = 0, noevent=noevent
end
;===========================================================================
