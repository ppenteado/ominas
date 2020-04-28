;=============================================================================
;+
; NAME:
;       vtaylor
;
;
; PURPOSE:
;       Evaluates a taylor series using the given t=0 derivatives, dv, at
;       each time t=dt.
;
;
; CATEGORY:
;       UTIL
;
;
; CALLING SEQUENCE:
;       result = vtaylor(dv, dt)
;
;
; ARGUMENTS:
;  INPUT:
;       dv:    dblarr(ndv,nelm)
;
;       dt:    dblarr(ndt)
;
;  OUTPUT:
;       NONE
;
; RETURN:
;       dblarr(ndt,nelm)
;
; RESTRICTIONS:
;       Works for column vectors - not scalars
;
; STATUS:
;       Works, but coeff not implemented
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale
;
;-
;=============================================================================
function vtaylor, _dv, _dt, coeff=coeff

 s=size(_dv)
 ndv = s[1]
 nelm = s[2]
 ndt = n_elements(_dt)

 ;---------------------------------------
 ; n increments from 0 to ndv-1 nt times
 ;---------------------------------------
 n = findgen(ndv)#make_array(nelm*ndt,val=1)

 ;-------------------------------------------------------------
 ; every ndv elements, dt contains the next element of _dt
 ;-------------------------------------------------------------
 dt = _dt[indgen(1,nelm*ndt)/nelm]##make_array(ndv,val=1)

 ;--------------------------------------------------
 ; nfac contains the factorial of each element in n
 ;--------------------------------------------------
 nfac = mfact(n) 

; faster?
; nfac=reform(vfact(findgen(ndv))#make_array(ndt,val=1), 1), ndv*ndt,/overwrite)

 ;---------------------------
 ; dv is repeated nt times
 ;---------------------------
 dv = _dv[reform(fix(indgen(ndv*nelm*ndt) mod (ndv*nelm)),ndv,nelm*ndt)]


 return, transpose( reform(total(dv*((dt^n)/nfac), 1), nelm,ndt) )
end
;===========================================================================
