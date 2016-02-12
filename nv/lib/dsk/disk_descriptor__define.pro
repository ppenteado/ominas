;=============================================================================
;+
; NAME:
;	disk_descriptor__define
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
;	
;-
;=============================================================================
pro disk_descriptor__define

 ndv = bod_ndv()
 nm = dsk_get_nm()
 nl = dsk_get_nl()
 npht = dsk_npht()

 struct = $
    { disk_descriptor, $
	sld:		 nv_ptr_new(), $	; ptr to solid descriptor
	class:		 '', $			; Name of descriptor class
	abbrev:		 '', $			; Abbreviation of descriptor class

	sma:		 dblarr(ndv+1,2), $	; semimajor axes and derivatives
						;  Negative sma means no edge
	ecc:		 dblarr(ndv+1,2), $	; eccentricities and derivatives
						; 0=inner edge, 1=outer edge
						
	scale:		dblarr(2), $		; Radial scale coefficients:
						;  scaled_radii = 
						;    scale[0] * radii*scale[1]

	;----------------------------------------
	; photometric parameters
	;----------------------------------------
	refl_fn:	 '', $			; Photometric functions
	refl_parm:	 dblarr(npht), $
	phase_fn:	 '', $	
	phase_parm:	 dblarr(npht), $

	albedo:		 0d, $			; Bond albedo

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



