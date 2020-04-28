;=============================================================================
;+
; NAME:
;       dsk_cat
;
;
; PURPOSE:
;	Concatenates the given disk descriptors into one descriptor encompassing
;	the entire system.
;
;
; CATEGORY:
;       NV/LIB/TOOLS
;
;
; CALLING SEQUENCE:
;       dkx_cat = dsk_cat(dkx)
;
;
; ARGUMENTS:
;  INPUT:
;	dkx:	Array (nt) of any subclass of DISK.
;
;  OUTPUT:
;       NONE
;
;
; KEYOWRDS:
;  INPUT: NONE
;
;  OUTPUT: NONE
;
;
; RETURN: 
;	A descriptor of the same class as dkx whose semimajor axes
;	encompass the all of the input disks.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale
;
;-
;=============================================================================
function dsk_cat, dkxs
@core.include

 n = n_elements(dkxs)
 if(n Eq 1) then return, nv_clone(dkxs[0])

 ;----------------------------------------------------
 ; Compute new sma.  New ecc is 0 and new sma
 ; spans inner periapse to outer apoapse
 ;----------------------------------------------------
 sma = dsk_sma(dkxs)
 ecc = dsk_ecc(dkxs)

 inner_radii = sma[0,0,*] * (1d - ecc[0,0,*])
 outer_radii = sma[0,1,*] * (1d + ecc[0,0,*])

 new_sma = reform(sma[*,*,0])
 new_sma[0,0] = min(inner_radii)
 new_sma[0,1] = max(outer_radii)

 new_ecc = reform(ecc[*,*,0])
 new_ecc[*] = 0

 ;----------------------------------------------------
 ; New name is concatentation of component names
 ;----------------------------------------------------
 names = cor_name(dkxs)
 new_name = names[0]
 for i=1, n-1 do  new_name = new_name + '/' + names[i]

 ;----------------------------------------------------
 ; New orientation is average of old one.  Note that
 ; this new matrix will be orthogonal.
 ;----------------------------------------------------
 orient = bod_orient(dkxs)
 new_orient = dblarr(3,3)
 new_orient[0,*] = v_unit(total(orient[0,*,*], 3) / double(n))
 new_orient[1,*] = v_unit(total(orient[1,*,*], 3) / double(n))
 new_orient[2,*] = v_unit(total(orient[2,*,*], 3) / double(n))

 ;-------------------------------------------------------------------------
 ; New avel are average of component avels.
 ;-------------------------------------------------------------------------
 avel = bod_avel(dkxs)
 new_avel = total(avel, 3) / double(n)

 ;-------------------------------------------------------------------------
 ; New position/velocity are average of component positions/velocities.
 ;-------------------------------------------------------------------------
 pos = bod_pos(dkxs)
 new_pos = total(pos, 3) / double(n)
 vel = bod_vel(dkxs)
 new_vel = total(vel, 3) / double(n)

 ;----------------------------------------------------
 ; Construct new descriptor.
 ;----------------------------------------------------
 new_dkx = nv_clone(dkxs[0])
 cor_set_name, new_dkx, new_name
 dsk_set_sma, new_dkx, new_sma
 dsk_set_ecc, new_dkx, new_ecc
 bod_set_orient, new_dkx, new_orient
 bod_set_avel, new_dkx, new_avel
 bod_set_pos, new_dkx, new_pos
 bod_set_vel, new_dkx, new_vel

 return, new_dkx
end
;===============================================================================
