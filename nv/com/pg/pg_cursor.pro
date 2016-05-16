;=============================================================================
;+
; NAME:
;	pg_cursor
;
;
; PURPOSE:
;	Allows the user to obtain information about image pixels selected 
;	using the mouse in the current graphics window.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	pg_cursor, dd
;
;
; ARGUMENTS:
;  INPUT:
;	dd:	Data descriptor containing the image.  Multiple data 
;		descriptors may be given and the pixel values for each will 
;		be displayed.  However, descriptors for only one of the data
;		descriptors may be given.
;
;  OUTPUT:
;	NONE
;
;
; KEYWORDS:
;  INPUT:
;	cd:	Camera descriptor.  Must be included for planet and ring
;		coordinate, RA/DEC, and photometric output.  A map descriptor
;		may be substitued for this argument, in which case ring
;		coordinates, RA/DEC, and photometric data are not output.
;
;	gbx:	Object descriptors, subclass of 'GLOBE'.  Must be included for 
;		planet coordinate output.
;
;	dkx:	Object descriptors, subclass of 'DISK'.  Must be included for 
;		ring coordinate output.
;
;	sund:	Star descriptor specifying the state of the sun.
;
;	sd:	Star descriptors.  Must be included for star otput.
;
;	gd:	Generic descriptor.  If given, the above object descriptors are
;		taken from this structure.
;
;	radec:	If set, right ascension and declination with respect to the
;		inertial coordinate system are output for each selected pixel. 
;
;	photom:	If set, photometric angles are output for each pixel that
;		intersects a planet or ring.  (Ring photometry is not yet
;		implememented)
;
;	fn:	Name of a function to be called whenever a point is selected. 
;		The function is called as follows:
;
;		value = call_function(fn, p, image, gd=gd, $
;                                               format=_format, label=label)
;
;		p is the image coords of the selected point, image is the 
;		input image and gd is a generic descriptor containing the 
;		object descriptors.  format and label are outputs used to label
;		the returned value.
;
;	silent:	If set, no string is printed, although the 'string' output
;		keyword remains valid.
;
;	xy:	If present, this image point is used and the user is not 
;		prompted to select a point.
;
;
;  OUTPUT:
;	string:	The string that's printed.  If /silent is specified, this
;		string is valid, but not printed.
;
;	values: Array (nfn,2,npoints) giving the numerical results in the order
;		that they appear in the output.
;
;
; RETURN:
;	NONE
;
;
; STATUS:
;	Ring photometry is not yet implemented.
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale, 3/2002
;	
;-
;=============================================================================

;=============================================================================
; _pgc_xy
;
;=============================================================================
function _pgc_xy, p, dd, gd=gd, format=format, label=label, name=name

 name = cor_name(dd)
 label = ['X', 'Y']
 format = ['(1i10)', '(1i10)']
 return, long(p)
end
;=============================================================================



;=============================================================================
; _pgc_dn
;
;=============================================================================
function _pgc_dn, p, dd, gd=gd, format=format, label=label, name=name

; format = '(1i10)'
 format = '(d20.10)'
 label = ''
 name = cor_name(dd)

 pp = fix(p)

 n = n_elements(dd)
 image0 = dat_data(dd[0])
 dn = make_array(n, val=image0[0])
 dn[*] = 0

 for i=0, n-1 do $
  begin
   image = dat_data(dd[i])

   s = size(image)
   if((pp[0] GE 0) AND (pp[0] LT s[1]) $
        AND (pp[1] GE 0) AND (pp[1] LT s[2])) then dn[i] = image[pp[0], pp[1]]
  end

 label = 'DN'

 return, dn
end
;=============================================================================



;=============================================================================
; _pgc_star
;
;=============================================================================
function _pgc_star, p, dd, gd=gd, format=format, label=label, name=name

 all_radec = bod_body_to_radec(bod_inertial(), transpose(bod_pos(gd.sd)))
 radec = image_to_radec(gd.cd, p)
 d2 = (all_radec[*,0] - radec[0])^2 + (all_radec[*,1] - radec[1])^2
 w = where(d2 EQ min(d2))
 sd = gd.sd[w]


 format = '(1d10.5)'
 label = ['MAG']
 name = cor_name(sd)
 return, str_get_mag(sd)
end
;=============================================================================



;=============================================================================
; _pgc_radec
;
;=============================================================================
function _pgc_radec, p, dd, gd=gd, format=format, label=label, name=name

 name = cor_name(gd.cd)
 label = ['RA', 'DEC']
 format = ['(1d10.5)', '(1d10.5)']

 radec = transpose(image_to_radec(gd.cd, p))

 ra = reduce_angle(radec[0])
 dec = radec[1]
 return, [ra, dec] * 180d/!dpi
end
;=============================================================================



;=============================================================================
; _pgc_globe
;
;=============================================================================
function _pgc_globe, p, dd, gd=gd, format=format, label=label, name=name

 format = ['(1g10.5)', '(1g10.5)', '(1g10.5)', '(1g10.5)']
 label = ''

 name = cor_name(gd.gbx)
 nt = n_elements(name)

 v = image_to_surface(gd.cd, gd.gbx, p, dis=dis, body_pts=body_pts)
 if(NOT keyword_set(v)) then return, 0

 inertial_pts = bod_body_to_inertial_pos(gd.gbx, body_pts)

 rad = glb_get_radius(gd.gbx, v[*,0,*], v[*,1,*])
 v[*,2,*] = rad


 v = v[0,*,*]
 v = reform(v, 3, nt, /over)
 v[0:1,*] = v[0:1,*] * 180d/!dpi

 if(keyword_set(dis)) then $
  begin
   w = where(dis GT 0)
   if(w[0] EQ -1) then return, 0
   nw = n_elements(w)

   v = v[*,w]
   name = name[w]

   gbx = gd.gbx[w]
   body_pts = body_pts[0,*,w]
  end

 inertial_pts = bod_body_to_inertial_pos(gbx, body_pts)
 range = v_mag(bod_pos(gd.cd)##make_array(nw,val=1d) - transpose(inertial_pts))
 v = [v,transpose(range)]

 label = ['LAT', 'LON', 'RAD', 'RANGE']


 return, v
end
;=============================================================================



;=============================================================================
; _pgc_map
;
;=============================================================================
function _pgc_map, p, dd, gd=gd, format=format, label=label, name=name

 format = ['(1g10.5)', '(1g10.5)']
 label = ''

 name = cor_name(gd.cd)
 nt = n_elements(name)

 v = image_to_map(gd.cd, p, valid=valid)
 if(NOT keyword_set(v)) then return, 0
 if(valid[0] EQ -1) then return, 0
 
 v = v[*,valid] * 180d/!dpi
 name = name[valid]

 label = ['LAT', 'LON']

 return, v 
end
;=============================================================================



;=============================================================================
; _pgc_disk
;
;=============================================================================
function _pgc_disk, p, dd, gd=gd, format=format, label=label, name=name

; format = '(1g10.5)'
 format = ['(1g20.10)', '(1g20.10)', '(1g10.5)']
 label = ''

 rd = gd.dkx
 cd = gd.cd
 pd = gd.gbx

 name = cor_name(rd)
 nt = n_elements(name)

; frame_bd = get_primary(cd, pd);, rx=rd)
; frame_bd = get_primary(cd, pd, rx=rd)

 frame_bd = objarr(nt)
 for i=0, nt-1 do $
  begin
   xd = get_primary(cd, pd, rx=rd[i])
   if(keyword_set(xd)) then frame_bd[i] = xd
  end
;stop

 v = (image_to_disk(cd, rd, frame_bd=frame_bd, p, hit=w, body=v_int))[*,0:1,*]
 v[*,1,*] = 180d/!dpi * v[*,1,*]
 v = reform(v, 2, nt, /over)

 if(w[0] EQ -1) then return, 0


 v = v[*,w]
 name = name[w]

 inertial_pts = bod_body_to_inertial_pos(gd.dkx, v_int)
 range = v_mag(bod_pos(gd.cd) - inertial_pts[w,*])
 v = [v,range]

 label = ['RAD', 'LON', 'RANGE']

 return, v
end
;=============================================================================



;=============================================================================
; _pgc_disk_scale
;
;=============================================================================
function _pgc_disk_scale, p, dd, gd=gd, format=format, label=label, name=name

; format = '(1g10.5)'
 format = ['(1g20.10)', '(1g20.10)']
 label = ''

 rd = gd.dkx
 cd = gd.cd
 pd = gd.gbx

 name = cor_name(rd)
 nt = n_elements(name)

 frame_bd = get_primary(cd, pd);, rx=rd)

 v = (image_to_disk(cd, rd, frame_bd=frame_bd, p, hit=w, body=v_int))[*,0:1,*]
 v[*,1,*] = 180d/!dpi * v[*,1,*]
 v = reform(v, 2, nt, /over)

 if(w[0] EQ -1) then return, 0

 v = v[*,w]
 name = name[w]

 vv_int = bod_body_to_inertial_pos(rd, v_int)
 dsk_projected_resolution, rd[w], cd, vv_int[*,*,w], $
          (cam_scale(cd))[0], rad=resrad, lon=reslon, perp=resperp, rr=rr

 v = [tr(resrad), tr(reslon)]
 v = v[*,w]

 nn = n_elements(resrad)
; label = make_array(nn, val='R_SCL L_SCL')
 label = ['R_SCL', 'L_SCL']

 return, v
end
;=============================================================================


;=============================================================================
; _pgc_eqplane
;
;=============================================================================
function _pgc_eqplane, p, dd, gd=gd, format=format, label=label, name=name

 gbx = get_primary(gd.cd, gd.gbx)
 if(NOT obj_valid(gbx[0])) then return, 0

 dkd = dsk_create_descriptors(1, name='EQUATORIAL_PLANE', $
	orient = bod_orient(gbx), $
	pos = bod_pos(gbx))
 sma = dsk_sma(dkd)
 sma[0,0] = 0d
 sma[0,1] = 1d20
 dsk_set_sma, dkd, sma
 
 _gd = {cd:gd.cd, gbx:gd.gbx, dkx:dkd}


 return, _pgc_disk(p, dd, gd=_gd, format=format, label=label, name=name)
end
;=============================================================================


;=============================================================================
; _pgc_eqplane_scale
;
;=============================================================================
function _pgc_eqplane_scale, p, dd, gd=gd, format=format, label=label, name=name

 gbx = get_primary(gd.cd, gd.gbx)
 if(NOT obj_valid(gbx[0])) then return, 0

 dkd = dsk_create_descriptors(1, name='EQUATORIAL_PLANE', $
	orient = bod_orient(gbx), $
	pos = bod_pos(gbx))
 sma = dsk_sma(dkd)
 sma[0,0] = 0d
 sma[0,1] = 1d20
 dsk_set_sma, dkd, sma
 
 _gd = {cd:gd.cd, gbx:gd.gbx, dkx:dkd}


 return, _pgc_disk_scale(p, dd, gd=_gd, format=format, label=label, name=name)
end
;=============================================================================



;=============================================================================
; _pgc_photom_globe
;
;=============================================================================
function _pgc_photom_globe, p, dd, gd=gd, format=format, label=label, name=name

;stop
 format = ['(1d10.5)', '(1d10.5)', '(1d10.5)']
 label = ''

 name = cor_name(gd.gbx)
 nt = n_elements(name)

 pht_angles, p, gd.cd, gd.gbx, gd.sund, emm=emm, inc=inc, g=g, valid=valid

 if(valid[0] EQ -1) then return, 0

 emm = emm[valid]
 inc = inc[valid]
 g = g[valid]
 name = name[valid]

 label = ['EMM', 'INC', 'PH']

 result = [tr(acos(emm)), tr(acos(inc)), tr(acos(g))] * 180d/!dpi

 return, reform(result, 3, n_elements(valid), /over)
end
;=============================================================================



;=============================================================================
; _pgc_photom_disk
;
;=============================================================================
function _pgc_photom_disk, p, dd, gd=gd, format=format, label=label, name=name

 format = ['(1d10.5)', '(1d10.5)', '(1d10.5)']
 label = ''

 name = cor_name(gd.dkx)
 nt = n_elements(name)

 if((NOT keyword_set(gd.cd)) OR $
    (NOT keyword_set(gd.sund)) OR $
    (NOT keyword_set(gd.dkx)) OR $
    (NOT keyword_set(gd.gbx))) then return, 0


 frame_bd = get_primary(gd.cd, gd.gbx)
 pht_angles, p, gd.cd, gd.dkx, gd.sund, frame=frame_bd, emm=emm, inc=inc, g=g, valid=valid

 if(valid[0] EQ -1) then return, 0

 emm = emm[valid]
 inc = inc[valid]
 g = g[valid]
 name = name[valid]

 label = ['EMM', 'INC', 'PH']

 result = [tr(acos(emm)), tr(acos(inc)), tr(acos(g))] * 180d/!dpi

 return, reform(result, 3, n_elements(valid), /over)
end
;=============================================================================



;=============================================================================
; _pgc_photom_eqplane
;
;=============================================================================
function _pgc_photom_eqplane, p, dd, gd=gd, format=format, label=label, name=name

 gbx = get_primary(gd.cd, gd.gbx)
 if(NOT obj_valid(gbx[0])) then return, 0

 dkd = dsk_create_descriptors(1, name='EQUATORIAL_PLANE', $
	orient = bod_orient(gbx), $
	pos = bod_pos(gbx))
 sma = dsk_sma(dkd)
 sma[0,0] = 0d
 sma[0,1] = 1d20
 dsk_set_sma, dkd, sma
 
 _gd = {cd:gd.cd, gbx:gd.gbx, dkx:dkd, sund:gd.sund}


 return, _pgc_photom_disk(p, dd, gd=_gd, format=format, label=label, name=name)
end
;=============================================================================



;=============================================================================
; pg_table
;
;=============================================================================
function pgc_table, name, name_p, value_p, label_p, format_p, $
          label_pad=label_pad, value_pad=value_pad
common pgc_table_block, last_labels, first

 n = n_elements(name_p)

 ;-----------------------------------
 ; extract all fields for this name
 ;-----------------------------------
 for i=0, n-1 do $
  begin
   w = where(*name_p[i] EQ name)
   if(w[0] NE -1) then $
    begin
     values = append_array(values, (*value_p[i])[*,w])
     labels = append_array(labels, *label_p[i])
     formats = append_array(formats, *format_p[i])
    end
  end


 ;--------------------------------
 ; build table
 ;--------------------------------
 nval = n_elements(values)
 svals = strarr(nval)
 for i=0, nval-1 do $
     svals[i] = str_pad(strtrim(string(values[i], format=formats[i]), 2), value_pad-1)

 w = where((labels EQ last_labels) EQ 0)
 if(w[0] NE -1) then $
  begin
    if(NOT first) then s = ' '
    s = append_array(s, $
           str_pad(' ', label_pad+3) + str_cat(str_pad(labels, value_pad)))
  end

 s = append_array(s, str_pad(name, label_pad) + ' : ' + $
                                    str_cat(str_pad(svals, value_pad)))

 last_labels = labels 
 first = 0

 return, s
end
;=============================================================================



;=============================================================================
; pg_cursor
;
;=============================================================================
pro pg_cursor, dd, ptd, cd=cd, gbx=gbx, dkx=dkx, sund=sund, sd=sd, gd=_gd, fn=_fn, $
           radec=radec, photom=photom, xy=xy, string=string, $
           silent=silent, values=values
common pgc_table_block, last_labels, first

 first = 1
 last_labels = ''

 ;-----------------------------------------------
 ; dereference the generic descriptor if given
 ;-----------------------------------------------
 pgs_gd, _gd, cd=cd, gbx=gbx, dkx=dkx, sund=sund, sd=sd, dd=dd

 ;-----------------------------------------------
 ; construct internal generic descriptor 
 ;-----------------------------------------------
 if(keyword_set(_gd)) then $
  begin
   if(keyword_set(gbx) AND keyword_set(dkx)) then $
           gd = struct_sub(_gd, ['gbx','dkx'], [nv_ptr_new(gbx),nv_ptr_new(dkx)]) $
   else if(keyword_set(gbx)) then $
                   gd = struct_sub(_gd, ['gbx'], [nv_ptr_new(gbx)]) $
   else if(keyword_set(dkx)) then gd = struct_sub(_gd, ['dkx'], [nv_ptr_new(dkx)]) $
   else gd = _gd
  end 

 ;-----------------------------------------------
 ; assemble list of transformation functions
 ;-----------------------------------------------

 ;- - - - - - - - 
 ; minimum set
 ;- - - - - - - -
 fn = ['_pgc_xy', '_pgc_dn']

 ;- - - - - - - - - 
 ; options 
 ;- - - - - - - - - 
 if(keyword_set(cd)) then $
  case cor_class(cd) of
   'CAMERA' : $
	begin
	 if(keyword_set(radec)) then fn = [fn, '_pgc_radec']
	 if(keyword_set(gbx)) then fn = [fn, '_pgc_globe']
	 if(keyword_set(photom)) then $
	        if(keyword_set(gbx) AND keyword_set(sund)) then $
                                                  fn = [fn, '_pgc_photom_globe']
	 if(keyword_set(gbx)) then $
                fn = [fn, '_pgc_eqplane', '_pgc_eqplane_scale', '_pgc_photom_eqplane']
	 if(keyword_set(dkx)) then $
                fn = [fn, '_pgc_disk', '_pgc_disk_scale', '_pgc_photom_disk']
	 if(keyword_set(sd)) then fn = [fn, '_pgc_star']
	end
   'MAP' : fn = [fn, '_pgc_map']
   else :
  endcase


 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - -
 ; user-specified functions
 ;- - - - - - - - - - - - - - - - - - - - - - - - - - - -
 if(keyword_set(_fn)) then fn = [fn, _fn]
 nfn = n_elements(fn)


 ;-----------------------------------------------
 ; select points until cancelled
 ;-----------------------------------------------
 cancel = 0 
 values = dblarr(1,4,nfn)
 repeat $
  begin
   if(keyword_set(xy)) then p = xy $
   else p = pg_select_points(dd, /one, /nov, cancel=cancel)
   if(NOT cancel) then $
    begin
     val = dblarr(10,10,nfn)

     ;- - - - - - - - - - - - - - - - -
     ; collect all the function data
     ;- - - - - - - - - - - - - - - - -
     all_names = ''
     for i=0, nfn-1 do $
      begin
       value = call_function(fn[i], p, dd, gd=gd, format=format, label=label, name=name)
       if(keyword_set(value)) then $
        begin
         value_p = append_array(value_p, nv_ptr_new(value))
         name_p = append_array(name_p, nv_ptr_new(name))
         label_p = append_array(label_p, nv_ptr_new(label))
         format_p = append_array(format_p, nv_ptr_new(format))
         all_names = append_array(all_names, name)
        end
      end

     ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     ; sort names such that they are unique and occur in the original order
     ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     ss = sort(all_names)
     uu = uniq(all_names[ss])
     _all_names = all_names[ss[uu]]
     n_names = n_elements(_all_names)
     ii = lonarr(n_names)
     for i=0, n_names-1 do $
      begin
       w = where(_all_names[i] EQ all_names)
       ii[i] = w[0]
      end
     all_names = all_names[ii[sort(ii)]]

     ;- - - - - - - - - - - - - - - - -
     ; create the tables
     ;- - - - - - - - - - - - - - - - -
     for i=0, n_names-1 do $
       string = append_array(string, $
         pgc_table(all_names[i], name_p, value_p, label_p, format_p, $
                         label_pad=16, value_pad=12))
 
    end
   if(keyword_set(xy)) then cancel = 1
  endrep until(cancel)

 values = tr(values)
 if(NOT keyword_set(silent)) then print, transpose(string)


end
;=============================================================================
