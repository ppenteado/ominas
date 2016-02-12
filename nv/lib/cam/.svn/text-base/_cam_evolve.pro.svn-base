;===========================================================================
; _cam_evolve
;
;  Input  : array (nbd) of camera descriptor (structures)
;  Output : array (nbd, ndt) of camera descriptor (structures)
;
;===========================================================================
function _cam_evolve, cds, dt, nodv=nodv
@nv_lib.include

 ndt = n_elements(dt)
 ncd = n_elements(cds)
 tcds = cds[gen3x(ncd, ndt, 1)]

 bdp = bod_evolve(cds.bd, dt, nodv=nodv)
 tcds.bd = bdp

 return, tcds
end
;===========================================================================



