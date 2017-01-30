;=============================================================================
;+
; NAME:
;	_pnt_nt
;
;
; PURPOSE:
;	Returns the nt dimension of a POINT structure.
;
;
; CATEGORY:
;	nt/SYS/PS
;
;
; CALLING SEQUENCE:
;	nt = _pnt_nt(_ptd)
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
;	The nt dimensions of the POINT structure.
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
function _pnt_nt, _ptd, condition=condition

 if(NOT keyword_set(condition)) then return, _ptd.nt
 if(NOT ptr_valid(_ptd.flags_p)) then return, _ptd.nt

 n_ptd = n_elements(_ptd)
 nt = lonarr(n_ptd)

 for i=0, n_ptd-1 do $
  begin
   ii = _pnt_apply_condition(_ptd[i], condition)
   if(ii[0] NE -1) then nt[i] = (size(ii, /dim))[0]
  end

 if(n_ptd EQ 1) then nt = nt[0]
 return, nt
end
;===========================================================================



