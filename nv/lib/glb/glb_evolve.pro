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
;	gbxt = glb_evolve(gbx, dt)
;
;
; ARGUMENTS:
;  INPUT: 
;	gbx:	 Array (ngd) of any subclass of GLOBE descriptors.
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
;       by time dt, where ngd is the number of gbx, and ndt is the
;       number of dt.
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
function glb_evolve, gbxp, dt, nodv=nodv
@nv_lib.include
 gbdp = class_extract(gbxp, 'GLOBE')
 gbds = nv_dereference(gbdp)

 ndt = n_elements(dt)
 ngbd = n_elements(gbds)

 tgbds = _glb_evolve(gbds, dt, nodv=nodv)

 
 tgbdps = ptrarr(ngbd, ndt)
 nv_rereference, tgbdps, tgbds

 return, tgbdps
end
;===========================================================================
