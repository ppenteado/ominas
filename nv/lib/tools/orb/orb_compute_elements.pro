;==============================================================================
; orb_compute_elements
;
;==============================================================================
pro orb_compute_elements, rd, gbx, $
	sma=sma, $		; Semimajor axis
	ecc=ecc, $		; Eccentricity
	inc=inc, $		; Inclination
	ap=ap, $		; Argument of periapse
	lan=lan, $		; Lon. ascending node
	dmldt=dmldt, $		; Sidereal mean motion
	dmadt=dmadt, $		; Kepler mean motion
	dapdt=dapdt, $
	liba_ap=liba_ap, $
	dlibdt_ap=dlibdt_ap, $
	lib_ap=lib_ap, $
	dlandt=dlandt, $
	liba_lan=liba_lan, $
	dlibdt_lan=dlibdt_lan, $
	lib_lan=lib_lan, $
	ma=ma, $		; Mean anomaly
	ml=ml, $
	lp=lp, $
	ta=ta, $
	tl=tl, $
	rad=rad, $
        dlpdt=dlpdt, $
	time=t, $			; Epoch at which returned elements apply
	rdt=rdt, $
	gbxt=gbxt

; need to free rdt, gbxt if not returned!!!

 if(NOT defined(t)) then t = bod_time(gbx)

 ;-----------------------------------------
 ; precess to epoch
 ;-----------------------------------------
 gbxt = glb_evolve(gbx, t - bod_time(gbx))
 rdt = orb_evolve(rd, t - bod_time(rd))

 ;-----------------------------------------
 ; compute precessing elements
 ;-----------------------------------------
 bd = class_extract(gbxt, 'BODY')

 if(arg_present(sma)) then sma = orb_get_sma(rdt)
 if(arg_present(ecc)) then ecc = orb_get_ecc(rdt)
 if(arg_present(inc)) then inc = orb_get_inc(rdt, bd)
 if(arg_present(ap) $
    OR arg_present(lp)) then ap = orb_get_ap(rdt, bd)
 if(arg_present(lan)) then lan = orb_get_lan(rdt, bd)
 if(arg_present(ma) $
    OR arg_present(ml)) then ma = orb_get_ma(rdt)
 if(arg_present(dapdt) $
    OR arg_present(dlpdt) $
    OR arg_present(dmldt)) then dapdt = orb_get_dapdt(rdt, bd)
 if(arg_present(liba_ap)) then liba_ap = orb_get_liba_ap(rdt, bd)
 if(arg_present(dlibdt_ap)) then dlibdt_ap = orb_get_dlibdt_ap(rdt, bd)
 if(arg_present(lib_ap)) then lib_ap = orb_get_lib_ap(rdt, bd)
 if(arg_present(dlandt) $
    OR arg_present(dlpdt) $
    OR arg_present(dmldt)) then dlandt = orb_get_dlandt(rdt, bd)

 if(arg_present(liba_lan)) then liba_lan = orb_get_liba_lan(rdt, bd)
 if(arg_present(dlibdt_lan)) then dlibdt_lan = orb_get_dlibdt_lan(rdt, bd)
 if(arg_present(lib_lan)) then lib_lan = orb_get_lib_lan(rdt, bd)

 if(arg_present(dmadt) $
    OR arg_present(dmldt)) then dmadt = orb_get_dmadt(rdt)

 if(arg_present(lp)) then lp = orb_arg_to_lon(rdt, ap, bd)
 if(arg_present(ml)) then ml = orb_anom_to_lon(rdt, ma, bd)
 if(arg_present(dlpdt)) then dlpdt = dapdt + dlandt
 if(arg_present(dmldt)) then dmldt = dapdt + dlandt + dmadt

 if(arg_present(ta) $
    OR arg_present(tl)) then ta = orb_compute_ta(rdt)
 if(arg_present(tl)) then tl = reduce_angle(orb_anom_to_lon(rdt, ta, bd)) ; there may be a problem with this.

 if(arg_present(rad)) then rad = orb_compute_r(rdt)

end
;==============================================================================
