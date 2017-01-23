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
; CALLING SEQUENCE(only to be called by dat_get_value):
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
;
; ENVIRONMENT VARIABLES:
;	NV_RING_DATA:	Sets the directory in which to look for data files.
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



;=============================================================================
; ri_clone
;
;=============================================================================
function ri_clone, _rd

 n = n_elements(_rd)
 rd = objarr(n)

 for i=0, n-1 do if(obj_valid(_rd[i])) then $
                           rd[i] = nv_clone(_rd[i])

 return, rd
end
;=============================================================================



;=============================================================================
; ri_load
;
;=============================================================================
function ri_load, catfile, reload=reload
common ri_load_block, _catfile, _dat_p

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
 ; otherwise read and parse the catalog
 ;--------------------------------------------------------------------
 if(load) then $
  begin
   ;- - - - - - - - - - - - - - - - - - - -
   ; read the catalog
   ;- - - - - - - - - - - - - - - - - - - -
   dat = ringcat_read(catfile)

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
; ring_input
;
;=============================================================================
function ring_input, dd, keyword, prefix, values=values, status=status, $
@nv_trs_keywords_include.pro
@nv_trs_keywords1_include.pro
	end_keywords

 ;--------------------------
 ; verify keyword
 ;--------------------------
 if(keyword NE 'RNG_DESCRIPTORS') then $
  begin
   status = -1
   return, 0
  end

 ;----------------------------------------------
 ; if no ring catalog, then use old translator
 ;----------------------------------------------
 catpath = getenv('NV_RING_DATA')
 if(NOT keyword_set(catpath)) then $
   nv_message, /con, $
     'NV_RING_DATA environment variable is undefined.', $
       exp=['NV_RING_DATA specifies directory in which this translator', $
            'searches for ring catalog files.']

 status = 0

 deg2rad = !dpi/180d
 degday2radsec = !dpi/180d / 86400d

 ;-----------------------------------------------
 ; translator arguments
 ;-----------------------------------------------
 system = tr_keyword_value(dd, 'system')
 select_all = tr_keyword_value(dd, 'all')
 select_fiducial = tr_keyword_value(dd, 'fiducial')
 reload = tr_keyword_value(dd, 'reload')
 sel_names = tr_keyword_value(dd, 'name')
 if(NOT keyword_set(sel_names[0])) then sel_names= '' $
 else select_all = 1


 ;-----------------------------------------------
 ; planet descriptor passed as key1
 ;-----------------------------------------------
 if(keyword_set(key1)) then pds = key1 $
; else nv_message, 'Planet descriptor required.'
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
 ; set up ring descriptors
 ;-----------------------------------------------
 npds = n_elements(pds)
 for i=0, npds-1 do $
  begin
   planet = cor_name(pds[i])

   dkd_inner = (dkd_outer = '')

   ;- - - - - - - - - - - - - - - - - - - - - - - - -
   ; read relevant ring catalog
   ;- - - - - - - - - - - - - - - - - - - - - - - - -
   catfile = catpath + '/ringcat_' + strlowcase(planet) + '.txt'
   if(file_test(catfile)) then $
    begin
     dat = ri_load(catfile, reload=reload)


     ;- - - - - - - - - - - - - - - - - - - - - - - -
     ; select desired rings by classification
     ;- - - - - - - - - - - - - - - - - - - - - - - -
     if(NOT keyword_set(select_all)) then $
      begin
       if(keyword_set(select_fiducial)) then w = where(dat.fiducial EQ 'yes') $
       else w = where(dat.default EQ 'yes')
       dat = dat[w]
      end


     ;- - - - - - - - - - - - - - - - - - - - - - - -
     ; if any requested names, select only those
     ;- - - - - - - - - - - - - - - - - - - - - - - -
     continue = 1
     if(keyword_set(sel_names)) then $
      begin
       for j=0, n_elements(sel_names)-1 do $
               ww = append_array(ww, where(strupcase(dat.ring) EQ strupcase(sel_names[j])), /def)
       w = ww[where(ww NE -1)]
       if(w[0] EQ -1) then continue = 0 $
       else dat = dat[w]
      end

     if(continue) then $
      begin
       ;- - - - - - - - - - - - - - - - - -
       ; build descriptors
       ;- - - - - - - - - - - - - - - - - -

       ;.............................................
       ; get unique ring names + all unnamed rings
       ;.............................................
       ss = sort(dat.name)
       uu = uniq(dat[ss].name)
       dat = dat[ss[uu]]


       ;...........................................................
       ; create descriptors
       ;  rings with no name are created using their feature name
       ;  with inner and outer edges identical
       ;...........................................................
       n_rings = n_elements(dat)

       opaque = strupcase(dat.opaque) EQ 'YES'

       dkd_inner = objarr(n_rings)
       dkd_outer = objarr(n_rings)
       dkd_peak = objarr(n_rings)
       dkd_trough = objarr(n_rings)
       kk = 0
       for j=0, n_rings-1 do $
        begin
         ring = dat[j].ring
         w = where(dat.ring EQ ring)
         name = ring

         nw = n_elements(w)
         if(nw GT 2) then nv_message, $
                    'Too many features with ring name ' + dat[j].ring + '.'
         w0 = where(dat[w].type EQ 'INNER') 
         w1 = where(dat[w].type EQ 'OUTER') 
         w2 = where(dat[w].type EQ 'PEAK') 
         w3 = where(dat[w].type EQ 'TROUGH') 

         dkd_inner[j] = (dkd_outer[j] = (dkd_peak[j] = (dkd_trough[j] = obj_new())))

         ;................................ 
         ; inner edge
         ;................................ 
         if(w0[0] NE -1) then $
          begin
           ii = w[w0]
           dkd_inner[j] = orb_construct_descriptor(pds[i], /ring, /noevolve, $
			name = strupcase(name), $
			time = dat[ii].epoch, $ 
			sma = dat[ii].sma, $
			ecc = dat[ii].ecc[0] , $
			lp =  dat[ii].lp[0] , $
			dlpdt = dat[ii].dlpdt[0] , $
			inc =  dat[ii].inc, $
			lan =  dat[ii].lan, $
			dlandt = dat[ii].dlandt)
           dm = size(dat[ii].ecc, /dim)
           if(n_elements(dm) GT 1) then $
            for k=1, dm[1]-1 do $
             begin
              dsk_set_m, dkd_inner[j], dat[ii].m[k]
              dsk_set_em, dkd_inner[j], dat[ii].ecc[k]
              dsk_set_lpm, dkd_inner[j], dat[ii].lp[k]
              dsk_set_dlpmdt, dkd_inner[j], dat[ii].dlpdt[k]
             end
           dkdx = append_array(dkdx, dkd_inner[j])	; save to free later
          end

         ;................................ 
         ; outer edge
         ;................................ 
         if(w1[0] NE -1) then $
          begin
           ii = w[w1]
           dkd_outer[j] = orb_construct_descriptor(pds[i], /ring, /noevolve, $
			name = strupcase(name), $
			time = dat[ii].epoch, $ 
			sma = dat[ii].sma, $
			ecc = dat[ii].ecc[0] , $
			lp =  dat[ii].lp[0] , $
			dlpdt = dat[ii].dlpdt[0] , $
			inc =  dat[ii].inc, $
			lan =  dat[ii].lan, $
			dlandt = dat[ii].dlandt)
           dm = size(dat[ii].ecc, /dim)
           if(n_elements(dm) GT 1) then $
            for k=1, dm[1]-1 do $
             begin
              dsk_set_m, dkd_outer[j], dat[ii].m[k]
              dsk_set_em, dkd_outer[j], dat[ii].ecc[k]
              dsk_set_lpm, dkd_outer[j], dat[ii].lp[k]
              dsk_set_dlpmdt, dkd_outer[j], dat[ii].dlpdt[k]
             end
           dkdx = append_array(dkdx, dkd_outer[j])	; save to free later
          end

         ;................................ 
         ; peak
         ;................................ 
         if(w2[0] NE -1) then $
          begin
           ii = w[w2]
           dkd_peak[j] = orb_construct_descriptor(pds[i], /ring, /noevolve, $
			name = strupcase(name), $
			time = dat[ii].epoch, $ 
			sma = dat[ii].sma, $
			ecc = dat[ii].ecc[0] , $
			lp =  dat[ii].lp[0] , $
			dlpdt = dat[ii].dlpdt[0] , $
			inc =  dat[ii].inc, $
			lan =  dat[ii].lan, $
			dlandt = dat[ii].dlandt)
           dm = size(dat[ii].ecc, /dim)
           if(n_elements(dm) GT 1) then $
            for k=1, dm[1]-1 do $
             begin
              dsk_set_m, dkd_peak[j], dat[ii].m[k]
              dsk_set_em, dkd_peak[j], dat[ii].ecc[k]
              dsk_set_lpm, dkd_peak[j], dat[ii].lp[k]
              dsk_set_dlpmdt, dkd_peak[j], dat[ii].dlpdt[k]
             end
           dsk_widen, dkd_peak[j], 0d

           dkds = append_array(dkds, dkd_peak[j])
           primaries = append_array(primaries, pds[i])
           assoc_xd = append_array(assoc_xd, cor_assoc_xd(pds[i]))
           ppds = append_array(ppds, pds[i])
           end

         ;................................ 
         ; trough
         ;................................ 
         if(w3[0] NE -1) then $
          begin
           ii = w[w3]
           dkd_trough[j] = orb_construct_descriptor(pds[i], /ring, /noevolve, $
			name = strupcase(name), $
			time = dat[ii].epoch, $ 
			sma = dat[ii].sma, $
			ecc = dat[ii].ecc[0] , $
			lp =  dat[ii].lp[0] , $
			dlpdt = dat[ii].dlpdt[0] , $
			inc =  dat[ii].inc, $
			lan =  dat[ii].lan, $
			dlandt = dat[ii].dlandt)
           dm = size(dat[ii].ecc, /dim)
           if(n_elements(dm) GT 1) then $
            for k=1, dm[1]-1 do $
             begin
              dsk_set_m, dkd_trough[j], dat[ii].m[k]
              dsk_set_em, dkd_trough[j], dat[ii].ecc[k]
              dsk_set_lpm, dkd_trough[j], dat[ii].lp[k]
              dsk_set_dlpmdt, dkd_trough[j], dat[ii].dlpdt[k]
             end
           dsk_widen, dkd_trough[j], 0d

           dkds = append_array(dkds, dkd_trough[j])
           primaries = append_array(primaries, pds[i])
           assoc_xd = append_array(assoc_xd, cor_assoc_xd(pds[i]))
           ppds = append_array(ppds, pds[i])
          end
        end

       ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       ; record which rings had only one edge, and fix them up so
       ; that the following calculations are valid
       ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       xx_inner = where(obj_valid(dkd_inner) EQ 0)
       xx_outer = where(obj_valid(dkd_outer) EQ 0)
       xx_peak = where(obj_valid(dkd_peak) EQ 0)
       xx_trough = where(obj_valid(dkd_trough) EQ 0)

       if(xx_inner[0] NE -1) then dkd_inner[xx_inner] = dkd_outer[xx_inner]
       if(xx_outer[0] NE -1) then dkd_outer[xx_outer] = dkd_inner[xx_outer]
       if(xx_peak[0] NE -1) then dkd_peak[xx_peak] = dkd_peak[xx_peak]
       if(xx_trough[0] NE -1) then dkd_trough[xx_trough] = dkd_trough[xx_trough]

       ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       ; if /system, make one descriptor encompassing entire ring system
       ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       if(keyword_set(system)) then $
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
         primaries = append_array(primaries, make_array(ndkd, val=pds[i]))
         assoc_xd = append_array(assoc_xd, make_array(ndkd, val=cor_assoc_xd(pds[i])))
         ppds = append_array(ppds, make_array(n_elements(dkd), val=pds[i]))
        end
      end

    end
  end


 if(NOT keyword_set(dkds)) then $
  begin
   status = -1
   return, 0
  end


 ;------------------------------------------------------------------
 ; handle rings with only one edge
 ;------------------------------------------------------------------
 if(xx_inner[0] NE -1) then $
  begin
   sma = dsk_sma(dkds[xx_inner])
   sma[0,0,*] = -1
   dsk_set_sma, dkds[xx_inner], sma
  end

 if(xx_outer[0] NE -1) then $
  begin
   sma = dsk_sma(dkds[xx_outer])
   sma[0,1,*] = -1
   dsk_set_sma, dkds[xx_outer], sma
  end


 ;----------------------------------------------
 ; evolve rings to primary epochs
 ;----------------------------------------------
 n_obj = n_elements(dkds)

 dkdts = objarr(n_obj)
 for i=0, n_obj-1 do $
  dkdts[i] = rng_evolve(dkds[i], bod_time(ppds[i]) - bod_time(dkds[i]))
 nv_free, dkdx


 ;------------------------------------------------------------------
 ; make ring descriptors
 ;------------------------------------------------------------------
 rds = rng_create_descriptors(n_obj, $
		assoc_xd=assoc_xd, $
		primary=primaries, $
		name=cor_name(dkdts), $
		opaque=bod_opaque(dkdts), $
		orient=bod_orient(dkdts), $
		avel=bod_avel(dkdts), $
		pos=bod_pos(dkdts), $
		vel=bod_vel(dkdts), $
		time=bod_time(dkdts), $
		sma=dsk_sma(dkdts), $
		ecc=dsk_ecc(dkdts))

 return, rds
end
;===========================================================================



