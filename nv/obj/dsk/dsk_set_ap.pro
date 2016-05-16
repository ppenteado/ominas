;=============================================================================
;+
; NAME:
;	dsk_set_ap
;
;
; PURPOSE:
;	Replaces ap in each given disk descriptor.
;
;
; CATEGORY:
;	NV/LIB/DSK
;
;
; CALLING SEQUENCE:
;	dsk_set_ap, bx, ap
;
;
; ARGUMENTS:
;  INPUT: 
;	dkd:	 Array (nt) of any subclass of DISK.
;
;	ap:	 New ap value.
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
; 	Written by:	Spitale, 1/1998
; 	Adapted by:	Spitale, 5/2016
;	
;-
;=============================================================================
pro dsk_set_ap, dkd, ap, frame_bd
@core.include
 

 if(NOT keyword_set(frame_bd)) then $
             nv_message, name='dsk_set_ap', 'frame_bd required.'

 orb_set_ap, dkd, frame_bd, ap

end
;===========================================================================
