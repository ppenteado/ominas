;=============================================================================
;+
; NAME:
;	plt_evolve
;
;
; PURPOSE:
;	Computes new planet descriptors at the given time offsets from the 
;	given planet descriptors using the taylor series expansion 
;	corresponding to the derivatives contained in the given planet 
;	descriptor.
;
;
; CATEGORY:
;	NV/LIB/PLT
;
;
; CALLING SEQUENCE:
;	pdt = plt_evolve(px, dt)
;
;
; ARGUMENTS:
;  INPUT: 
;	px:	 Any subclass of PLANET.
;
;	dt:	 Time offset.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	nodv:	 If set, derivatives will not be evolved.
;
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Array (npd,ndt) of newly allocated descriptors, of class PLANET,
;	evolved by time dt, where npd is the number of px, and ndt
;	is the number of dt.
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
;=============================================================================
function plt_evolve, pxp, dt, nodv=nodv
@nv_lib.include
 pdp = class_extract(pxp, 'PLANET')
 pds = nv_dereference(pdp)

 ndt = n_elements(dt)
 npd = n_elements(pds)


 tpds = _plt_evolve(pds, dt, nodv=nodv)


 tpdps = ptrarr(npd, ndt)
 nv_rereference, tpdps, tpds

 return, tpdps
end
;===========================================================================



