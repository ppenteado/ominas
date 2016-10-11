;=============================================================================
;+
; NAME:
;	pnt_explode
;
;
; PURPOSE:
;	Explodes a POINT object into single-point objects.
;
;
; CATEGORY:
;	NV/OBJ/PNT
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
;  INPUT: 
;	n:	If given, new objects will have nv = n instead of nv = 1.
;		nv must be divisible by n.
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Array (nv/n x nt) of POINT objects, each containing a n points.
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
function pnt_explode, ptd, n=n

 if(NOT keyword_set(n)) then n = 1
 n = long(n)

 pnt_get, ptd, nv=nv, nt=nt, $
        name=name, desc=desc, input=input, assoc_xd=assoc_xd, $
        flags=flags, points=points, vectors=vectors, data=data, tags=tags

 nvv = nv/n
 pptd = objarr(nvv, nt)

 for i=0, nvv-1 do $
  begin
   ii = lindgen(n)+i*n
   for j=0, nt-1 do $
    begin
     pptd[i,j] = nv_clone(ptd)

     pnt_set_flags, pptd[i,j], flags[ii,j], /noevent
     if(keyword_set(points)) then pnt_set_points, pptd[i,j], points[*,ii,j], /noevent
     if(keyword_set(vectors)) then pnt_set_vectors, pptd[i,j], vectors[ii,*,j], /noevent
     if(keyword_set(data)) then pnt_set_data, pptd[i,j], data[*,ii,j], /noevent

     cor_set_udata, pptd[i,j], '', tag_list_clone(cor_udata(ptd))
    end
  end

 return, pptd
end
;==============================================================================
