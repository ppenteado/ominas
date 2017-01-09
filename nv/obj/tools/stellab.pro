;=============================================================================
;+
; NAME:
;       stellab
;
;
; PURPOSE:
;	Corrects body positions for stellar aberration.
;
;
; CATEGORY:
;       NV/LIB/TOOLS
;
;
; CALLING SEQUENCE:
;       stellab, obs_bx, targ_bx
;
;
; ARGUMENTS:
;  INPUT:
;	obs_bx:		Array (nt) of any subclass of BODY describing 
;			the observer.
;
;	targ_bx:	Array (nt) of any subclass of BODY describing 
;			the target.  The position of this body is modified. 
;
;  OUTPUT:  NONE
;
;
; KEYWORDS:
;  INPUT: 
;	c:		Speed of light.
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
pro stellab, obs_bx, targ_bx, c=c, fast=fast, invert=invert

 nt = n_elements(targ_bx)

 ;----------------------------------------------------------------
 ; inverse correction -- restore saved positions
 ;----------------------------------------------------------------
 if(keyword_set(invert)) then $
  begin
   for i=0, nt-1 do bod_set_pos, targ_bx[i], $
                                    cor_udata(targ_bx[i], 'STELLAB_POS_0')
   return
  end

 ;----------------------------------------------------------------
 ; forwawrd correction
 ;----------------------------------------------------------------
 obs_pos = bod_pos(obs_bx) ## make_array(nt, val=1d)
 targ_pos = bod_pos(targ_bx)
 for i=0, nt-1 do cor_set_udata, targ_bx[i], 'STELLAB_POS_0', targ_pos[*,*,i]

 pos = - (obs_pos - transpose(targ_pos))
 vel = (bod_vel(obs_bx))[0,*] ## make_array(nt, val=1d) 

 pos_cor = stellab_pos(pos, vel, c=c, fast=fast)

 bod_set_pos, targ_bx, reform(transpose(obs_pos + pos_cor), 1, 3, nt)
end
;=============================================================================



;=============================================================================
; stellab
;
;=============================================================================
pro _stellab, obs_bx, targ_bx, c=c, fast=fast

 obs_pos = bod_pos(obs_bx)
 
 pos = bod_pos(targ_bx) - obs_pos
 vel = (bod_vel(targ_bx) - bod_vel(obs_bx))[0,*,*]

 pos_cor = stellab_pos(pos, vel, c=c, fast=fast)

 bod_set_pos, targ_bx, obs_pos + pos_cor
end
;=============================================================================
