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
;	glb_set_lref, gbx, lref
;
;
; ARGUMENTS:
;  INPUT: 
;	gbx:	 Array (nt) of any subclass of GLOBE descriptors.
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
;	
;-
;===========================================================================
pro glb_set_lref, gbxp, lref, noevent=noevent
@nv_lib.include
 gbdp = class_extract(gbxp, 'GLOBE')
 gbd = nv_dereference(gbdp)

 gbd.lref=lref

 nv_rereference, gbdp, gbd
 nv_notify, gbdp, type = 0, noevent=noevent
end
;===========================================================================
