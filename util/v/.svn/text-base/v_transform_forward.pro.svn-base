;=============================================================================
;+
; NAME:
;       v_transform_forward
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
;       result = v_transform_forward(M, p, v)
;
;
; ARGUMENTS:
;  INPUT:
;       M:      array of nt (nel x nel) rotation matrices
;       p:      array of nt nel-element column vectors
;       v:      v is array (nv,nel,nt) of nel-element column vectors
;
;  OUTPUT:
;       NONE
;
; RETURN:
;       Array (nv,nel,nt) of nel-element transformed column vectors.
;
; PROCEDURE:
;       Vectors are first rotated using M and then translated using p.
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
function v_transform_forward, M, p, v

 nt = 1 
 sp = size(p)
 if(sp[0] EQ 3) then nt = sp[3]
 nel = sp[2]
 nv = (size(v))[1]

 sub = linegen3x(nv,nel,nt)
 r = dblarr(nv,nel,nt,/nozero)

 for i=0, nel-1 do $
  begin
   MM = (M[*,i,*])[sub]
   r[*,i,*] = total(MM*v,2)
  end

 return, r + p[sub]
end
;===========================================================================
