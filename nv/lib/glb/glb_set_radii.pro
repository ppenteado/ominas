;===========================================================================
;+
; NAME:
;	glb_set_radii
;
;
; PURPOSE:
;       Replaces the triaxial radii for each given globe descriptor.
;
;
; CATEGORY:
;	NV/LIB/GLB
;
;
; CALLING SEQUENCE:
;	glb_set_radii, gbx, radii
;
;
; ARGUMENTS:
;  INPUT: 
;	gbx:	 Array (nt) of any subclass of GLOBE descriptors.
;
;	radii:	 Array (3,nt) of new triaxial radii.
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
pro glb_set_radii, gbxp, radii, noevent=noevent
@nv_lib.include
 gbdp = class_extract(gbxp, 'GLOBE')
 gbd = nv_dereference(gbdp)

 gbd.radii=radii

 nv_rereference, gbdp, gbd
 nv_notify, gbdp, type = 0, noevent=noevent
end
;===========================================================================
