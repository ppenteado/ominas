;=============================================================================
;+
; NAME:
;	array_input
;
;
; PURPOSE:
;	Input translator for arrays.
;
;
; CATEGORY:
;	NV/CONFIG
;
;
; CALLING SEQUENCE(only to be called by dat_get_value):
;	result = array_input(dd, keyword)
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
;	key1:  Body descriptor
;
;	key2:  Camera descriptor
;
;  OUTPUT:
;	status:  Zero if valid data is returned
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
;	Written by: Spitale; 10/2012
; 
;-
;=============================================================================



;=============================================================================
; ai_load
;
;=============================================================================
function ai_load, catpath, catfile, reload=reload
common ai_load_block, _catfile, _dat_p

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
   dat = arr_read(catdirs + '/' + catfile)

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
; array_input
;
;=============================================================================
function array_input, dd, keyword, prefix, values=values, status=status, $
@nv_trs_keywords_include.pro
@nv_trs_keywords1_include.pro
 end_keywords

 ;--------------------------
 ; verify keyword
 ;--------------------------
 if(keyword NE 'ARR_DESCRIPTORS') then $
  begin
   status = -1
   return, 0
  end


 ;----------------------------------------------
 ; check array catalog
 ;----------------------------------------------
 catpath = getenv('NV_ARRAY_DATA')
 if(NOT keyword_set(catpath)) then $
  begin
   nv_message, name='array_input', /con, $
     'NV_ARRAY_DATA environment variable is undefined.', $
       exp=['NV_ARRAY_DATA specifies the directory under which this translator', $
            'searches for data files.']
   status = -1
   return, 0
  end


 status = 0


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
 ; observer descriptor passed as key1
 ;-----------------------------------------------
 if(keyword_set(key1)) then od = key1
 if(NOT keyword_set(od)) then nv_message, name='array_input', 'No observer.'

 ;-----------------------------------------------
 ; primary descriptor passed as key2
 ;-----------------------------------------------
 if(keyword_set(key2)) then bx = key2

 ;-----------------------------------------------
 ; array names passed as key8
 ;-----------------------------------------------
 if(keyword_set(key8) AND (NOT keyword_set(names))) then names = key8


 ;-----------------------------------------------
 ; set up array descriptors
 ;-----------------------------------------------
 if(keyword_set(bx)) then xd = bx $
 else if(keyword_set(od)) then xd = od $
 else nv_message, name='array_input', 'No primary descriptor.'

 n = n_elements(xd)
 for i=0, n-1 do $
  begin
   _ards = 0
   primary = cor_name(xd[i])

   ;- - - - - - - - - - - - - - - - - - - - - - - - -
   ; read relevant array catalogs
   ;- - - - - - - - - - - - - - - - - - - - - - - - -
   dir = catpath + '/' + strlowcase(primary) + '/'
   files = file_search(dir + '*.arr')
   split_filename, files, dirs, files

   if(keyword_set(files)) then $
    begin
     nfiles = n_elements(files)

     if(NOT keyword_set(select_all)) then $ 
      if(keyword_set(names)) then $
       begin
        split_filename, files, _dir, name, ext
        w = nwhere(strupcase(name), strupcase(names))
        nfiles = n_elements(w)
        if(w[0] NE -1) then files = files[w] $
        else nfiles = 0
       end

     for j=0, nfiles-1 do $
      begin
       dat = ai_load(dir, files[j], reload=reload)
       split_filename, files[j], _dir, name, ext

       if(keyword_set(dat)) then $
        begin
         ;- - - - - - - - - - - - - - - - - - - - - - - -
         ; construct descriptors
         ;- - - - - - - - - - - - - - - - - - - - - - - -
         _ards = arr_create_descriptors(1, assoc_xd=cor_assoc_xd(xd[i]))

         cor_set_name, _ards, name
         arr_set_primary, _ards, xd[i]
         arr_set_surface_pts, _ards, dat
        end
       ards = append_array(ards, _ards)
      end
    end
  end


 if(NOT keyword_set(ards)) then $
  begin
   status = -1
   return, 0
  end


 return, ards
end
;===========================================================================



