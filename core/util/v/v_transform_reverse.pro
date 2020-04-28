;=============================================================================
;+
; NAME:
;       v_transform_reverse
;
;
; PURPOSE:
;       Transforms vectors given rotation matrices and translation vectors.
;
;
; CATEGORY:
;       UTIL/V
;
;
; CALLING SEQUENCE:
;       result = v_transform_reverse(M, p, v)
;
;
; ARGUMENTS:
;  INPUT:
;       M:      array of nt (nel x nel) rotation matrices
;
;       p:      array of nt nel-element column vectors
;
;       v:      v is array (nv,nel,nt) of nel-element column vectors
;
;  OUTPUT:
;       NONE
;
; RETURN:
;       Array (nv,nel,nt) of nel-element transformed column vectors.
;
; PROCEDURE:
;       Vectors are first translated using p and then rotated using M.
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
function v_transform_reverse, M, p, v

 nt = 1 
 sp = size(p)
 if(sp[0] EQ 3) then nt = sp[3]
 nel = sp[2]
 nv = (size(v))[1]

 sub = linegen3x(nv,nel,nt)
 r = dblarr(nv,3,nt,/nozero)
 vv = (v - (bd.pos)[sub])

 for i=0, nel-1 do $
  begin
   MM = (M[*,i,*])[sub]
   r[*,i,*] = total(MM*vv,2)
  end

 return, r
end
;===========================================================================
