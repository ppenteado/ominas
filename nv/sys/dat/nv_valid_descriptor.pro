;=============================================================================
;+
; NAME:
;	nv_valid_descriptor
;
;
; PURPOSE:
;	Determines whether the argument is a valid data descriptor,
;	or data descriptor structure.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	test = nv_valid_descriptor(dd)
;
;
; ARGUMENTS:
;  INPUT:
;	dd:	Data descriptor to test.
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
;	True if the argument is a data descriptr structure or a
;	pointer to one.
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
function nv_valid_descriptor, ddp

 if(size(ddp[0], /type) EQ 10) then dd = *ddp[0] $
 else dd = ddp[0]

 if(size(dd, /type) NE 8) then return, 0

 fields = tag_names(dd)
 if((where(strupcase(fields) EQ 'DATA_DAP'))[0] EQ -1) then return, 0

 return, 1
end
;=============================================================================
