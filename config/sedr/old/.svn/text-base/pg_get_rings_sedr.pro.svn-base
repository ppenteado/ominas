;==================================================================
;+
; NAME:
;	pg_get_rings_sedr
;
;
; PURPOSE:
;	To read the SEDR and fill a ring descriptor.  Normally, one
;	would use pg_get_rings and let the SEDR translator fill the
;	ring descriptor with information about the rings around the
;	SEDR central body. 
;	 However, the translator will return values in B1950 coordinates
;	and the original predict SEDR.  This procedure gives one the choice
;	of using J2000 coordinates and also choosing a SEDRUPD record.
;
;
; CATEGORY:
;       NV/PG
;
;
; CALLING SEQUENCE:
;       result = pg_get_rings_sedr(dd, source=source, /j2000)
;
;
; ARGUMENTS:
;  INPUT:
;
;	dd:	A data descriptor.
;
;  OUTPUT:
;       NONE
;
; KEYWORDS:
;  INPUT:
;
;	  source:    SEDR source, if given one of 'SEDR', 'DAVI',
;                    'NAV ', 'FARE', 'NAV2', 'NEAR', 'AMOS'.  If
;                    not given, then default is 'SEDR'.
;
;          j2000:    Return co-ordinates (matricies and vectors) in J2000.
;
;  OUTPUT:
;      NONE 
;
;
; RETURN:
;       Planet descriptor describing the SEDR target.
;
; RESTRICTIONS:
;	NONE.
;
;
; PROCEDURE:
;	The same routines used by the sedr_vgr_input nv translator, but
;	more flexability is allowed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Vance Haemmerle, 1/1999
;
;-
;=============================================================================
function pg_get_rings_sedr, dd, ods=ods, gd=gd, j2000=j2000, source=source, $
no_sort=no_sort, $
@ring_keywords.include
@nv_trs_keywords.include
		end_keywords


 ;-----------------------------------------------
 ; dereference the generic descriptor if given
 ;-----------------------------------------------
 if(keyword__set(gd)) then $
  begin
   if(NOT keyword__set(ods)) then ods=gd.ods
  end
; if(NOT keyword__set(ods)) then nv_message, $
;                            name='pg_get_rings_sedr', 'No observer descriptor.'


 override_all=1
 override_name=0

 ;---------------------------------
 ; get sctime and planet and source
 ;---------------------------------
 sctime = long(vicar_vgrkey(nv_header(dd),'SCTIME'))
 planet = vicar_vgrkey(nv_header(dd),'PLANET')
 if(NOT keyword__set(source)) then _source = 'SEDR' $
 else _source = source

 ;---------------------------------
 ; Get SEDR
 ;---------------------------------
 sedr = sedr_read(sctime, planet=planet, source=_source)
 _size = size(sedr)
 if(_size[2] NE 8) then $
  begin
   nv_message, name='pg_get_cameras_sedr', 'No SEDR/SEDRUPD match'
   return, 0
  end $
 else $
  print, format='(A,I7,A,A4,A,I3,A,I4)','Read SEDR ',sctime, '   source: ', $
          _source, '    Update: ', sedr.update_day,'/',sedr.update_year


 ;-------------------------------
 ; name - array(nobj)
 ;-------------------------------
 if(n_elements(rng__name) EQ 0) then $
   rng__name=sedr_vgr_rings(sedr, planet, 'RNG_NAME', j2000=j2000, $
                            n_obj=n_obj, dim=dim, status=status) $
 else override_name=1


 ;-------------------------------
 ; primary - array(nobj)
 ;-------------------------------
 if(n_elements(rng__primary) EQ 0) then $
   rng__primary=sedr_vgr_rings(sedr, planet, 'RNG_PRIMARY', j2000=j2000, $
                            n_obj=n_obj, dim=dim, status=status) $
 else override_name=1


 ;----------------------------------
 ; orientation - array(3,3,nobj)
 ;----------------------------------
 if(n_elements(rng__orient) EQ 0) then $
  begin
   rng__orient=sedr_vgr_rings(sedr, planet, 'RNG_ORIENT', j2000=j2000, $
                            n_obj=n_obj, dim=dim, status=status)
   override_all=0
  end


 ;--------------------------------------
 ; angular velocity - array(ndv,3,nobj)
 ;--------------------------------------
 if(n_elements(rng__avel) EQ 0) then $
  begin
   rng__avel=sedr_vgr_rings(sedr, planet, 'RNG_AVEL', j2000=j2000, $
                            n_obj=n_obj, dim=dim, status=status)
   override_all=0
  end


 ;-------------------------------
 ; position - array(1,3,nobj)
 ;-------------------------------
 if(n_elements(rng__pos) EQ 0) then $
  begin
   rng__pos=sedr_vgr_rings(sedr, planet, 'RNG_POS', j2000=j2000, $
                            n_obj=n_obj, dim=dim, status=status)
   override_all=0
  end


 ;--------------------------------
 ; velocity - array(ndv,3,nobj)
 ;--------------------------------
 if(n_elements(rng__vel) EQ 0) then $
  begin
   rng__vel=sedr_vgr_rings(sedr, planet, 'RNG_VEL', j2000=j2000, $
                            n_obj=n_obj, dim=dim, status=status)
   override_all=0
  end


 ;----------------------
 ; time - array(nobj)
 ;----------------------
 if(n_elements(rng__time) EQ 0) then $
  begin
   rng__time=sedr_vgr_rings(sedr, planet, 'RNG_TIME', j2000=j2000, $
                            n_obj=n_obj, dim=dim, status=status)
   override_all=0
  end


 ;--------------------------------------
 ; semimajor axis - array(ndv,2,nobj)
 ;--------------------------------------
 if(n_elements(rng__sma) EQ 0) then $
  begin
   rng__sma=sedr_vgr_rings(sedr, planet, 'RNG_SMA', j2000=j2000, $
                            n_obj=n_obj, dim=dim, status=status)
   override_all=0
  end


 ;--------------------------------------
 ; eccentricity - array(ndv,2,nobj)
 ;--------------------------------------
 if(n_elements(rng__ecc) EQ 0) then $
  begin
   rng__ecc=sedr_vgr_rings(sedr, planet, 'RNG_ECC', j2000=j2000, $
                            n_obj=n_obj, dim=dim, status=status)
   override_all=0
  end


 ;------------------------------------------------
 ; disk longitude of periapse - array(ndv,2,nobj)
 ;------------------------------------------------
 if(n_elements(rng__dlp) EQ 0) then $
  begin
   rng__dlp=sedr_vgr_rings(sedr, planet, 'RNG_DLP', j2000=j2000, $
                            n_obj=n_obj, dim=dim, status=status)
   override_all=0
  end



 ;---------------------------------------------------
 ; Use rng_name to determine subscripts such that
 ; only values of the named objects are returned.
 ;
 ; If rng_name is not given, then all values will be
 ; returned.
 ;
 ; If rng_name is given and all values have been
 ; overridden, then do not call the translators.
 ;---------------------------------------------------
 n=n_elements(rng__name)
 if(override_name AND override_all) then sub=lindgen(n) $
 else $
  begin
   tr_names=sedr_vgr_rings(sedr, planet, 'RNG_NAME', j2000=j2000, $
                            n_obj=n_obj, dim=dim, status=status)

   sub=nwhere(tr_names, rng__name)
  end



 ;-------------------------------
 ; create the ring descriptors
 ;-------------------------------
 _rds=rng_init_descriptors(n, $
	name=rng__name[sub], $
	primary=rng__primary[sub], $
	orient=rng__orient[*,*,sub], $
	avel=rng__avel[*,*,sub], $
	pos=rng__pos[*,*,sub], $
	vel=rng__vel[*,*,sub], $
	time=rng__time[sub], $
	sma=rng__sma[*,*,sub], $
	dlp=rng__dlp[*,*,sub], $
	ecc=rng__ecc[*,*,sub])


 ;-------------------------------------------------------
 ; if pds given, then concatenate with the new 
 ; descriptors and remove any repeated names, keeping
 ; only the most recent occurrence, i.e., entries
 ; which have resulted from this call.
 ;-------------------------------------------------------
 if(NOT keyword__set(rds)) then rds=_rds $
 else $
  begin
   rds=([rds,_rds])
   if(NOT keyword__set(no_sort)) then rds=rds[uniq(sort(class_get_name(rds)))]
  end


 return, rds
end
;===========================================================================



