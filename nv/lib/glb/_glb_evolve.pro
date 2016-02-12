;===========================================================================
; _glb_evolve
;
;  Input  : array (nbd) of globe descriptor (structures)
;  Output : array (nbd, ndt) of globe descriptor (structures)
;
;===========================================================================
function _glb_evolve, gbds, dt, nodv=nodv
@nv_lib.include

 ndt = n_elements(dt)
 ngbd = n_elements(gbds)
 tgbds = gbds[gen3x(ngbd, ndt, 1)]

 sldp = sld_evolve(gbds.sld, dt, nodv=nodv)
 tgbds.sld = sldp

 return, tgbds
end
;===========================================================================
