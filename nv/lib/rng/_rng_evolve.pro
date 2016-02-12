;===========================================================================
; _rng_evolve
;
;  Input  : array (nbd) of ring descriptor (structures)
;  Output : array (nbd, ndt) of ring descriptor (structures)
;
;===========================================================================
function _rng_evolve, rds, dt, nodv=nodv
@nv_lib.include

 ndt = n_elements(dt)
 nrd = n_elements(rds)
 trds = rds[gen3x(nrd, ndt, 1)]

 dkdp = dsk_evolve(rds.dkd, dt, nodv=nodv)
 trds.dkd = dkdp

 return, trds
end
;===========================================================================



