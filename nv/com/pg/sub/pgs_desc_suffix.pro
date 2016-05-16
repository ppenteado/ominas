;=============================================================================
;+
; NAME:
;	pgs_desc_suffix
;
;
; PURPOSE:
;	Constructs a string describing all input descriptors.
;
;
; CATEGORY:
;	NV/PGS
;
;
; CALLING SEQUENCE:
;	string = pgs_desc_suffix(xd, gd=gd)
;
;
; ARGUMENTS:
;  INPUT:
;	xd:	Array of descriptors of arbitrary class.
;
;	dkx:	Descriptors to be listed as subclasses of DISK.
;
;	gbx:	Descriptors to be listed as subclasses of GLOBE.
;
;	bx:	Descriptors to be listed as subclasses of BODY.
;
;	sund:	Descriptors to be listed as SUN.
;
;	od:	Descriptors to be listed as OBSERVER.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	gd:	Generic descriptor from which the above special desccriptors
;		will be extracted.
;
;
;  OUTPUT: NONE
;
;
; RETURN:
;	String containing a list of descriptions delimited by '/'. 
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
;	
;-
;=============================================================================
function pgs_desc_suffix, xd, gd=gd, $
                              dkx=dkx, gbx=gbx, bx=bx, sund=sund, od=od

 pgs_gd, gd, dkx=dkx, gbx=gbx, bx=bx, sund=sund, od=od

 suffix = ''
 if(keyword_set(xd)) then $
   suffix = suffix + str_cat('/' + cor_class(xd) + ':' + cor_name(xd))

 if(keyword_set(dkx)) then suffix = suffix + str_cat('/DKX:' + cor_name(dkx))
 if(keyword_set(gbx)) then suffix = suffix + str_cat('/GBX:' + cor_name(gbx))
 if(keyword_set(bx)) then suffix = suffix + str_cat('/BX:' + cor_name(bx))
 if(keyword_set(sund)) then suffix = suffix + str_cat('/SUN:' + cor_name(sund))
 if(keyword_set(od)) then suffix = suffix + str_cat('/OBSERVER:' + cor_name(od))
 
 return, strmid(suffix, 1, 4096)
end
;=============================================================================
