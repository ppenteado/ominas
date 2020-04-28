;=============================================================================
;+
; NAME:
;       cc_threshold
;
;
; PURPOSE:
;       To threshold points by correlation coefficient.
;
;
; CATEGORY:
;       UTIL
;
;
; CALLING SEQUENCE:
;       result = cc_threshold(cc, min=min, max=max)
;
;
; ARGUMENTS:
;  INPUT:
;        cc:    An array of image point arrays.
;
;  OUTPUT:
;       NONE
;
;
; KEYWORDS:
;  INPUT:
;       min:    Minimum cc for threshold
;
;       max:    Maximum cc for threshold
;
;  relative:    If set, uses the maximum of the smoothed cc array,
;               and min and max are relative to this maximum.
;
;  OUTPUT:
;       NONE
;
; RETURN:
;       Subscripts into the cc array that are between the input minimum
;       and maximum.
;
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale
;
;-
;=============================================================================
function cc_threshold, cc, min=min, max=max, relative=relative


 ncc = n_elements(cc)

 ;---------------------------------
 ; absolute threshold
 ;---------------------------------
 if(NOT keyword__set(relative)) then $
  begin
   max_cc = max
   min_cc = min
  end $
 ;------------------------------------------------------------
 ; for relative thresholding, use max of smoothed correlations
 ;------------------------------------------------------------
 else $
  begin
   nsmooth = fix(ncc/40)
   if(nsmooth mod 2 EQ 0) then nsmooth = nsmooth + 1
   if(nsmooth GT 2 AND nsmooth LT ncc) then $
                    smooth_cc = (smooth(cc, nsmooth))[nsmooth+1:ncc-nsmooth] $
   else smooth_cc = cc

   ccmax = max(smooth_cc)

   max_cc = max*ccmax
   min_cc = min*ccmax
  end

 ;--------------------
 ; apply thresholds
 ;--------------------
 sub = where(cc LT min_cc OR cc GE max_cc)


 return, sub
end
;=============================================================================
