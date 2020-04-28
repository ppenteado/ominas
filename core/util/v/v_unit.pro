;=============================================================================
;+
; NAME:
;       v_unit
;
;
; PURPOSE:
;       Returns unit vectors in the directions given by v.
;
;
; CATEGORY:
;       UTIL/V
;
;
; CALLING SEQUENCE:
;       result = v_unit(v)
;
;
; ARGUMENTS:
;  INPUT:
;       v:     An array of nv x nt column vectors (i.e. nv x 3 x nt).
;
;  OUTPUT:
;       NONE
;
; RETURN:
;       An array of nv x nt unit vectors
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
function v_unit, v, mag=vmag

 dim = size(v, /dim)
 nv = dim[0]
 nt = 1
 if(n_elements(dim) GT 2) then nt = dim[2]

 vmag = sqrt(total(v*v, 2))

 w = where(vmag EQ 0)
 if(w[0] NE -1) then vmag[w] = 1d

 u = v
 u[*,0,*] = v[*,0,*]/vmag
 u[*,1,*] = v[*,1,*]/vmag
 u[*,2,*] = v[*,2,*]/vmag

 if(w[0] NE -1) then u[colgen(nv,3,nt, w)] = 0

 return, u
end
;===========================================================================
