;===========================================================================
; _plt_evolve
;
;  Input  : array (nbd) of planet descriptor (structures)
;  Output : array (nbd, ndt) of planet descriptor (structures)
;
;===========================================================================
function _plt_evolve, pds, dt, nodv=nodv
@nv_lib.include

 ndt = n_elements(dt)
 npd = n_elements(pds)
 tpds = pds[gen3x(npd, ndt, 1)]

 gbdp = glb_evolve(pds.gbd, dt, nodv=nodv)
 tpds.gbd = gbdp

 return, tpds
end
;===========================================================================



