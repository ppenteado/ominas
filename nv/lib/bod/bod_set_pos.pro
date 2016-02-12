;===========================================================================
;+
; NAME:
;	bod_set_pos
;
;
; PURPOSE:
;       Replaces the position of body center (in the inertial frame)
;       of each given body descriptor.
;
;
; CATEGORY:
;	NV/LIB/BOD
;
;
; CALLING SEQUENCE:
;	bod_set_pos, bx, pos
;
;
; ARGUMENTS:
;  INPUT: 
;	bx:	 Array (nt) of any subclass of BODY descriptors.
;
;	pos:	 Array (1,3,nt) of new position vectors.
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
;	
;-
;===========================================================================
pro bod_set_pos, bxp, pos
@nv_lib.include
 bdp = class_extract(bxp, 'BODY')
 bd = nv_dereference(bdp)

 bd.pos=pos

 nv_rereference, bdp, bd
 nv_notify, bdp, type = 0
end
;===========================================================================
