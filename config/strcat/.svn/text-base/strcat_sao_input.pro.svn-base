;==================================================================
;+
; NAME:
;       strcat_sao_input
;
;
; PURPOSE:
;        Input translator for SAO star catalog.
;
;
; CATEGORY:
;       NV/CONFIG
;
;
; CALLING SEQUENCE(only to be called by nv_get_value):
;       result = strcat_sao_input(dd, keyword)
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
;	path_sao:	The directory of the star catalog, sao_idl.str.   
;			In the file, the data is grouped into 18 segments of 
;			10 degrees each.  Each star has a data record of 36
;			bytes.  RA (radians), RAMu (pm in sec time/year)
;			DEC (radians), DECMu (pm in sec arc/year)
;			Visual Magnitude,  13-byte Name and 3-byte Spectral type
;			The first 4 records of the output catalog are 18 sets
;			of pointers to the records for the start and end of
;			each segment.
;			The real values (RA, RAMu, DEC, DECMu and Mag) are in
;			XDR.  The pointer integers are in network byte order.
;
;	faint:		Stars with magnitudes fainter than this will not be
;			returned.
;
;	bright:		Stars with magnitudes brighter than this will not be
;			returned.
;
;
;  ENVIRONMENT VARIABLES:
;	NV_SAO_DATA:	Directory containing the SAO catalog data unless
;			overridden using the path_sao translator keyword.
;
;
; RETURN:
;       Star descriptor containing all the stars found.
;
; RESTRICTIONS:
;       Since the distance to stars are not given in the SAO catalog, the
;       position vector magnitude is set as 10 parsec and the luminosity
;       is calculated from the visual magnitude and the 10 parsec distance.
;
;
; PROCEDURE:
;       Stars are found in a square area in RA and DEC around a given
;       or calculated center.  The star descriptor is filled with stars
;       that fit in this area.  If J2000 is selected, input RA, DEC and/or
;	ods orient matrix is assumed to be J2000 also, if not, input is
;	assumed to be B1950, like the catalog. 
;
;
; MODIFICATION HISTORY:
;       Written by:     Vance Haemmerle, 5/1998
;	Modified:       1/1999
;       Modified:       Tiscareno, 7/2000 (stellar aberration added)
;       Modified:       Haemmerle, 12/2000
;       Modified:       Spitale 9/2001 - changed to strcat_sao_input.pro
;
;-
;=============================================================================



;==========================================================================
;  sao_get_regions
;
;==========================================================================
function sao_get_regions, ra1, ra2, dec1, dec2, path_sao=path_sao
 return, path_sao + 'sao_idl.str'	; there's only one sao "region"
end
;==========================================================================



;===================================================================
; sao_get_stars 
;
;===================================================================
function sao_get_stars, filename, cam_vel=cam_vel, $
         b1950=b1950, ra1=ra1, ra2=ra2, dec1=dec1, dec2=dec2, $
         faint=faint, bright=bright, nbright=nbright, $
         noaberr=noaberr, names=names, mag=mag, jtime=jtime

 ra1= ra1 * !dpi/180d
 ra2= ra2 * !dpi/180d
 dec1= dec1 * !dpi/180d
 dec2= dec2 * !dpi/180d

 ;---------------------
 ; Open file
 ;---------------------
 openr, unit, filename, /get_lun
 record = assoc(unit,{sao_record})
 pointer = assoc(unit,lonarr(9))

 ;-------------------------
 ; Get segment pointers
 ;-------------------------
 ptr = lonarr(36)
 ptr=[pointer[0],pointer[1],pointer[2],pointer[3]]
 byteorder, ptr, /ntohl

;print, ptr

; find segments
 start_segment = 17 - fix((dec2*!RADEG+90.)/10)
 end_segment = 17 - fix((dec1*!RADEG+90.)/10)

;print, 'Search segments from ',start_segment,' to ',end_segment

 first_segment = 1
 for i = start_segment, end_segment DO $
  begin
   start_record = ptr(2*i)
   end_record = ptr(2*i+1)

;print, 'Whole segment is ',start_record,' to ',end_record

 ;--------------------------------------------------
 ; Search within segment to find RA limits
 ;--------------------------------------------------
   if(end_record-start_record GT 100) then $
   begin
    ra_ptr = ptr(2*i) + lindgen(37)*((ptr(2*i+1)-ptr(2*i))/36)
    ra_ptr[36] = ptr(2*i+1)
    ra_test = fltarr(37)
    for j = 0, 36 do $
     begin
      _star = record[ra_ptr[j]]
      ra_test[j] = _star.RA
     end
    byteorder, ra_test, /XDRTOF

    index = where(ra_test LE ra1,count)
    start_record = ra_ptr[0]
    if(count NE 0) then start_record = ra_ptr[count-1]

    end_record = ra_ptr[36]
    index = where(ra_test GE ra2,count)
    if(count NE 0) then end_record = ra_ptr[37-count]
   end

;print, 'Search records from ',start_record,' to ',end_record

   _star = replicate({sao_record},end_record-start_record+1)
   for j = start_record, end_record do _star[j-start_record] = record[j]

;print,'star contains',n_elements(_star),' stars'

   _RA = _star[*].RA
   byteorder, _RA, /XDRTOF
   index = where(_RA LE ra2 AND _RA GE ra1, ra_count)
   if(ra_count NE 0) then _star = _star(index)

;print, 'After RA test, star contains',n_elements(_star),' stars'

   dec_count = 0
   if(ra_count NE 0) then $
    begin
     _DEC = _star[*].DEC
     byteorder, _DEC, /XDRTOF
     index = where(_DEC LE dec2 AND _DEC GE dec1, dec_count)
     if(dec_count NE 0) then _star = _star(index)
    end

;print, 'After DEC test, star contains',n_elements(_star),' stars'

 ;------------------------------------
 ; select within magnitude limits
 ;------------------------------------
 if(keyword__set(faint)) then $
  begin
   status = -1
   _Mag = _star.mag
   byteorder, _Mag, /XDRTOF
   w = where(_Mag LE faint)
   if(w[0] NE -1) then star = _star[w]
   if(NOT keyword__set(star)) then return, ''
   _star = star
   status = 0
  end

 if(keyword__set(bright)) then $
  begin
   status = -1
   _Mag = _star.mag
   byteorder, _Mag, /XDRTOF
   w = where(_Mag GE bright)
   if(w[0] NE -1) then star1 = _star[w]
   if(NOT keyword__set(star1)) then return, ''
   _star = star1
   status = 0
  end


 ;-------------------------
 ; Unpack the _star array
 ;-------------------------
   if(dec_count NE 0) then $
    begin
     _RA = _star.RA
     _DEC = _star.DEC
     _DECpm = _star.DECpm
     _RApm = _star.RApm
     _Mag = _star.mag
     _Name = STRING(_star.Name)
     _Sp = STRING(_star.sp)
     byteorder, _RA, /XDRTOF
     byteorder, _DEC, /XDRTOF
     byteorder, _RApm, /XDRTOF
     byteorder, _DECpm, /XDRTOF
     byteorder, _Mag, /XDRTOF

 ;-------------------------------------------------------
 ; Apply proper motion to star (JTIME = years past 1950.0)
 ;-------------------------------------------------------
     _RA = _RA + (double(_RApm)*JTIME/240.D0)*!DTOR 
     _DEC = _DEC + (double(_DECpm)*JTIME/3600.D0)*!DTOR

 ;---------------------------------------------------------------
 ; Correct for stellar aberration if camera velocity is available
 ;---------------------------------------------------------------
     if keyword__set(cam_vel) then $
      str_aberr_radec, _RA, _DEC, cam_vel, _RA, _DEC 
   end

 ;-----------------------------------
 ; Print out data
 ;-----------------------------------
;    print, _Name, _RA, _DEC, Mag, ' ',_Sp
;    if(n_elements(_Name) NE 0) then $
;    print, _Name

 ;----------------------
 ; Build arrays
 ;---------------------
    if(dec_count NE 0) then $
    begin
     if(first_segment EQ 1) then $
      begin
       first_segment = 0
       RA = _RA
       DEC = _DEC
       Mag = _Mag
       Name = _Name
       Sp = _Sp
      end $
     else $
      begin
       RA = [RA,_RA]
       DEC = [DEC,_DEC]
       Mag = [Mag,_Mag]
       Name = [Name,_Name]
       Sp = [Sp,_Sp]
      end
     end

   end ;segment end

 ;-------------------------------------
 ; select named stars
 ;-------------------------------------
 if(keyword__set(names)) then $
  begin
   status = -1
   w = where(names EQ name)
   if(w[0] NE -1) then star = _star[w]
   if(NOT keyword__set(star)) then return, ''
   _star = star
   status = 0
  end

 close, unit
 free_lun, unit
 ;-----------------------
 ;  Fill star descriptors
 ;-----------------------

 n = n_elements(Name)

 print, 'Total of ',n,' stars'
 status = -1
 if(n EQ 0) then return, ''
 status = 0

 ;-----------------------------
 ; Calculate "dummy" properties
 ;-----------------------------

 orient = make_array(3,3,n)
 _orient = [ [1d,0d,0d], [0d,1d,0d], [0d,0d,1d] ]
 for j = 0 , n-1 do orient[*,*,j] = _orient
 avel = make_array(1,3,n,value=0d)
 vel = make_array(1,3,n,value=0d)
; time = make_array(n,value=(bod_time(cam_body(ods[0]))))
 time = make_array(n,value=0d)
 radii = make_array(3,n,value=1d)
 lora = make_array(n, value=0d)

 ;-----------------------------------------------------
 ; Calculate position vector, use distance as 10 parsec 
 ; to have apparent magnitude = absolute magnitude
 ;-----------------------------------------------------

 dist = 3.085678d+17 ; 10pc in meters
 pos = make_array(3,n,value=0d)
 pos[0,*] = cos(RA)*cos(DEC)*dist
 pos[1,*] = sin(RA)*cos(DEC)*dist
 pos[2,*] = sin(DEC)*dist

 ;-----------------------------------------------------
 ; Precess B1950 to J2000 if wanted
 ;-----------------------------------------------------

 if(keyword__set(j2000)) then pos = transpose(b1950_to_j2000(transpose(pos)))
 pos = reform(pos,1,3,n)

 ;-------------------------------------------------------
 ; Calculate "luminosity" from visual Magnitude
 ; Use Sun as model, though this is wrong for other stars
 ; but since we don't know A (space absorption) and may
 ; only sometimes know Spectral type... what the heck
 ; use formula Mv = 4.83 - 2.5*log(L/Lsun) and since
 ; distance is 10pc mv = Mv
 ; Lum is expressed in J/sec (Lsun = 3.826e+26 J/sec)
 ;-------------------------------------------------------

 lum = 3.826d+26 * 10.d^( (4.83d0-double(Mag))/2.5d ) 

 _sd = str_init_descriptors( n, $
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

 return, _sd
end
;==========================================================================


       
;==========================================================================
; strcat_sao_input
;
;==========================================================================
function strcat_sao_input, dd, keyword, n_obj=n_obj, dim=dim, values=values, status=status, $
@nv_trs_keywords_include.pro
@nv_trs_keywords1_include.pro
	end_keywords

 return, strcat_input('sao', dd, keyword, n_obj=n_obj, dim=dim, values=values, status=status, $
@nv_trs_keywords_include.pro
@nv_trs_keywords1_include.pro
	end_keywords )

end
;==========================================================================
