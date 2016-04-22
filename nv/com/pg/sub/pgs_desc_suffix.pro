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
;	string = pgs_desc_suffix(gd)
;
;
; ARGUMENTS:
;  INPUT:
;	gd:	Generic descriptor.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	<x>d:	There is an input keyword for each descriptor type,
;		which will override anything in gd.
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
function pgs_desc_suffix, gd, $
                 dd=dd, crd=crd, bd=bd, md=md, dkx=dkx, gbx=gbx, dkd=dkd, $
                 gbd=gbd, pd=pd, sd=sd, rd=rd, cd=cd, sund=sund, bx=bx, od=od

 pgs_gd, gd, $
                 dd=dd, crd=crd, bd=bd, md=md, dkx=dkx, gbx=gbx, dkd=dkd, $
                 gbd=gbd, pd=pd, sd=sd, rd=rd, cd=cd, sund=sund, bx=bx, od=od

 suffix = ''
 if(keyword_set(dd)) then suffix = suffix + '/dd:' + cor_name(dd)
 if(keyword_set(crd)) then suffix = suffix + '/crd:' + cor_name(crd)
 if(keyword_set(bd)) then suffix = suffix + '/bd:' + cor_name(bd)
 if(keyword_set(md)) then suffix = suffix + '/md:' + cor_name(md)
 if(keyword_set(dkx)) then suffix = suffix + '/dkx:' + cor_name(dkx)
 if(keyword_set(gbx)) then suffix = suffix + '/gbx:' + cor_name(gbx)
 if(keyword_set(dk)) then suffix = suffix + '/dk:' + cor_name(dk)
 if(keyword_set(gbd)) then suffix = suffix + '/gbd:' + cor_name(gbd)
 if(keyword_set(pd)) then suffix = suffix + '/pd:' + cor_name(pd)
 if(keyword_set(sd)) then suffix = suffix + '/sd:' + cor_name(sd)
 if(keyword_set(rd)) then suffix = suffix + '/rd:' + cor_name(rd)
 if(keyword_set(cd)) then suffix = suffix + '/cd:' + cor_name(cd)
 if(keyword_set(sund)) then suffix = suffix + '/sund:' + cor_name(sund)
 if(keyword_set(bx)) then suffix = suffix + '/bx:' + cor_name(bx)
 if(keyword_set(od)) then suffix = suffix + '/od:' + cor_name(od)
 
 return, suffix
end
;=============================================================================
