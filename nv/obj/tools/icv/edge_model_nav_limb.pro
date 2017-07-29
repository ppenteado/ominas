;===========================================================================
;+
; NAME:
;       edge_model_nav_limb
;
;
; PURPOSE:
;	Returns the edge model used by the VICAR program NAV for limb fits.
;
; CATEGORY:
;       NV/LIB/TOOLS/ICV
;
;
; CALLING SEQUENCE:
;       result = edge_model_nav_limb()
;
;
; ARGUMENTS:
;  INPUT:
;	    NONE
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
function edge_model_nav_limb, zero=zero, delta=delta, cd=cd

 ;--------------------------------------------------------------------
 ; 4/8/98 - Haemmerle speculates that the edge occurs at the point
 ;          where the model crosses the mean.  This hasn't been 
 ;          verified.
 ;
 ;          Also, these points are given at 1/2 pixel intervals
 ;          so delta=0.5
 ;--------------------------------------------------------------------
 zero = 10.24
 delta = 0.5


 nav_model = $
	[15.2,15.5,15.9,16.3,16.8,17.4,18.2,19.4,21.2,24.1, $
	 30.4,42.4,63.6,93.8,131.2,169.5,202.3,225.9,243.8, $
	 258.0,268.8,277.1,283.6,289.8,295.1]

 return, rotate(nav_model, 2)
end
;===========================================================================
