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
;	glb_set_j, gbd, j
;
;
; ARGUMENTS:
;  INPUT: 
;	gbd:	 Array (nt) of any subclass of GLOBE descriptors.
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
; 	Adapted by:	Spitale, 5/2016
;	
;-
;===========================================================================
pro glb_set_j, gbd, J, noevent=noevent
 
 _gbd = cor_dereference(gbd)

 _gbd.J = J

 cor_rereference, gbd, _gbd
 nv_notify, gbd, type = 0, noevent=noevent
end
;===========================================================================
