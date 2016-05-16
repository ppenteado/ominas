;=============================================================================
; ominas_disk::init
;
;=============================================================================
function ominas_disk::init, ii, crd=crd0, bd=bd0, sld=sld0, dkd=dkd0, $
@disk__keywords.include
end_keywords
@core.include
 
 void = self->ominas_solid::init(ii, crd=crd0, bd=bd0, sld=sld0, $
@solid__keywords.include
end_keywords)
 if(keyword_set(dkd0)) then struct_assign, dkd0, self

 self.abbrev = 'DSK'


 self.m = -1

 if(keyword_set(sma)) then self.sma[0:(size(sma))[1]-1,*] = sma[*,*,ii]
 if(keyword_set(ecc)) then self.ecc[0:(size(ecc))[1]-1,*] = ecc[*,*,ii]

 if(keyword_set(nm)) then self.nm = nm[ii]
 if(keyword_set(m)) then self.m = m[ii]
 if(keyword_set(em)) then self.em = em[ii]
 if(keyword_set(lpm)) then self.lpm = lpm[ii]
 if(keyword_set(dlpmdt)) then self.dlpmdt = dlpmdt[ii]

 if(keyword_set(libm)) then self.libm = libm[ii]
 if(keyword_set(libam)) then self.libam = libam[ii]
 if(keyword_set(dlibmdt)) then self.dlibmdt = dlibmdt[ii]

 if(keyword_set(nl)) then self.nl = nl[ii]
 if(keyword_set(_l)) then self.l = l[ii]
 if(keyword_set(il)) then self.il = il[ii]
 if(keyword_set(lanl)) then self.lanl = lanl[ii]
 if(keyword_set(dlanldt)) then self.dlanldt = dlanldt[ii]

 if(keyword_set(libl)) then self.libl = libl[ii]
 if(keyword_set(libal)) then self.libal = libal[ii]
 if(keyword_set(dlibldt)) then self.dlibldt = dlibldt[ii]


 if(keyword_set(scale)) then self.scale = scale[*,ii] $
 else self.scale = [0.,1.]


 return, 1
end
;=============================================================================



;=============================================================================
;+
; NAME:
;	ominas_disk__define
;
;
; PURPOSE:
;	Class structure for the DISK class.
;
;
; CATEGORY:
;	NV/LIB/DSK
;
;
; CALLING SEQUENCE:
;	N/A 
;
;
; FIELDS:
;	sld:	SOLID class descriptor.  
;
;		Methods: dsk_solid, dsk_set_solid
;
;
;	sma:	Array ndv+1 x 2 giving the semimajor axes and derivatives
;		for each edge. 
;
;		Methods: dsk_sma, dsk_set_sma
;
;
;	ecc:	Array ndv+1 x 2 giving the eccentricities and derivatives
;		for each edge.
;
;		Methods: dsk_ecc, dsk_set_ecc
;
;
;	scale:	2-elements array giving optional radial scale coefficients:
;
;			 scaled_radii = scale[0] * radii*scale[1]
;
;		Methods: dsk_scale, dsk_set_scale, dsk_apply_scale
;
;
;	nm:	Integer giving the number of radial harmonics in the ring
;		shape.
;
;		Methods: dsk_nm, dsk_set_nm, dsk_get_nm
;
;
;	m:	Array nm x 2 giving the m value for each harmonic, for
;		each edge.
;
;		Methods: dsk_m, dsk_set_m, dsk_get_nm
;
;
;	em:	Array nm x 2 giving the eccentricity for each harmonic, for
;		each edge.
;
;		Methods: dsk_em, dsk_set_em
;
;
;	lpm:	Array nm x 2 giving the longitude of periapse for each 
;		harmonic, for each edge.
;
;		Methods: dsk_lpm, dsk_set_lpm
;
;
;	dlpmdt:	Array nm x 2 giving the apsidal precession rate for each 
;		harmonic, for each edge.
;
;		Methods: dsk_dlpmdt, dsk_set_dlpmdt
;
;
;	libam:	Array nm x 2 giving the libration amplitude for each 
;		harmonic, for each edge.
;
;		Methods: dsk_libam, dsk_set_libam
;
;
;	libm:	Array nm x 2 giving the libration phase for each 
;		harmonic, for each edge.
;
;		Methods: dsk_libm, dsk_set_libm
;
;
;	dlibmdt:	Array nm x 2 giving the libration frequency for each 
;			harmonic, for each edge.
;
;			Methods: dsk_dlibmdt, dsk_set_dlibmdt
;
;
;	nl:	Integer giving the number of radial harmonics in the ring
;		shape.
;
;		Methods: dsk_nm, dsk_set_nm, dsk_get_nm
;
;
;	l:	Array nl x 2 giving the l value for each harmonic, for
;		each edge.
;
;		Methods: dsk_m, dsk_set_m, dsk_get_nm
;
;
;	il:	Array nl x 2 giving the inclination for each harmonic, for
;		each edge.
;
;		Methods: dsk_em, dsk_set_em
;
;
;	lanl:	Array nl x 2 giving the longitude of periapse for each 
;		harmonic, for each edge.
;
;		Methods: dsk_lpm, dsk_set_lpm
;
;
;	dlanldt:	Array nl x 2 giving the nodal precession rate for each 
;			harmonic, for each edge.
;
;			Methods: dsk_dlpmdt, dsk_set_dlpmdt
;
;
;	libal:	Array nl x 2 giving the libration amplitude for each 
;		harmonic, for each edge.
;
;		Methods: dsk_libam, dsk_set_libam
;
;
;	libl:	Array nl x 2 giving the libration phase for each 
;		harmonic, for each edge.
;
;		Methods: dsk_libm, dsk_set_libm
;
;
;	dlibldt:	Array nl x 2 giving the libration frequency for each 
;			harmonic, for each edge.
;
;			Methods: dsk_dlibmdt, dsk_set_dlibmdt
;
;
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 1/1998
; 	Adapted by:	Spitale, 5/2016
;	
;-
;=============================================================================
pro ominas_disk__define

 ndv = bod_ndv()
 nm = dsk_get_nm()
 nl = dsk_get_nl()
 npht = dsk_npht()

 struct = $
    { ominas_disk, inherits ominas_solid, $
	sma:		 dblarr(ndv+1,2), $	; semimajor axes and derivatives
						;  Negative sma means no edge
	ecc:		 dblarr(ndv+1,2), $	; eccentricities and derivatives
						; 0=inner edge, 1=outer edge
						
	scale:		dblarr(2), $		; Radial scale coefficients:
						;  scaled_radii = 
						;    scale[0] * radii*scale[1]

	;--------------------- m != 1 radial harmonics ----------------------

	nm:		 intarr(2), $		; Number of m != 1  harmonics
	m:		 intarr(nm,2), $	; m values
	em:		 dblarr(nm,2), $	; ecc for each m != 1
	lpm:		 dblarr(nm,2), $	; lp for each m != 1
	dlpmdt:		 dblarr(nm,2), $	; dlpdt for each m != 1
						; 0=inner edge, 1=outer edge	
	libam:		 dblarr(nm,2), $	; Libration ampl. for each m != 1
	libm:		 dblarr(nm,2), $	; Libration phase for each m != 1
	dlibmdt:	 dblarr(nm,2), $	; Libration freq. for each m != 1

	;--------------------- l > 0 vertical harmonics ----------------------
	; We allow l=1 modes here so that one can specify inner and
	; outer planar edges with different inclinations.

	nl:		 intarr(2), $		; Number of l > 1  harmonics
	l:		 intarr(nl,2), $	; l values
	il:		 dblarr(nl,2), $	; inc for each l > 1
	lanl:		 dblarr(nl,2), $	; lan for each l > 1
	dlanldt:	 dblarr(nl,2), $		; dlandt for each l > 1
						; 0=inner edge, 1=outer edge	
	libal:	 	 dblarr(nm,2), $	; Libration ampl. for each l != 1
	libl:		 dblarr(nm,2), $	; Libration phase for each l != 1
	dlibldt:	 dblarr(nm,2)  $	; Libration freq. for each l != 1
						; 0=inner edge, 1=outer edge	
    }

end
;===========================================================================



