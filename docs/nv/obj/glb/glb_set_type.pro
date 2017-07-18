;===========================================================================
;+
; NAME:
;	glb_set_type
;
;
; PURPOSE:
;       Replaces the type string for each given globe descriptor.
;
;
; CATEGORY:
;	NV/LIB/GLB
;
;
; CALLING SEQUENCE:
;	glb_set_type, gbd, type
;
;
; ARGUMENTS:
;  INPUT: 
;	gbd:	 Array (nt) of any subclass of GLOBE descriptors.
;
;	type:	 String array (nt) of new type strings.
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
pro glb_set_type, gbd, type, noevent=noevent
@core.include
 
 _gbd = cor_dereference(gbd)

 _gbd.type=type

 cor_rereference, gbd, _gbd
 nv_notify, gbd, type = 0, noevent=noevent
end
;===========================================================================
