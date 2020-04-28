;===========================================================================
;+
; NAME:
;       edge_model_atan
;
;
; PURPOSE:
;	Calculates an arctan edge model for use in curve fitting.
;
; CATEGORY:
;       NV/LIB/TOOLS/ICV
;
;
; CALLING SEQUENCE:
;       result = edge_model_atan(n, w)
;
;
; ARGUMENTS:
;  INPUT:
;	    n:	Size of the model in samples
;
;	    a:	Scaling factor: larger values give a sharper edge.
;
;  OUTPUT:
;	 zero:  The array element corresponding to the physical edge.
;
;	delta:	The number of pixels represented by each element
;		Currently = 1.0
;
;	cd:	Not used.
;
;
; RETURN:
;	An array containing the model.
;
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale, 6/1998
;
;-
;===========================================================================
function edge_model_atan, n, a, zero=zero, delta=delta, cd=cd
 zero = float(n)/2
 delta=1.0
 return, !pi/2. - atan(indgen(n)*a-n*a/2)
end
;===========================================================================
