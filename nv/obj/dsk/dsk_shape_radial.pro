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
;	z = dsk_shape_radial(dkd, a, e, dap, ta, m, em, tapm)
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
;	dap:	 Array (nt) of apsidal shift values. 
;
;	ta:	 Array (nta) of true anomalies at which to compute radii.
;
;	m:	 Array (nt) of radial wavenumbers.
;
;	em:	 Array (nt) of eccentricities for each m.
;
;	tapm:	 Array (nt) of true anomalies of periapse for each m.
;
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:  
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
;	Array (nt x nta) of radii computed at each true anomaly on each 
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
function dsk_shape_radial, dkd=dkd, $
	a, e, dap, $		; nt x nta
	ta, $			; nta
	m, em, tapm, $		; nt x nta x nm
	mm=mm, mii=mii


 ;-----------------------------------
 ; get ring elements from dkd
 ;-----------------------------------
 if(keyword_set(dkd)) then $
  begin	
   if(NOT keyword_set(a)) then a = (dsk_sma(dkd))[0]
   if(NOT keyword_set(e)) then e = (dsk_ecc(dkd))[0]
   if(NOT keyword_set(dap)) then dap = (dsk_dap(dkd))[0]
   if(NOT keyword_set(m)) then m = (dsk_m(dkd))[*,0]
   if(NOT keyword_set(em)) then em = (dsk_em(dkd))[*,0]
   if(NOT keyword_set(tapm)) then tapm = (dsk_tapm(dkd))[*,0]
  end


 ;-----------------------------------
 ; m = 1 : keplerian ellipse
 ;-----------------------------------
 r01 = a*(1d - e^2)/(1d + e*cos(ta-dap))
 if(NOT keyword__set(m)) then return, r01		; keyword__set intended


 ;--------------------------------------------------
 ; m != 1 : streamline form; valid only for small e
 ;--------------------------------------------------
 nta = n_elements(ta)
 nt = n_elements(a)/nta
 nm = n_elements(m) / nt / nta

 sub = linegen3z(nt,nta,nm)
 tas = (ta##make_array(nt,val=1d))[sub]
 aa = a[sub]


 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ; note: where m = 0 and em != 0, this will produce an azimuth-independent
 ;       radial variation in time, i.e., a breathing mode.
 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; this doesn't seem right... I don't see how the m=0 can vary with time here
 rm = -aa*em*cos(m*((m NE 0)*tas - tapm))

 if(defined(mii)) then return, rm[*,*,mii]		; nt x nta

 if(keyword_set(mm)) then $
  begin
   ii = where(m[0,0,*] EQ mm)
   return, rm[*,*,ii]                                   ; nt x nta
  end

 if(nm EQ 1) then return, r01 + rm
 return, r01 + total(rm, 3)				; nt x nta
end
;===========================================================================
