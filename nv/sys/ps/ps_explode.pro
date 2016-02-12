;=============================================================================
;+
; vectors:
;	ps_explode
;
;
; PURPOSE:
;	Explodes a points structures into single-point structures.
;
;
; CATEGORY:
;	NV/SYS/PS
;
;
; CALLING SEQUENCE:
;	xps = ps_explode(ps)
;
;
; ARGUMENTS:
;  INPUT:
;	ps:		Points structure.
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
;	Array (nv x nt) of point structures, each containing a single point.
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
function ps_explode, ps

 ps_get, ps, nv=nv, nt=nt, $
        name=name, desc=desc, input=input, assoc_idp=assoc_idp, $
        flags=flags, points=points, vectors=vectors, data=data, tags=tags

 pps = ptrarr(nv, nt)

 for i=0, nv-1 do $
  for j=0, nt-1 do $
   begin
    pps[i,j] = ps_template(ps)

    ps_set_flags, pps[i,j], flags[i,j], /noevent
    if(keyword_set(points)) then ps_set_points, pps[i,j], points[*,i,j], /noevent
    if(keyword_set(vectors)) then ps_set_vectors, pps[i,j], vectors[i,*,j], /noevent
    if(keyword_set(data)) then ps_set_data, pps[i,j], data[*,i,j], /noevent

    ps_set_udata, pps[i,j], tag_list_clone(ps_udata(ps))
   end

 return, pps
end
;==============================================================================
