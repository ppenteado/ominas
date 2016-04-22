;===========================================================================
;+
; NAME:
;	glb_set_j
;
;
; PURPOSE:
;       Replaces the zonal harmonics for each given globe descriptor.
;
;
; CATEGORY:
;	NV/LIB/GLB
;
;
; CALLING SEQUENCE:
;	glb_set_j, gbx, j
;
;
; ARGUMENTS:
;  INPUT: 
;	gbx:	 Array (nt) of any subclass of GLOBE descriptors.
;
;	j:	 Array (nj,nt) of new zonal harmonics.
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
pro glb_set_j, gbxp, J, noevent=noevent
 gbdp = class_extract(gbxp, 'GLOBE')
 gbd = nv_dereference(gbdp)

 gbd.J = J

 nv_rereference, gbdp, gbd
 nv_notify, gbdp, type = 0, noevent=noevent
end
;===========================================================================
