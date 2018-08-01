;=============================================================================
;+
; NAME:
;	strcat_input
;
;
; PURPOSE:
;	Generic star catalog input translator core.  This routine is not an 
;	OMINAS input translator; it is intended to be called by an input
;	translator that is taylored to a specific catalog. 
;
;
; CATEGORY:
;	NV/CONFIG
;
;
; CALLING SEQUENCE:
;	result = strcat_input(dd, keyword, cat)
;
;
; ARGUMENTS:
;  INPUT:
;	dd:		Data descriptor.
;
;	keyword:	If not 'STR_DESCRIPTORS', the function returns null.
;
;	cat:		String giving the name of the star catalog.  
;
;  OUTPUT:
;	NONE
;
;
; KEYWORDS:
;  INPUT:
;	key1:		Observer descriptor.
;
;	key8:		Array of requested object names.
;
;  OUTPUT:
;	status:		Zero if valid data is returned.
;
;
;  TRANSLATOR KEYWORDS:
;	j2000:		Set to use j2000 reference frame.
;
;	b1950:		Set to use b1950 reference frame.
;
;	faint:		Faintest limiting visual magnitude.
;
;	bright:		Brightest limiting visual magnitude.
;
;	nbright:	Maximum number of brightest stars to return.
;
;	path:		Path to the star catalog data.  If not set, the
;			environment variable NV_<cat>_DATA is checked.
;
;	fov:		Number of fields of view in which to retrieve stars.
;
;	cov:		Image coordinates of center of view in which to
;			retrieve stars. [[maybe change this to RA/DEC]]
;
;
;
; ENVIRONMENT VARIABLES:
;	NV_<cat>_DATA:		Directory containing the star catalog data.
;
;
; RETURN:
;	Array of star descriptors.
;
;
; STATUS:
;	Complete
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 3/2004
;	MOdified:	Ryan, 8/2016
;	
;-
;=============================================================================



;=============================================================================
; strcat_get_inputs
;
;=============================================================================
pro strcat_get_inputs, dd, env, key, $
	b1950=b1950, j2000=j2000, time=time, jtime=jtime, $
	path=path, names=names, $
	ra1=ra1, ra2=ra2, dec1=dec1, dec2=dec2, $
	faint=faint, bright=bright, nbright=nbright, status=status, $
@nv_trs_keywords_include.pro
@nv_trs_keywords1_include.pro
	end_keywords

 status = -1

 ;---------------------------------------------------------
 ; Translator keywords
 ;---------------------------------------------------------
 b1950 = dat_keyword_value(dd, 'b1950')

 jtime = double(dat_keyword_value(dd, 'jtime'))

 j2000 = dat_keyword_value(dd, 'j2000')

 _faint = dat_keyword_value(dd, 'faint')
 if(_faint NE '') then faint = double(_faint)

 _bright = dat_keyword_value(dd, 'bright')
 if(_bright NE '') then bright = double(_bright)

 nbright = long(dat_keyword_value(dd, 'nbright'))

 ;---------------------------------------------------------
 ; Star catalog path
 ;---------------------------------------------------------
 path = dat_keyword_value(dd, key)
 if(NOT keyword_set(path)) then path = getenv(env);
 if(NOT keyword_set(path)) then $
  begin
   nv_message, /cont, 'Warning: ' + env + ' not defined.  No star catalog.'
   return
  end
   
 ;---------------------------------------------------------
 ; Observer descriptor passed as key1
 ;---------------------------------------------------------
 if(keyword_set(key1)) then ods = key1 
 if(NOT cor_isa(ods[0], 'BODY')) then ods = 0
 if(NOT keyword_set(ods)) then return

 ;---------------------------------------------------------
 ; fov and cov 
 ;---------------------------------------------------------
 fov = double(dat_keyword_value(dd, 'fov'))
 if(NOT keyword_set(fov)) then fov = 1

 cov = double(parse_comma_list(dat_keyword_value(dd, 'cov'), delim=';'))
 if(keyword_set(cov)) then cov = transpose(cov) $
 else if(NOT keyword_set(cov)) then cov = cam_oaxis(ods[0])
   ;;; this assumes od is a camera.  Not great.

 ;---------------------------------------------------------
 ; Names passed as key8
 ;---------------------------------------------------------
 if(keyword_set(key8)) then $
  begin
   names = key8
   if(n_elements(names) EQ 1) then $
        if(strupcase(names[0]) EQ 'SUN') then return
  end

 ;---------------------------------------------------------
 ; Get jtime 
 ;---------------------------------------------------------
 time = bod_time(ods[0])
 if(NOT keyword_set(jtime)) then $
  begin
   jtime = time/(365.25d*86400d)      ; assuming camtime is secs past 2000
   if(keyword__set(b1950)) then jtime = jtime + 50.
  end

 ;---------------------------------------------------------
 ; Get ra/dec limits 
 ;---------------------------------------------------------
 ra1 = 0d & ra2 = 2d*!dpi * 0.999
 dec1 = -!dpi/2d * 0.999 & dec2 = -dec1 * 0.999

 if(keyword_set(fov)) then $
  begin
   cam_scale = min(cam_scale(ods[0]))
   cam_size = cam_size(ods[0])

   radec0 = image_to_radec(ods[0], cov)
   cam_fov = min(cam_scale*cam_size)
   field = fov*cam_fov

   ra1 = reduce_angle(radec0[0] + field)
   ra2 = reduce_angle(radec0[0] - field)

   dec1 = radec0[1] + field
   dec2 = radec0[1] - field
  end $
 else nv_message, /con, $
      'WARNING: No FOV limits set for star catalog search.', $
       exp=['Without FOV limits, stars will be returned for the entire sky.', $
            'This may cause the software to run very slowly.']


 status = 0

end
;=============================================================================



;=============================================================================
; strcat_input
;
;
;=============================================================================
function strcat_input, dd, keyword, cat, n_obj=n_obj, dim=dim, values=values, status=status, $
@nv_trs_keywords_include.pro
@nv_trs_keywords1_include.pro
	end_keywords

 status = -1
 if(keyword NE 'STR_DESCRIPTORS') then return, ''

 ;---------------------------------------------------------
 ; Format catalog name and function names
 ;---------------------------------------------------------
 upcat = strupcase(cat)
 lowcat = strlowcase(cat)

 env = 'NV_' + upcat + '_DATA'
 key = 'path_' + lowcat
 fn_get_regions = lowcat + '_get_regions'
 fn_get_stars = lowcat + '_get_stars'

 ;---------------------------------------------------------
 ; Retrieve input data for scene
 ;---------------------------------------------------------
 strcat_get_inputs, dd, env, key, $
	b1950=b1950, j2000=j2000, time=time, jtime=jtime, $
	path=path, names=names, $
	ra1=ra1, ra2=ra2, dec1=dec1, dec2=dec2, $
	faint=faint, bright=bright, nbright=nbright, stat=stat, $
@nv_trs_keywords_include.pro
@nv_trs_keywords1_include.pro
	end_keywords

 if(stat NE 0) then return, ''

 status = 0
 n_obj = 0
 dim = [1]

 ;---------------------------------------------------------
 ; Convert ra and dec bounds of scene from rad -> deg
 ;---------------------------------------------------------
 ra1 = ra1 * 180d / !dpi
 ra2 = ra2 * 180d / !dpi
 dec1 = dec1 * 180d / !dpi
 dec2 = dec2 * 180d / !dpi

 ;---------------------------------------------------------
 ; set ra1 & dec1 as lower bound and ra2 & dec2 as 
 ; upper bound
 ;---------------------------------------------------------
 ras = [ra1,ra2]
 decs = [dec1,dec2]
 ras = ras[sort(ras)]
 decs = decs[sort(decs)]

 ra1 = ras[0] & ra2 = ras[1]
 dec1 = decs[0] & dec2 = decs[1]

 ;---------------------------------------------------------
 ; Get the regions/index file for the catalog
 ;---------------------------------------------------------
 regions = call_function(fn_get_regions, ra1, ra2, dec1, dec2, path=path)
 nregions = n_elements(regions)
 if(nregions eq 1 AND regions[0] eq '') then $
                              nv_message, 'No ' + upcat + ' regions found.'
 nv_message, verb=0.2, 'Number of ' + upcat + ' regions found ' + strtrim(nregions,2)

 ;---------------------------------------------------------
 ; Get star descriptors for all stars in regions
 ;---------------------------------------------------------
 first = 1
 for i=0, nregions-1 do $
  begin
   _sd = call_function(fn_get_stars, dd, regions[i], $
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

 if(NOT keyword_set(sd)) then return, 0

 ;--------------------------------------------------------
 ; indicate that light time is included in catalog states
 ;--------------------------------------------------------
 bod_set_aberration, sd, 'LT'

 ;--------------------------------------------------------
 ; Apply brightness threshold to data
 ;--------------------------------------------------------
 if(keyword__set(nbright) AND keyword__set(mags) AND keyword__set(_sd)) then $
  begin
   w = strcat_nbright(mags, nbright)
   sd = sd[w]
  end

 ;---------------------------------------------------------
 ; Return silently if no stars are found
 ;---------------------------------------------------------
 n_obj = n_elements(sd)
 if(n_obj EQ 0) then return, ''
 
 print, 'Total ' + upcat + ' stars found: ', n_obj
 
 bod_set_time, sd, time

 status = 0
 return, sd
end
;===============================================================================
