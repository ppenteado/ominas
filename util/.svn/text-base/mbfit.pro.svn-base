;=============================================================================
;+
; NAME:
;	mbfit
;
;
; PURPOSE:
;	Performs a simultaneous least square fit using the given coefficients.
;
;
; CATEGORY:
;	UTIL
;
;
; CALLING SEQUENCE:
;	result = mbfit(M, b)
;
;
; ARGUMENTS:
;  INPUT:
;	M:	Array (3,3,n) of coefficient matrices as computed by 
;		icv_coeff or ipt_coeff.  Coefficients from the two sources
;		may be mixed.
;
;	b:	Array (n,3) of coefficient vectors as computed by 
;		icv_coeff or ipt_coeff.  Coefficients from the two sources
;		may be mixed.
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
; RETURN:
;	3-element vector giving the offset as [dx,dy,dtheta].
;
;
; PROCEDURE:
;	The simultaneous fit is performed by solving the system of equations
;
;				SM x = Sb,
;
;	where SM and Sb represent the sums of the M and b arguments over the 
;	'n' dimension respectively, and x is the return vector, [dx,dy,dtheta].
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 2/1998
;	
;-
;=============================================================================
function mbfit, M, b

 MM = M
 bb = b

 ;-------------------------------------------
 ; sum coefficients from all objects
 ;-------------------------------------------
 s = size(M)
 if(s[0] EQ 3) then $
  begin
   MM = total(M,3)
   bb = transpose(total(b,1))
  end

 ;----------------------------------------------------
 ; solve the system using cholesky decomposition
 ;----------------------------------------------------
 choldc, MM, p, /double
 return, cholsol(MM, p, bb[0:*], /double)	; bb[0:*] will be array[3]
						; regardless of whether bb is
						; array[3] or array[1,3]
end
;===========================================================================
