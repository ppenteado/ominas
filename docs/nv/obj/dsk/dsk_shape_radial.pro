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
;	z = dsk_shape_radial(a, e, dap, ta, m, em, tapm)
;
;
; ARGUMENTS:
;  INPUT:
;	a:	 Array (nt) of semimajor axis values. 
;
;	e:	 Array (nt) of eccentricity values. 
;
;	dap:	 Array (nt) of apsidal shift values. 
;
;	ta:	 Array (nv x nt) of true anomalies at which to compute radii.
;
;	m:	 Array (nt x nm) of radial wavenumbers.
;
;	em:	 Array (nt x nm) of eccentricities for each m.
;
;	tapm:	 Array (nt x nm) of true anomalies of periapse for each m.
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
;	Array (nv x nt) of radii computed at each true anomaly on each 
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
function dsk_shape_radial, $
	_a, _e, _dap, $		; nt
	ta, $			; nv x nt
	_m, _em, _tapm, $	; nt x nm
	mm=mm, mii=mii

 nt = n_elements(_a)
 nv = n_elements(ta) / nt
 nm = n_elements(_m) / nt

 Mv = make_array(nv, val=1d)
 Mt = make_array(nt, val=1d)

 ;-----------------------------------
 ; m = 1 : keplerian ellipse
 ;-----------------------------------
 a = _a	## Mv						; nv x nt
 e = _e	## Mv						; nv x nt
 dap = _dap ## Mv					; nv x nt
 r01 = a*(1d - e^2)/(1d + e*cos(ta-dap))		; nv x nt
 if(NOT keyword__set(_m)) then return, r01		; keyword__set intended


 ;--------------------------------------------------
 ; m != 1 : streamline form; valid only for small e
 ;--------------------------------------------------
 sub = linegen3z(nt,nv,nm)
 tas = ta[sub]						; nv x nt x nm
 aa = a[sub]						; nv x nt x nm

 sub = linegen3x(nv,nt,nm)
 m = _m[sub]						; nv x nt x nm
 em = _em[sub]						; nv x nt x nm
 tapm = _tapm[sub]					; nv x nt x nm

 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ; note: where m = 0 and em != 0, this will produce an azimuth-independent
 ;       radial variation in time, i.e., a breathing mode.
 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
; this doesn't seem right... I don't see how the m=0 can vary with time here
 rm = -aa*em*cos(m*((m NE 0)*tas - tapm))		; nv x nt x nm

 if(defined(mii)) then return, rm[*,*,mii]		; nv x nt

 if(keyword_set(mm)) then $
  begin
   ii = where(m[0,0,*] EQ mm)
   return, rm[*,*,ii]                                   ; nv x nt
  end

 if(nm EQ 1) then return, r01 + rm			; nv x nt
 return, r01 + total(rm, 3)				; nv x nt
end
;===========================================================================
