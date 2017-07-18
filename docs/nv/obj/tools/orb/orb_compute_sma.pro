;===========================================================================
; ocsma_fn
;
;===========================================================================
function ocsma_fn, a
common ocsma_block, xd, gbx, rate, fn

 return, call_function('orb_compute_' + fn, xd, gbx, sma=a) - rate
end
;===========================================================================



;===========================================================================
; orb_compute_sma
;
;===========================================================================
function orb_compute_sma, xd, gbx, GG=GG, J=J, dmldt=dmldt, $
                                     dlpdt=dlpdt, dapdt=dapdt, dlandt=dlandt
common ocsma_block, _xd, _gbx, rate, fn

 _xd=xd & _gbx=gbx

 if(keyword_set(GG)) then GM = GG*sld_mass(gbx) $
 else GM = sld_gm(gbx)

 if(NOT keyword_set(J)) then J = glb_j(gbx)


 if(keyword_set(dmldt)) then $
  begin
   fn = 'dmldt'
   rate = dmldt
   sma = (GM/rate^2)^0.33333
  end $
 else if(keyword_set(dlpdt)) then $
  begin
   fn = 'dlpdt'
   rate = dlpdt
   sma = (GM*J[2]^2/rate^2)^0.33333
  end $
 else if(keyword_set(dlandt)) then $
  begin
   fn = 'dlandt'
   rate = dlandt
   sma = (GM*J[2]^2/rate^2)^0.33333
  end $
 else if(keyword_set(dapdt)) then $
  begin
   fn = 'dapdt'
   rate = dapdt
   sma = (GM*J[2]^2/rate^2)^0.33333
  end $
 else $
  begin
   fn = 'dmldt'
   rate = orb_get_dmadt(xd) + orb_get_dlandt(xd, gbx) + orb_get_dapdt(xd, gbx)
   sma = (GM/rate^2)^0.33333
  end


 sma = newton(sma, 'ocsma_fn', /double, tolf=1d-9, tolx=1d-9)

 return, sma
end
;===========================================================================



