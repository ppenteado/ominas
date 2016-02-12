;===========================================================================
; orb_compute_dlandt
;
; Nicholson and Porco 1988, eq. 12.
;
;===========================================================================
function orb_compute_dlandt, xd, gbx, GG=GG, sma=sma
 
 if(keyword_set(GG)) then GM = GG*sld_mass(gbx) $
 else GM = sld_gm(gbx)
 J = glb_j(gbx)
 if(keyword_set(sma)) then a = sma $
 else a = (orb_get_sma(xd))[0]
 R = glb_rref(gbx)

 ratio = R/a


 dlandt = - sqrt(GM/a^3)*(    3./2.	* J[2]		* ratio^2 $
                          -   9./4.	* J[2]^2	* ratio^4 $
                          -  15./4.	* J[4]		* ratio^4 $
                          + 351./64.	* J[2]^3	* ratio^6 $
                          + 315./32.	* J[2]*J[4]	* ratio^6 $
                          + 105./16.	* J[6]		* ratio^6 )

 return, dlandt
end
;===========================================================================
