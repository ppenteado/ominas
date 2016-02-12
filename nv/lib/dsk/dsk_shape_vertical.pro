;=============================================================================
;+
; NAME:
;	dsk_shape_vertical
;
;
; PURPOSE:
;	Computes elevations along the edge of a disk using disk elements.
;
;
; CATEGORY:
;	NV/LIB/DSK
;
;
; CALLING SEQUENCE:
;	z = dsk_shape_vertical(dkx, a, i, lan, lon, l, il, lanl)
;
;
; ARGUMENTS:
;  INPUT:
;	dkx:	 Array (nt) of any subclass of DISK.
;
;	a:	 Array (nt) of semimajor axis values. 
;
;	i:	 Array (nt) of inclination values. 
;
;	lan:	 Array (nt) of longitudes of ascending node. 
;
;	lon:	 Array (nlon) of longitudes at which to compute elevations.
;
;	l:	 Array (nt) of vertical wavenumbers.
;
;	il:	 Array (nt) of inclinations for each l.
;
;	lanl:	 Array (nt) of longitudes of ascending node for each l.
;
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:  
;	frame_bd:	Subclass of BODY giving the frame against which to 
;			measure inclinations and nodes, e.g., a planet 
;			descriptor.  One for each dkx.
;
;	ll:	If set, only the elevation component for this wavenumber
;		is returned.
;
;	lii:	If set, only the elevation component with this index
;		is returned.
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Array (nt x nlon) of elevations computed at each longitude on each 
;	disk.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
;	
;-
;=============================================================================
function dsk_shape_vertical, dkx=dkx, frame_bd=frame_bd, $
	a, i, lan, $		; nt x nlon
	lon, $			; nlon
	l, il, lanl, $		; nt x nlon x nm
	ll=ll, lii=lii

 if(keyword_set(dkx)) then $
  begin						; keyword__set intentional here
   if(NOT keyword_set(a)) then a = (dsk_sma(dkx))[0]
   if(NOT keyword_set(e)) then e = (dsk_ecc(dkx))[0]
   if(NOT keyword_set(lp)) then $
       lp = orb_arg_to_lon(dkx, dsk_get_ap(dkx, frame_bd), frame_bd)
   if(NOT keyword_set(m)) then m = (dsk_m(dkx))[*,0]
   if(NOT keyword_set(em)) then em = (dsk_em(dkx))[*,0]
   if(NOT keyword_set(lpm)) then lpm = (dsk_lpm(dkx))[*,0]
  end

 nlon = n_elements(lon)
 nt = n_elements(a)/nlon

 z00 = dblarr(nt, nlon)	

 if(NOT keyword_set(l)) then return, z00
 if(l[0] EQ 0) then return, z00

 nl = n_elements(l) / nt / nlon

 sub = linegen3z(nt,nlon,nl)
 lons = (lon##make_array(nt,val=1d))[sub]
 aa = a[sub]

 zl = aa*sin(il)*sin(l*(lons-lanl))

 if(defined(lii)) then return, zl[*,*,lii]		; nt x nlon

 if(keyword_set(ll)) then $
  begin
   ii = where(l[0,0,*] EQ ll)
   return, zl[*,*,ii]                                   ; nt x nlon
  end

 if(nl EQ 1) then return, zl
 return, total(zl, 3)					; nt x nlon
end
;===========================================================================
