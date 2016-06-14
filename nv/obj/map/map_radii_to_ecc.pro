;===========================================================================
; map_radii_to_ecc
;
;===========================================================================
function map_radii_to_ecc, radii, rad=rad

 a = radii[2,*]

 ;--------------------------------------
 ; disk: polar radius is zero
 ;--------------------------------------
 if(a[0] EQ 0) then $
  begin
   ecc = radii[1,*]/radii[0,*] - 1d
   rad = radii[0,*]/(1d - ecc)
   return, ecc
  end
 
 ;--------------------------------------
 ; globe
 ;--------------------------------------
 b = 0.5d*(radii[0,*] + radii[1,*])
 rad = 0.5d*b
 return, sqrt(1d - (a/b)^2)
end
;===========================================================================



;===========================================================================
; map_radii_to_ecc
;
;  ecc is 2 x 2 x nt: 
;    disks use elements [0,1,*] ; i.e. rads correctsionare related to lons
;    globes use elements [0,0,*] ; i.e. lat corrections are related to lats
;
;===========================================================================
function ___map_radii_to_ecc, radii

 nt = n_elements(radii)/3

 ecc = dblarr(2,2,nt)
 a = radii[2,*]

 ;--------------------------------------
 ; disk: polar radius is zero
 ;--------------------------------------
 if(a[0] EQ 0) then ecc[0,1,*] = radii[1,*]/radii[0,*] - 1d $
 
 ;--------------------------------------
 ; globe
 ;--------------------------------------
 else $
  begin
   b = 0.5d*(radii[0,*] + radii[1,*])
   ecc[0,0,*] = sqrt(1d - (a/b)^2)
  end

 return, ecc
end
;===========================================================================

