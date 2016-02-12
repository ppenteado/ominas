;=============================================================================
;+
; NAME:
;	ps_offset
;
;
; PURPOSE:
;	Offsets points in a points structure.
;
;
; CATEGORY:
;	NV/SYS/PS
;
;
; CALLING SEQUENCE:
;	ps_offset, ps, offset
;
;
; ARGUMENTS:
;  INPUT:
;	ps:		Points structure.
;
;	offset:		Offset to apply.
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
; RETURN: NONE.
;
;
;
; MODIFICATION HISTORY:
;  Spitale, 11/2015; 	Adapted from pgs_offset
;	
;-
;=============================================================================
pro ps_offset, ps, offset, noevent=noevent

 if(NOT keyword__set(ps)) then return

 for i=0, n_elements(ps)-1 do $
  begin
   p = *ps[i].points_p
   p = p + offset#make_array(n_elements(p), val=1d)
   *ps[i].points_p = p
  end

 if(NOT keyword_set(noevent)) then nv_notify, ps, type = 0
end
;=============================================================================
