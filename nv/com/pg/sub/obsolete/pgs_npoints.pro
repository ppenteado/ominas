;=============================================================================
;+
; NAME:
;	pgs_npoints
;
;
; PURPOSE:
;	Counts points in an array of points structures.
;
;
; CATEGORY:
;	NV/PGS
;
;
; CALLING SEQUENCE:
;	n = pgs_npoints(pp)
;
;
; ARGUMENTS:
;  INPUT: 
;	pp:	Array of points structures
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	visible:	If set, only visible points are counted.
;
;  OUTPUT: NONE
;
;
; RETURN: 
;	Total number of points in the array of points structures.
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
;	
;-
;=============================================================================
function pgs_npoints, pp, visible=visible
nv_message, /con, name='pgs_npoints', 'This routine is obsolete.'
 nv_notify, pp, type = 1

 n = n_elements(pp)
 np = 0

 if(NOT keyword__set(visible)) then $
  begin
   for i=0, n-1 do if(ptr_valid(pp[i].points_p)) then $
                                   np = np + n_elements(*pp[i].points_p)/2
  end $
 else $
  for i=0, n-1 do $
   begin
    pgs_visible_points, pp[i], p=p
    if(keyword__set(p)) then np = np + n_elements(p)/2
   end

 return, np
end
;===========================================================================
