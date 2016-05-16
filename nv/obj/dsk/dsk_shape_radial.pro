;=============================================================================
;+
; NAME:
;	dsk_shape_radial
;
;
; PURPOSE:
;	Computes radii along the edge of a disk using disk elements.
;
;
; CATEGORY:
;	NV/LIB/DSK
;
;
; CALLING SEQUENCE:
;	z = dsk_shape_radial(dkd, a, e, lp, lon, m, em, lpm)
;
;
; ARGUMENTS:
;  INPUT:
;	dkd:	 Array (nt) of any subclass of DISK.
;
;	a:	 Array (nt) of semimajor axis values. 
;
;	e:	 Array (nt) of eccentricity values. 
;
;	lp:	 Array (nt) of longitudes of periapse. 
;
;	lon:	 Array (nlon) of longitudes at which to compute elevations.
;
;	m:	 Array (nt) of radial wavenumbers.
;
;	em:	 Array (nt) of eccentricities for each m.
;
;	lpm:	 Array (nt) of longitudes of periapse for each m.
;
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:  
;	frame_bd:	Subclass of BODY giving the frame against which to 
;			measure inclinations and nodes, e.g., a planet 
;			descriptor.  One for each dkd.
;
;	mm:	If set, only the radius component for this wavenumber
;		is returned.
;
;	mii:	If set, only the radius component with this index
;		is returned.
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Array (nt x nlon) of radii computed at each longitude on each 
;	disk.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
; 	Adapted by:	Spitale, 5/2016
;	
;-
;=============================================================================
function dsk_shape_radial, dkd=dkd, frame_bd=frame_bd, $
	a, e, lp, $		; nt x nlon
	lon, $			; nlon
	m, em, lpm, $		; nt x nlon x nm
	mm=mm, mii=mii


 ;-----------------------------------
 ; get ring elements from dkd
 ;-----------------------------------
 if(keyword_set(dkd)) then $
  begin						; keyword__set intentional here
   if(NOT keyword_set(a)) then a = (dsk_sma(dkd))[0]
   if(NOT keyword_set(e)) then e = (dsk_ecc(dkd))[0]
   if(NOT keyword_set(lp)) then $
       lp = orb_arg_to_lon(dkd, dsk_get_ap(dkd, frame_bd), frame_bd)
   if(NOT keyword_set(m)) then m = (dsk_m(dkd))[*,0]
   if(NOT keyword_set(em)) then em = (dsk_em(dkd))[*,0]
   if(NOT keyword_set(lpm)) then lpm = (dsk_lpm(dkd))[*,0]
  end


 ;-----------------------------------
 ; m = 1 : keplerian ellipse
 ;-----------------------------------
 r01 = a*(1d - e^2)/(1d + e*cos(lon-lp))
 if(NOT keyword__set(m)) then return, r01		; keyword__set intended


 ;--------------------------------------------------
 ; m != 1 : streamline form; valid only for small e
 ;--------------------------------------------------
 nlon = n_elements(lon)
 nt = n_elements(a)/nlon
 nm = n_elements(m) / nt / nlon

 sub = linegen3z(nt,nlon,nm)
 lons = (lon##make_array(nt,val=1d))[sub]
 aa = a[sub]


 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ; note: where m = 0 and em != 0, this will produce an azimuth-independent
 ;       radial variation in time, i.e., a breathing mode.
 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; this doesn't seem right... I don't see how the m=0 can vary with time here
 rm = -aa*em*cos(m*((m NE 0)*lons - lpm))

 if(defined(mii)) then return, rm[*,*,mii]		; nt x nlon

 if(keyword_set(mm)) then $
  begin
   ii = where(m[0,0,*] EQ mm)
   return, rm[*,*,ii]                                   ; nt x nlon
  end

 if(nm EQ 1) then return, r01 + rm
 return, r01 + total(rm, 3)				; nt x nlon
end
;===========================================================================
