;==============================================================================
; cas_delut
;
;  Adapted from cassimg__twelvebit.pro, which was contributed by Daren Wilson.
;
;  This Lookup Table (or LUT) is from Appendix F1 of the
;  Cassini ISS Calibration Report
;  It is the inverse of the 12bit to 8bit pseudologarithmic LUT
;  optionally used to encode the ISS images.
;  There are therefore 256 elements which map corresponding DNs back
;  into the full 12bit range 0-4095 in a near exponential relationship
;
;==============================================================================
function cas_radar_transform, ima, label, force=force
  compile_opt idl2,logical_predicate
 
  missing=label[where(stregex(label,'MISSING_CONSTANT',/bool))]
  misval=(stregex(missing,'=[[:space:]]*"?16#([[:xdigit:]]+)#',/extract,/subexpr))[-1]
  ;dat_header_value,dd,'MISSING_CONSTANT',get=missing
  ;misval=(stregex(missing,'16#([[:xdigit:]]+)#',/subexpr,/extract))[-1]
  ;dat_header_value,dd,'SAMPLE_BITS',get=sb
  ;sb=strtrim(sb[0],2)
  sb=label[where(stregex(label,'SAMPLE_BITS',/bool))]
  sb=(stregex(sb,'=[[:space:]]*([[:digit:]]+)',/extract,/subexpr))[-1]
  mv=sb eq '32' ? 0L : 0LL
  reads,misval,mv,format='(Z)'
  
  mv=sb eq '32' ? float(mv,0) : double(mv,0)
  w=where(ima eq mv,count)
  if count then ima[w]=!values.d_nan
  ima=rotate(ima,1)
 
 return, ima
end
;==============================================================================
