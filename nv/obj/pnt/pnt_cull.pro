;=============================================================================
;+
; NAME:
;	pnt_cull
;
;
; PURPOSE:
;	Cleans out an array of POINT object by removing invisible points
;	and/or empty POINT object.
;
;
; CATEGORY:
;	NV/SYS/PS
;
;
; CALLING SEQUENCE:
;	new_ptd = pnt_cull(ptd)
;
;
; ARGUMENTS:
;  INPUT:
;	ptd:	Array of POINT objects.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	visible:	If set, invisible points are removed.
;
;	nofree:		If set, invalid POINT object are not freed.
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Array POINT object, or 0 if all were empty.
;
;
;
; MODIFICATION HISTORY:
;  Spitale, 11/2015; 	Adapted from pgs_cull
;	
;-
;=============================================================================
function pnt_cull, ptd, visible=visible, nofree=nofree
@pnt_include.pro

 if(NOT keyword__set(ptd)) then return, 0

 ;------------------------
 ; reform to 1D
 ;------------------------
 n = n_elements(ptd)
 ptd = reform(ptd, n, /over)

 ;------------------------------------
 ; get rid of invisible points
 ;------------------------------------
 if(keyword_set(visible)) then $
  for i=0, n-1 do $
   begin
    points = pnt_points(ptd[i], /visible)
    if(NOT keyword__set(points)) then ptd[i] = obj_new() $
    else $
     begin
      vectors = pnt_vectors(ptd[i], /visible)
      flags = pnt_flags(ptd[i], /visible)
      data = pnt_data(ptd[i], /visible)
      name = cor_name(ptd[i], /visible)
      desc = pnt_desc(ptd[i], /visible)
      input = pnt_input(ptd[i], /visible)

;;; this won't work because can't change numer of points...
;;; need to update nv, nt
      pnt_set_points, ptd[i], points
      pnt_set_vectors, ptd[i], vectors
      pnt_set_flags, ptd[i], flags
      pnt_set_data, ptd[i], data
      cor_set_name, ptd[i], name
      pnt_set_desc, ptd[i], desc
      pnt_set_input, ptd[i], input
     end
   end

 ;-----------------------------
 ; mark empty POINT objects
 ;-----------------------------
 ff = bytarr(n)
 for i=0, n-1 do $
  begin
   if(NOT pnt_valid(ptd[i])) then ff[i] = 1 $
   else if(pnt_nv(ptd[i]) EQ 0) then ff[i] = 1
  end

 ;------------------------------------
 ; discard the empty POINT objects
 ;------------------------------------
 w = where(ff EQ 0)

 if(NOT keyword_set(nofree)) then $
  begin 
   ww = complement(ptd, w)
   if(ww[0] NE -1) then nv_free, ptd[ww]
  end 

 if(w[0] NE -1) then return, ptd[w] else return, 0
end
;===========================================================================
