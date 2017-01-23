;=============================================================================
;+
; NAME:
;	dat_set_header
;
;
; PURPOSE:
;	Replaces the header array associated with a data descriptor.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	dat_set_header, dd, header
;
;
; ARGUMENTS:
;  INPUT:
;	dd:	Data descriptor.
;
;	header:	New header array.
;
;  OUTPUT:
;	dd:	Modified data descriptor.
;
;
; KEYWORDS:
;  INPUT: 
;	update:	Update mode flag.  If not given, in will be taken from dd.
;
;	silent:	If set, messages are suppressed.
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
;	dat_header
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 2/1998
; 	Adapted by:	Spitale, 5/2016
;	
;-
;=============================================================================
pro dat_set_header, dd, header, silent=silent, update=update, noevent=noevent
@core.include
 _dd = cor_dereference(dd)

 if(NOT defined(update)) then update = _dd.update
 if(update EQ -1) then return


 if((NOT keyword_set(silent)) and (_dd.maintain GT 0)) then $
  nv_message, /con, $
   'WARNING: Changes to header array may be lost due to the maintainance level.'


 ;-----------------------------
 ; modify header array 
 ;-----------------------------
 if(keyword_set(_dd.header_dap)) then dap = _dd.header_dap
 data_archive_set, dap, header, index=_dd.dap_index
 _dd.header_dap = dap
 _dd.dap_index = 0


 ;--------------------------------------------
 ; generate write event
 ;--------------------------------------------
 cor_rereference, dd, _dd
 nv_notify, dd, type = 0, noevent=noevent
 nv_notify, /flush, noevent=noevent

end
;===========================================================================



