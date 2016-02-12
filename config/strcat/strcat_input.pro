;=============================================================================
; strcat_input
;
;=============================================================================
function strcat_input, cat, dd, keyword, n_obj=n_obj, dim=dim, values=values, status=status, $
@nv_trs_keywords_include.pro
@nv_trs_keywords1_include.pro
	end_keywords


 status = -1
 if(keyword NE 'STR_DESCRIPTORS') then return, ''

 ;---------------------------------------
 ; set up catalog names
 ;---------------------------------------
 upcat = strupcase(cat)
 lowcat = strlowcase(cat)

 env = 'NV_' + upcat + '_DATA'
 key = 'path_' + lowcat
 fn_get_regions = lowcat + '_get_regions'
 fn_get_stars = lowcat + '_get_stars'


 ;-----------------------------------------------
 ; get inputs
 ;-----------------------------------------------
 strcat_get_inputs, dd, env, key, $
	b1950=b1950, j2000=j2000, time=time, jtime=jtime, cam_vel=cam__vel, $
	path=path, names=names, noaberr=noaberr, $
	ra1=ra1, ra2=ra2, dec1=dec1, dec2=dec2, $
	faint=faint, bright=bright, nbright=nbright, stat=stat, $
@nv_trs_keywords_include.pro
@nv_trs_keywords1_include.pro
	end_keywords

 if(stat NE 0) then return, ''

 status=0
 n_obj=0
 dim = [1]

 ;---------------------------------
 ; Get catalog regions to read in
 ;---------------------------------
 ra1 = ra1*180d/!dpi
 ra2 = ra2*180d/!dpi
 dec1 = dec1*180d/!dpi
 dec2 = dec2*180d/!dpi

 ras = [ra1,ra2]
 decs = [dec1,dec2]
 ras = ras[sort(ras)]
 decs = decs[sort(decs)]

 ra1 = ras[0] & ra2 = ras[1]
 dec1 = decs[0] & dec2 = decs[1]


 regions = call_function(fn_get_regions, ra1, ra2, dec1, dec2, path=path)
 nregions = n_elements(regions)
 if(nregions eq 1 AND regions[0] eq '') then nv_message, $
                       name='strcat_input', 'No TYCHO-2 regions found.'
 print, 'Number of ' + upcat + ' regions found ',nregions

 ;-------------------------
 ; Loop on catalog regions
 ;-------------------------
 first = 1
 for i=0, nregions-1 do $
  begin
   _sd = call_function(fn_get_stars, regions[i], noaberr=noaberr, cam_vel=cam__vel, $
                       ra1=ra1, ra2=ra2, dec1=dec1, dec2=dec2, $
                       faint=faint, bright=bright, nbright=nbright, $
                       b1950=b1950, names=names, mag=mag, jtime=jtime)
   if(keyword__set(_sd)) then $
    begin
      if(first eq 1) then $
        begin
         sd = _sd
	 mags = mag
         first = 0
        end $
       else $
        begin
         sd = [sd, _sd]
         mags = [mags, mag]
        end
    end
  end

 if(keyword__set(nbright) AND keyword__set(mags)) then $
  begin
   w = strcat_nbright(mags, nbright)
   sd = sd[w]
  end

 bod_set_time, sd, time


 n_obj = n_elements(sd)
 print, 'Total ' + upcat + ' stars found: ', n_obj

 status = -1
 if(n_obj EQ 0) then return, ''

 status = 0
 return, sd
end

;==========================================================================
