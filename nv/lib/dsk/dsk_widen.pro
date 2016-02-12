;===========================================================================
; dsk_widen
;[[]]
;
;===========================================================================
pro dsk_widen, dkxp, width
@nv_lib.include
 dkdp = class_extract(dkxp, 'DISK')
 dkd = nv_dereference(dkdp)

 ;--------------------------------
 ; determine center-line params
 ;--------------------------------
; w = where(dkd.sma[0,*,*] NE 0)
 w = where((dkd.sma[0,*,*] NE -1) AND (dkd.sma[0,*,*] NE 0))

 ;--------------------------------
 ; set edges
 ;--------------------------------
 dkd.sma[*,0,*] = dkd.sma[*,w,*] - width
 dkd.sma[*,1,*] = dkd.sma[*,w,*] + width

 dkd.ecc[*,0,*] = dkd.ecc[*,w,*]
 dkd.ecc[*,1,*] = dkd.ecc[*,w,*]

 dkd.nm[0] = dkd.nm[w]
 dkd.nm[1] = dkd.nm[w]

 dkd.m[*,0,*] = dkd.m[*,w,*]
 dkd.em[*,0,*] = dkd.em[*,w,*]
 dkd.lpm[*,0,*] = dkd.lpm[*,w,*]
 dkd.dlpmdt[*,0,*] = dkd.dlpmdt[*,w,*]

 dkd.m[*,1,*] = dkd.m[*,w,*]
 dkd.em[*,1,*] = dkd.em[*,w,*]
 dkd.lpm[*,1,*] = dkd.lpm[*,w,*]
 dkd.dlpmdt[*,1,*] = dkd.dlpmdt[*,w,*]


 dkd.nl[0] = dkd.nl[w]
 dkd.nl[1] = dkd.nl[w]

 dkd.l[*,0,*] = dkd.l[*,w,*]
 dkd.il[*,0,*] = dkd.il[*,w,*]
 dkd.lanl[*,0,*] = dkd.lanl[*,w,*]
 dkd.dlanldt[*,0,*] = dkd.dlanldt[*,w,*]

 dkd.l[*,1,*] = dkd.l[*,w,*]
 dkd.il[*,1,*] = dkd.il[*,w,*]
 dkd.lanl[*,1,*] = dkd.lanl[*,w,*]
 dkd.dlanldt[*,1,*] = dkd.dlanldt[*,w,*]


 nv_rereference, dkdp, dkd
 nv_notify, dkdp, type = 0
end
;===========================================================================



