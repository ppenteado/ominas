;=============================================================================
;+
; NAME:
;	_pnt_nv
;
;
; PURPOSE:
;	Returns the nv dimension of a POINT structure.
;
;
; CATEGORY:
;	NV/OBJ/PNT
;
;
; CALLING SEQUENCE:
;	nv = _pnt_nv(_ptd)
;
;
; ARGUMENTS:
;  INPUT:
;	_ptd:	POINT structure.
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
;	The nv dimensions of the POINT structure.
;
;
; STATUS:
;	Complete
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/2017
;	
;-
;=============================================================================
function _pnt_nv, _ptd, condition=condition

 if(NOT keyword_set(condition)) then return, _ptd.nv
 if(NOT ptr_valid(_ptd.flags_p)) then return, _ptd.nv

 n_ptd = n_elements(_ptd)
 nv = lonarr(n_ptd)

 for i=0, n_ptd-1 do $
  begin
   ii = _pnt_apply_condition(_ptd[i], condition)
   if(ii[0] NE -1) then nv[i] = (size(ii, /dim))[0]
  end

 if(n_ptd EQ 1) then nv = nv[0]
 return, nv
end
;===========================================================================



