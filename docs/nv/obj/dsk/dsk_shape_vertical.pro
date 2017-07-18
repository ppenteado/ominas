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
;	z = dsk_shape_vertical(dkd, a, ta, l, il, taanl)
;
;
; ARGUMENTS:
;  INPUT:
;	dkd:	 Array (nt) of any subclass of DISK.
;
;	a:	 Array (nt) of semimajor axis values. 
;
;	ta:	 Array (nta) of true anomalies at which to compute elevations.
;
;	l:	 Array (nt) of vertical wavenumbers.
;
;	il:	 Array (nt) of inclinations for each l.
;
;	taanl:	 Array (nt) of true anomalies of ascending node for each l.
;
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT:  
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
;	Array (nt x nta) of elevations computed at each true anomaly on each 
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
function dsk_shape_vertical, dkd=dkd, $
	a, $			; nt x nta
	ta, $			; nta
	l, il, taanl, $		; nt x nta x nm
	ll=ll, lii=lii

 if(keyword_set(dkd)) then $
  begin						; keyword__set intentional here
   if(NOT keyword_set(a)) then a = (dsk_sma(dkd))[0]
   if(NOT keyword_set(e)) then e = (dsk_ecc(dkd))[0]
   if(NOT keyword_set(m)) then m = (dsk_m(dkd))[*,0]
   if(NOT keyword_set(em)) then em = (dsk_em(dkd))[*,0]
   if(NOT keyword_set(taanl)) then taanl = (dsk_taanl(dkd))[*,0]
  end

 nta = n_elements(ta)
 nt = n_elements(a)/nta

 z00 = dblarr(nt, nta)	

 if(NOT keyword_set(l)) then return, z00
 if(l[0] EQ 0) then return, z00

 nl = n_elements(l) / nt / nta

 sub = linegen3z(nt,nta,nl)
 tas = (ta##make_array(nt,val=1d))[sub]
 aa = a[sub]

 zl = aa*sin(il)*sin(l*(tas-taanl))

 if(defined(lii)) then return, zl[*,*,lii]		; nt x nta

 if(keyword_set(ll)) then $
  begin
   ii = where(l[0,0,*] EQ ll)
   return, zl[*,*,ii]                                   ; nt x nta
  end

 if(nl EQ 1) then return, zl
 return, total(zl, 3)					; nt x nta
end
;===========================================================================
