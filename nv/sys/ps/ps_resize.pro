;=============================================================================
;+
; points:
;	ps_resize
;
;
; PURPOSE:
;	Resizes a points struct.  Arrays are padded with zeroes or truncated
;	as needed.
;
;
; CATEGORY:
;	NV/SYS/PS
;
;
; CALLING SEQUENCE:
;	ps_resize, ps, nv=nv, nt=nt
;
;
; ARGUMENTS:
;  INPUT:
;	ps:		Points struct.  Note this is an actual points struct
;			rather than a pointer to one, as this routine is only
;			meant to be called internally.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	nv.nt:		New nv, nt.
;
;	noevent:	If set, no event is generated.
;
;  OUTPUT: NONE
;
;
; RETURN: NONE
;
;
; STATUS:
;	Complete;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale		12/2015
;	
;-
;=============================================================================
pro ps_resize, ps, nv=nv, nt=nt

 if(NOT keyword_set(nt)) then nt = 1

 if(ptr_valid(ps.points_p)) then $
        *ps.points_p = resize_array(*ps.points_p, [2,nv,nt])
 if(ptr_valid(ps.vectors_p)) then $
        *ps.vectors_p = resize_array(*ps.vectors_p, [nv,3,nt])
 if(ptr_valid(ps.flags_p)) then $
        *ps.flags_p = resize_array(*ps.flags_p, [nv,nt])
 if(ptr_valid(ps.data_p)) then $
  begin
   ndat = (size(*ps.data_p, /dim))[0]
   *ps.data_p = resize_array(*ps.data_p, [ndat,nv,nt])
  end

end
;===========================================================================
