;===========================================================================
; src_init_descriptors
;
;
;===========================================================================
function src_init_descriptors, n, $
@src__keywords.include
end_keywords


 scd = replicate({source_descriptor}, n)
 scd.class = decrapify(make_array(n, val='SOURCE'))

 if(keyword__set(src_bd)) then scd.src_bd = src_bd

 scd.bd = bod_init_descriptors(n,  $
@bod__keywords.include
end_keywords)


 scd_p = ptrarr(n)
 nv_rereference, scd_p, scd


 return, scd_p
end
;===========================================================================



