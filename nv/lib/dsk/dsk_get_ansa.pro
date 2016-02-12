;===========================================================================
; dsk_get_ansa
;
; r is observer position in body coords.  Result is ansa vectors in body coords.
;
; NOT COMPLETE
;
;===========================================================================
function dsk_get_ansa, dkx, r, n=n
@nv_lib.include
 dkd = class_extract(dkx, 'DISK')

 if(NOT keyword__set(n)) then n = 1000

 zz = tr([0d,0d,1d])
 aa = v_cross(zz, v_unit(r))

 aa_dsk = dsk_body_to_disk(dkd, aa)
 lon = aa_dsk[1]

 rad = dsk_get_radius(dkd, lon)


 return, ansa_pts
end
;===========================================================================
