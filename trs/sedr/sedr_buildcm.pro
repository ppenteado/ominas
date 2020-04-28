;=============================================================================
;+
; NAME:
;	sedr_buildcm
;
;
; PURPOSE:
;	Build the C-matrix (or ME-matrix) from the euler angles (degrees).
;
;
; CATEGORY:
;	UTIL/SEDR
;
;
; CALLING SEQUENCE:
;	result = sedr_buildcm(alpha, delta, kappa)
;
;
; ARGUMENTS:
;  INPUT:
;	alpha:		Right ascension of optic axis (or planet pole) (degrees)
;
;	delta:		Declination of optic axis (or planet pole) (degrees)
;
;	kappa:		Rotation about optic axis (or planet pole) (degrees)
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; PROCEDURE:
;
;
; RESTRICTIONS:
;
;
; STATUS:
;	Complete.
;
;
; MODIFICATION HISTORY:
; 	Written by:	Haemmerle, 12/1998 ported from a NAV function
;			Spitale 1/2002 transposed
;	
;-
;=============================================================================
function sedr_buildcm, alpha, delta, kappa

 euler_rad = [alpha, delta, kappa] * !DPI/180d
 sin_euler = SIN(euler_rad)
 cos_euler = COS(euler_rad)

 cm = dblarr(3,3)


 cm[0,0] =  -sin_euler[0]*cos_euler[2] - cos_euler[0]*sin_euler[1]*sin_euler[2]
 cm[0,1] =   cos_euler[0]*cos_euler[2] - sin_euler[0]*sin_euler[1]*sin_euler[2]
 cm[0,2] =   cos_euler[1]*sin_euler[2]

 cm[1,0] =   sin_euler[0]*sin_euler[2] - cos_euler[0]*sin_euler[1]*cos_euler[2]
 cm[1,1] =  -cos_euler[0]*sin_euler[2] - sin_euler[0]*sin_euler[1]*cos_euler[2]
 cm[1,2] =   cos_euler[1]*cos_euler[2]

 cm[2,0] =   cos_euler[0]*cos_euler[1]
 cm[2,1] =   sin_euler[0]*cos_euler[1]
 cm[2,2] =   sin_euler[1]





 return, cm
end
;=============================================================================
