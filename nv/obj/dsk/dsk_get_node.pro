;=============================================================================
;+
; NAME:
;	dsk_get_node
;
;
; PURPOSE:
;	Computes the ascending node of the given disk wrt the given frame
;	body descriptor.
;
;
; CATEGORY:
;	NV/LIB/DSK
;
;
; CALLING SEQUENCE:
;	node = dsk_get_node(dkd, frame_bd)
;
;
; ARGUMENTS:
;  INPUT:
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
;  INPUT:  NONE
;
;  OUTPUT: NONE
;
;
; RETURN:
;	One unit vector for each input descriptor pointng along the
;	ascending node of each given disk on each given frame
;	body descriptor.
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
; 	Adapted by:	Spitale, 5/2016
;	
;-
;=============================================================================
function dsk_get_node, dkd, frame_bd
@core.include

 if(NOT keyword_set(frame_bd)) then $
             nv_message, name='dsk_get_node', 'frame_bd required.'

 node = orb_get_ascending_node(dkd, frame_bd)

 return, node
end
;===========================================================================



