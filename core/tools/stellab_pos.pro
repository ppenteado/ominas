;=============================================================================
;+
; NAME:
;       stellab_pos
;
;
; PURPOSE:
;	Corrects positions for stellar aberration.
;
;
; CATEGORY:
;       NV/LIB/TOOLS
;
;
; CALLING SEQUENCE:
;       new_pos = stellab_pos(pos, vel)
;
;
; ARGUMENTS:
;  INPUT:
;	pos:	Array (nv,3) of target inertial position vectors to be 
;		corrected.
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
;  OUTPUT: 
;	axis:	Array (nv,3) of rotation axes corresponding to each 
;		correction.
;
;	theta:	Array (nv) of rotation angles corresponding to each 
;		correction.
;
;
; RETURN: 
;	Array (nv,3) of corrected position vectors.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale
;
;-
;=============================================================================
function stellab_pos, pos, $	; Target positions relative to observer,
				;  in inertial frame.
                      vel, $	; Observer velocity in inertial frame.
                      c=c, axis=axis, theta=theta, fast=fast

 if(NOT keyword__set(c)) then c = 1d

 s = size(pos)
 nv = s[1]
 nt = 1
 if(s[0] EQ 3) then nt = s[3]

 if(keyword_set(fast)) then $
  begin
   vv = v_unit(v_unit(pos, mag=mag) + vel/c)
   return, vv * (mag # make_array(3, val=1d))
  end

 axis = v_cross(v_unit(pos), vel/c)
 theta = asin(v_mag(axis))
 axis = v_unit(axis)

 result = pos
 w = where(theta NE 0)
 if(w[0] NE -1) then $
  begin
   sub = colgen(nv,3,nt, w)
   result[sub] = v_rotate_11(pos[sub], axis[sub], sin(theta[w]), cos(theta[w]))
  end
 
 return, result
end
;=============================================================================
