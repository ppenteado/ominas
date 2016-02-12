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
;	c:	Speed of light.
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
pro stellab, obs_bx, targ_bx, c=c, fast=fast

 nt = n_elements(targ_bx)

 obs_pos = bod_pos(obs_bx) ## make_array(nt, val=1d)


 pos = - (obs_pos - transpose(bod_pos(targ_bx)))
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

 obs_bd = class_extract(obs_bx, 'BODY')
 targ_bd = class_extract(targ_bx, 'BODY')

 obs_pos = bod_pos(obs_bd)
 
 pos = bod_pos(targ_bd) - obs_pos
 vel = (bod_vel(targ_bd) - bod_vel(obs_bd))[0,*,*]

 pos_cor = stellab_pos(pos, vel, c=c, fast=fast)

 bod_set_pos, targ_bd, obs_pos + pos_cor
end
;=============================================================================
