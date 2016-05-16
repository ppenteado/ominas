;=============================================================================
;+
; NAME:
;	station_input
;
;
; PURPOSE:
;	Input translator for planet-based stations.
;
;
; CATEGORY:
;	NV/CONFIG
;
;
; CALLING SEQUENCE(only to be called by dat_get_value):
;	result = station_input(dd, keyword)
;
;
; ARGUMENTS:
;  INPUT:
;	dd:  Data descriptor.
;
;	keyword: String giving the name of the translator quantity.
;
;  OUTPUT:
;	NONE
;
;
; KEYWORDS:
;  INPUT:
;	key2:  Primary body descriptor
;
;  OUTPUT:
;	status:  Zero if valid data is returned
;
;	n_obj:  Number of objects returned.
;
;	dim:  Dimensions of return objects.
;
;
;  TRANSLATOR KEYWORDS:
;	NONE
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
;	Written by: Spitale; 7/2007
; 
;-
;=============================================================================



;=============================================================================
; si_load
;
;=============================================================================
function si_load, catpath, catfile, reload=reload
common si_load_block, _catfile, _dat_p

 dat = ''

 ;--------------------------------------------------------------------
 ; if appropriate catalog is loaded, then just return descriptors
 ;--------------------------------------------------------------------
 load = 1

 if(keyword_set(_catfile) AND (NOT keyword_set(reload))) then $
  begin
   w = where(_catfile EQ catfile)
   if(w[0] NE -1) then $
    begin
     load = 0
     dat = *(_dat_p[w[0]])
    end
  end 


 ;--------------------------------------------------------------------
 ; parse catalog path
 ;--------------------------------------------------------------------
 catdirs = get_path(catpath, file=catfile)
 if(NOT keyword_set(catdirs[0])) then load = 0


 ;--------------------------------------------------------------------
 ; otherwise read and parse the catalog
 ;--------------------------------------------------------------------
 if(load) then $
  begin
   ;- - - - - - - - - - - - - - - - - - - -
   ; read the catalog
   ;- - - - - - - - - - - - - - - - - - - -
   dat = station_read(catdirs + '/' + catfile)

   ;- - - - - - - - - - - - - - - - - - - -
   ; save catalog data
   ;- - - - - - - - - - - - - - - - - - - -
   _catfile = append_array(_catfile, catfile)
   _dat_p = append_array(_dat_p, nv_ptr_new(dat))
  end

 return, dat
end
;=============================================================================



;=============================================================================
; station_input
;
;=============================================================================
function station_input, dd, keyword, prefix, $
                      n_obj=n_obj, dim=dim, values=values, status=status, $
@nv_trs_keywords_include.pro
@nv_trs_keywords1_include.pro
 end_keywords

 ;--------------------------
 ; verify keyword
 ;--------------------------
 if(keyword NE 'STN_DESCRIPTORS') then $
  begin
   status = -1
   return, 0
  end


 ;----------------------------------------------
 ; check station catalog
 ;----------------------------------------------
 catpath = getenv('NV_STATION_DATA')
 if(NOT keyword_set(catpath)) then $
   nv_message, name='station_input', $
     'NV_STATION_DATA environment variable is undefined.'


 status = 0
 n_obj = 0
 dim = [1]


 ;-----------------------------------------------
 ; translator arguments
 ;-----------------------------------------------
 select_all = tr_keyword_value(dd, 'all')
 reload = tr_keyword_value(dd, 'reload')
 names = str_nsplit(tr_keyword_value(dd, 'name'), ';')
 primaries = str_nsplit(tr_keyword_value(dd, 'primary'), ';')
 if(NOT keyword_set(names[0])) then names= '' $
 else select_all = 1


 ;-----------------------------------------------
 ; primary descriptor passed as key2
 ;-----------------------------------------------
 if(keyword_set(key2)) then bx = key2


 ;-----------------------------------------------
 ; station names passed as key8
 ;-----------------------------------------------
 if(keyword_set(key8) AND (NOT keyword_set(names))) then names = key8


 ;-----------------------------------------------
 ; primary names passed as key6
 ;-----------------------------------------------
 if(keyword_set(key6) AND (NOT keyword_set(primaries))) then primaries = key6
 if(NOT keyword_set(primaries)) then primaries = cor_name(bx)
 if(NOT keyword_set(primaries)) then $
                      nv_message, name='station_input', 'no primary.'


 ;-----------------------------------------------
 ; set up station descriptors
 ;-----------------------------------------------
 n = n_elements(primaries)
 for i=0, n-1 do $
  begin
   _stds = 0
   primary = primaries[i]

   ;- - - - - - - - - - - - - - - - - - - - - - - - -
   ; read relevant station catalog
   ;- - - - - - - - - - - - - - - - - - - - - - - - -
   catfile = 'stations_' + strlowcase(primary) + '.txt'
   dat = si_load(catpath, catfile, reload=reload)

   if(keyword_set(dat)) then $
    begin
     ;- - - - - - - - - - - - - - - - - - - - - - - -
     ; if any requested names, select only those
     ;- - - - - - - - - - - - - - - - - - - - - - - -
     continue = 1
     if(keyword_set(names)) then $
      begin
       ww = append_array(ww, nwhere(strupcase(dat.name), strupcase(names)))
       www = where(ww NE -1)
       if(www[0] EQ -1) then continue = 0 $
       else dat = dat[ww[www]]
      end

     ;- - - - - - - - - - - - - - - - - - - - - - - -
     ; construct descriptors
     ;- - - - - - - - - - - - - - - - - - - - - - - -
     if(continue) then $
      begin
       ndat = n_elements(dat)
       _stds = stn_create_descriptors(ndat)

       pos_surf = transpose([transpose([dat.lat]), transpose([dat.lon]), transpose([dat.alt])])

       cor_set_name, _stds, dat.name
       stn_set_primary, _stds, primary
       stn_set_surface_pt, _stds, reform(transpose(pos_surf), 1,3,ndat,/over)
      end
    end
   stds = append_array(stds, _stds)
  end


 if(NOT keyword_set(stds)) then $
  begin
   status = -1
   return, 0
  end



 n_obj = n_elements(stds)
 return, stds
end
;===========================================================================



