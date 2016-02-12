;==================================================================
;+
; NAME:
;	pg_get_planets_sedr
;
;
; PURPOSE:
;	To read the SEDR and fill a planet descriptor.  Normally, one
;	would use pg_get_planets and let the SEDR translator fill the
;	planet descriptor with information about the SEDR Target. 
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
;       result = pg_get_planets_sedr(dd, source=source, /j2000)
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
function pg_get_planets_sedr, dd, ods=ods, gd=gd, j2000=j2000, source=source, $
no_sort=no_sort, $
@planet_keywords.include
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
;                          name='pg_get_planets_sedr', 'No observer descriptor.'


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
 ; Get SEDR and Body Constants
 ;---------------------------------
 sedr = sedr_read(sctime, planet=planet, source=_source)
 _size = size(sedr)
 if(_size[2] NE 8) then $
  begin
   nv_message, name='pg_get_planets_sedr', 'No SEDR/SEDRUPD match'
   return, 0
  end $
 else $
  print, format='(A,I7,A,A4,A,I3,A,I4)','Read SEDR ',sctime, '   source: ', $
          _source, '    Update: ', sedr.update_day,'/',sedr.update_year
 target_id = sedr.target
 bconst = sedr_get_bcons(target_id)
 _size = size(bconst)
 if(_size[2] NE 8) then $
  begin
   nv_message, name='pg_get_planets_sedr', 'No Body Constant data for Target'
   return, 0
  end

 ;-------------------------------
 ; name - array(nobj)
 ;-------------------------------
 if(n_elements(plt__name) EQ 0) then $
   plt__name=sedr_vgr_planets(sedr, bconst, 'PLT_NAME', j2000=j2000, $
                            n_obj=n_obj, dim=dim, status=status) $
 else override_name=1


 ;----------------------------------
 ; orientation - array(3,3,nobj)
 ;----------------------------------
 if(n_elements(plt__orient) EQ 0) then $
  begin
   plt__orient=sedr_vgr_planets(sedr, bconst, 'PLT_ORIENT', j2000=j2000, $
                            n_obj=n_obj, dim=dim, status=status)
   override_all=0
  end


 ;--------------------------------------
 ; angular velocity - array(ndv,3,nobj)
 ;--------------------------------------
 if(n_elements(plt__avel) EQ 0) then $
  begin
   plt__avel=sedr_vgr_planets(sedr, bconst, 'PLT_AVEL', j2000=j2000, $
                            n_obj=n_obj, dim=dim, status=status)
   override_all=0
  end


 ;-------------------------------
 ; position - array(1,3,nobj)
 ;-------------------------------
 if(n_elements(plt__pos) EQ 0) then $
  begin
   plt__pos=sedr_vgr_planets(sedr, bconst, 'PLT_POS', j2000=j2000, $
                            n_obj=n_obj, dim=dim, status=status)
   override_all=0
  end


 ;--------------------------------
 ; velocity - array(ndv,3,nobj)
 ;--------------------------------
 if(n_elements(plt__vel) EQ 0) then $
  begin
   plt__vel=sedr_vgr_planets(sedr, bconst, 'PLT_VEL', j2000=j2000, $
                            n_obj=n_obj, dim=dim, status=status)
   override_all=0
  end


 ;----------------------
 ; time - array(nobj)
 ;----------------------
 if(n_elements(plt__time) EQ 0) then $
  begin
   plt__time=sedr_vgr_planets(sedr, bconst, 'PLT_TIME', j2000=j2000, $
                            n_obj=n_obj, dim=dim, status=status)
   override_all=0
  end


 ;-----------------------
 ; radii - array(3,nobj)
 ;-----------------------
 if(n_elements(plt__radii) EQ 0) then $
  begin
   plt__radii=sedr_vgr_planets(sedr, bconst, 'PLT_RADII', j2000=j2000, $
                            n_obj=n_obj, dim=dim, status=status)
   override_all=0
  end


 ;----------------------
 ; lora - array(nobj)
 ;----------------------
 if(n_elements(plt__lora) EQ 0) then $
  begin
   plt__lora=sedr_vgr_planets(sedr, bconst, 'PLT_LORA', j2000=j2000, $
                            n_obj=n_obj, dim=dim, status=status)
   override_all=0
  end



 ;---------------------------------------------------
 ; Use plt_name to determine subscripts such that
 ; only values of the named objects are returned.
 ;
 ; If plt_name is not given, then all values will be
 ; returned.
 ;
 ; If plt_name is given and all values have been
 ; overridden, then do not call the translators.
 ;---------------------------------------------------
 n=n_elements(plt__name)
 if(override_name AND override_all) then sub=lindgen(n) $
 else $
  begin
   tr_names=sedr_vgr_planets(sedr, bconst, 'PLT_NAME', j2000=j2000, $
                            n_obj=n_obj, dim=dim, status=status)

   sub=nwhere(tr_names, plt__name)
  end



 ;-------------------------------
 ; create the planet descriptors
 ;-------------------------------
 _pds=plt_init_descriptors(n, $
	name=plt__name[sub], $
	orient=plt__orient[*,*,sub], $
	avel=plt__avel[*,*,sub], $
	pos=plt__pos[*,*,sub], $
	vel=plt__vel[*,*,sub], $
	time=plt__time[sub], $
	radii=plt__radii[*,sub], $
	lora=plt__lora[sub])


 ;-------------------------------------------------------
 ; if pds given, then concatenate with the new 
 ; descriptors and remove any repeated names, keeping
 ; only the most recent occurrence, i.e., entries
 ; which have resulted from this call.
 ;-------------------------------------------------------
 if(NOT keyword__set(pds)) then pds=_pds $
 else $
  begin
   pds=([pds,_pds])
   if(NOT keyword__set(no_sort)) then pds=pds[uniq(sort(class_get_name(pds)))]
  end


 return, pds
end
;===========================================================================



