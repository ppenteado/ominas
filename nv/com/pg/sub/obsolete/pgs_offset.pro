;=============================================================================
;+
; NAME:
;	pgs_offset
;
;
; PURPOSE:
;	Offsets points in a pg_points structure.
;
;
; CATEGORY:
;	NV/PGS
;
;
; CALLING SEQUENCE:
;	pgs_offset, pp, offset
;
;
; ARGUMENTS:
;  INPUT:
;	pp:		Points structure.
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
; 	Written by:	Spitale; 4/2015
;	
;-
;=============================================================================
pro pgs_offset, pp, offset, noevent=noevent
nv_message, /con, name='pgs_offset', 'This routine is obsolete.'

print, offset
 if(NOT keyword__set(pp)) then return

 for i=0, n_elements(pp)-1 do $
  begin
   p = *pp[i].points_p
   p = p + offset#make_array(n_elements(p), val=1d)
   *pp[i].points_p = p
  end

 if(NOT keyword_set(noevent)) then nv_notify, pp, type = 0
end
;=============================================================================
