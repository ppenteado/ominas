;=============================================================================
;+
; NAME:
;	dsk_get_dapdt
;
;
; PURPOSE:
;	Determines dapdt for each given disk descriptor, based on the
;	orientation of its BODY axes.
;
;
; CATEGORY:
;	NV/LIB/DSK
;
;
; CALLING SEQUENCE:
;	dapdt = dsk_dapdt(dkd, frame_bd)
;
;
; ARGUMENTS:
;  INPUT: NONE
;	dkd:	 Array (nt) of any subclass of DISK.
;
;	frame_bd:	Subclass of BODY giving the frame against which to 
;			measure inclinations and nodes, e.g., a planet 
;			descriptor.  One for each dkd.
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
;	dapdt value associated with each given disk descriptor.  One for each dkd.
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
function dsk_get_dapdt, dkd, frame_bd
@core.include
 

 if(NOT keyword_set(frame_bd)) then $
             nv_message, name='dsk_get_dapdt', 'frame_bd required.'

 dapdt = orb_get_dapdt(dkd, frame_bd)

 return, dapdt
end
;===========================================================================



