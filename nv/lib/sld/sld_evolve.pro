;===========================================================================
;+
; NAME:
;	sld_evolve
;
;
; PURPOSE:
;       Computes new solid descriptors at the given time offsets from
;       the given solid descriptors using the taylor series expansion
;       corresponding to the derivatives contained in the given solid
;       descriptor.
;
;
; CATEGORY:
;	NV/LIB/SLD
;
;
; CALLING SEQUENCE:
;	slxt = sld_evolve(slx, dt)
;
;
; ARGUMENTS:
;  INPUT: 
;	slx:	 Array (nsld) of any subclass of SOLID descriptors.
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
;       Array (ngd,ndt) of newly allocated solid descriptors evolved
;       by time dt, where ngd is the number of slx, and ndt is the
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
function sld_evolve, slxp, dt, nodv=nodv
@nv_lib.include
 sldp = class_extract(slxp, 'SOLID')
 slds = nv_dereference(sldp)

 ndt = n_elements(dt)
 nsld = n_elements(slds)

 tslds = _sld_evolve(slds, dt, nodv=nodv)

 
 tsldps = ptrarr(nsld, ndt)
 nv_rereference, tsldps, tslds

 return, tsldps
end
;===========================================================================
