;=============================================================================
;+
; points:
;	ps_set_points
;
;
; PURPOSE:
;	Replaces the points in a points struct.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	ps_set_points, ps, points
;
;
; ARGUMENTS:
;  INPUT:
;	ps:		Points struct.
;
;	points:		New points array.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	noevent:	If set, no event is generated.
;
;  OUTPUT: NONE
;
;
; RETURN: NONE
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	ps_points
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale		11/2015
;	
;-
;=============================================================================
pro ps_set_points, psp, points, noevent=noevent
@nv.include
 ps = nv_dereference(psp)

 dim = size(points, /dim)
 ndim = n_elements(dim)
 nv = (nt = 1)
 if(ndim GT 1) then nv = dim[1]
 if(ndim GT 2) then nt = dim[2]


 if(NOT ptr_valid(ps.points_p)) then $
  begin
   ps.nv = nv & ps.nt = nt
   ps.points_p = nv_ptr_new(points)
  end $
 else $
  begin
   if((nv NE ps.nv) OR (nt NE ps.nt)) then ps_resize, ps, nv=nv, nt=nt
   *ps.points_p = points
  end


 nv_rereference, psp, ps
 if(NOT keyword_set(noevent)) then $
  begin
   nv_notify, psp, type = 0
   nv_notify, /flush
  end
end
;===========================================================================
