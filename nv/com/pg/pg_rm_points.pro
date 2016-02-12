;=============================================================================
;++
; NAME:
;	pg_rm_points
;
;
; PURPOSE:
;	xx
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	result = xx(xx, xx)
;	xx, xx, xx
;
;
; ARGUMENTS:
;  INPUT:
;	xx:	xx
;
;	xx:	xx
;
;  OUTPUT:
;	xx:	xx
;
;	xx:	xx
;
;
; KEYWORDS:
;  INPUT:
;	xx:	xx
;
;	xx:	xx
;
;  OUTPUT:
;	xx:	xx
;
;	xx:	xx
;
;
; ENVIRONMENT VARIABLES:
;	xx:	xx
;
;	xx:	xx
;
;
; RETURN:
;	xx
;
;
; COMMON BLOCKS:
;	xx:	xx
;
;	xx:	xx
;
;
; SIDE EFFECTS:
;	xx
;
;
; RESTRICTIONS:
;	xx
;
;
; PROCEDURE:
;	xx
;
;
; EXAMPLE:
;	xx
;
;
; STATUS:
;	xx
;
;
; SEE ALSO:
;	xx, xx, xx
;
;
; MODIFICATION HISTORY:
; 	Written by:	xx, xx/xx/xxxx
;	
;-
;=============================================================================
function pg_rm_points, ps, xps, radius=radius
@ps_include.pro

 if(NOT keyword_set(radius)) then radius = 10

 n = n_elements(ps)

 xpts = pg_points(xps)

 for i=0, n-1 do $
  begin
   ps_get, ps[i], p=p, f=f
   w = near_points(p, xpts, radius)
   if(w[0] NE -1) then $
    begin
     f[w] = f[w] OR PS_MASK_INVISIBLE
     ps_set, ps[i], p=p, f=f)
    end
  end

 return, ps
end
;=============================================================================
