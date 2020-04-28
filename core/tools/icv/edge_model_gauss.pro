;===========================================================================
;+
; NAME:
;       edge_model_gauss
;
;
; PURPOSE:
;	Calculates a gaussian edge model for use in curve fitting.
;
; CATEGORY:
;       NV/LIB/TOOLS/ICV
;
;
; CALLING SEQUENCE:
;       result = edge_model_gauss(n, w)
;
;
; ARGUMENTS:
;  INPUT:
;	    n:	Size of the model in samples
;
;	    w:	Width of the gaussian (sigma)
;
;  OUTPUT:
;	 zero:  The array element corresponding to the phyiscal edge.
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
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Haemmerle, 6/1998
;
;-
;===========================================================================
function edge_model_gauss, n, w, zero=zero, delta=delta, cd=cd
 zero = float(n)/2
 delta=1.0
 return, exp(-((indgen(n)-zero)^2)/(2*w^2))
end
;===========================================================================
