;===========================================================================
; ocsma_fn
;
;===========================================================================
function ocsma_fn, a
common ocsma_block, xd, gbx, dmldt

 return, orb_compute_dmldt(xd, gbx, sma=a) - dmldt
end
;===========================================================================



;===========================================================================
; orb_compute_sma
;
;===========================================================================
function orb_compute_sma, xd, gbx, GG=GG, dmldt=dmldt
common ocsma_block, _xd, _gbx, _dmldt

 if(NOT keyword_set(dmldt)) then $
   dmldt = orb_get_dmadt(xd) + orb_get_dlandt(xd, gbx) + orb_get_dapdt(xd, gbx)

 _xd=xd & _gbx=gbx & _dmldt=dmldt
\

 if(keyword__set(GG)) then GM = GG*glb_mass(gbx) $
 else GM = glb_gm(gbx)

 sma = (GM/dmldt^2)^0.33333
 sma = newton(sma, 'ocsma_fn', /double, tolf=1d-9, tolx=1d-9)

 return, sma
end
;===========================================================================



