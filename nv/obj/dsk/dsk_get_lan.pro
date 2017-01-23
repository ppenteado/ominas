;=============================================================================
;+
; NAME:
;	dsk_get_lan
;
;
; PURPOSE:
;	Determines lan for each given disk descriptor, based on the
;	orientation of its BODY axes.
;
;
; CATEGORY:
;	NV/LIB/DSK
;
;
; CALLING SEQUENCE:
;	lan = dsk_lan(dkd, frame_bd)
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
;	lan value associated with each given disk descriptor.  One for each dkd.
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
function dsk_get_lan, dkd, frame_bd
@core.include
 

 if(NOT keyword_set(frame_bd)) then nv_message, 'frame_bd required.'


 ref0 = orb_get_ascending_node(frame_bd, bod_inertial())
 lan = orb_get_lan(dkd, frame_bd, ref=ref0)

 return, lan
end
;===========================================================================
