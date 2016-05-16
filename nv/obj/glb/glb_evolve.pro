;===========================================================================
;+
; NAME:
;	glb_evolve
;
;
; PURPOSE:
;       Computes new globe descriptors at the given time offsets from
;       the given globe descriptors using the taylor series expansion
;       corresponding to the derivatives contained in the given globe
;       descriptor.
;
;
; CATEGORY:
;	NV/LIB/GLB
;
;
; CALLING SEQUENCE:
;	gbdt = glb_evolve(gbd, dt)
;
;
; ARGUMENTS:
;  INPUT: 
;	gbd:	 Array (ngd) of any subclass of GLOBE descriptors.
;
;	dt:	 Array (ndt) of time offsets.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	nodv:	 If set, velocities will not be evolved.
;
;
;  OUTPUT: NONE
;
;
; RETURN:
;       Array (ngd,ndt) of newly allocated globe descriptors evolved
;       by time dt, where ngd is the number of gbd, and ndt is the
;       number of dt.
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
function glb_evolve, gbd, dt, nodv=nodv
@core.include
 return, sld_evolve(gbd, dt, nodv=nodv)
end
;===========================================================================
