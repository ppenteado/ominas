;===========================================================================
; _stn_evolve
;
;  Input  : array (nbd) of planet descriptor (structures)
;  Output : array (nbd, ndt) of planet descriptor (structures)
;
;===========================================================================
function _stn_evolve, stds, dt, nodv=nodv
@nv_lib.include

 ndt = n_elements(dt)
 nstd = n_elements(stds)
 tstds = stds[gen3x(nstd, ndt, 1)]

 bdp = bod_evolve(stds.bd, dt, nodv=nodv)
 tstds.bd = bdp

 return, tstds
end
;===========================================================================



