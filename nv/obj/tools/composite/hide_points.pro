;=============================================================================
;+
; NAME:
;       hide_points
;
;
; PURPOSE:
;	Hides points with respect to given object and observer.
;
; CATEGORY:
;       NV/LIB/TOOLS/COMPOSITE
;
;
; CALLING SEQUENCE:
;       result = hide_points(bx, r, p)
;
;
; ARGUMENTS:
;  INPUT:
;	bx:	Array (nt) of any subclass of BODY.
;
;	r:	Columns vector giving the BODY-frame position of the viewer.
;
;	p:	Array (nv) of BODY-frame vectors giving the points to hide.
;
;  OUTPUT:
;       NONE
;
; KEYWORDS:
;   INPUT: 
;	rm:	If set, points are flagged for being in front of or behind
;		the globe, rather then just behind it.
;
;   OUTPUT: NONE
;
;
; RETURN:
;	Subscripts of the points in p that are hidden by the object.  
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale	3/2017
;-
;=============================================================================
function hide_points, bx, r, p, rm=rm

 if(NOT keyword_set(p)) then return, 0

 class = (cor_class(bx))[0]

 gbx = cor_select(bx, 'GLOBE', /class)
 dkx = cor_select(bx, 'DISK', /class)

 if(keyword_set(gbx)) then return, glb_hide_points(bx, r, p, rm=rm)
 if(keyword_set(dkx)) then return, dsk_hide_points(bx, r, p, rm=rm)

end
;==========================================================================
