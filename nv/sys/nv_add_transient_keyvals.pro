;=============================================================================
;+
; NAME:
;	nv_add_transient_keyvals
;
;
; PURPOSE:
;	Records keyword/value pairs from a transient argument string.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	nv_add_transient_keyvals, dd, trs
;
;
; ARGUMENTS:
;  INPUT:
;	dd:	Data descriptor in which to record transient keyvals.
;
;	trs:	Transient argument string.
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
; RETURN: NONE
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
;	
;-
;=============================================================================
pro nv_add_transient_keyvals, dd, trs
@nv.include

 if(ptr_valid(dd.transient_keyvals_p)) then nv_ptr_free, dd.transient_keyvals_p

 ;--------------------------------------------
 ; parse any transient keyvals
 ;--------------------------------------------
 if(keyword_set(trs)) then $
  begin
   keyvals = transpose(nv_parse_transient_keyvals(trs))
   if(keyword_set(keyvals)) then $
                   dd.transient_keyvals_p = nv_ptr_new(nv_parse_keyvals(keyvals))
  end


end
;===========================================================================




