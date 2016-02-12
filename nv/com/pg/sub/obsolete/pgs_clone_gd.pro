;=============================================================================
;+
; NAME:
;	pgs_clone_gd
;
;
; PURPOSE:
;	Clones a generic descriptor.
;
;
; CATEGORY:
;	NV/PGS
;
;
; CALLING SEQUENCE:
;	new_gd = pgs_clone_gd(gd)
;
;
; ARGUMENTS:
;  INPUT:
;	gd:		Generic descriptor to clone.
;
;  OUTPUT: NONE
;
;
; KEYWORDS:
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; RETURN:
;	A new generic descriptor is created containing descriptors cloned 
;	from the input generic descriptor.
;
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale
;	
;-
;=============================================================================
function pgs_clone_gd, gd
nv_message, /con, name='pgs_clone_gd', 'This routine is obsolete.  Use NV_CLONE instead.'

 if(NOT keyword__set(gd)) then return, 0

 tags = tag_names(gd)

 new_gd = gd


 if((where(tags EQ 'DD'))[0] NE -1) then new_gd.dd = nv_clone_descriptor(gd.dd)
 if((where(tags EQ 'CRD'))[0] NE -1) then $
                                     new_gd.crd = cor_clone_descriptor(gd.crd)
 if((where(tags EQ 'BD'))[0] NE -1) then $
                                     new_gd.bd = bod_clone_descriptor(gd.bd)
 if((where(tags EQ 'MD'))[0] NE -1) then $
                                     new_gd.md = map_clone_descriptor(gd.md)
 if((where(tags EQ 'DKD'))[0] NE -1) then $
                                     new_gd.dkd = dsk_clone_descriptor(gd.dkd)
 if((where(tags EQ 'GBD'))[0] NE -1) then $
                                     new_gd.gbd = glb_clone_descriptor(gd.gbd)
 if((where(tags EQ 'PD'))[0] NE -1) then $
                                     new_gd.pd = plt_clone_descriptor(gd.pd)
 if((where(tags EQ 'SD'))[0] NE -1) then $
                                     new_gd.sd = str_clone_descriptor(gd.sd)
 if((where(tags EQ 'RD'))[0] NE -1) then $
                                     new_gd.rd = rng_clone_descriptor(gd.rd)
 if((where(tags EQ 'CD'))[0] NE -1) then $
                                     new_gd.cd = cam_clone_descriptor(gd.cd)
 if((where(tags EQ 'SUND'))[0] NE -1) then $
                                    new_gd.sund = str_clone_descriptor(gd.sund)
 if((where(tags EQ 'BX'))[0] NE -1) then $
                                     new_gd.bx = class_clone_descriptor(gd.bx)
 if((where(tags EQ 'OD'))[0] NE -1) then $
                                     new_gd.od = class_clone_descriptor(gd.od)
 if((where(tags EQ 'DKX'))[0] NE -1) then $
                                     new_gd.dkx = class_clone_descriptor(gd.dkx)
 if((where(tags EQ 'GBX'))[0] NE -1) then $
                                     new_gd.gbx = class_clone_descriptor(gd.gbx)


 return, new_gd
end
;===========================================================================
