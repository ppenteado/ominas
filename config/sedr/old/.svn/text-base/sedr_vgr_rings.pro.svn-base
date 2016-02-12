;===========================================================================
;+
; NAME:
;	sedr_vgr_rings
;
;
; PURPOSE:
;	To be called by Voyager SEDR input translator or similar procedure to
;	convert sedr values to an nv ring descriptor
;
; CATEGORY:
;	UTIL/SEDR
;
;
; RESTRICTIONS:
;	By default, Voyager values return B1950 co-ordinates
;	NOTE: This is a basic implementation only including one ring with the
;	inner and outer edges defined by the range of the entire planetary
;	ring system.  It does not include compenont rings including eccentric
;	rings.  This routine will implement RINGS as the VICAR program
;	NAV did some time in the future.
;
;
; MODIFICATION HISTORY:
;       Written by:     Haemmerle, 1/1999
;
;-
;===========================================================================
function sedr_vgr_rings, sedr, planet, keyword, j2000=j2000, $
         n_obj=n_obj, dim=dim, status=status

 status=0
 dim = [1]


 status = get_rings(planet, n_obj=n_obj, ndv=ndv, name=name, $
                            alpha_p=alpha_p, delta_p=delta_p, $
                            sma=sma, ecc=ecc, dlp=dlp)

; case planet of $
;
;'jupiter': $
;	begin
;	 alpha_p = 268.00d
;	 delta_p =  64.50d
;	 ndv=1
;	 n_obj=1
;	 name=['MAIN_RING_SYSTEM']
;         sma=tr([123740d,130215d])
;         ecc=tr([0d,0d])
;         dlp=tr([0d,0d])
;	end
;
; 'saturn': $
;        begin
;         alpha_p =  38.409d
;         delta_p =  83.324d
;         ndv=1
;         n_obj=1
;         name=['MAIN_RING_SYSTEM']
;         sma=tr([74500d,136800d])
;         ecc=tr([0d,0d])
;         dlp=tr([0d,0d])
;        end
;
; 'uranus': $
;	begin
;	 alpha_p =  76.5969d
;	 delta_p =  15.1117d
;        ndv=1
;	 n_obj=1
;	 name=['MAIN_RING_SYSTEM']
;         sma=tr([41837d,51149d])
;         ecc=tr([0d,0d])
;         dlp=tr([0d,0d])
;	end
;
;'neptune': $
;	begin
;	 alpha_p = 298.8575d
;	 delta_p =  42.8118d
;         ndv=1
;	 n_obj=3
;	 name=['ADAMS','LE VERRIER','GALLE']
;	 sma=[tr([62905d,62955d]),tr([53175d,53225d]),tr([41150d,42850d])]
;         ecc=[tr([0d,0d]),tr([0d,0d]),tr([0d,0d])]
;         dlp=[tr([0d,0d]),tr([0d,0d]),tr([0d,0d])]
;	end
;
; else: $
;	begin
;	 status=-1
;	 return, ''
;	end
;
; end

 sma = reform(sma,n_obj,ndv,2, /overwrite)
 ecc = reform(ecc,n_obj,ndv,2, /overwrite)
 dlp = reform(dlp,n_obj,ndv,2, /overwrite)

 ;--------------------------
 ; rng_name
 ;--------------------------
 rng_name = name

 ;--------------------------
 ; rng_primary
 ;--------------------------
 rng_primary = replicate(strupcase(planet), n_obj)

 ;--------------------------
 ; rng_orient
 ;--------------------------
 me_array = dblarr(3,3,n_obj)
 ;--------------------------------------------------------------
 ; ME is currenly central body inertial system 
 ; 0 long is ascending node of equator plane on EME1950
 ; To be implemented:  me different for each inclined ring plane
 ;--------------------------------------------------------------
 me = sedr_buildcm(alpha_p, delta_p, 0d)
 if(keyword__set(j2000)) then me = b1950_to_j2000(me)
 for i=0,n_obj-1 do $
  begin
   me_array[*,*,i] = me
  end
 rng_orient = me_array

 ;--------------------------
 ; rng_pos
 ;--------------------------
 if(sedr.target GT 0 and sedr.target LT 10) then $
 pos = transpose(double(sedr.sc_position + sedr.pb_position)) $
 else pos = transpose([0d,0d,0d])
 if(NOT keyword__set(j2000)) then pos = b1950_to_j2000(pos, /reverse)
 pos_array = dblarr(1,3,n_obj)
 for i=0,n_obj-1 do $
  begin
   pos_array[*,*,i] = pos 
  end
 rng_pos = pos_array

 ;--------------------------
 ; rng_vel
 ;--------------------------
 vel = transpose([0d,0d,0d])  ; Not implemented
 if(keyword__set(j2000)) then vel = b1950_to_j2000(vel)
 vel_array = dblarr(1,3,n_obj)
 for i=0,n_obj-1 do $
  begin
   vel_array[*,*,i] = vel
  end
 rng_vel = vel_array

 ;--------------------------
 ; rng_avel
 ;--------------------------
 avel = transpose([0d,0d,0d]) ; Not implemented
 if(keyword__set(j2000)) then avel = b1950_to_j2000(avel)
 avel_array = dblarr(1,3,n_obj)
 for i=0,n_obj-1 do $
  begin
   avel_array[*,*,i] = avel
  end
 rng_avel = avel_array

 ;-------------------------------
 ; rng_time -- Seconds past 1950
 ;-------------------------------
 time = sedr_time(sedr)
 rng_time = replicate(time, n_obj)

 ;--------------------------
 ; rng_sma
 ;--------------------------
 rng_sma = 1000d*transpose(sma, [1,2,0])

 ;--------------------------
 ; rng_ecc
 ;--------------------------
 rng_ecc = 1000d*transpose(ecc, [1,2,0])


 ;--------------------------
 ; rng_dlp
 ;--------------------------
 rng_dlp = 1000d*transpose(dlp, [1,2,0])


 rd = rng_init_descriptors(n_obj, $
		name=rng_name, $
		primary=rng_primary, $
		orient=rng_orient, $
		avel=rng_avel, $
		pos=rng_pos, $
		vel=rng_vel, $
		time=rng_time, $
		sma=rng_sma, $
		dlp=rng_dlp, $
		ecc=rng_ecc)


  return, rd

end
;===========================================================================
