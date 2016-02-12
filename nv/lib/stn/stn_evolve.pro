;=============================================================================
;+
; NAME:
;	stn_evolve
;
;
; PURPOSE:
;	Computes new station descriptors at the given time offsets from the 
;	given station descriptors using the taylor series expansion 
;	corresponding to the derivatives contained in the given station 
;	descriptor.
;
;
; CATEGORY:
;	NV/LIB/STN
;
;
; CALLING SEQUENCE:
;	sdt = stn_evolve(stx, dt)
;
;
; ARGUMENTS:
;  INPUT: 
;	stx:	 Any subclass of STATION.
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
;	Array (nstd,ndt) of newly allocated descriptors, of class STATION,
;	evolved by time dt, where nstd is the number of stx, and ndt
;	is the number of dt.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
;	
;-
;=============================================================================
function stn_evolve, pxp, dt, nodv=nodv
@nv_lib.include
 stdp = class_extract(pxp, 'PLANET')
 stds = nv_dereference(stdp)

 ndt = n_elements(dt)
 nstd = n_elements(stds)


 tstds = _stn_evolve(stds, dt, nodv=nodv)


 tstdps = ptrarr(nstd, ndt)
 nv_rereference, tstdps, tstds

 return, tstdps
end
;===========================================================================



