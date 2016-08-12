;=============================================================================
;+
; NAME:
;	pgs_gd
;
;
; PURPOSE:
;	Dereferences a generic descriptor.
;
;
; CATEGORY:
;	NV/PGS
;
;
; CALLING SEQUENCE:
;	pgs_gd, gd, <descriptor output keywords>
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
;	<x>d:	There is an output keyword for each descriptor type.
;
;  OUTPUT: NONE
;
;
; RETURN: NONE 
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
;	
;-
;=============================================================================
pro pgs_gd, gd, $
                 dd=dd, crd=crd, bd=bd, md=md, dkx=dkx, gbx=gbx, dkd=dkd, $
                 gbd=gbd, pd=pd, sd=sd, std=std, rd=rd, cd=cd, sund=sund, bx=bx, $
                 od=od, ard=ard, xd=xd, frame_bd=frame_bd

 if(NOT keyword_set(gd)) then return

 tags = tag_names(gd)

 if(NOT keyword_set(dd)) then $
    if((where(tags EQ 'DD'))[0] NE -1) then $
                           if(keyword_set(gd.dd)) then dd = gd.dd
 if(NOT keyword_set(crd)) then $
    if((where(tags EQ 'CRD'))[0] NE -1) then $
                           if(keyword_set(gd.crd)) then crd = gd.crd
 if(NOT keyword_set(bd)) then $
    if((where(tags EQ 'BD'))[0] NE -1) then $
                           if(keyword_set(gd.bd)) then bd = gd.bd
 if(NOT keyword_set(md)) then $
    if((where(tags EQ 'MD'))[0] NE -1) then $
                           if(keyword_set(gd.md)) then md = gd.md
 if(NOT keyword_set(dkx)) then $
    if((where(tags EQ 'DKX'))[0] NE -1) then $
                           if(keyword_set(gd.dkx)) then dkx = gd.dkx
 if(NOT keyword_set(gbx)) then $
    if((where(tags EQ 'GBX'))[0] NE -1) then $
                           if(keyword_set(gd.gbx)) then gbx = gd.gbx
 if(NOT keyword_set(dkd)) then $
    if((where(tags EQ 'DKD'))[0] NE -1) then $
                           if(keyword_set(gd.dkd)) then dkd = gd.dkd
 if(NOT keyword_set(gbd)) then $
    if((where(tags EQ 'GBD'))[0] NE -1) then $
                           if(keyword_set(gd.gbd)) then gbd = gd.gbd
 if(NOT keyword_set(pd)) then $
    if((where(tags EQ 'PD'))[0] NE -1) then $
                           if(keyword_set(gd.pd)) then pd = gd.pd
 if(NOT keyword_set(sd)) then $
    if((where(tags EQ 'SD'))[0] NE -1) then $
                           if(keyword_set(gd.sd)) then sd = gd.sd
 if(NOT keyword_set(std)) then $
    if((where(tags EQ 'STD'))[0] NE -1) then $
                           if(keyword_set(gd.std)) then std = gd.std
 if(NOT keyword_set(rd)) then $
    if((where(tags EQ 'RD'))[0] NE -1) then $
                           if(keyword_set(gd.rd)) then rd = gd.rd
 if(NOT keyword_set(cd)) then $
    if((where(tags EQ 'CD'))[0] NE -1) then $
                           if(keyword_set(gd.cd)) then cd = gd.cd
 if(NOT keyword_set(sund)) then $
    if((where(tags EQ 'SUND'))[0] NE -1) then $
                           if(keyword_set(gd.sund)) then sund = gd.sund
 if(NOT keyword_set(xd)) then $
    if((where(tags EQ 'xd'))[0] NE -1) then $
                           if(keyword_set(gd.xd)) then xd = gd.xd
 if(NOT keyword_set(bx)) then $
    if((where(tags EQ 'BX'))[0] NE -1) then $
                           if(keyword_set(gd.bx)) then bx = gd.bx
 if(NOT keyword_set(od)) then $
    if((where(tags EQ 'OD'))[0] NE -1) then $
                           if(keyword_set(gd.od)) then od = gd.od
 if(NOT keyword_set(ard)) then $
    if((where(tags EQ 'ARD'))[0] NE -1) then $
                           if(keyword_set(gd.ard)) then od = gd.ard
 if(NOT keyword_set(frame_bd)) then $
    if((where(tags EQ 'FRAME_BD'))[0] NE -1) then $
                 if(keyword_set(gd.frame_bd)) then frame_bd = gd.frame_bd


end
;===========================================================================
