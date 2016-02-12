;===========================================================================
; get_rings
;
; 
;===========================================================================
function get_rings, planet, plt_orient, system=system, $
                            n_obj=n_obj, ndv=ndv, name=name, get_names=get_names, $
                            sma=sma, ecc=ecc, orient=orient

 status = 0

 case planet of $

  'JUPITER': $
	begin
	 ndv=1
	 n_obj=1
	 name=['MAIN_RING_SYSTEM']
	 sma=tr([123740d,130215d]*1000d)
	 ecc=tr([0d,0d])
	 orient = plt_orient
;	 orient = bod_inertialize_orient(plt_orient)
	end

  'SATURN': $ ; from cpck14Dec2001.tpc
	;--------------------------------------------------------
	; NOTE: i and e are set to zero for all rings because
	;   we don't know the locations of the node and periapse.
	;--------------------------------------------------------
	begin
	 ndv = 1
	 n_obj = 7
	 name = ['A_RING','B_RING','C_RING','D_RING', $
	         'E_RING', 'F_RING', 'G_RING']
	 sma = $
	  transpose( $
	   [tr([122170d,136780d]), $
	    tr([92000.001d,117580d]), $		; Add a meter so that ring
						; shadows don't get projected 
						; on other rings.
	    tr([74510.001d,92000d]), $
	    tr([66970d,74510d]), $
	    tr([189870d, 420000d]), $
	    tr([140180d, 140270d]), $
	    tr([165000d, 176000d]) ] )*1000d
	 ecc = transpose( [tr([0d,0d]),tr([0d,0d]),tr([0d,0d]),tr([0d,0d]),$
	                   tr([0d,0d]),tr([0d,0d]),tr([0d,0d])] )
	 orient = plt_orient
	end

  'URANUS': $
	begin
	 ndv=1
	 n_obj=1
	 name=['MAIN_RING_SYSTEM']
	 sma=tr([41837d,51149d]*1000d)
	 ecc=tr([0d,0d])
	 orient = plt_orient
	end

  'NEPTUNE': $
	begin
	 ndv = 1
	 n_obj = 3
	 name = ['ADAMS','LE_VERRIER','GALLE']
	 sma = $
	  transpose( $
	   [tr([62905d,62955d]),tr([53175d,53225d]),tr([41150d,42850d])] )*1000d
	 ecc = transpose( [tr([0d,0d]),tr([0d,0d]),tr([0d,0d])] )
	 orient = plt_orient
	end

   else: return, -1

 endcase


 ;---------------------------------------------------------------------
 ; if /system, make one descriptor encompassing entire ring system
 ;---------------------------------------------------------------------
 if(keyword__set(system)) then $
  begin
   ndv = 1
   n_obj = 1
   name = ['MAIN_RING_SYSTEM']
   q = sma*(1d - ecc)
   qq = sma*(1d + ecc)
   sma = tr([min(q), max(qq)])
   ecc = tr([0d,0d])
   orient = plt_orient
  end

 ;---------------------------------------------------------------------
 ; select any requested names
 ;---------------------------------------------------------------------
 if(keyword__set(get_names)) then $
  begin
   w = nwhere(name, get_names)
   if(w[0] EQ -1) then return, -1
   sma = sma[*,w]
   ecc = ecc[*,w]
   name = name[w]
   n_obj = n_elements(w)
  end

 return, status
end
;===========================================================================
