;=============================================================================
;+
; NAME:
;	sedr_vgr_input
;
;
; PURPOSE:
;	Input translator for Voyager images using SEDR database.
;
;
; CATEGORY:
;	NV/CONFIG
;
;
; CALLING SEQUENCE(only to be called by dat_get_value):
;	result = sedr_vgr_input(dd, keyword)
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
;	key1:		Camera descriptor.
;
;  OUTPUT:
;	status:		Zero if valid data is returned.
;
;	n_obj:		Number of objects returned.
;
;	dim:		Dimensions of return objects.
;
;
;  TRANSLATOR KEYWORDS:
;	j2000:		If set, returned quantites are rotated to j2000
;			reference frame.  Otherwise, results are b1950.
;
;	sedr_source:	String giving the name of the SEDR update source to use.
;			Default is 'SEDR'.
;
;
;  ENVIRONMENT VARIABLES:
;	NV_SEDR_DATA:	Directory containing the SEDR data files.  The 
;			variable should contain a trailing slash.
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
; 	Written by:	VRH
;	
;-
;=============================================================================
function sedr_vgr_input, dd, keyword, n_obj=n_obj, dim=dim, values=values, status=status, $
@nv_trs_keywords_include.pro
@nv_trs_keywords1_include.pro
	end_keywords

 common sedr_block, sedr, bconst
 status=0
 n_obj=0


 ;-----------------------------------------------
 ; translator keywords
 ;-----------------------------------------------
 j2000 = tr_keyword_value(dd, 'j2000')
 source = tr_keyword_value(dd, 'sedr_source')


 ;-----------------------------
 ; Check existance of SEDR data
 ;-----------------------------
 sedr_data = getenv('NV_SEDR_DATA')
 if(sedr_data EQ '') then $
    begin
     status = -1
     return, ''
    end


 ;---------------------------------
 ; get sctime and planet and source
 ;---------------------------------
 sctime = long(vicar_vgrkey(dat_header(dd),'SCTIME'))
 planet = vicar_vgrkey(dat_header(dd),'PLANET')
 if(keyword__set(source)) then _source=source $
 else _source = 'SEDR'

 ;---------------------------------------
 ; If needed, get SEDR and Body Constants
 ;---------------------------------------
 sedr = sedr_read(sctime, planet=planet, source=_source)
 _size = size(sedr)
 if(_size[2] NE 8) then $
  begin
   nv_message, name='sedr_vgr_input', 'No SEDR/SEDRUPD match', /con
   status = -1
   return, 0
  end

 print, format='(A,I7,A,A4,A,I3,A,I4)','Read SEDR ',sctime, '   source: ', $
          _source, '    Update: ', sedr.update_day,'/',sedr.update_year
 target_id = sedr.target
 bconst = sedr_get_bcons(target_id)
 _size = size(bconst)
 if(_size[2] NE 8) then $
  begin
   nv_message, name='sedr_vgr_input', 'No Body Constant data for Target', /con
   status = -1
   return, 0
  end


 ;--------------------------
 ; match keyword
 ;--------------------------

 ;-------------------camera keywords--------------------
 if(keyword EQ 'CAM_DESCRIPTORS') then $
   begin

    ;-----------------------------------------
    ; Test if image is Object space ("geomed")
    ;-----------------------------------------
    geom = 0
    if(strpos(dat_header(dd),'GEOM') NE -1) then geom = 1
    if(strpos(dat_header(dd),'FARENC') NE -1) then geom = 1
    if(strpos(dat_header(dd),'*** OBJECT SPACE') NE -1) then geom = 1
    s = size(dat_data(dd))
    ; If size = 1000x1000 assume it's geomed
    if(s[1] EQ 1000 AND s[2] EQ 1000) then geom = 1

    return, sedr_vgr_cameras(dd, sedr, geom, j2000=j2000, $
                            n_obj=n_obj, dim=dim, status=status)
   end

 ;-------------------planet keywords--------------------
 if(keyword EQ 'PLT_DESCRIPTORS') then $
   begin
    planet_pds = sedr_vgr_planets(planet, sedr, j2000=j2000, $
                                        n_obj=n_planets, dim=dim, status=status)

    target_pds = sedr_vgr_targets(sedr, bconst, j2000=j2000, $
                                        n_obj=n_targets, dim=dim, status=status)

    n_obj = n_planets + n_targets 
    return, [target_pds, planet_pds]
   end


 ;-------------------sun keywords--------------------
 if(keyword EQ 'STR_DESCRIPTORS') then $
   begin

    return, sedr_vgr_sun(sedr, bconst, j2000=j2000, $
                                        n_obj=n_obj, dim=dim, status=status)
   end


 status=-1
end
;===========================================================================
