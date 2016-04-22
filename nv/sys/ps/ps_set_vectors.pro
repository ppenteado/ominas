;=============================================================================
;+
; points:
;	ps_set_vectors
;
;
; PURPOSE:
;	Replaces the vectors in a points struct.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	ps_set_vectors, ps, vectors
;
;
; ARGUMENTS:
;  INPUT:
;	ps:		Points struct.
;
;	vectors:	New vectors array.
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
;	ps_vectors
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale		11/2015
;	
;-
;=============================================================================
pro ps_set_vectors, psp, vectors, noevent=noevent
@nv.include
 ps = nv_dereference(psp)

 dim = size(vectors, /dim)
 ndim = n_elements(dim)
 nv = (nt = 1)
 nv = dim[0]
 if(ndim GT 2) then nt = dim[2]


 if(NOT ptr_valid(ps.vectors_p)) then $
  begin
   ps.nv = nv & ps.nt = nt
   ps.vectors_p = nv_ptr_new(vectors)
  end $
 else $
  begin
   if((nv NE ps.nv) OR (nt NE ps.nt)) then ps_resize, ps, nv=nv, nt=nt

   *ps.vectors_p = vectors
  end


 nv_rereference, psp, ps
 nv_notify, psp, type = 0, noevent=noevent
 nv_notify, /flush, noevent=noevent
end
;===========================================================================
