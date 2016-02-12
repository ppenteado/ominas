;=============================================================================
;+
; NAME:
;	pgs_clone_ps
;
;
; PURPOSE:
;	Clones a points structure.
;
;
; CATEGORY:
;	NV/PGS
;
;
; CALLING SEQUENCE:
;	new_gd = pgs_clone_ps(ps)
;
;
; ARGUMENTS:
;  INPUT:
;	ps:		Points structure to clone.
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
;	A new points structure is created containing fields identical
;	to the input points structure.
;
;
; SEE ALSO:
;	pgs_copy_ps
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
;	
;-
;=============================================================================
function pgs_clone_ps, ps
nv_message, /con, name='pgs_clone_ps', 'This routine is obsolete.  Use NV_CLONE instead.'

 if(NOT keyword__set(ps)) then return, 0

 new_ps = replicate({pg_points_struct}, n_elements(ps))
 for i=0, n_elements(ps)-1 do new_ps[i].udata_tlp = tag_list_clone(ps[i].udata_tlp)
;stop
 pgs_copy_ps, new_ps, ps


 return, new_ps
end
;==============================================================================
