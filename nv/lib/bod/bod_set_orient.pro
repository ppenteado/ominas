;===========================================================================
;+
; NAME:
;	bod_set_orient
;
;
; PURPOSE:
;	Replaces the orientation matrix of each given body descriptor.
;
;
; CATEGORY:
;	NV/LIB/BOD
;
;
; CALLING SEQUENCE:
;	bod_set_orient, bx, orient
;
;
; ARGUMENTS:
;  INPUT: 
;	bx:	 Array (nt) of any subclass of BODY descriptors.
;
;	orient:	 Array (3,3,nt) of new orientation matrices.
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
pro bod_set_orient, bxp, orient, noevent=noevent
@nv_lib.include
 bdp = class_extract(bxp, 'BODY')
 bd = nv_dereference(bdp)

 bd.orient=orient
 if(n_elements(bd) GT 1) then bd.orientT=transpose(orient, [1,0,2]) $
 else bd.orientT=transpose(orient)

 nv_rereference, bdp, bd
 nv_notify, bdp, type = 0, noevent=noevent
end
;===========================================================================
