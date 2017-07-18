;=============================================================================
;+
; NAME:
;       surface_to_degrees
;
;
; PURPOSE:
;       Converts angular part of surface vectors from radians to degrees
;
;
; CATEGORY:
;       NV/LIB/TOOLS
;
;
; CALLING SEQUENCE:
;       result = surface_to_degrees(v)
;
;
; ARGUMENTS:
;  INPUT:
;              v:       An array of surface vectors (nv,3,nt).
;
;  OUTPUT:
;       NONE
;
; RETURN:
;       Array of vectors (nv,3,nt)
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale		11/12/01
;-
;=============================================================================
function  surface_to_degrees, v

 vv = v
 vv[*,0:1,*] = vv[*,0:1,*]*180d/!dpi

 return, vv
end
;==========================================================================
