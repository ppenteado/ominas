;=============================================================================
;+
; NAME:
;	pgs_make_gd
;
;
; PURPOSE:
;	Creates a generic descriptor.
;
;
; CATEGORY:
;	NV/PGS
;
;
; CALLING SEQUENCE:
;	new_gd = pgs_make_gd(gd,  <descriptor output keywords>
;
;
; ARGUMENTS:
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: 
;	gd:	Generic descriptor.  Fields from this descriptor will
;		be included in the output generic descriptor.
;
;	<x>d:	There is an input keyword for each descriptor type.
;
;  OUTPUT: NONE
;
;
; RETURN: 
;	Generic descriptor containing all of the input fields, and any 
;	descripors contained in gd.  Note that no descriptors are cloned;
;	only the pointers are copied.
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
;	
;-
;=============================================================================
function pgs_make_gd, gd=gd, $
                 dd=dd, crd=crd, bd=bd, md=md, dkx=dkx, gbx=gbx, dkd=dkd, $
                 gbd=gbd, pd=pd, sd=sd, std=std, ard=ard, rd=rd, cd=cd, sund=sund, bx=bx, od=od


 if(keyword_set(gd)) then pgs_gd, gd, $
                 dd=dd, crd=crd, bd=bd, md=md, dkx=dkx, gbx=gbx, dkd=dkd, $
                 gbd=gbd, pd=pd, sd=sd, std=std, ard=ard, rd=rd, cd=cd, sund=sund, bx=bx, od=od

 if(NOT keyword_set(dd)) then dd = 0
 if(NOT keyword_set(crd)) then crd = 0
 if(NOT keyword_set(bd)) then bd = 0
 if(NOT keyword_set(md)) then md = 0
 if(NOT keyword_set(dkd)) then dkd = 0
 if(NOT keyword_set(gbd)) then gbd = 0
 if(NOT keyword_set(pd)) then pd = 0
 if(NOT keyword_set(sd)) then sd = 0
 if(NOT keyword_set(std)) then std = 0
 if(NOT keyword_set(ard)) then ard = 0
 if(NOT keyword_set(rd)) then rd = 0
 if(NOT keyword_set(cd)) then cd = 0
 if(NOT keyword_set(sund)) then sund = 0
 if(NOT keyword_set(od)) then od = cd
 if(NOT keyword_set(dkx)) then dkx = rd
 if(NOT keyword_set(gbx)) then gbx = pd
 if(NOT keyword_set(bx)) then bx = 0

 return, {dd:dd, crd:crd, bd:bd, md:md, dkd:dkd, gbd:gbd, pd:pd, sd:sd, std:std, ard:ard, $
                 rd:rd, cd:cd, sund:sund, od:od, dkx:dkx, gbx:gbx, bx:bx}
end
;=============================================================================
