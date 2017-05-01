;=============================================================================
;+
; NAME:
;       stellab_radec
;
;
; PURPOSE:
;	Corrects positions given in the radec system for stellar 
;	aberration.
;
;
; CATEGORY:
;       NV/LIB/TOOLS
;
;
; CALLING SEQUENCE:
;       new_radec = stellab_radec(radec, vel)
;
;
; ARGUMENTS:
;  INPUT:
;	radec:	Array (nv,3) of target inertial position vectors to be 
;		corrected, given in the radec system.
;
;	vel:	Array (nv,3) of observer inertial velocity vectors.
;		Note observer is assumed to be at the origin.
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
; RETURN: 
;	Array (nv,3) of corrected position vectors in the radec system.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale
;
;-
;=============================================================================
function stellab_radec, radec, vel, c=c

 bd = bod_inertial()
 pos = bod_radec_to_body(bd, radec)
 pos_cor = stellab_pos(pos, vel, c=c)
 radec_cor = bod_body_to_radec(bd, pos_cor)

 return, radec_cor
end
;=============================================================================
