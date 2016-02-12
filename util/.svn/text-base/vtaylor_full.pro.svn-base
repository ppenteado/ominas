;===========================================================================
; vtaylor_full.pro - not complete
;
;  works for column vectors - not scalars
;
;  evaluates a taylor series using the given t0 derivatives, dv, at time 
;  t0 + dt.  Also computes new time derivatives.
;
;  dv is dblarr(ndv,nelm) t is dblarr(ndt)
;  result is dblarr(ndt,nelm,ndv)
;  result is dblarr(ndv,nelm,ndt)
;
;===========================================================================
function vtaylor_full, dv, dt

 s=size(_dv)
 ndv = s[1]
 nelm = s[2]
 ndt = n_elements(_dt)

 for i=0, ndv-1 do $
  begin
   tdv = vtaylor(v[i:*,*], dt)				; ndt x 3*nelm
   tdv = reform(tdv, ndt, 3, nelm, /over)		; ndt x 3 x nelm
   tbds.vel[i,*,*,*] = $				; 1 x 3 x nbd x ndt
               reform(transpose(tvel, [1,2,0]), $
                                   1,3,nbd,ndt, /over)
  end


end
;===========================================================================
