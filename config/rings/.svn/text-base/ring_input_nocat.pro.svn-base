;=============================================================================
;+
; NAME:
;	ring_input
;
;
; PURPOSE:
;	Input translator for planetary rings.
;
;
; CATEGORY:
;	NV/CONFIG
;
;
; CALLING SEQUENCE(only to be called by nv_get_value):
;	result = ring_input(dd, keyword)
;
;
; ARGUMENTS:
;  INPUT:
;	dd:		Data descriptor.
;
;	keyword:	String giving the name of the translator quantity.
;
;  OUTPUT:
;	NONE
;
;
; KEYWORDS:
;  INPUT:
;	key1:		Planet descriptor -- required
;
;	key2:		Camera descriptor
;
;  OUTPUT:
;	status:		Zero if valid data is returned
;
;	n_obj:		Number of objects returned.
;
;	dim:		Dimensions of return objects.
;
;
;  TRANSLATOR KEYWORDS:
;	system:		Asks translator to return a single ring descriptor
;			encompassing the entire ring system.  If not specified,
;			the translator may return a more detailed set of
;			individual rings.
;
;
; RETURN:
;	Data associated with the requested keyword.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale; 8/2004
;	
;-
;=============================================================================
function ring_input_nocat, dd, keyword, prefix, $
                      n_obj=n_obj, dim=dim, values=values, status=status, $
@nv_trs_keywords_include.pro
@nv_trs_keywords1_include.pro
	end_keywords

 status = 0
 n_obj = 0
 dim = [1]

 deg2rad = !dpi/180d
 degday2radsec = !dpi/180d / 86400d

 ;-----------------------------------------------
 ; translator arguments
 ;-----------------------------------------------
 system = tr_keyword_value(dd, 'system')

 ;-----------------------------------------------
 ; translator arguments
 ;-----------------------------------------------
 catalog = tr_keyword_value(dd, 'catalog')

 ;--------------------------
 ; verify keyword
 ;--------------------------
 if(keyword NE 'RNG_DESCRIPTORS') then $
  begin
   status = -1
   return, 0
  end


 ;-----------------------------------------------
 ; planet descriptor passed as key1
 ;-----------------------------------------------
 if(keyword__set(key1)) then pds = key1 $
 else nv_message, name='ring_input', 'Planet descriptor required.'

 ;-----------------------------------------------
 ; object names passed as key8
 ;-----------------------------------------------
 if(keyword__set(key8)) then names = key8



 ;-----------------------------------------------
 ; set up ring descriptors
 ;-----------------------------------------------
 npds = n_elements(pds)
 for i=0, npds-1 do $
  begin
   planet = cor_name(pds[i])

   dkd_inner = (dkd_outer = '')

   ;- - - - - - - - - - - - - - - - - - - - - - - - -
   ; construct disk descriptors for this planet
   ;- - - - - - - - - - - - - - - - - - - - - - - - -
   case planet of $
    'JUPITER': $
	begin
	 dkd_inner = orb_construct_descriptor(pds[i], /ring, GG=pgc_const('G'), $
			name = 'MAIN_RING_SYSTEM', $
			sma = 123740000d )
	 dkd_outer = orb_construct_descriptor(pds[i], /ring, GG=pgc_const('G'), $
			name = 'MAIN_RING_SYSTEM', $
			sma = 130215000d )
	 opaque = 1
	end

    'SATURN': $
	begin
	 dkd_d_inner = orb_construct_descriptor(pds[i], /ring, GG=pgc_const('G'), $
			name = 'D_RING', $
			sma = 66970000d )
	 dkd_d_outer = orb_construct_descriptor(pds[i], /ring, GG=pgc_const('G'), $
			name = 'D_RING', $
			sma = 74510000d )
	 opaque_d = 1

	 dkd_c_inner = orb_construct_descriptor(pds[i], /ring, GG=pgc_const('G'), $
			name = 'C_RING', $
			sma = 74510001d )
	 dkd_c_outer = orb_construct_descriptor(pds[i], /ring, GG=pgc_const('G'), $
			name = 'C_RING', $
			sma = 92000000d )
	 opaque_c = 1

	 dkd_b_inner = orb_construct_descriptor(pds[i], /ring, GG=pgc_const('G'), $
			name = 'B_RING', $
			sma = 92000001d )
	 dkd_b_outer = orb_construct_descriptor(pds[i], /ring, GG=pgc_const('G'), $
			name = 'B_RING', $
			sma = 117580000d )
	 opaque_b = 1

	 dkd_a_inner = orb_construct_descriptor(pds[i], /ring, GG=pgc_const('G'), $
			name = 'A_RING', $
			sma = 122170000d )
	 dkd_a_outer = orb_construct_descriptor(pds[i], /ring, GG=pgc_const('G'), $
			name = 'A_RING', $
			sma = 136780000d )
	 opaque_a = 1

; from Bosh et al. 2002
	 dkd_f_inner = orb_construct_descriptor(pds[i], /ring, $
			name = 'F_RING', $
			time = 0d, $   		; i.e., the J2000 epoch
			sma = 140178700d, $
			ecc =  0.00254d, $
			inc =  0.0065 * deg2rad, $
			lp =   24.1d * deg2rad, $
			lan =  16.1d * deg2rad, $
			dlpdt =  2.7001d * degday2radsec, $
			dlandt = -2.6876d * degday2radsec)
	 dkd_f_outer = orb_construct_descriptor(pds[i], /ring, $
			name = 'F_RING', $
			time = 0d, $   		; i.e., the J2000 epoch
			sma = 140268700d, $
			ecc =  0.00254d, $
			inc =  0.0065 * deg2rad, $
			lp =   24.1d * deg2rad, $
			lan =  16.1d * deg2rad, $
			dlpdt =  2.7001d * degday2radsec, $
			dlandt = -2.6876d * degday2radsec)

;	 dkd_f_inner = orb_construct_descriptor(pds[i], /ring, GG=pgc_const('G'), $
;			name = 'F_RING', $
;			sma = 140180000d )
;	 dkd_f_outer = orb_construct_descriptor(pds[i], /ring, GG=pgc_const('G'), $
;			name = 'F_RING', $
;			sma = 140270000d )
	 opaque_f = 1

	 dkd_g_inner = orb_construct_descriptor(pds[i], /ring, GG=pgc_const('G'), $
			name = 'G_RING', $
			sma = 165000000d )
	 dkd_g_outer = orb_construct_descriptor(pds[i], /ring, GG=pgc_const('G'), $
			name = 'G_RING', $
			sma = 176000000d )
	 opaque_g = 0

	 dkd_e_inner = orb_construct_descriptor(pds[i], /ring, GG=pgc_const('G'), $
			name = 'E_RING', $
			sma = 189870000d )
	 dkd_e_outer = orb_construct_descriptor(pds[i], /ring, GG=pgc_const('G'), $
			name = 'E_RING', $
			sma = 420000000d )
	 opaque_e = 0

	 dkd_inner = [dkd_a_inner, dkd_b_inner, dkd_c_inner, dkd_d_inner, $
                      dkd_e_inner, dkd_f_inner, dkd_g_inner]
	 dkd_outer = [dkd_a_outer, dkd_b_outer, dkd_c_outer, dkd_d_outer, $
                      dkd_e_outer, dkd_f_outer, dkd_g_outer]
	 opaque = [opaque_a, opaque_b, opaque_c, opaque_d, $
 	           opaque_e, opaque_f, opaque_g]
	end

    'URANUS': $
	begin
	 dkd_inner = orb_construct_descriptor(pds[i], /ring, GG=pgc_const('G'), $
			name = 'MAIN_RING_SYSTEM', $
			sma = 41837000d )
	 dkd_outer = orb_construct_descriptor(pds[i], /ring, GG=pgc_const('G'), $
			name = 'MAIN_RING_SYSTEM', $
			sma = 51149000d )
	 opaque = 1
	end

    'NEPTUNE': $
	begin
	 dkd_adams_inner = orb_construct_descriptor(pds[i], /ring, GG=pgc_const('G'), $
			name = 'ADAMS', $
			sma = 62905000d )
	 dkd_adams_outer = orb_construct_descriptor(pds[i], /ring, GG=pgc_const('G'), $
			name = 'ADAMS', $
			sma = 62955000d )
	 opaque_adams = 1

	 dkd_le_verrier_inner = orb_construct_descriptor(pds[i], /ring, GG=pgc_const('G'), $
			name = 'LE_VERRIER', $
			sma = 53175000d )
	 dkd_le_verrier_outer = orb_construct_descriptor(pds[i], /ring, GG=pgc_const('G'), $
			name = 'LE_VERRIER', $
			sma = 53225000d )
	 opaque_le_verrier = 1

	 dkd_galle_inner = orb_construct_descriptor(pds[i], /ring, GG=pgc_const('G'), $
			name = 'GALLE', $
			sma = 41150000d )
	 dkd_galle_outer = orb_construct_descriptor(pds[i], /ring, GG=pgc_const('G'), $
			name = 'GALLE', $
			sma = 42850000d )
	 opaque_galle = 1

	 dkd_inner = [dkd_adams_inner, dkd_le_verrier_inner, dkd_galle_inner]
	 dkd_outer = [dkd_adams_outer, dkd_le_verrier_outer, dkd_galle_outer]
	 opaque = [opaque_adams, opaque_le_verrier, opaque_galle]
	end

    else :
   endcase

   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   ; if /system, make one descriptor encompassing entire ring system
   ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   if(keyword__set(system)) then $
    begin
     sma = (dsk_sma(dkd_inner))[0,0,*]
     ecc = (dsk_ecc(dkd_inner))[0,0,*]
     q = sma*(1d - ecc)
     w = where(q EQ min(q))
     dkd_inner = dkd_inner[w]
     cor_set_name, dkd_inner, 'MAIN_RING_SYSTEM'

     sma = (dsk_sma(dkd_outer))[0,0,*]
     ecc = (dsk_ecc(dkd_outer))[0,0,*]
     q = sma*(1d + ecc)
     w = where(q EQ max(q))
     dkd_outer = dkd_outer[w]
     cor_set_name, dkd_outer, 'MAIN_RING_SYSTEM'
    end

   ;- - - - - - - - - - - - - - - - - - - - -
   ; merge inner/outer descriptors
   ;- - - - - - - - - - - - - - - - - - - - -
   if(keyword__set(dkd_inner)) then $
    begin
     dkd = dkd_inner
     ndkd = n_elements(dkd)
     for j=0, ndkd-1 do $
      begin
       sma = tr( [tr((dsk_sma(dkd[j]))[*,0]), tr((dsk_sma(dkd_outer[j]))[*,0])] )
       dsk_set_sma, dkd[j], sma
       ecc = tr( [tr((dsk_ecc(dkd[j]))[*,0]), tr((dsk_ecc(dkd_outer[j]))[*,0])] )
       dsk_set_ecc, dkd[j], ecc
       bod_set_pos, dkd[j], bod_pos(pds[i])
       bod_set_opaque, dkd[j], opaque[j]
      end

     dkds = append_array(dkds, dkd)
     primaries = append_array(primaries, make_array(ndkd, val=cor_name(pds[i])))
    end
  end

 if(NOT keyword_set(dkds)) then $
  begin
   status = -1
   return, 0
  end


 ;------------------------------------------------------------------
 ; select any requested names
 ;------------------------------------------------------------------
 if(keyword_set(names)) then $
  begin
   all_names = cor_name(dkds)
   w = nwhere(all_names, names)
   if(w[0] EQ -1) then $
    begin
     status = -1
     return, 0
    end
   dkds = dkds[w]
   primaries = primaries[w]
  end


 ;------------------------------------------------------------------
 ; make ring descriptors
 ;------------------------------------------------------------------
 n_obj = n_elements(dkds)
 rds = rng_init_descriptors(n_obj, $
		primary=primaries, $
		name=cor_name(dkds), $
		opaque=bod_opaque(dkds), $
		orient=bod_orient(dkds), $
		avel=bod_avel(dkds), $
		pos=bod_pos(dkds), $
		vel=bod_vel(dkds), $
		time=bod_time(dkds), $
		sma=dsk_sma(dkds), $
		ecc=dsk_ecc(dkds))


 return, rds
end
;===========================================================================



