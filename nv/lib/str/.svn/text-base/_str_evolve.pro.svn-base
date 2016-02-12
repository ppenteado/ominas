;===========================================================================
; _str_evolve
;
;  Input  : array (nbd) of star descriptor (structures)
;  Output : array (nbd, ndt) of star descriptor (structures)
;
;===========================================================================
function _str_evolve, sds, dt, nodv=nodv
@nv_lib.include

 ndt = n_elements(dt)
 nsd = n_elements(sds)
 tsds = sds[gen3x(nsd, ndt, 1)]

 gbdp = glb_evolve(sds.gbd, dt, nodv=nodv)
 tsds.gbd = gbdp

 return, tsds
end
;===========================================================================



