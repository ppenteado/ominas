;===========================================================================
;+
; NAME:
;	dh_rings
;
;
; PURPOSE:
;	To be called by the make dh header routines to fill the ring
;	descriptor
;
; CATEGORY:
;	UTIL/SPICE
;
; USAGE:
;	dh_rings, dh, planet, et, pos, vel     
;
; ARGUMENTS:
;	     dh:	Detatched header
;	 planet:	Planet of ring system
;	     et:	Ephemeris time
;	    pos:	Position of main planet
;	    vel:	Velocity of main planet
;
; RESTRICTIONS:
;	This is a basic implementation only including one ring with the
;	inner and outer edges defined by the range of the entire planetary
;	ring system.  It does not include compenent rings including eccentric
;	rings.  This routine will implement RINGS as the VICAR program
;	NAV did some time in the future.
;
;
; MODIFICATION HISTORY:
;       Written by:     Haemmerle, 12/2000
;
;-
;===========================================================================
pro dh_rings, dh, planet, et, pos, vel

 status=0

 case planet of $

'jupiter': $
	begin
	 alpha_p = 268.05d
	 delta_p =  64.49d
	 ndv=1
	 n_obj=1
	 name=['MAIN_RING_SYSTEM']
         sma=tr([122500d,128940d])
         ecc=tr([0d,0d])
         dlp=tr([0d,0d])
	end

 'saturn': $
        begin
         alpha_p =  40.589d
         delta_p =  83.537d
         ndv=1
         n_obj=1
         name=['MAIN_RING_SYSTEM']
         sma=tr([74500d,136800d])
         ecc=tr([0d,0d])
         dlp=tr([0d,0d])
        end

 'uranus': $
	begin
	 alpha_p =  257.311d
	 delta_p =   15.175d
         ndv=1
	 n_obj=1
	 name=['MAIN_RING_SYSTEM']
         sma=tr([41837d,51149d])
         ecc=tr([0d,0d])
         dlp=tr([0d,0d])
	end

'neptune': $
	begin
	 alpha_p = 299.36d
	 delta_p =  43.46d
         ndv=1
	 n_obj=3
	 name=['ADAMS','LE VERRIER','GALLE']
	 sma=[tr([62905d,62955d]),tr([53175d,53225d]),tr([41150d,42850d])]
         ecc=[tr([0d,0d]),tr([0d,0d]),tr([0d,0d])]
         dlp=[tr([0d,0d]),tr([0d,0d]),tr([0d,0d])]
	end

 else: $
	begin
	  nv_message, name='dh_rings', 'Not a valid value for planet'
	end

 end
 sma = reform(sma,n_obj,ndv,2, /overwrite)
 ecc = reform(ecc,n_obj,ndv,2, /overwrite)
 dlp = reform(dlp,n_obj,ndv,2, /overwrite)

 ;--------------------------
 ; fill keywords
 ;--------------------------
 ring_primary = replicate(strupcase(planet), n_obj)
 me_array = dblarr(3,3,n_obj)
  ;--------------------------------------------------------------
  ; ME is currenly central body inertial system 
  ; 0 long is ascending node of equator plane on EME1950
  ; To be implemented:  me different for each inclined ring plane
  ;--------------------------------------------------------------
  me = sedr_buildcm(alpha_p, delta_p, 0d)
  for i=0,n_obj-1 do me_array[*,*,i] = me

  pos_array = dblarr(1,3,n_obj)
  for i=0,n_obj-1 do pos_array[*,*,i] = pos 

  vel_array = dblarr(1,3,n_obj)
  for i=0,n_obj-1 do vel_array[*,*,i] = vel

  avel = transpose([0d,0d,0d]) ; Not implemented
  avel_array = dblarr(1,3,n_obj)
  for i=0,n_obj-1 do avel_array[*,*,i] = avel

  sma = 1000d*transpose(sma, [1,2,0])
  ecc = 1000d*transpose(ecc, [1,2,0])
  dlp = 1000d*transpose(dlp, [1,2,0])

 for j=0,n_obj-1 do begin
  dh_put_value, dh, 'rng_sma', sma(*,*,j), object_index=j
  dh_put_value, dh, 'rng_ecc', ecc(*,*,j), object_index=j
  dh_put_value, dh, 'rng_dlp', dlp(*,*,j), object_index=j
  dh_put_value, dh, 'rng_avel', avel_array(*,*,j), object_index=j
  dh_put_value, dh, 'rng_pos', pos_array(*,*,j), object_index=j
  dh_put_value, dh, 'rng_vel', vel_array(*,*,j), object_index=j
  dh_put_value, dh, 'rng_time', et, object_index=j
  dh_put_value, dh, 'rng_orient', me_array(*,*,j), object_index=j
  dh_put_value, dh, 'rng_primary', ring_primary(j), object_index=j
  dh_put_value, dh, 'rng_name', name(j), object_index=j
 endfor

end
;===========================================================================
