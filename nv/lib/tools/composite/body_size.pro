;=============================================================================
;+
; NAME:
;       body_size
;
;
; PURPOSE:
;	Returns the sizes of the given bodies.
;
;
; CATEGORY:
;       NV/LIB/TOOLS/COMPOSITE
;
;
; CALLING SEQUENCE:
;       body_size(bx)
;
;
; ARGUMENTS:
;  INPUT:
;	bx:      Globe or Disk descriptor; nt.
;
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;   INPUT: NONE
;
;   OUTPUT: NONE
;
;
; RETURN: 
;	nt-element array giving the size of each body.
;
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale
;-
;=============================================================================
function body_size, bx

 nt = n_elements(bx)
 size = dblarr(nt)

 gbx = class_extract(bx, 'GLOBE', ind=ii)
 if(keyword_set(gbx)) then size[ii] = (glb_radii(bx))[0,ii]

 dkx = class_extract(bx, 'DISK', ind=ii)
 if(keyword_set(dkx)) then size[ii] = $
                  (dsk_sma(dkx))[0,1,ii] * (1d + (dsk_ecc(dkx))[0,1,ii])

 return, size
end
;=============================================================================
