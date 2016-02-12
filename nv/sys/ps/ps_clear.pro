;==============================================================================
;+
; NAME:
;	ps_clear
;
;
; PURPOSE:
;	Clears all points structure fields anf frees pointers.
;
;
; CATEGORY:
;	NV/SYS/PS
;
;
; CALLING SEQUENCE:
;	ps_clear, ps
;
;
; ARGUMENTS:
;  INPUT:
;	ps:	        Points structure to clear.
;
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
; MODIFICATION HISTORY:
;  Spitale, 12/2015
;	
;-
;==============================================================================
pro ps_clear, psp, noevent=noevent
 if(NOT keyword_set(noevent)) then nv_notify, psp, type = 1
 ps = nv_dereference(psp)

 ps.name = ''
 ps.desc = ''
 ps.input = ''
 ps.nv = 0
 ps.nt = 0
 ps.assoc_idp = ptr_new()

 nv_free, ps.points_p & ps.points_p = ptr_new()
 nv_free, ps.vectors_p & ps.vectors_p = ptr_new()
 nv_free, ps.flags_p & ps.flags_p = ptr_new()
 nv_free, ps.tags_p & ps.tags_p = ptr_new()
 nv_free, ps.udata_tlp & ps.udata_tlp = ptr_new()


end
;===========================================================================
