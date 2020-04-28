;===========================================================================
; dsk_widen
;[[]]
;
;===========================================================================
pro dsk_widen, dkd, width, noevent=noevent
@core.include
 
 _dkd = cor_dereference(dkd)

 ;--------------------------------
 ; determine center-line params
 ;--------------------------------
; w = where(_dkd.sma[0,*,*] NE 0)
 w = where((_dkd.sma[0,*,*] NE -1) AND (_dkd.sma[0,*,*] NE 0))

 ;--------------------------------
 ; set edges
 ;--------------------------------
 _dkd.sma[*,0,*] = _dkd.sma[*,w,*] - width
 _dkd.sma[*,1,*] = _dkd.sma[*,w,*] + width

 _dkd.ecc[*,0,*] = _dkd.ecc[*,w,*]
 _dkd.ecc[*,1,*] = _dkd.ecc[*,w,*]

 _dkd.nm[0] = _dkd.nm[w]
 _dkd.nm[1] = _dkd.nm[w]

 _dkd.m[*,0,*] = _dkd.m[*,w,*]
 _dkd.em[*,0,*] = _dkd.em[*,w,*]
 _dkd.lpm[*,0,*] = _dkd.lpm[*,w,*]
 _dkd.dlpmdt[*,0,*] = _dkd.dlpmdt[*,w,*]

 _dkd.m[*,1,*] = _dkd.m[*,w,*]
 _dkd.em[*,1,*] = _dkd.em[*,w,*]
 _dkd.lpm[*,1,*] = _dkd.lpm[*,w,*]
 _dkd.dlpmdt[*,1,*] = _dkd.dlpmdt[*,w,*]


 _dkd.nl[0] = _dkd.nl[w]
 _dkd.nl[1] = _dkd.nl[w]

 _dkd.l[*,0,*] = _dkd.l[*,w,*]
 _dkd.il[*,0,*] = _dkd.il[*,w,*]
 _dkd.lanl[*,0,*] = _dkd.lanl[*,w,*]
 _dkd.dlanldt[*,0,*] = _dkd.dlanldt[*,w,*]

 _dkd.l[*,1,*] = _dkd.l[*,w,*]
 _dkd.il[*,1,*] = _dkd.il[*,w,*]
 _dkd.lanl[*,1,*] = _dkd.lanl[*,w,*]
 _dkd.dlanldt[*,1,*] = _dkd.dlanldt[*,w,*]


 cor_rereference, dkd, _dkd
 nv_notify, dkd, type = 0, noevent=noevent
end
;===========================================================================



