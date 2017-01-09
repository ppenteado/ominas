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
; 	Adapted by:	Spitale, 5/2016
;	
;-
;===========================================================================
pro bod_set_orient, bd, orient, noevent=noevent
@core.include
 _bd = cor_dereference(bd)

 _bd.orient=orient
;;; if(n_elements(_bd) GT 1) then _bd.orientT=transpose(orient, [1,0,2]) $
;;; else _bd.orientT=transpose(orient)

 cor_rereference, bd, _bd
 nv_notify, bd, type = 0, noevent=noevent
end
;===========================================================================
