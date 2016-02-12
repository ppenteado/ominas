;=============================================================================
;+
; NAME:
;	str_evolve
;
;
; PURPOSE:
;	Computes new star descriptors at the given time offsets from the 
;	given star descriptors using the taylor series expansion 
;	corresponding to the derivatives contained in the given star 
;	descriptor.
;
;
; CATEGORY:
;	NV/LIB/STR
;
;
; CALLING SEQUENCE:
;	sdt = str_evolve(sx, dt)
;
;
; ARGUMENTS:
;  INPUT: 
;	sx:	 Any subclass of STAR.
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
;	Array (nsd,ndt) of newly allocated descriptors, of class STAR,
;	evolved by time dt, where nsd is the number of sx, and ndt
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
function str_evolve, sxp, dt, nodv=nodv
@nv_lib.include
 sdp = class_extract(sxp, 'STAR')
 sds = nv_dereference(sdp)

 ndt = n_elements(dt)
 nsd = n_elements(sds)


 tsds = _str_evolve(sds, dt, nodv=nodv)


 tsdps = ptrarr(nsd, ndt)
 nv_rereference, tsdps, tsds

 return, tsdps
end
;===========================================================================



