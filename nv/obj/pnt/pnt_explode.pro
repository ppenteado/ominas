;=============================================================================
;+
; vectors:
;	pnt_explode
;
;
; PURPOSE:
;	Explodes a POINT object into single-point objects.
;
;
; CATEGORY:
;	NV/SYS/PS
;
;
; CALLING SEQUENCE:
;	xptd = pnt_explode(ptd)
;
;
; ARGUMENTS:
;  INPUT:
;	ptd:		POINT object.
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
;	Array (nv x nt) of POINT object, each containing a single point.
;
;
; STATUS:
;	Complete
;
;
;
;
; MODIFICATION HISTORY:
; 	Adapted from pgs_explode:	Spitale, 11/2015
;	
;-
;=============================================================================
function pnt_explode, ptd

 pnt_get, ptd, nv=nv, nt=nt, $
        name=name, desc=desc, input=input, assoc_idp=assoc_idp, $
        flags=flags, points=points, vectors=vectors, data=data, tags=tags

 pptd = objarr(nv, nt)

 for i=0, nv-1 do $
  for j=0, nt-1 do $
   begin
    pptd[i,j] = nv_clone(ptd)

    pnt_set_flags, pptd[i,j], flags[i,j], /noevent
    if(keyword_set(points)) then pnt_set_points, pptd[i,j], points[*,i,j], /noevent
    if(keyword_set(vectors)) then pnt_set_vectors, pptd[i,j], vectors[i,*,j], /noevent
    if(keyword_set(data)) then pnt_set_data, pptd[i,j], data[*,i,j], /noevent

    cor_set_udata, pptd[i,j], '', tag_list_clone(cor_udata(ptd))
   end

 return, pptd
end
;==============================================================================
