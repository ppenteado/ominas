;===========================================================================
;+
; NAME:
;       strcat_tycho2_input
;
;
; PURPOSE:
;        Input translator for tycho-2 star catalog.
;
;
; CATEGORY:
;	NV/CONFIG
;
;
; CALLING SEQUENCE:
;       result = strcat_tycho2_input(dd, keyword)
;
;
; ARGUMENTS:
;  INPUT:
;	dd:		Data descriptor.
;
;	keyword:	String giving the name of the translator quantity.
;
;  OUTPUT:
;       NONE
;
; KEYWORDS:
;  INPUT:
;	key1:		Observer descriptor, must be of subclass CAMERA.
;
;
;  OUTPUT:
;	status:		Zero if valid data is returned.
;
;	n_obj:		Number of objects returned.
;
;	dim:		Dimensions of return objects.
;
;
;  TRANSLATOR KEYWORDS:
; 	jtime:		Years since 1950 (the epoch of catalog) for precession
;			and proper motion correction.  If not given, it is taken
;			from the object descriptor bod_time, which is assumed to
;			be seconds past 1950 unless keyword /j2000 is set.
;
;	j2000:		If set, coordinates are output wrt j2000.
;
;	b1950:		If set, coordinates are output wrt b1950.
;
;	path_tycho2:	The directory of the star catalog.   If not given, the
;			routine uses the environment variable 'NV_tycho2_DATA'.  
;			The catalog data is grouped into approx 10,000 separate
;			regions in numbered files in 24 separate subdirectories.
;			Each star has a data record of 16 bytes.
;			tycho2_ID, CLASS, RA_DEG (degrees), DEC_DEG (degrees), and
;			MAG (Visual Magnitude). The real values (RA_DEG, DEC_DEG
;			and MAG) are in XDR, the tycho2_ID and CLASS are 
;			network-order short integers.
;
;	faint:		Stars with magnitudes fainter than this will not be
;			returned.
;
;	bright:		Stars with magnitudes brighter than this will not be
;			returned.
;
;
;  ENVIRONMENT VARIABLES:
;	NV_TYCHO2_DATA:	Directory containing the tycho-2 catalog data unless
;			overridden using the path_tycho2 translator keyword.
;
;
; RETURN:
;       Star descriptor containing all the stars found.  The Sp part of
;       the star descriptor does not contain the Spectral type since this
;       is not available.  Instead it contains the class of the object:
;       0 - star
;       1 - galaxy
;       2 - blend or member of incorrectly resolved blend.
;       3 - non-star
;       5 - potential artifact
;
;         (Note that code 1 is used only for a few  hand-entered errata;
;         galaxies successfully processed by the software have a classi-
;         fication of 3 [non-stellar].  Also code 4 is never used.)  
;
;
; RESTRICTIONS:
;       Since the distance to stars are not given in the TYCHO-2 catalog, the
;       position vector magnitude is set as 10 parsec and the luminosity
;       is calculated from the visual magnitude and the 10 parsec distance.
;
;
; PROCEDURE:
;       Stars are found in a square area in RA and DEC around a given
;       or calculated center.  The star descriptor is filled with stars
;       that fit in this area.  If B1950 is selected, input ods orient 
;	matrix is assumed to be B1950 also, if not, input is assumed to be
;	J2000, like the catalog.  
;
;
; MODIFICATION HISTORY:
;       Written by:	   	  Spitale; 3/2004
;
;-
;============================================================================



;==========================================================================
;  tycho2_get_regions
;
;==========================================================================
function tycho2_get_regions, ra1, ra2, dec1, dec2, path_tycho2=path_tycho2
 return, path_tycho2 + 'index.dat'	; there's only one "region" file
end
;==========================================================================



;==========================================================================
;  tycho2_unpack_stars
;
;==========================================================================
pro tycho2_unpack_stars, packed_stars, $
  ra=ra, dec=dec, _rapm=rapm, _decpm=decpm, mag=mag, px=px, sp=sp, num=num, $
  epochra=epochra, epochdec=epochdec

 ;-------------------------
 ; ra, dec
 ;-------------------------
 if(arg_present(ra)) then ra = packed_stars.ra / 268435456d * 180d/!dpi		; deg
 if(arg_present(dec)) then dec = packed_stars.dec / 268435456d * 180d/!dpi		; deg

 ;-------------------------
 ; proper motions
 ;-------------------------
 if(arg_present(rapm)) then $
  begin
   xx = mvbits(packed_stars.rapm, 14, 18, 0)
   w = where(btest(xx,17))
   if(w[0] NE -1) then xx[w] = xx[w] OR 'fffc0000'xl
   rapm = xx / 2147483648d * 180d/!dpi			; deg/yr
  end

 if(arg_present(decpm)) then $
  begin
   xx = mvbits(packed_stars.decpm, 14, 18, 0)
   w = where(btest(xx,17))
   if(w[0] NE -1) then xx[w] = xx[w] OR 'fffc0000'xl
   decpm = xx / 2147483648d * 180d/!dpi			; deg/yr
  end

 ;-------------------------
 ; misc
 ;-------------------------
 if(arg_present(mag)) then $
  begin
   xx = mvbits(packed_stars.pxmagsp, 8, 11, 0)
   mag = xx/100. - 2.
  end

 if(arg_present(px)) then $
  begin
   xx = mvbits(packed_stars.pxmagsp, 19, 13, 0)
   px = xx/10000.
  end

 if(arg_present(sp)) then $
  begin
   sp1 = byte(mvbits(packed_stars.pxmagsp, 0, 8, 0))
   sp2 = byte(mvbits(packed_stars.DM, 0, 8, 0))
   sp3 = byte(mvbits(packed_stars.num, 0, 8, 0))
   sp = string([tr(sp1), tr(sp2), tr(sp3)])
  end

 if(arg_present(num)) then $
  begin
   xx = mvbits(packed_stars.num, 8, 24, 0)
   w = where(btest(xx,23))
   if(w[0] NE -1) then xx[w] = xx[w] OR 'ff000000'xl
   num = xx
  end

 if(arg_present(epochra)) then $
  begin
   xx = mvbits(packed_stars.epoch, 16, 16, 0)
   w = where(btest(xx,15))
   if(w[0] NE -1) then xx[w] = xx[w] OR 'ffff0000'xl
   epochra = xx/100d + 1950
  end

 if(arg_present(epochdec)) then $
  begin
   xx = mvbits(packed_stars.epoch, 0, 16, 0)
   w = where(btest(xx,15))
   if(w[0] NE -1) then xx[w] = xx[w] OR 'ffff0000'xl
   epochdec = xx/100d + 1950
  end


end
;==========================================================================



;==========================================================================
; tycho2_get_stars 
;
;==========================================================================
function tycho2_get_stars, filename, cam_vel=cam_vel, $
         b1950=b1950, ra1=ra1, ra2=ra2, dec1=dec1, dec2=dec2, $
         faint=faint, bright=bright, nbright=nbright, $
         noaberr=noaberr, names=names, mag=mag, jtime=jtime


 f = file_search(filename)
 if(f[0] eq '') then $
  begin
   nv_message, name='tycho2_get_stars', 'File does not exist - ' + filename
   return, ''
  end

 ;-----------------------------------
 ; probe byte order
 ;-----------------------------------
 b = 1l
 byteorder, b, /htonl
 swap = (b EQ 1)

 ;-----------------------------------
 ; open file 
 ;-----------------------------------
 openr, unit, filename, /get_lun

 ;-----------------------------------
 ; read header
 ;-----------------------------------
 hrec = assoc(unit, {tycho2_header})
 header = hrec[0]

 ;-----------------------------------
 ; read zone directories
 ;-----------------------------------
 point_lun, -unit, pos
 zrec = assoc(unit, replicate({tycho2_directory},180), pos)
 zones = zrec[0]
 if(swap) then zones = swap_endian(zones)

 ;-------------------------------------------
 ; build a list of star records
 ;-------------------------------------------
 point_lun, -unit, pos
 srec = assoc(unit, {tycho2_record}, pos)

;;; _z1 = fix(90-dec1)
;;; _z2 = fix(90-dec2)
 _z1 = round(90-dec1)
 _z2 = round(90-dec2)
 z1 = min([_z1,_z2])
 z2 = max([_z1,_z2])

; z = lindgen(z2-z1+1) + z1
; if(z1 EQ z2) then z = z1
;;; z = lindgen((z2-z1)>1) + z1
 z = lindgen((z2-z1+2)>1) + z1 - 1

 nz = n_elements(z)
 for i=0, nz-1 do $
  begin
;stop
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   ; starting ra for each star record in this zone
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   ra_start = double(zones[z[i]].ra_start[0:zones[z[i]].numrec-1]) / $
                                                      268435456d * 180d/!dpi

   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   ; number of first (2560-byte) star record in this zone
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   rec_start = zones[z[i]].rec_start - zones[0].rec_start
   if(rec_start[0] NE -1) then $
    begin
w1 = max(where(ra1 GE ra_start))
w2 = min(where(ra2 LE ra_start))
;;;     w1 = min(where(ra_start GE ra1))
;;;     w2 = max(where(ra_start LE ra2) + 1) 
     w = lindgen(w2-w1+1) + w1
     nw = n_elements(w)

     ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     ; extract selected records
     ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     ps = replicate({tycho2_packed_star}, nw*71)
     ns = 0
     for j=0, nw-1 do $
      begin
       recnum = rec_start+w[j]
       if(recnum LE 686945) then $
        begin
         record = srec[recnum]
         if(swap) then record = swap_endian(record)

         ps[ns:ns+record.nstars-1] = record.stars[0:record.nstars-1]
         ns = ns + record.nstars
        end
      end

     if(ns GT 0) then $
      begin
       ps = ps[0:ns-1]

       ;- - - - - - - - - - - - - - - - - - - -
       ; select stars within magnitude limits
       ;- - - - - - - - - - - - - - - - - - - -
       mag = ''
       if(keyword_set(faint)) then $
        begin
         tycho2_unpack_stars, ps, mag=mag
         w = where(mag LE faint)
         if(w[0] NE -1) then $
          begin
           ps = ps[w]
           mag = mag[w]
          end else ps = (mag = 0)
        end

       if(keyword_set(bright)) then $
        begin
         if(NOT keyword_set(mag)) then tycho2_unpack_stars, ps, mag=mag
         w = where(mag GE bright)
         if(w[0] NE -1) then $
          begin
           ps = ps[w]
           mag = mag[w]
          end else ps = (mag = 0)
        end

       ;- - - - - - - - - - - - - - - - - - - -
       ; select brightest stars 
       ;- - - - - - - - - - - - - - - - - - - -
       if(keyword_set(nbright)) then $
        begin
         nps = n_elements(ps)
         if(NOT keyword_set(mag)) then tycho2_unpack_stars, ps, mag=mag
         ss = sort(mag)
         ps = (ps[ss])[0:(nbright<nps)-1]
        end



        ;- - - - - - - - - - - - - - - - - - - -
        ; add stars 
        ;- - - - - - - - - - - - - - - - - - - -
        packed_stars = append_array(packed_stars, ps)
      end
    end
  end

 ;-------------------------------------------
 ; close file
 ;-------------------------------------------
 close, unit
 free_lun, unit
 
 ;-------------------------------------------
 ; unpack star records
 ;-------------------------------------------
 if(NOT keyword_set(packed_stars)) then return, ''
 tycho2_unpack_stars, packed_stars, $
  ra=stars_ra, dec=stars_dec, _rapm=stars_rapm, _decpm=stars_decpm, $
  mag=stars_mag, px=stars_px, sp=stars_sp, num=stars_num, $
  epochra=stars_epochra, epochdec=stars_epochdec

 nstars = n_elements(stars_ra)
 stars = replicate({tycho2_star}, nstars)
 stars.ra = stars_ra
 stars.dec = stars_dec
 stars.rapm = stars_rapm
 stars.decpm = stars_decpm
 stars.mag = stars_mag
 stars.px = stars_px
 stars.sp = stars_sp
 stars.num = stars_num
 stars.epochra = stars_epochra
 stars.epochdec = stars_epochdec


 ;------------------------------------------------------------------
 ; If limits are defined, remove stars that fall outside the limits
 ; Limits in deg, Assumes RA's + DEC's in J2000 (B1950 if /b1950)
 ;------------------------------------------------------------------
 if(keyword_set(dec1) AND keyword_set(dec2)) then $
   begin
    subs = where((stars.dec GE dec1) AND (stars.dec LE dec2), count)
    if(count EQ 0) then return, ''
    stars = stars[subs]
   end


 if(keyword_set(ra1) AND keyword_set(ra2)) then $
   begin
    subs = where((stars.ra GE ra1) AND (stars.ra LE ra2), count)
    if(count EQ 0) then return, ''
    stars = stars[subs]
   end

 ;--------------------------------------------------------
 ; Apply proper motion to star 
 ; jtime = years past 2000.0
 ; rapm and decpm = radians per year
 ;--------------------------------------------------------
 stars.ra = stars.ra + stars.rapm*(jtime-(stars.epochra-2000))
 stars.dec = stars.dec + stars.decpm*(jtime-(stars.epochdec-2000))

 ;-------------------------------------------
 ; work in radians now
 ;-------------------------------------------
 stars.ra = stars.ra * !dpi/180d
 stars.dec = stars.dec * !dpi/180d
 stars.rapm = stars.rapm * !dpi/180d
 stars.decpm = stars.decpm * !dpi/180d

 ;-----------------------------------------------------------
 ; if desired, select only nbright brightest stars
 ;-----------------------------------------------------------
 if(keyword_set(nbright)) then $
  begin
   mag = stars.mag
   w = strcat_nbright(mag, nbright)
   stars = stars[w]
  end

 ;-------------------------------------
 ; select named stars
 ;-------------------------------------
 name = 'UCACT ' + strtrim(stars.num, 2)
 if(keyword_set(names)) then $
  begin
   w = where(names EQ name)
   if(w[0] NE -1) then _stars = stars[w]
   if(NOT keyword__set(_stars)) then return, ''
   stars = _stars
   name = name[w]
  end

 ;----------------------
 ; Fill star descriptors
 ;----------------------
 n = n_elements(stars)
 print, 'Total of ',n,' stars.'
 if(n eq 0) then return, ''

 ;-----------------------------
 ; Calculate "dummy" properties
 ;-----------------------------
 orient = make_array(3,3,n)
 _orient = [ [1d,0d,0d], [0d,1d,0d], [0d,0d,1d] ]
 for j = 0 , n-1 do orient[*,*,j] = _orient
 avel = make_array(1,3,n,value=0d)
 vel = make_array(1,3,n,value=0d)
 time = make_array(n,value=0d)
 radii = make_array(3,n,value=1d)
 lora = make_array(n, value=0d)

 ;---------------------------------------------------------------
 ; Correct for stellar aberration if camera velocity is available
 ;---------------------------------------------------------------
; if((NOT keyword__set(noaberr)) AND keyword__set(cam_vel)) then $
;  begin
;   str_aberr_radec, stars.ra, stars.dec, cam_vel, ra, dec
;   stars.ra = ra & stars.dec = dec
;  end


 ;--------------------------------------------------------------------
 ; Calculate position vector, use a very large distance unless 
 ; parallax is known.
 ;--------------------------------------------------------------------
 dist = make_array(n,val=1d21)	
		; this is something like the diameter of the milky way

 ;--------------------------------------------------------
 ; if parallax is known, then compute the actual distance
 ;--------------------------------------------------------
 w = where(stars.px NE 0)
 if(w[0] NE -1) then $
  begin
   px_rad = stars[w].px / 3600d * !dpi/180d
;   dist[w] = 1.5d11 / tan(0.5d*px_rad) 
   dist[w] = 1.5d11 / tan(px_rad) 
  end

 radec = transpose([transpose([stars.ra]), transpose([stars.dec]), transpose([dist])])
 pos = transpose(bod_radec_to_body(bod_inertial(), radec))

; pos = make_array(3,n,value=0d)
; pos[0,*] = cos(stars.ra)*cos(stars.dec)*dist
; pos[1,*] = sin(stars.ra)*cos(stars.dec)*dist
; pos[2,*] = sin(stars.dec)*dist

 ;---------------------------------------------------
 ; compute skyplane velocity from proper motion 
 ;---------------------------------------------------
 radec_vel = transpose([transpose([stars.rapm]/86400d/365.25d), transpose([stars.decpm]/86400d/365.25d), dblarr(1,n)])
 vel = bod_radec_to_body_vel(bod_inertial(), radec, radec_vel)



 ;-----------------------------------------------------
 ; Precess J2000 to B1950 if desired
 ;-----------------------------------------------------
 if(keyword_set(b1950)) then pos = $
  transpose(b1950_to_j2000(transpose(pos),/reverse))
 pos = reform(pos,1,3,n)

 if(keyword_set(b1950)) then vel = $
  transpose(b1950_to_j2000(transpose(vel),/reverse))
 vel = reform(vel,1,3,n)


 ;------------------------------------------------------------------------
 ; Calculate "luminosity" from visual Magnitude using the Sun as a model. 
 ; If distance is unknown, lum will be incorrect, but the magnitudes will 
 ; work out.
 ; Lum is expressed in J/sec (Lsun = 3.826e+26 J/sec)
 ;------------------------------------------------------------------------
 pc = 3.085678e+16			; 1 parsec (m)
 Lsun = 3.826d+26			; W
 m = stars.mag - 5d*alog10(dist/pc) + 5d
 lum = Lsun * 10.d^( (4.83d0-m)/2.5d ) 

 _sd = str_create_descriptors(n, $
        name=name, $
        orient=orient, $
        avel=avel, $
        pos=pos, $
        vel=vel, $
        time=time, $
        radii=radii, $
        lora=lora, $
        lum=lum, $
        sp=sp )

 mag = stars.mag

 return, _sd
end

;=============================================================================



;=============================================================================
; strcat_tycho2_input
;
;=============================================================================
function strcat_tycho2_input, dd, keyword, n_obj=n_obj, dim=dim, values=values, status=status, $
@nv_trs_keywords_include.pro
@nv_trs_keywords1_include.pro
	end_keywords


 return, strcat_input('tycho2', dd, keyword, n_obj=n_obj, dim=dim, values=values, status=status, $
@nv_trs_keywords_include.pro
@nv_trs_keywords1_include.pro
	end_keywords )

end
;=============================================================================



