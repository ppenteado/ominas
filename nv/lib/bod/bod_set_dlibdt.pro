;===========================================================================
;+
; NAME:
;	bod_set_dlibdt
;
;
; PURPOSE:
;       Replaces the frequency of each libration vector for each given
;       body descriptor.
;
;
; CATEGORY:
;	NV/LIB/BOD
;
;
; CALLING SEQUENCE:
;	bod_set_dlibdt, bx, dlibdt
;
;
; ARGUMENTS:
;  INPUT: 
;	bx:	 Array (nt) of any subclass of BODY descriptors.
;
;	dlibdt:	 Array (ndv,nt) of new frequencies.
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
pro bod_set_dlibdt, bxp, dlibdt, noevent=noevent
@nv_lib.include
 bdp = class_extract(bxp, 'BODY')
 bd = nv_dereference(bdp)

 bd.dlibdt=dlibdt

 nv_rereference, bdp, bd
 nv_notify, bdp, type = 0, noevent=noevent
end
;===========================================================================
