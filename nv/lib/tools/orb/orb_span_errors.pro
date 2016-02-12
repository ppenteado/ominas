;==============================================================================
; ope_span_mc
;
;==============================================================================
function ope_span_mc, x0, _sig_x, nsig, n, seed

 sig_x = (_sig_x * nsig)[0]
 _x = (randomu(seed, n) - 0.5d) * 2d*sig_x + x0[0]

 return, _x
end
;==============================================================================



;==============================================================================
; ope_span
;
;==============================================================================
function ope_span, x0, _sig_x, nsig, nscan, n, dim

 sig_x = (_sig_x * nsig)[0]

 _x = (dindgen(nscan)/(nscan-1d) - 0.5d) * 2d*sig_x + x0[0]

 nrep = nscan^dim
 sub = lindgen(nscan*nrep)/nrep
 sub = sub # make_array(n/(nscan*nrep), val=1)
 sub = reform(sub, n)

 dim = dim + 1

 return, _x[sub]
end
;==============================================================================



;==============================================================================
; orb_span_errors
;
;  NOTE: the returned descriptors must be freed by the caller.
;
;==============================================================================
function orb_span_errors, dkx, gbx, sig_dkx, $
                          nsig=nsig, nscan=nscan, nsamples=n

 frame_bd = class_extract(gbx, 'BODY')
 if(NOT keyword__set(nsig)) then nsig = 1d
 if(NOT keyword__set(n)) then n = 100

 ;------------------------------------
 ; extract elements and uncertainties
 ;------------------------------------
 sma0 = orb_get_sma(dkx)
 ecc0 = orb_get_ecc(dkx)
 inc0 = orb_get_inc(dkx, frame_bd)
 ma0 = orb_get_ma(dkx)
 ap0 = orb_get_ap(dkx, frame_bd)
 lan0 = orb_get_lan(dkx, frame_bd)
 dmadt0 = orb_get_dmadt(dkx)
 dapdt0 = orb_get_dapdt(dkx, frame_bd)
 dlandt0 = orb_get_dlandt(dkx, frame_bd)

 tags = strlowcase(tag_names(sig_dkx))
 if((where(tags EQ 'sma'))[0] NE -1) then sig_sma = sig_dkx.sma
 if((where(tags EQ 'ecc'))[0] NE -1) then sig_ecc = sig_dkx.ecc
 if((where(tags EQ 'inc'))[0] NE -1) then sig_inc = sig_dkx.inc
 if((where(tags EQ 'ma'))[0] NE -1) then sig_ma = sig_dkx.ma
 if((where(tags EQ 'ap'))[0] NE -1) then sig_ap = sig_dkx.ap
 if((where(tags EQ 'lan'))[0] NE -1) then sig_lan = sig_dkx.lan
 if((where(tags EQ 'dmadt'))[0] NE -1) then sig_dmadt = sig_dkx.dmadt
 if((where(tags EQ 'dapdt'))[0] NE -1) then sig_dapdt = sig_dkx.dapdt
 if((where(tags EQ 'dlandt'))[0] NE -1) then sig_dlandt = sig_dkx.dlandt

 ;-------------------------------------------------------------
 ; set up a monte-carlo grid in orbital-element space
 ;-------------------------------------------------------------
 if(keyword__set(sig_sma)) then sma = ope_span_mc(sma0, sig_sma, nsig, n, seed) $
 else sma = make_array(n, val=sma0)
 if(keyword__set(sig_ecc)) then ecc = ope_span_mc(ecc0, sig_ecc, nsig, n, seed) $
 else ecc = make_array(n, val=ecc0)
 if(keyword__set(sig_inc)) then inc = ope_span_mc(inc0, sig_inc, nsig, n, seed) $
 else inc = make_array(n, val=inc0)
 if(keyword__set(sig_ma)) then ma = ope_span_mc(ma0, sig_ma, nsig, n, seed) $
 else ma = make_array(n, val=ma0)
 if(keyword__set(sig_ap)) then ap = ope_span_mc(ap0, sig_ap, nsig, n, seed) $
 else ap = make_array(n, val=ap0)
 if(keyword__set(sig_lan)) then lan = ope_span_mc(lan0, sig_lan, nsig, n, seed) $
 else lan = make_array(n, val=lan0)
 if(keyword__set(sig_dmadt)) then dmadt = ope_span_mc(dmadt0, sig_dmadt, nsig, n, seed) $
 else dmadt = make_array(n, val=dmadt0)
 if(keyword__set(sig_dapdt)) then dapdt = ope_span_mc(dapdt0, sig_dapdt, nsig, n, seed) $
 else dapdt = make_array(n, val=dapdt0)
 if(keyword__set(sig_dlandt)) then dlandt = ope_span_mc(dlandt0, sig_dlandt, nsig, n, seed) $
 else dlandt = make_array(n, val=dlandt0)

 ;------------------------------------------------
 ; make a descriptor for each orbit
 ;------------------------------------------------
 rd = orb_init_descriptors(n, gbx, name='ERROR_LOCUS', $
	t = bod_time(dkx), $
	sma=sma, $
	ecc=ecc, $
	inc=inc, $
	lan=lan, $
	ap=ap, $
	ma=ma, $
	dmadt=dmadt, $
	dlandt=dlandt, $
	dapdt=dapdt )

 return, rd
end
;==============================================================================
