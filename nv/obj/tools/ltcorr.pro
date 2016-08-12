;=============================================================================
;+
; NAME:
;       ltcorr
;
;
; PURPOSE:
;	Performs a light-travel-time correction.
;
;
; CATEGORY:
;       NV/LIB/TOOLS
;
;
; CALLING SEQUENCE:
;       targ_bx = (ltcorr, obs_bx, targ_bx0, c=c)
;
;
; ARGUMENTS:
;  INPUT:
;	obs_bx:  Any subclass of BODY describing the observer.
;
;	targ_bx0: Array(nt) of any subclass of BODY describing the targets.
;
;  OUTPUT:  NONE
;
;
; KEYOWRDS:
;  INPUT: 
;	c:	Speed of light.
;
;	iterate:	If set, then the routine will iterate to refine
;			the solution.
;
;	epsilon:	Stopping criterion: maximum allowable timing error.
;			Default is 1d-7.
;
;  OUTPUT: NONE
;
;
; RETURN: 
;	New target descriptors.  
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale
;
;-
;=============================================================================
function ltcorr, obs_bx, targ_bx, c=c, epsilon=epsilon, iterate=iterate

 if(NOT keyword_set(epsilon)) then epsilon = 1d-7
 if(NOT keyword_set(iterate)) then epsilon = 1d100

 nt = n_elements(targ_bx)

 t = make_array(nt, val=bod_time(obs_bx))
 pos = bod_pos(obs_bx) ## make_array(nt, val=1d)

 targ_bxt = objarr(nt)

 done = 0
 w = lindgen(nt)
 while(NOT done) do $
  begin
   ;-------------------------------------------------------------------
   ; compare current center-to-center light time to actual time offset
   ;-------------------------------------------------------------------
   range = v_mag(pos - transpose(bod_pos(targ_bx)))
   ltime = range/c
   dt = (t - bod_time(targ_bx)) - ltime

   ;------------------
   ; adjust targets 
   ;------------------
   if(w[0] NE -1) then $
    begin
     nw = n_elements(w)
     for i=0, nw-1 do targ_bxt[w[i]] = cor_evolve(targ_bx[w[i]], dt[w[i]])
     nv_free, targ_bx[w]
     targ_bx[w] = targ_bxt[w]
    end $
   else done = 1

   w = where(abs(dt) GT epsilon)
  end


 return, targ_bxt
end
;=============================================================================


