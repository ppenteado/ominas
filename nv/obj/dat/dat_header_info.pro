;=============================================================================
;+
; NAME:
;	dat_header_info
;
;
; PURPOSE:
;	Obtains header info specific to the given data descriptorby calling
;	an application-speciic header program.
;
;
; CATEGORY:
;	NV/SYS
;
;
; CALLING SEQUENCE:
;	info = dat_header_info(dd)
;
;
; ARGUMENTS:
;  INPUT:
;	dd:	Data descriptor.
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
;	Anonymous structure containing info relevant to the calling application.
;	An application specific program named <instrument>_<filetype>_header_info()
;	Is called with the header as the only argmuent.  The output of that
;	program is returned by DAT_HEADER_INFO.
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	dat_set_header
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 9/2017
;	
;-
;=============================================================================
function dat_header_info, dd, noevent=noevent
@core.include
 nv_notify, dd, type = 1, noevent=noevent

 _dd = cor_dereference(dd)

 header = dat_header(_dd, noevent=noevent)
 if(NOT keyword_set(header)) then return, 0

 instrument = dat_instrument(_dd, noevent=noevent)
 htype = dat_htype(_dd, noevent=noevent)

 fn = strupcase(instrument) + '_' + strupcase(htype) + '_' + 'header_info'
 return, call_function(fn, dd)
end
;===========================================================================



