;===========================================================================
; _dsk_evolve
;
;  Input  : array (ndkd) of disk descriptor (structures)
;  Output : array (ndkd, ndt) of disk descriptor (structures)
;
;===========================================================================
function _dsk_evolve, dkds, dt, nodv=nodv
@nv_lib.include

 ndt = n_elements(dt)
 ndv = n_elements(dkds[0].sma[*,0]) - 1
 n_dkds = n_elements(dkds)
 tdkds = dkds[gen3x(n_dkds, ndt, 1)]

 ;---------------------------
 ; solid descriptor
 ;---------------------------
 tdkds.sld = sld_evolve(dkds.sld, dt, nodv=nodv)

 ;---------------------------
 ; semimajor axis
 ;---------------------------
 sma = reform(dkds.sma, ndv+1, 2*n_dkds)
 for i=0, ndv do tdkds.sma[i,*,*,*] = $
     reform(transpose(reform(vtaylor(sma[i:*,*,0], dt), ndt, 2, n_dkds), $
                                                  [1,2,0]), 1, 2, n_dkds, ndt)

 ;----------------------------
 ; eccentricity
 ;----------------------------
 ecc = reform(dkds.ecc, ndv+1, 2*n_dkds)
 for i=0, ndv do tdkds.ecc[i,*,*,*] = $
     reform(transpose(reform(vtaylor(ecc[i:*,*,0], dt), ndt, 2, n_dkds), $
                                                  [1,2,0]), 1, 2, n_dkds, ndt)

 ;----------------------------
 ; lpm
 ;----------------------------
; tdkds.lpm = reduce_angle(tdkds.lpm + dt* tdkds.dlpmdt)

 tdkds.libm = reduce_angle(tdkds.libm + dt* tdkds.dlibmdt)
 tdkds.lpm = reduce_angle(tdkds.lpm + dt* tdkds.dlpmdt  $
                                         + tdkds.libam*cos(tdkds.libm))


; nodal...


 return, tdkds
end
;===========================================================================

