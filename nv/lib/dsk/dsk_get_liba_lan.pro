;=============================================================================
;+
; NAME:
;	dsk_get_liba_lan
;
;
; PURPOSE:
;	Determines liba_lan for each given disk descriptor, based on the
;	orientation of its BODY axes.
;
;
; CATEGORY:
;	NV/LIB/DSK
;
;
; CALLING SEQUENCE:
;	liba_lan = dsk_liba_lan(dkx, frame_bd)
;
;
; ARGUMENTS:
;  INPUT: NONE
;	dkx:	 Array (nt) of any subclass of DISK.
;
;	frame_bd:	Subclass of BODY giving the frame against which to 
;			measure inclinations and nodes, e.g., a planet 
;			descriptor.  One for each dkx.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;
;  OUTPUT: NONE
;
;
; RETURN:
;	liba_lan value associated with each given disk descriptor.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/1998
;	
;-
;=============================================================================
function dsk_get_liba_lan, dkx, frame_bd
@nv_lib.include
 dkd = class_extract(dkx, 'DISK')

 if(NOT keyword_set(frame_bd)) then $
             nv_message, name='dsk_get_liba_lan', 'frame_bd required.'


 liba_lan = orb_get_liba_lan(dkd, frame_bd)

 return, liba_lan
end
;===========================================================================
