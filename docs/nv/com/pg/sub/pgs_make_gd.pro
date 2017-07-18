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
function pgs_make_gd, xds, gd=gd, $
                 dd=dd, crd=crd, bd=bd, md=md, dkx=dkx, gbx=gbx, dkd=dkd, $
                 gbd=gbd, pd=pd, sd=sd, std=std, ard=ard, rd=rd, cd=cd, sund=sund, bx=bx, od=od


 if(keyword_set(gd)) then pgs_gd, gd, $
                 dd=dd, crd=crd, bd=bd, md=md, dkx=dkx, gbx=gbx, dkd=dkd, $
                 gbd=gbd, pd=pd, sd=sd, std=std, ard=ard, rd=rd, cd=cd, sund=sund, bx=bx, od=od

 if(keyword_set(xds)) then $
  begin
   class = cor_class(xds)
   w = where(class EQ 'DATA')
   if(w[0] NE -1) then dd = append_array(dd, xds[w])
   w = where(class EQ 'CORE')
   if(w[0] NE -1) then crd = append_array(crd, xds[w])
   w = where(class EQ 'BODY')
   if(w[0] NE -1) then bd = append_array(bd, xds[w])
   w = where(class EQ 'MAP')
   if(w[0] NE -1) then md = append_array(md, xds[w])
   w = where(class EQ 'DISK')
   if(w[0] NE -1) then dkd = append_array(dkd, xds[w])
   w = where(class EQ 'GLOBE')
   if(w[0] NE -1) then gbd = append_array(gbd, xds[w])
   w = where(class EQ 'PLANET')
   if(w[0] NE -1) then pd = append_array(pd, xds[w])
   w = where(class EQ 'STAR')
   if(w[0] NE -1) then sd = append_array(sd, xds[w])
   w = where(class EQ 'STATION')
   if(w[0] NE -1) then std = append_array(std, xds[w])
   w = where(class EQ 'ARRAY')
   if(w[0] NE -1) then ard = append_array(ard, xds[w])
   w = where(class EQ 'RING')
   if(w[0] NE -1) then rd = append_array(rd, xds[w])
   w = where(class EQ 'CAMERA')
   if(w[0] NE -1) then cd = append_array(cd, xds[w])
   w = where((class EQ 'STAR') AND (cor_name(xds) EQ 'SUN'))
   if(w[0] NE -1) then sund = append_array(sund, xds[w])
  end

 if(NOT keyword_set(dd)) then dd = obj_new()
 if(NOT keyword_set(crd)) then crd = obj_new()
 if(NOT keyword_set(bd)) then bd = obj_new()
 if(NOT keyword_set(md)) then md = obj_new()
 if(NOT keyword_set(dkd)) then dkd = obj_new()
 if(NOT keyword_set(gbd)) then gbd = obj_new()
 if(NOT keyword_set(pd)) then pd = obj_new()
 if(NOT keyword_set(sd)) then sd = obj_new()
 if(NOT keyword_set(std)) then std = obj_new()
 if(NOT keyword_set(ard)) then ard = obj_new()
 if(NOT keyword_set(rd)) then rd = obj_new()
 if(NOT keyword_set(cd)) then cd = obj_new()
 if(NOT keyword_set(sund)) then sund = obj_new()
 if(NOT keyword_set(od)) then od = cd
 if(NOT keyword_set(dkx)) then dkx = rd
 if(NOT keyword_set(gbx)) then gbx = pd
 if(NOT keyword_set(bx)) then bx = obj_new()

 return, {dd:dd, crd:crd, bd:bd, md:md, dkd:dkd, gbd:gbd, pd:pd, sd:sd, std:std, ard:ard, $
                 rd:rd, cd:cd, sund:sund, od:od, dkx:dkx, gbx:gbx, bx:bx}
end
;=============================================================================
