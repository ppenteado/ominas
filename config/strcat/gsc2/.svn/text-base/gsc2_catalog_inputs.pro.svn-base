;=============================================================================
;+
; NAME:
;	gsc2_catalog_inputs
;
;
; PURPOSE:
;	Generates commands necessary for obtaining a prtion of the GSCII
;	guide star catalog and converting it to a format readable by the
;	translator strcat_gsc2_input. 
;
;
; CATEGORY:
;	NV/CONFIG
;
;
; CALLING SEQUENCE:
;	gsc2_catalog_inputs, dd, cd=cd
;
;
; ARGUMENTS:
;  INPUT:
;	dd:		Data descriptor.
;
;  OUTPUT:
;	NONE
;
;
; KEYWORDS:
;  INPUT:
;	cd:	Camera descriptor, required.
;
;	n:	Maximum number of stars searched in catalog.  Default is 5000.
;
;	m1:	Brightest visual magnitude to match.  Default is 0.
;
;	m2:	Faintest visual magnitude to match.  Default is 19.5.
;
;  OUTPUT:
;	NONE
;
;
; PROCEDURE:
;	This procedure uses the given information to generate and print a URL
;	that the user can enter into a web browser to automatically search the
;	guide star catalog.  The user is instructed to save the results in
;	a file in the directory given by the environment variable NV_GSC2_DATA.
;	A command is then printed that will convert all such data files in that
;	directory into a single binary file in the same directory, readable by
;	the gsc2 translator.
;
;
; STATUS:
;	Complete
;
;
; SEE ALSO:
;	strcat_gsc2_input
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 2/2002
;	
;-
;=============================================================================
pro gsc2_catalog_inputs, dd, cd=cd, n=n, m1=m1, m2=m2

 if(NOT keyword__set(n)) then n = 5000
 if(NOT keyword__set(m1)) then m1 = 0d
 if(NOT keyword__set(m2)) then m2 = 19.5d

 key1 = cd

 ;-----------------------------------------------
 ; get inputs
 ;-----------------------------------------------
 strcat_get_inputs, dd, 'NV_GSC2_DATA', 'path_gsc2', $
	b1950=b1950, j2000=j2000, jtime=jtime, cam_vel=cam__vel, $
	path=path_gsc2, ra1=ra1, ra2=ra2, dec1=dec1, dec2=dec2, $
@nv_trs_keywords_include.pro
@nv_trs_keywords1_include.pro
	end_keywords

 oa_ra = 180d/!dpi * 0.5d*(ra1 + ra2)
 oa_dec = 180d/!dpi * 0.5d*(dec1 + dec2)
 fov = 180d/!dpi * max([abs(ra2 - ra1), abs(dec2 - dec1)])

 ra = deg_to_hhmmss(oa_ra, h=hra, m=mra, s=sra)
 dec = deg_to_degmmss(oa_dec, d=ddec, m=mdec, s=sdec)
 fov = (fov*60d) < 60d

 print, $
   '**************************************************************************'
 print
 print, 'To search the catalog, paste the following URL into your web browser:'
 print
 print, 'http://www-gsss.stsci.edu/cgi-bin/gsc22query.exe?ra='+hra+'%3A'+mra+'%3A'+sra+'&dec='+ddec+'%3A'+mdec+'%3A'+sdec+'&r1=0&r2='+strtrim(fov,2)+'&m1='+strtrim(m1,2)+'&m2='+strtrim(m2,2)+'&n='+strtrim(n,2)+'&submit2=Submit+Request'
 print
 print


 files = findfile(path_gsc2+'gsc*.dat')
 num = n_elements(files)
 if(NOT keyword__set(files)) then name = 'gsc0.dat' $
 else name = 'gsc'+strtrim(num,2)+'.dat' 

 print, 'Save the data in a file named:' 
 print
 print, path_gsc2 + name
 print
 print

 print, 'After downloading all of your star files in this way, convert them to'
 print, 'binary using the following IDL command:'
 print
 print, 'make_star_files_gsc2, indir="'+path_gsc2+'", outdir="'+path_gsc2+'"'
 print
 print
 print, 'You may now use the gsc2 input translator.'
 print


 print, $
   '**************************************************************************'
end
;=============================================================================


; print, 'If there is a problem, go to http://www-gsss.stsci.edu/support/data_access.htm,'
; print, 'enter the following data by hand, and press "Submit":'
; print
; print, 'Right Ascension '+ra+'   Declination '+dec
; print, 'Annulus : Inner radius 0 (arcmin)  Outer radius '+strtrim(fov,2)+' (arcmin)
; print, 'Mag.Range : Brightest '+strtrim(m1,2)+'   Faintest '+strtrim(m2,2)
; print, 'Max.N returned : '+strtrim(n,2)
; print
