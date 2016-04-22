;=============================================================================
;+
; NAME:
;	nv_directive_stop__define
;
;
; PURPOSE:
;	Structure defining the NV_STOP directive.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	N/A 
;
;
; FIELDS:
;	directive:	String giving the directive.
;
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
pro nv_directive_stop__define

 struct = {nv_directive_stop, directive:0, nv_stop:0}

end
;===========================================================================



