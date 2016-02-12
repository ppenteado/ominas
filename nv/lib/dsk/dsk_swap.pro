;===========================================================================
; dsk_swap
;
;  This routine is not used
;
;===========================================================================
pro dsk_swap, dkxp
@nv_lib.include
 dkdp = class_extract(dkxp, 'DISK')
 dkd = nv_dereference(dkdp)

 tags = tag_names(dkd)

 for i=2, n_elements(tags)-1 do $
  begin
   dim = size(dkd.(i), /dim)
   ndim = n_elements(dim)
   if(ndim EQ 2) then if(dim[1] EQ 2) then dkd.(i) = rotate(dkd.(i),7)
  end

 nv_rereference, dkdp, dkd
 nv_notify, dkdp, type = 0
end
;===========================================================================
