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
;	glb_set_type, gbx, type
;
;
; ARGUMENTS:
;  INPUT: 
;	gbx:	 Array (nt) of any subclass of GLOBE descriptors.
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
;	
;-
;===========================================================================
pro glb_set_type, gbxp, type, noevent=noevent
@nv_lib.include
 gbdp = class_extract(gbxp, 'GLOBE')
 gbd = nv_dereference(gbdp)

 gbd.type=type

 nv_rereference, gbdp, gbd
 nv_notify, gbdp, type = 0, noevent=noevent
end
;===========================================================================
