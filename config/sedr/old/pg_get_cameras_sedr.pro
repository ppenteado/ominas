;==================================================================
;+
; NAME:
;	pg_get_cameras_sedr
;
;
; PURPOSE:
;	To read the SEDR and fill a camera  descriptor.  Normally, one
;	would use pg_get_cameras and let the SEDR translator fill the
;	camera descriptor.  However, the translator will return values
;	in B1950 coordinates and the original predict SEDR.  This 
;	procedure gives one the choice of using J2000 coordinates and
;	also choosing a SEDRUPD record.
;
;
; CATEGORY:
;       NV/PG
;
;
; CALLING SEQUENCE:
;       result = pg_get_cameras_sedr(dd, source=source, /j2000)
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
;       Camera descriptor.
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
function pg_get_cameras_sedr, dd, j2000=j2000, source=source, no_sort=no_sort, $
@camera_keywords.include
@nv_trs_keywords.include
		end_keywords


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

 ;-----------------------------------------
 ; Test if image is Object space ("geomed")
 ;-----------------------------------------
 geom = 0
 if(strpos(nv_header(dd),'GEOM') NE -1) then geom = 1
 if(strpos(nv_header(dd),'FARENC') NE -1) then geom = 1
 if(strpos(nv_header(dd),'*** OBJECT SPACE') NE -1) then geom = 1
 s = size(nv_data(dd))
 ; If size = 1000x1000 assume it's geomed
 if(s[1] EQ 1000 AND s[2] EQ 1000) then geom = 1

 ;-------------------------------
 ; name - array(nobj)
 ;-------------------------------
 if(n_elements(cam__name) EQ 0) then $
   cam__name=sedr_vgr_cameras(sedr, geom, 'CAM_NAME', j2000=j2000, $
                              n_obj=n_obj, dim=dim, status=status) $
 else override_name=1

 ;----------------------------------
 ; orientation - array(3,3,nobj)
 ;----------------------------------
 if(n_elements(cam__orient) EQ 0) then $
  begin
   cam__orient=sedr_vgr_cameras(sedr, geom, 'CAM_ORIENT', j2000=j2000, $
                              n_obj=n_obj, dim=dim, status=status)
   override_all=0
  end


 ;--------------------------------------
 ; angular velocity - array(ndv,3,nobj)
 ;--------------------------------------
 if(n_elements(cam__avel) EQ 0) then $
  begin
   cam__avel=sedr_vgr_cameras(sedr, geom, 'CAM_AVEL', j2000=j2000, $
                              n_obj=n_obj, dim=dim, status=status)
   override_all=0
  end


 ;-------------------------------
 ; position - array(1,3,nobj)
 ;-------------------------------
 if(n_elements(cam__pos) EQ 0) then $
  begin
   cam__pos=sedr_vgr_cameras(sedr, geom, 'CAM_POS', j2000=j2000, $
                              n_obj=n_obj, dim=dim, status=status)
   override_all=0
  end


 ;--------------------------------
 ; velocity - array(ndv,3,nobj)
 ;--------------------------------
 if(n_elements(cam__vel) EQ 0) then $
  begin
   cam__vel=sedr_vgr_cameras(sedr, geom, 'CAM_VEL', j2000=j2000, $
                              n_obj=n_obj, dim=dim, status=status)
   override_all=0
  end


 ;----------------------
 ; time - array(nobj)
 ;----------------------
 if(n_elements(cam__time) EQ 0) then $
  begin
   cam__time=sedr_vgr_cameras(sedr, geom, 'CAM_TIME', j2000=j2000, $
                              n_obj=n_obj, dim=dim, status=status)
   override_all=0
  end

 ;---------------------------------
 ; fn_focal_to_image - array(nobj)
 ;---------------------------------
 if(n_elements(cam__fn_focal_to_image) EQ 0) then $
  begin
   cam__fn_focal_to_image=sedr_vgr_cameras(sedr, geom, 'CAM_FN_F2I', $
                              j2000=j2000, n_obj=n_obj, dim=dim, status=status)
   override_all=0
  end

 ;---------------------------------
 ; fn_image_to_focal - array(nobj)
 ;---------------------------------
 if(n_elements(cam__fn_image_to_focal) EQ 0) then $
  begin
   cam__fn_image_to_focal=sedr_vgr_cameras(sedr, geom, 'CAM_FN_I2F', $
                              j2000=j2000, n_obj=n_obj, dim=dim, status=status)
   override_all=0
  end

 ;---------------------------------
 ; fn_data - array(nobj)
 ;---------------------------------
 if(n_elements(cam__fn_data) EQ 0) then $
  begin
   cam__fn_data=sedr_vgr_cameras(sedr, geom, 'CAM_FN_DATA', j2000=j2000, $
                              n_obj=n_obj, dim=dim, status=status)
   if(status NE 0) then cam__fn_data=nv_ptr_new()

   override_all=0
  end


 ;-----------------------
 ; scale - array(2,nobj)
 ;-----------------------
 if(n_elements(cam__scale) EQ 0) then $
  begin
   cam__scale=sedr_vgr_cameras(sedr, geom, 'CAM_SCALE', j2000=j2000, $
                              n_obj=n_obj, dim=dim, status=status)
   override_all=0
  end


 ;-----------------------
 ; oaxis - array(2,nobj)
 ;-----------------------
 if(n_elements(cam__oaxis) EQ 0) then $
  begin
   cam__oaxis=sedr_vgr_cameras(sedr, geom, 'CAM_OAXIS', j2000=j2000, $
                              n_obj=n_obj, dim=dim, status=status)
   override_all=0
  end



 ;---------------------------------------------------
 ; Use cam_name to determine subscripts such that
 ; only values of the named objects are returned.
 ;
 ; If cam_name is not given, then all values will be
 ; returned.
 ;
 ; If cam_name is given and all values have been
 ; overridden, then do not call the translators.
 ;---------------------------------------------------
 n=n_elements(cam__name)
 if(override_name AND override_all) then sub=lindgen(n) $
 else $
  begin
   tr_names=sedr_vgr_cameras(sedr, geom, 'CAM_NAME', j2000=j2000, $
                              n_obj=n_obj, dim=dim, status=status)

   sub=nwhere(tr_names, cam__name)
  end



 ;-------------------------------
 ; create the camera descriptors
 ;-------------------------------
 _cds=cam_init_descriptors(n, $
	name=cam__name[sub], $
	orient=cam__orient[*,*,sub], $
	avel=cam__avel[*,*,sub], $
	pos=cam__pos[*,*,sub], $
	vel=cam__vel[*,*,sub], $
	time=cam__time[sub], $
	fn_focal_to_image=cam__fn_focal_to_image[sub], $
	fn_image_to_focal=cam__fn_image_to_focal[sub], $
	fn_data=cam__fn_data[sub], $
	scale=cam__scale[*,sub], $
	oaxis=cam__oaxis[*,sub])


 ;-------------------------------------------------------
 ; if cds given, then concatenate with the new 
 ; descriptors and remove any repeated names, keeping
 ; only the most recent occurrence, i.e., entries
 ; which have resulted from this call.
 ;-------------------------------------------------------
 if(NOT keyword__set(cds)) then cds=_cds $
 else $
  begin
   cds=([cds,_cds])
   if(NOT keyword__set(no_sort)) then cds=cds[uniq(sort(class_get_name(cds)))]
  end


 return, cds
end
;===========================================================================



