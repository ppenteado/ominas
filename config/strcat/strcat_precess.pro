;================================================================================
; strcat_precess
;
;
;================================================================================
pro strcat_precess, parm, v, back=back

 if(parm.coord EQ parm.format) then return

 reverse = 1
 if(parm.coord EQ 'b1950') then reverse = 0
 if(keyword_set(back)) then reverse = 1 - reverse

 ;-------------------------------
 ; precess ras / decs
 ;-------------------------------
; use radec_to_body instead...
 ra_to_xyz, parm.ra1, parm.dec1, pos1
 ra_to_xyz, parm.ra2, parm.dec2, pos2
 pos1_1950 = b1950_to_j2000(pos1, reverse=reverse)
 pos2_1950 = b1950_to_j2000(pos2, reverse=reverse)
 xyz_to_ra, pos1_1950, _ra1, _dec1
 xyz_to_ra, pos2_1950, _ra2, _dec2
 parm.ra1 = _ra1
 parm.ra2 = _ra2
 if (_ra1 LT 0) then parm.ra1 = parm.ra1 + 2d*!dpi
 if (_ra2 LT 0 ) then parm.ra2 = parm.ra2 + 2d*!dpi

 
 ;-------------------------------
 ; precess vectors
 ;-------------------------------
 if(arg_present(v)) then $
  begin
   n = (size(v, /dim))[0]
   v = b1950_to_j2000(v, reverse=reverse)
  end


end
;================================================================================
