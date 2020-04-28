;=============================================================================
;+
; NAME:
;       ltcorr
;
;
; PURPOSE:
;	Performs a light-travel-time correction on objects for which the 
;	correction has not already been performed.
;
;
; CATEGORY:
;       NV/LIB/TOOLS
;
;
; CALLING SEQUENCE:
;       ltcorr, obs_bx, targ_bx0, c=c
;
;
; ARGUMENTS:
;  INPUT:
;	obs_bx:  Any subclass of BODY describing the observer.
;
;	targ_bx: Array(nt) of any subclass of BODY describing the targets.
;
;  OUTPUT:  NONE
;
;
; KEYOWRDS:
;  INPUT: 
;	c:		Speed of light.
;
;	iterate:	If set, then the routine will iterate to refine
;			the solution.
;
;	epsilon:	Stopping criterion: maximum allowable timing error.
;			Default is 1d-7.
;
;	invert:		If set, the inverse correction is performed.
;
;  OUTPUT: NONE
;
;
; RETURN: NONE 
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale
;
;-
;=============================================================================
pro ltcorr, obs_bx, _targ_bx, c=c, epsilon=epsilon, iterate=iterate, invert=invert

 if(NOT keyword_set(epsilon)) then epsilon = 1d-7
 if(NOT keyword_set(iterate)) then epsilon = 1d100

 ;-------------------------------------------------------------------------
 ; select targets for which the correction as not already been performed
 ;-------------------------------------------------------------------------
 ab = bod_aberration(_targ_bx, 'LT')
 val = keyword_set(invert) ? 1:0
 w = where(ab EQ val)
 if(w[0] EQ -1) then return
 targ_bx = _targ_bx[w]

 ;--------------------------------------------------
 ; perform corrections
 ;--------------------------------------------------
 nt = n_elements(targ_bx)

 t = make_array(nt, val=bod_time(obs_bx))
 pos = bod_pos(obs_bx) ## make_array(nt, val=1d)

 ltime = 0d

 done = 0
 w = lindgen(nt)
 while(NOT done) do $
  begin
   ;-------------------------------------------------------------------
   ; compare current center-to-center light time to actual time offset
   ; require time offset of zero for inverse correction
   ;-------------------------------------------------------------------
   range = v_mag(pos - transpose(bod_pos(targ_bx)))
   if(NOT keyword_set(invert)) then ltime = range/c
   dt = (t - bod_time(targ_bx)) - ltime

   ;------------------
   ; adjust targets 
   ;------------------
   if(w[0] NE -1) then $
    begin
     nw = n_elements(w)
     for i=0, nw-1 do targ_bx[w[i]] = cor_evolve(targ_bx[w[i]], dt[w[i]], /copy)
    end $
   else done = 1

   w = where(abs(dt) GT epsilon)
  end

 ;--------------------------------------------------
 ; record that corrections have been performed
 ;--------------------------------------------------
 bod_set_aberration, targ_bx, 'LT', unset=val

end
;=============================================================================
