;==============================================================================
; orb_create_descriptors
;
;  This routine differs from orb_construct_descriptor in that it doesn't
;  attempt to compute any quantities.  Also, it can produce any number of 
;  descriptors.
;
;==============================================================================
function orb_create_descriptors, n, gbx, $
		name=name, $
		sma=_sma, $		; Semimajor axis
		ecc=_ecc, $		; Eccentricity
		inc=inc, $		; Inclination
		lan=lan, $		; Lon. asc. node
		ap=ap, $		; Arg. Periapse
		ma=ma, $		; Mean anom. at epoch
		dmadt=dmadt, $		; Kepler mean motion
		dlandt=dlandt, $
		dapdt=dapdt, $
		t=t			; Epoch at which given elements apply


 ndv = bod_ndv()

 frame_bd = make_array(n, val=gbx, 'BODY')

 if(NOT keyword__set(t)) then t = make_array(n, val=bod_time(gbx))
 if(n_elements(name) EQ 1) then name = make_array(n, val=name)

 if(defined(_sma)) then sma = dblarr(ndv,2,n) & sma[0,0,*] = _sma
 if(defined(_ecc)) then ecc = dblarr(ndv,2,n) & ecc[0,0,*] = _ecc

 rd = rng_create_descriptors(n, $
		name=name, $
		primary = make_array(n, val={bx0:gbx}), $
		orient = (bod_orient(gbx))[linegen3z(3,3,n)], $
		pos = reform(tr(bod_pos(gbx)) # $
                                    make_array(n, val=1d), 1,3,n, /over), $
                time = t, $
                sma=sma, $
                ecc=ecc )

 if(defined(inc)) then orb_set_inc, rd, frame_bd, inc
 if(defined(lan)) then orb_set_lan, rd, frame_bd, lan
 if(defined(ap)) then orb_set_ap, rd, frame_bd, ap
 if(defined(ma)) then orb_set_ma, rd, ma
 if(defined(dlandt)) then orb_set_dlandt, rd, frame_bd, dlandt
 if(defined(dapdt)) then orb_set_dapdt, rd, frame_bd, dapdt
 if(defined(dmadt)) then orb_set_dmadt, rd, dmadt

 return, rd
end
;==============================================================================
