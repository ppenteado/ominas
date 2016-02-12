;===========================================================================
;+
; NAME:
;	cam_evolve
;
;
; PURPOSE:
;       Computes new camera descriptors at the given time offsets from
;       the given camera descriptors using the taylor series expansion
;       corresponding to the derivatives contained in the given camera
;       descriptor.
;
;
; CATEGORY:
;	NV/LIB/CAM
;
;
; CALLING SEQUENCE:
;	cdt = cam_evolve(cd, dt)
;
;
; ARGUMENTS:
;  INPUT: 
;	cd:	 Array (ncd) of CAMERA descriptors.
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
;       Array (ncd,ndt) of newly allocated camera descriptors evolved
;       by time dt, where ncd is the number of cd, and ndt is the
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
function cam_evolve, cxp, dt, nodv=nodv
@nv_lib.include
 cdp = class_extract(cxp, 'CAMERA')
 cds = nv_dereference(cdp)

 ndt = n_elements(dt)
 ncd = n_elements(cds)


 tcds = _cam_evolve(cds, dt, nodv=nodv)


 tcdps = ptrarr(ncd, ndt)
 nv_rereference, tcdps, tcds

 return, tcdps
end
;===========================================================================



