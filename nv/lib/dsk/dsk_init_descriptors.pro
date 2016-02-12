;=============================================================================
;+
; NAME:
;	dsk_init_descriptors
;
;
; PURPOSE:
;	Init method for the DISK class.
;
;
; CATEGORY:
;	NV/LIB/DSK
;
;
; CALLING SEQUENCE:
;	dkd = dsk_init_descriptors(n)
;
;
; ARGUMENTS:
;  INPUT:
;	n:	Number of descriptors to create.
;
;  OUTPUT: NONE
;
;
; KEYWORDS (in addition to those accepted by all superclasses):
;  INPUT:  
;	dkd:	Disk descriptor(s) to initialize, instead of creating a new one.
;
;	sld:	Solid descriptor(s) instead of using sld_init_descriptors.
;
;	bd:	Body descriptor(s) to pass to bod_init_descriptors.
;
;	crd:	Core descriptor(s) to pass to cor_init_descriptors.
;
;	sma:	Array (ndv+1 x 2 x n) giving the semimajor axes and derivatives
;		for each edge. 
;
;	ecc:	Array (ndv+1 x 2 x n) giving the eccentricities and derivatives
;		for each edge.
;
;	scale:	Array (2 x n) giving radial scale coefficients.
;
;	nm:	Integer giving the number of radial harmonics in the ring
;		shape.
;
;	m:	Array (nm x 2 x n) giving the m value for each harmonic, for
;		each edge.
;
;	em:	Array (nm x 2 x n) giving the eccentricity for each harmonic, for
;		each edge.
;
;	lpm:	Array (nm x 2 x n) giving the longitude of periapse for each 
;		harmonic, for each edge.
;
;	dlpmdt:	Array (nm x 2 x n) giving the apsidal precession rate for each 
;		harmonic, for each edge.
;
;	libam:	Array (nm x 2 x n) giving the libration amplitude for each 
;		harmonic, for each edge.
;
;	libm:	Array (nm x 2 x n) giving the libration phase for each 
;		harmonic, for each edge.
;
;	dlibmdt:	Array (nm x 2 x n) giving the libration frequency for each 
;			harmonic, for each edge.
;
;	nl:	Integer giving the number of radial harmonics in the ring
;		shape.
;
;	_l:	Array (nl x 2 x n) giving the l value for each harmonic, for
;		each edge.  The leading underscore is needed to avoid 
;		conflict with other keywords.
;
;	il:	Array (l x 2 x n) giving the inclination for each harmonic, for
;		each edge.
;
;	lanl:	Array (nl x 2 x n) giving the longitude of periapse for each 
;		harmonic, for each edge.
;
;	dlanldt:	Array (nl x 2 x n) giving the nodal precession rate for each 
;			harmonic, for each edge.
;
;	libal:	Array (nl x 2 x n) giving the libration amplitude for each 
;		harmonic, for each edge.
;
;	libl:	Array (nl x 2 x n) giving the libration phase for each 
;		harmonic, for each edge.
;
;	dlibldt:	Array (nl x 2 x n) giving the libration frequency for each 
;			harmonic, for each edge.
;
;  OUTPUT: NONE
;
;
; RETURN:
;	Newly created or or freshly initialized disk descriptors, depending
;	on the presence of the dkd keyword.
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
function dsk_init_descriptors, n, crd=crd, sld=sld, bd=bd, dkd=dkd, $
@dsk__keywords.include
end_keywords
@nv_lib.include

 npht = glb_npht()

 if(NOT keyword_set(n)) then n = n_elements(dkd)

 if(NOT keyword_set(dkd)) then dkd=replicate({disk_descriptor}, n)
 dkd.class=decrapify(make_array(n, val='DISK'))
 dkd.abbrev=decrapify(make_array(n, val='DSK'))

 dkd.m = -1

 if(keyword_set(sma)) then dkd.sma[0:(size(sma))[1]-1,*,*] = sma
 if(keyword_set(ecc)) then dkd.ecc[0:(size(ecc))[1]-1,*,*] = ecc

 if(keyword_set(nm)) then dkd.nm = nm
 if(keyword_set(m)) then dkd.m = m
 if(keyword_set(em)) then dkd.em = em
 if(keyword_set(lpm)) then dkd.lpm = lpm
 if(keyword_set(dlpmdt)) then dkd.dlpmdt = dlpmdt

 if(keyword_set(libm)) then dkd.libm = libm
 if(keyword_set(libam)) then dkd.libam = libam
 if(keyword_set(dlibmdt)) then dkd.dlibmdt = dlibmdt

 if(keyword_set(nl)) then dkd.nl = nl
 if(keyword_set(_l)) then dkd.l = l
 if(keyword_set(il)) then dkd.il = il
 if(keyword_set(lanl)) then dkd.lanl = lanl
 if(keyword_set(dlanldt)) then dkd.dlanldt = dlanldt

 if(keyword_set(libl)) then dkd.libl = libl
 if(keyword_set(libal)) then dkd.libal = libal
 if(keyword_set(dlibldt)) then dkd.dlibldt = dlibldt


 if(keyword_set(scale)) then dkd.scale = scale $
 else dkd.scale = [0.,1.]#make_array(n, val=1d)


 if(keyword_set(sld)) then dkd.sld = sld $
 else dkd.sld=sld_init_descriptors(n, sld=sld, bd=bd, crd=crd, $
@sld__keywords.include
end_keywords)

 dkdp = ptrarr(n)
 nv_rereference, dkdp, dkd


 return, dkdp
end
;===========================================================================



