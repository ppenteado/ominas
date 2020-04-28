;===========================================================================
;+
; NAME:
;	glb_lref
;
;
; PURPOSE:
;       Returns the longitude system reference for each given globe
;       descriptor.
;
;
; CATEGORY:
;	NV/LIB/GLB
;
;
; CALLING SEQUENCE:
;	lref = glb_lref(gbd)
;
;
; ARGUMENTS:
;  INPUT:
;	gbd:	 Array (nt) of any subclass of GLOBE descriptors.
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
; RETURN:
;       Longitude system reference associated with each given globe
;       descriptor.
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
function glb_lref, gbd, noevent=noevent
 
 nv_notify, gbd, type = 1, noevent=noevent
 _gbd = cor_dereference(gbd)
 return, _gbd.lref
end
;===========================================================================
