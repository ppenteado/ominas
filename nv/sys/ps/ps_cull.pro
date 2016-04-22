;=============================================================================
;+
; NAME:
;	ps_cull
;
;
; PURPOSE:
;	Cleans out an array of points structures by removing invisible points
;	and empty points structures.
;
;
; CATEGORY:
;	NV/SYS/PS
;
;
; CALLING SEQUENCE:
;	new_ps = ps_cull(ps)
;
;
; ARGUMENTS:
;  INPUT:
;	ps:	Array of points structures.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	visible:	If set, invisible points are removed.
;
;	nofree:		If set, invalid points structures are not freed.
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Array points structures, or 0 if all were empty.
;
;
;
; MODIFICATION HISTORY:
;  Spitale, 11/2015; 	Adapted from pgs_cull
;	
;-
;=============================================================================
function ps_cull, ps, visible=visible, nofree=nofree
@ps_include.pro

 if(NOT keyword__set(ps)) then return, 0

 ;------------------------
 ; reform to 1D
 ;------------------------
 n = n_elements(ps)
 ps = reform(ps, n, /over)

 ;------------------------------------
 ; get rid of invisible points
 ;------------------------------------
 if(keyword_set(visible)) then $
  for i=0, n-1 do $
   begin
    points = ps_points(ps[i], /visible)
    if(NOT keyword__set(points)) then ps[i] = ptr_new() $
    else $
     begin
      vectors = ps_vectors(ps[i], /visible)
      flags = ps_flags(ps[i], /visible)
      data = ps_data(ps[i], /visible)
      name = cor_name(ps[i], /visible)
      desc = ps_desc(ps[i], /visible)
      input = ps_input(ps[i], /visible)

;;; this won't work becuse can't change numer of points...
;;; need to update nv, nt
      ps_set_points, ps[i], points
      ps_set_vectors, ps[i], vectors
      ps_set_flags, ps[i], flags
      ps_set_data, ps[i], data
      cor_set_name, ps[i], name
      ps_set_desc, ps[i], desc
      ps_set_input, ps[i], input
     end
   end

 ;-----------------------------
 ; mark empty points structs
 ;-----------------------------
 ff = bytarr(n)
 for i=0, n-1 do $
  begin
   if(NOT ps_valid(ps[i])) then ff[i] = 1 $
   else if(ps_nv(ps[i]) EQ 0) then ff[i] = 1
  end

 ;------------------------------------
 ; discard the empty points structs
 ;------------------------------------
 w = where(ff EQ 0)

 if(NOT keyword_set(nofree)) then $
  begin 
   ww = complement(ps, w)
   if(ww[0] NE -1) then nv_free, ps[ww]
  end 

 if(w[0] NE -1) then return, ps[w] else return, 0
end
;===========================================================================
