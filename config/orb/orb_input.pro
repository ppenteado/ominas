;=============================================================================
;+
; NAME:
;	orb_input
;
;
; PURPOSE:
;	Input translator for planetary orbits.
;
;
; CATEGORY:
;	NV/CONFIG
;
;
; CALLING SEQUENCE(only to be called by dat_get_value):
;	result = orb_input(dd, keyword)
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
;	key1:		Camera descriptor
;
;  OUTPUT:
;	status:		Zero if valid data is returned
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
; 	Written by:	Spitale; 9/2007
;	
;-
;=============================================================================



;=============================================================================
; oi_clone
;
;=============================================================================
function oi_clone, _rd

 n = n_elements(_rd)
 rd = objarr(n)

 for i=0, n-1 do if(obj_valid(_rd[i])) then $
                           rd[i] = nv_clone(_rd[i])

 return, rd
end
;=============================================================================



;=============================================================================
; oi_load
;
;=============================================================================
function oi_load, catpath, catfile, reload=reload
common oi_load_block, _catfile, _dat_p

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
   dat = orbcat_read(catdirs + '/' + catfile)

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
; oi_get_element
;
;=============================================================================
pro oi_get_element, dat, tag, var

 tags = tag_names(dat)
 w = where(tags EQ strupcase(tag))
 defined = dat.(w[0]+1)
 if(NOT defined) then return
 var = dat.(w[0])

end
;=============================================================================



;=============================================================================
; orb_input
;
;=============================================================================
function orb_input, dd, keyword, prefix, values=values, status=status, $
@nv_trs_keywords_include.pro
@nv_trs_keywords1_include.pro
	end_keywords

 ;--------------------------
 ; verify keyword
 ;--------------------------
 if(keyword NE 'PLT_DESCRIPTORS') then $
  begin
   status = -1
   return, 0
  end


 status = 0

 ;-----------------------------------------------
 ; translator arguments
 ;-----------------------------------------------
 select_all = tr_keyword_value(dd, 'all')
 reload = tr_keyword_value(dd, 'reload')
; sel_names = str_nsplit(tr_keyword_value(dd, 'name'), ';')
 sel_names = tr_keyword_value(dd, 'name')
 if(NOT keyword_set(sel_names[0])) then sel_names= '' $
 else select_all = 1


; ;-----------------------------------------------
; ; camera descriptor passed as key1
; ;-----------------------------------------------
; if(keyword_set(key1)) then cd = key1 $
; else $
;  begin
;   nv_message, /con, name='orb_input', 'Camera descriptor required.'
;   status = -1
;   return, 0
;  end


 ;-----------------------------------------------
 ; star descriptor passed as key2
 ;-----------------------------------------------
 if(keyword_set(key2)) then sd = key2
; if(keyword_set(sd)) then values = append_array(values, sd)

 ;------------------------------------------------------------
 ; primary planet descriptors must be passed as key4
 ; if not present, do not continue
 ;------------------------------------------------------------
 if(keyword_set(key4)) then pds = key4 $
 else $
  begin
   status = -1
   return, 0
  end

 ;-----------------------------------------------
 ; object names passed as key8
 ;-----------------------------------------------
 if(keyword_set(key8) AND (NOT keyword_set(sel_names))) then sel_names = key8



 ;-----------------------------------------------
 ; set up orbit descriptors
 ;-----------------------------------------------
 npds = n_elements(pds)
 for i=0, npds-1 do $
  begin
   planet = cor_name(pds[i])

   ;- - - - - - - - - - - - - - - - - - - - - - - - -
   ; read orbit catalog
   ;- - - - - - - - - - - - - - - - - - - - - - - - -
   catpath = getenv('NV_ORBIT_DATA')
   catfile = 'orbcat_' + strlowcase(planet) + '.txt'
   dat = oi_load(catpath, catfile, reload=reload)

;   catfile = getenv('NV_ORBIT_DATA') + '/orbcat_' + strlowcase(planet) + '.txt'
;   if(keyword_set(file_test(catfile))) then $
   if(keyword_set(dat)) then $
    begin
;     dat = oi_load(catfile, reload=reload)

     ;- - - - - - - - - - - - - - - - - - - - - - - -
     ; if any requested names, select only those
     ;- - - - - - - - - - - - - - - - - - - - - - - -
     continue = 1
     if(keyword_set(sel_names)) then $
      begin
       for j=0, n_elements(sel_names)-1 do $
               ww = append_array(ww, where(strupcase(dat.name) EQ strupcase(sel_names[j])), /def)

       if(ww[0] EQ -1) then continue = 0 $
       else $
        begin
         w = ww[where(ww NE -1)]
         if(w[0] EQ -1) then continue = 0 $
         else dat = dat[w]
        end
      end


     ;- - - - - - - - - - - - - - - - - - - - - - - -
     ; construct planet descriptors
     ;- - - - - - - - - - - - - - - - - - - - - - - -
     if(continue) then $
      begin
       ndat = n_elements(dat)
       for j=0, ndat-1 do $
        begin
         oi_get_element, dat[j], 'EPOCH', epoch
         oi_get_element, dat[j], 'PPT', ppt
         oi_get_element, dat[j], 'DAPDT', dapdt
         oi_get_element, dat[j], 'DLPDT', dlpdt
         oi_get_element, dat[j], 'DMLDT', dmldt
         oi_get_element, dat[j], 'DLANDT', dlandt
         oi_get_element, dat[j], 'DMADT', dmadt
         oi_get_element, dat[j], 'SMA', sma
         oi_get_element, dat[j], 'ECC', ecc
         oi_get_element, dat[j], 'INC', inc
         oi_get_element, dat[j], 'LAN', lan
         oi_get_element, dat[j], 'AP', ap
         oi_get_element, dat[j], 'MA', ma
         oi_get_element, dat[j], 'TA', ta
         oi_get_element, dat[j], 'TL', tl
         oi_get_element, dat[j], 'LP', lp
         oi_get_element, dat[j], 'ML', ml

         dkd = orb_construct_descriptor(pds[i], GG=GG, $
          name=dat[j].name, $
	   time = epoch, $
	   ppt = ppt, $
	   dapdt = dapdt, $
	   dlpdt = dlpdt, $
	   dmldt = dmldt, $
	   dlandt = dlandt, $
	   dmadt = dmadt, $
	   sma = sma, $
	   ecc = ecc, $
	   inc = inc, $
	   lan = lan, $
	   ap = ap, $
	   ma = ma, $
	   ta = ta, $
	   tl = tl, $
	   lp = lp, $
	   ml = ml)

         pos = orb_to_cartesian(dkd, vel=vel)
         
         _pd = plt_create_descriptors(1, $
		assoc_xd=dd, $
		name=cor_name(dkd), $
		pos=pos, $
		vel=vel, $
		time=bod_time(dkd))

         orb_pds = append_array(orb_pds, _pd)         
        end
      end
    end
  end


 if(NOT keyword_set(orb_pds)) then $
  begin
   status = -1
   return, 0
  end


 return, orb_pds
end
;===========================================================================



