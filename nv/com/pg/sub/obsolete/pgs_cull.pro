;=============================================================================
;+
; NAME:
;	pgs_cull
;
;
; PURPOSE:
;	Cleans out an array of points structures by removing invisible points
;	and empty points structures.
;
;
; CATEGORY:
;	NV/PGS
;
;
; CALLING SEQUENCE:
;	new_pp = pgs_cull(pp)
;
;
; ARGUMENTS:
;  INPUT:
;	pp:	Array of points structures.
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
;	Array points structures, or 0 if all were empty.
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
;	
;-
;=============================================================================
function pgs_cull, pp, null=null, visible=visible
@pgs_include.pro
nv_message, /con, name='pgs_cull', 'This routine is obsolete.'

 if(NOT keyword__set(pp)) then return, 0

 ;------------------------
 ; reform to 1D
 ;------------------------
 n = n_elements(pp)
 pp = reform(pp, n, /over)

 ;------------------------------------
 ; get rid of invisible points
 ;------------------------------------
 if(keyword_set(visible)) then $
  for i=0, n-1 do $
   begin
    pgs_visible_points, pp[i], $
	points=points, $
	vectors=vectors, $
	flags=flags, $
	data=data, name=name, desc=desc, input=input
    if(NOT keyword__set(points)) then pp[i] = pgs_null() $
    else pp[i] = pgs_set_points(pp[i], $
	points=points, $
	vectors=vectors, $
	flags=flags, $
	data=data, name=name, desc=desc, input=input)
   end

 ;-----------------------------
 ; mark empty points structs
 ;-----------------------------
 ff = bytarr(n)
 for i=0, n-1 do $
  begin
   if(NOT pgs_valid(pp[i])) then ff[i] = 1 $
   else $
    begin
     pgs_size, pp[i], nn=nn
     if(nn EQ 0) then ff[i] = 1
    end
  end

 ;------------------------------------
 ; discard the empty points structs
 ;------------------------------------
 w = where(ff EQ 0)
; if(w[0] NE -1) then pp = pp[w] else pp = pgs_null()
 if(w[0] NE -1) then return, pp[w] else return, 0


end
;===========================================================================
