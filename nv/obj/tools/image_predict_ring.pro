;=============================================================================
; image_predict_ring
;
;  Inputs: nt camera descriptors, nt ring (orbit) descriptors.  For best 
;  results, the epoch of each ring descriptor should be pretty close 
;  (within a couple of light-travel times) to that of the corresponding 
;  camera descriptor.
;
;  Return: Array of indices of all input camera descriptors for which a
;          given ring is likely to be observed.
;
;=============================================================================
function image_predict_ring, cd, gbx, rx, sund=sund, rxt=_rxt

 nt = n_elements(cd)

 ;----------------------------------
 ; camera vectors
 ;----------------------------------
 orient = bod_orient(cd)
 v = orient[1,*,*]					; 1 x 3 x nt
 r = bod_pos(cd)
 if(nt GT 1) then $
  begin
   v = tr(v)
   r = tr(r)
  end


 ;----------------------------------
 ; evolve ring
 ;----------------------------------
 dt = bod_time(gbx) - bod_time(rx)			; nt
 rxt = rng_evolve(rx, dt)

 ;-------------------------------------
 ; recenter ring on planet center
 ;-------------------------------------
 bod_set_pos, rxt, bod_pos(gbx)


 ;------------------------------------------------------
 ; compute ring points and test each observation
 ;------------------------------------------------------
 w = bytarr(nt)
 for i=0, nt-1 do $
  begin
   ring_ptd = pg_disk(cd=cd, dkx=rxt, np=100, /fov)
   pg_hide, ring_ptd, cd=cd, bx=pd
   if(keyword_set(sund)) then pg_hide, ring_ptd, cd=cd, od=sund, bx=pd

   pp = pnt_points(/cat, /vis, ring_ptd)
   if(NOT keyword_set(pp)) then w[i] = -1

   nv_free, ring_ptd
  end

 if(NOT arg_present(_rxt)) then nv_free, rxt $
 else _rxt = rxt


 return, w
end
;=============================================================================
