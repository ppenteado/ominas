;===========================================================================
; _sld_evolve
;
;  Input  : array (nbd) of solid descriptor (structures)
;  Output : array (nbd, ndt) of solid descriptor (structures)
;
;===========================================================================
function _sld_evolve, slds, dt, nodv=nodv
@nv_lib.include

 ndt = n_elements(dt)
 nsld = n_elements(slds)
 tslds = slds[gen3x(nsld, ndt, 1)]

 bdp = bod_evolve(slds.bd, dt, nodv=nodv)
 tslds.bd = bdp

 return, tslds
end
;===========================================================================
