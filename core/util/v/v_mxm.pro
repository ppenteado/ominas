;=============================================================================
;+
; NAME:
;       v_mxm
;
;
; PURPOSE:
;       Performs matrix multiplication.
;
; CATEGORY:
;       UTIL/V
;
;
; CALLING SEQUENCE:
;       result = v_mxm(m1, m2)
;
;
; ARGUMENTS:
;  INPUT:
;       m1:     An array of nt matrices (i.e. 3 x 3 x nt).
;
;       m1:     Another array of nt matrices.
;
;
;  OUTPUT:
;       NONE
;
; RETURN:
;       Array of nt matrix products (i.e. 3 x 3 x nt).
;
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale
;
;-
;=============================================================================
;==========================================================================
; v_mxm
;
;  m1 and m2 are (3,3,nt)
;
;==========================================================================
function v_mxm, m1, m2

 s = size(m1)
 nt = 1
 if(s[0] EQ 3) then nt = s[3]

 result = dblarr(3,3,nt, /nozero)

 result[0,0,*] = m2[*,0,*] ## m1[0,*,*]
 result[1,0,*] = m2[*,0,*] ## m1[1,*,*]
 result[2,0,*] = m2[*,0,*] ## m1[2,*,*]

 result[0,1,*] = m2[*,1,*] ## m1[0,*,*]
 result[1,1,*] = m2[*,1,*] ## m1[1,*,*]
 result[2,1,*] = m2[*,1,*] ## m1[2,*,*]

 result[0,2,*] = m2[*,2,*] ## m1[0,*,*]
 result[1,2,*] = m2[*,2,*] ## m1[1,*,*]
 result[2,2,*] = m2[*,2,*] ## m1[2,*,*]

 return, result
end
;==========================================================================
