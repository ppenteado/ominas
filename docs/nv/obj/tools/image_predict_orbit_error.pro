;==============================================================================
; image_predict_orbit_error
;
;==============================================================================
function image_predict_orbit_error, cd, gbx, rx, sig_rx, c=c, GG=GG, $
                                             nsample=nsample, simple=simple

 ;--------------------------------------------------------
 ; simple method -- just span longitude error, very fast
 ;  Also, this method doesn't correct for light-travel
 ;--------------------------------------------------------
 if(keyword_set(simple)) then $
  begin
   dt = bod_time(gbx) - bod_time(rx)
   rxt = orb_evolve(rx, dt)
   bod_set_pos, rxt, bod_pos(gbx)

   sig_dmadt = sig_rx.dmadt
   sig_ma = dt * sig_dmadt

   ma =  (orb_get_ma(rxt))[0]
   mas = dindgen(nsample)/double(nsample)*(2d*sig_ma) - sig_ma + ma
   pos = tr(orb_to_cartesian(rxt, f=mas))
   p = inertial_to_image_pos(cd, pos)

   nv_free, rxt
  end $
 ;------------------------------------------------------
 ; full method -- span all dimensions
 ;------------------------------------------------------
 else $
  begin
   rde = orb_span_errors(rx, gbx, sig_rx, nsample=nsample)

   n = n_elements(rde)
   p = dblarr(2,n)
   for i=0, n-1 do $
    begin
     w = image_predict_orbit(cd, gbx, rde[i], c=c, GG=GG, pp=pp)
     p[*,i] = pp
    end

   nv_free, rde
  end

 return, p
end
;==============================================================================
