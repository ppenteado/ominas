;=============================================================================
;+
; points:
;	ps_set_flags
;
;
; PURPOSE:
;	Replaces the flags in a points struct.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	ps_set_flags, ps, flags
;
;
; ARGUMENTS:
;  INPUT:
;	ps:		Points struct.
;
;	flags:		New flags array.
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
;	ps_flags
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale		11/2015
;	
;-
;=============================================================================
pro ps_set_flags, psp, flags, noevent=noevent
@nv.include
 ps = nv_dereference(psp)

 dim = [1]
 if(n_elements(flags) GT 1) then dim = size(flags, /dim)
 ndim = n_elements(dim)
 nv = dim[0]
 nt = 1
 if(ndim GT 1) then nt = dim[1]


 if(NOT ptr_valid(ps.flags_p)) then $
  begin
   ps.nv = nv & ps.nt = nt
   ps.flags_p = nv_ptr_new(flags)
  end $
 else $
  begin
   if((nv NE ps.nv) OR (nt NE ps.nt)) then ps_resize, ps, nv=nv, nt=nt

   *ps.flags_p = flags
  end

 
 nv_rereference, psp, ps
 nv_notify, psp, type = 0, noevent=noevent
 nv_notify, /flush, noevent=noevent
end
;===========================================================================
