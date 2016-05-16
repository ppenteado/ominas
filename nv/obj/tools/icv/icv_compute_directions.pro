;=============================================================================
;+
; NAME:
;	icv_compute_directions
;
;
; PURPOSE:
;	Computes the normal to a specified curve at every point.
;
;
; CATEGORY:
;	NV/LIB/TOOLS/ICV
;
;
; CALLING SEQUENCE:
;	icv_compute_directions, curve_pts, $
;	                        cos_alpha=cos_alpha, sin_alpha=sin_alpha
;
;
; ARGUMENTS:
;  INPUT:
;	curve_pts:	Array (2, n_points) of image points making up the curve.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: NONE
;
;  OUTPUT:
;	cos_alpha:	Array (n_points) of direction cosines.
;
;	sin_alpha:	Array (n_points) of direction sines.
;
;
; RETURN:
;	NONE
;
;
; RESTRICTIONS:
;	It is assumed that the curve is closed; if this is not the case, then
;	the results will not be meaningful at the endpoints of the curve.
;
;
; PROCEDURE:
;	At each point on the specified curve, the two nearest neighbors are 
;	used to compute the components of the normal. 
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 2/1998
;	
;-
;=============================================================================
pro icv_compute_directions, curve_pts, center=center, $
                           cos_alpha=cos_alpha, sin_alpha=sin_alpha

; if(NOT keyword_set(center)) then $
;             nv_message, /con, name='icv_strip_curve', ...

 ;--------------------------------------
 ; distances between i+1 and i-1 points
 ;--------------------------------------
 delta = shift(curve_pts, 0,1) - shift(curve_pts, 0,-1)
 mag_delta = sqrt(total(delta^2, 1))

 ;--------------------------------------------------
 ; cos and sin of normal between i+1 and i-1 points
 ;--------------------------------------------------
 cos_alpha = -transpose(-delta[1,*]/mag_delta)
 sin_alpha = -transpose(delta[0,*]/mag_delta)

 ;----------------------------------------------------------------
 ; if a center is given, then arrange directions such that strip 
 ; is oriented with outermost points at the bottom
 ;----------------------------------------------------------------
 if(keyword_set(center)) then $
  begin
   np = n_elements(curve_pts)/2
   rr = curve_pts - center#make_array(np, val=1d)
   nn = [tr(cos_alpha), tr(sin_alpha)]

   dot = p_inner(rr, nn)
;   if(total(dot) GT 0) then $
   if(total(dot) LT 0) then $
    begin
     cos_alpha = -cos_alpha
     sin_alpha = -sin_alpha
    end
  end

end
;===========================================================================
