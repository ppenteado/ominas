;=============================================================================
;+
; NAME:
;	icv_chisq
;
;
; PURPOSE:
;	Computes chi-squared value for given curve fit parameters.
;
;
; CATEGORY:
;	NV/LIB/TOOLS/ICV
;
;
; CALLING SEQUENCE:
;	result = icv_chisq(dxy, dtheta, fix, cos_alpha, sin_alpha, scan_offsets)
;
;
; ARGUMENTS:
;  INPUT:
;	dxy:		Array (2) giving x- and y-offset solution.
;
;	dtheta:		Scalar giving theta-offset solution.
;
;	fix:		Array specifying which parameters to fix as
;			[dx,dy,dtheta].
;
;	cos_alpha:	Array (n_points) of direction cosines computed by
;			icv_compute_directions.
;
;	sin_alpha:	Array (n_points) of direction sines computed by
;			icv_compute_directions.
;
;	scan_offsets:	Array (n_points) containing offset of best correlation 
;			at each point on the curve.  Produced by icv_scan_strip.
;
;	scan_pts:	Array (2, n_points) of image coordinates corresponding
;			to each scan offset.
;
;	axis:		Array (2) giving image coordinates of rotation axis
;			in the case of a 3-parameter fit.
;
;  OUTPUT: NONE
;
;
; KEYWORDS: 
;  INPUT:
;	norm:		If set, the returned value is normalized by dividing
;			it by the number of degrees of freedom.
;
;  OUTPUT: NONE
;
;
; RETURN:
;	The chi-squared value is returned.
;
;
; STATUS:
;	Complete.
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 6/1998
;	
;-
;=============================================================================
function icv_chisq, dxy, dtheta, fix, $
                    cos_alpha, sin_alpha, scan_offsets, scan_pts, axis, $
                    norm=norm

 n = n_elements(sin_alpha)
 nfix = n_elements(fix)

 d = scan_offsets
 R = scan_pts - axis#make_array(n,val=1)
 Q = -cos_alpha*R[1,*] + sin_alpha*R[0,*]


 chisq = total( (d - dxy[0]*cos_alpha - dxy[1]*sin_alpha - dtheta*Q)^2 ) 

 if(keyword__set(norm)) then chisq = chisq / (n - nfix)

 return, chisq
end
;===========================================================================
