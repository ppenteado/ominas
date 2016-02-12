;=============================================================================
;+
; NAME:
;	dsk_get_dlandt
;
;
; PURPOSE:
;	Determines dlandt for each given disk descriptor, based on the
;	orientation of its BODY axes.
;
;
; CATEGORY:
;	NV/LIB/DSK
;
;
; CALLING SEQUENCE:
;	dlandt = dsk_dlandt(dkx, frame_bd)
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
;	dlandt value associated with each given disk descriptor.  One for each dkx.
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
function dsk_get_dlandt, dkx, frame_bd
@nv_lib.include
 dkd = class_extract(dkx, 'DISK')

 if(NOT keyword_set(frame_bd)) then $
             nv_message, name='dsk_get_dlandt', 'frame_bd required.'


 dlandt = orb_get_dlandt(dkd, frame_bd)

 return, dlandt
end
;===========================================================================
