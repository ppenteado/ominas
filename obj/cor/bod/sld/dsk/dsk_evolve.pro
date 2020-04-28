;=============================================================================
;+
; NAME:
;	dsk_evolve
;
;
; PURPOSE:
;	Computes new disk descriptors at the given time offsets from the 
;	given disk descriptors using the taylor series expansion 
;	corresponding to the derivatives contained in the given disk 
;	descriptor.
;
;
; CATEGORY:
;	NV/LIB/BOD
;
;
; CALLING SEQUENCE:
;	dkdt = dsk_evolve(dkd, dt)
;
;
; ARGUMENTS:
;  INPUT: 
;	dkd:	 Any subclass of DISK.
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
;	copy:	If set, the evolved descriptor is copied into the input
;		descriptor and it is freed.  The input descriptor is returned.
;
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Array (ndkd,ndt) of newly allocated descriptors, of class DISK,
;	evolved by time dt, where ndkd is the number of dkd, and ndt
;	is the number of dt.
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
;=============================================================================
function dsk_evolve, dkd, dt, nodv=nodv, copy=copy
@core.include

 ndt = n_elements(dt)
 ndv = bod_ndv()
 ndkd = n_elements(dkd)

 ;---------------------------
 ; evolve solid descriptor
 ;---------------------------
 tdkd = sld_evolve(dkd, dt, nodv=nodv)

 ;---------------------------
 ; semimajor axis
 ;---------------------------
 _dkd = cor_dereference(dkd)
 _tdkd = cor_dereference(tdkd)

 sma = reform(_dkd.sma, ndv+1, 2*ndkd)
 for i=0, ndv do _tdkd.sma[i,*,*,*] = $
     reform(transpose(reform(vtaylor(sma[i:*,*,0], dt), ndt, 2, ndkd), $
                                                  [1,2,0]), 1, 2, ndkd, ndt)

 ;----------------------------
 ; eccentricity
 ;----------------------------
 ecc = reform(_dkd.ecc, ndv+1, 2*ndkd)
 for i=0, ndv do _tdkd.ecc[i,*,*,*] = $
     reform(transpose(reform(vtaylor(ecc[i:*,*,0], dt), ndt, 2, ndkd), $
                                                  [1,2,0]), 1, 2, ndkd, ndt)

 ;----------------------------
 ; tapm
 ;----------------------------
; _tdkd.tapm = reduce_angle(_tdkd.tapm + dt* _tdkd.dtapmdt)

 _tdkd.libm = reduce_angle(_tdkd.libm + dt* _tdkd.dlibmdt)
 _tdkd.tapm = reduce_angle(_tdkd.tapm + dt* _tdkd.dtapmdt  $
                                         + _tdkd.libam*cos(_tdkd.libm))


; nodal...


 cor_rereference, tdkd, _tdkd

 if(keyword_set(copy)) then $
  begin
   nv_copy, dkd, tdkd
   nv_free, tdkd
   return, dkd
  end

 return, tdkd
end
;===========================================================================

