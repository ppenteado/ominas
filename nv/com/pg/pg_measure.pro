;=============================================================================
;+
; NAME:
;	pg_measure
;
;
; PURPOSE:
;	Allows the user to measure quantities between two points in an 
;	image using the mouse in the current graphics window.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	pg_measure, dd
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
;	gd:	Generic descriptor.  If given, the above object descriptors are
;		taken from this structure.
;
;	radec:	If set, right ascension and declination differences with 
;		respect to the inertial coordinate system are output for 
;		each selected pair. 
;
;	xy:	If set, this is taken as the first point, and the user selects
;		only the second point. 
;
;	fn:	Name of a function to be called whenever a ppoint is selected. 
;		The function is called as follows:
;
;		value = call_function(fn, p, image, gd=gd, $
;                                               format=_format, label=label)
;
;		p is the image coords of the select ed point, image is the 
;		input image and gd is a generic descriptor containing the 
;		object descriptors.  format and label are outputs used to label
;		the returned value.
;
;	silent:	If set, no string is printed, although the 'string' output
;		keyword remains valid.
;
;
;  OUTPUT:
;	string:	The string that's printed.  If /silent is specified, this
;		string is valid, but not printed.
;
;	values: Array (nfn,2,npoints) giving the numerical results in the order
;		that they appear in the output.
;
;	p:	Array (2,2) giving the selected points.
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
; _pgm_xy_test
;
;=============================================================================
function _pgm_xy_test, p, dd, gd=gd, inertial_pt=inertial_pt, surface_pt=surface_pt
 inertial_pt = dblarr(1,3,2)
 surface_pt = dblarr(1,3,2)
 return, [dd, dd]
end
;=============================================================================



;=============================================================================
; _pgm_xy
;
;=============================================================================
function _pgm_xy, p, dd, xd, gd=gd, format=format, label=label, inertial_pt=inertial_pt, surface_pt=surface_pt

 label = ['dX', 'dY', 'DIAG']
 format = ['(d20.10)', '(d20.10)', '(d20.10)']

 dp = p[*,1]-p[*,0]
 return, [dp, p_mag(dp)]
end
;=============================================================================



;=============================================================================
; _pgm_dn_test
;
;=============================================================================
function _pgm_dn_test, p, dd, gd=gd, inertial_pt=inertial_pt, surface_pt=surface_pt
 inertial_pt = dblarr(1,3,2)
 surface_pt = dblarr(1,3,2)
 return, [dd, dd]
end
;=============================================================================



;=============================================================================
; _pgm_dn
;
;=============================================================================
function _pgm_dn, p, dd, xd, gd=gd, format=format, label=label, inertial_pt=inertial_pt, surface_pt=surface_pt

 format = '(d20.10)'
 label = ''

 pp = fix(p)

 n = n_elements(dd)
 image0 = nv_data(dd[0])
 dn0 = make_array(n, val=image0[0])
 dn1 = make_array(n, val=image0[0])
 dn0[*] = 0
 dn1[*] = 0

 for i=0, n-1 do $
  begin
   image = nv_data(dd[i])

   s = size(image)
   if((pp[0,0] GE 0) AND (pp[0,0] LT s[1]) $
        AND (pp[1,0] GE 0) AND (pp[1,0] LT s[2])) then dn0[i] = image[pp[0,0], pp[1,0]]
   if((pp[0,1] GE 0) AND (pp[0,1] LT s[1]) $
        AND (pp[1,1] GE 0) AND (pp[1,1] LT s[2])) then dn1[i] = image[pp[0,1], pp[1,1]]
  end

 label = 'dDN'

 return, dn1-dn0
end
;=============================================================================



;=============================================================================
; _pgm_radec_test
;
;=============================================================================
function _pgm_radec_test, p, dd, gd=gd, inertial_pt=inertial_pt, surface_pt=surface_pt
 inertial_pt = dblarr(1,3,2)
 surface_pt = dblarr(1,3,2)
 return, [gd.cd, gd.cd]
end
;=============================================================================



;=============================================================================
; _pgm_radec
;
;=============================================================================
function _pgm_radec, p, dd, xd, gd=gd, format=format, label=label, inertial_pt=inertial_pt, surface_pt=surface_pt

 label = ['dRA', 'dDEC', 'ANGLE']
 format = ['(1d10.5)', '(1d10.5)', '(1d10.5)']

 radec = transpose(image_to_radec(gd.cd, p))

 dradec = (radec[*,1]-radec[*,0])[0:1,*] * 180d/!dpi

 v0 = image_to_inertial(gd.cd, p[*,0])
 v1 = image_to_inertial(gd.cd, p[*,1])

 theta = v_angle(v0,v1) * 180d/!dpi

 return, [dradec, theta]
end
;=============================================================================



;=============================================================================
; _pgm_globe_test
;
;=============================================================================
function _pgm_globe_test, p, dd, gd=gd, inertial_pt=inertial_pt, surface_pt=surface_pt

 xd = ptrarr(2)
 inertial_pt = dblarr(1,3,2)
 surface_pt = dblarr(1,3,2)

 for i=0, 1 do $
  begin
   v = image_to_surface(gd.cd, gd.gbx, p[*,i], dis=dis, body_pts=body_pts)
   w = where(dis GE 0)

   if((NOT keyword_set(v)) OR (w[0] EQ -1)) then xd[i] = nv_ptr_new() $
    else $
     begin
      range = v_mag(v)
      w = where(range EQ min(range))
      ww = w/2
      xd[i] = gd.gbx[ww[0]]

      body_pt = body_pts[ww[0] mod 2, *, ww[0]]
      inertial_pt[0,*,i] = bod_body_to_inertial_pos(xd[i], body_pt)

      surface_pt[0,*,i] = v[ww[0] mod 2, *, ww[0]]
     end
  end

 return, xd
end
;=============================================================================



;=============================================================================
; _pgm_globe
;
;=============================================================================
function _pgm_globe, p, dd, xd, gd=gd, format=format, label=label, inertial_pt=inertial_pt, surface_pt=surface_pt

 format = ['(1g10.5)', '(1g10.5)'];, '(1g10.5)']
 label = ''

 v = surface_pt[0,*,1] - surface_pt[0,*,0]
 v[0:1] = v[0:1] *180d/!dpi

 label = ['dLAT', 'dLON'];, 'dRAD']

 return, v[0:1]
end
;=============================================================================



;=============================================================================
; _pgm_disk_test
;
;=============================================================================
function _pgm_disk_test, p, dd, gd=gd, inertial_pt=inertial_pt, surface_pt=surface_pt

 xd = ptrarr(2)
 inertial_pt = dblarr(1,3,2)
 surface_pt = dblarr(1,3,2)

 for i=0, 1 do $
  begin
   frame_bd = get_primary(gd.cd, gd.gbx)
   v = image_to_surface(gd.cd, gd.dkx, p[*,i], body_pts=body_pts, $
                                               frame_bd=frame_bd, hit=hit)
   if((NOT keyword_set(v)) OR (hit[0] EQ -1)) then xd[i] = nv_ptr_new() $
    else $
     begin
      range = v_mag(v)
      w = where(range EQ min(range))
      ww = w/2
      xd[i] = gd.dkx[ww[0]]

      body_pt = body_pts[ww[0] mod 2, *, w[0]]
      inertial_pt[0,*,i] = bod_body_to_inertial_pos(xd[i], body_pt)

      surface_pt[0,*,i] = v[ww[0] mod 2, *, w[0]]
     end
  end

 return, xd
end
;=============================================================================



;=============================================================================
; _pgm_disk
;
;=============================================================================
function _pgm_disk, p, dd, xd, gd=gd, format=format, label=label, inertial_pt=inertial_pt, surface_pt=surface_pt

 format = ['(1g20.10)', '(1g20.10)']
 label = ''


 v = (surface_pt[0,*,1] - surface_pt[0,*,0])[0:1]
 v[1] = v[1] *180d/!dpi
 label = ['dRAD', 'dLON']

 return, v
end
;=============================================================================



;=============================================================================
; _pgm_eqplane_test
;
;=============================================================================
function _pgm_eqplane_test, p, dd, gd=gd, inertial_pt=inertial_pt, surface_pt=surface_pt

 gbx = get_primary(gd.cd, gd.gbx)

 dkd = dsk_init_descriptors(1, name='EQUATORIAL_PLANE', $
	orient = bod_orient(gbx), $
	pos = bod_pos(gbx))
 sma = dsk_sma(dkd)
 sma[0,0] = 0d
 sma[0,1] = 1d20
 dsk_set_sma, dkd, sma
 
 xd = [dkd,dkd]

 for i=0, 1 do $
  begin
   frame_bd = gbx
   v = image_to_surface(gd.cd, xd[i], p[*,i], body_pt=body_pt, $
                                               frame_bd=frame_bd, hit=hit)

   inertial_pt[0,*,i] = bod_body_to_inertial_pos(xd[i], body_pt)
   surface_pt[0,*,i] = v
  end

 return, xd
end
;=============================================================================



;=============================================================================
; _pgm_eqplane
;
;=============================================================================
function _pgm_eqplane, p, dd, xd, gd=gd, format=format, label=label, inertial_pt=inertial_pt, surface_pt=surface_pt

 return, _pgm_disk(p, dd, gd=_gd, format=format, label=label, inertial_pt=inertial_pt, surface_pt=surface_pt)
end
;=============================================================================



;=============================================================================
; _pgm_eqplane
;
;=============================================================================
function ____pgm_eqplane, p, dd, xd, gd=gd, format=format, label=label, inertial_pt=inertial_pt, surface_pt=surface_pt

 gbx = get_primary(gd.cd, gd.gbx)

 dkd = dsk_init_descriptors(1, name='EQUATORIAL_PLANE', $
	orient = bod_orient(gbx), $
	pos = bod_pos(gbx))
 sma = dsk_sma(dkd)
 sma[0,0] = 0d
 sma[0,1] = 1d20
 dsk_set_sma, dkd, sma
 
 _gd = {cd:gd.cd, gbx:gd.gbx, dkx:dkd}


 return, _pgm_disk(p, dd, gd=_gd, format=format, label=label)
end
;=============================================================================



;=============================================================================
; _pgm_map
;
;=============================================================================
function _pgm_map, p, dd, xd, gd=gd, format=format, label=label, inertial_pt=inertial_pt, surface_pt=surface_pt

 format = ['(1g10.5)', '(1g10.5)']
 label = ''

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
; pg_table
;
;=============================================================================
function pgm_table, name, name_p, value_p, label_p, format_p, $
          label_pad=label_pad, value_pad=value_pad
common pgm_table_block, last_labels, first

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
; pg_measure
;
;=============================================================================
pro pg_measure, dd, cd=cd, gbx=gbx, dkx=dkx, sund=sund, sd=sd, gd=_gd, fn=_fn, $
           radec=radec, xy=xy, string=string, $
           silent=silent, values=values, p=p
common pgm_table_block, last_labels, first

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
 fn = ['_pgm_xy', '_pgm_dn']

 ;- - - - - - - - - 
 ; options 
 ;- - - - - - - - - 
 if(keyword_set(cd)) then $
  case class_get(cd) of
   'CAMERA' : $
	begin
	 if(keyword_set(radec)) then fn = [fn, '_pgm_radec']
	 if(keyword_set(gbx)) then fn = [fn, '_pgm_globe']
	 if(keyword_set(gbx)) then fn = [fn, '_pgm_eqplane']
	 if(keyword_set(dkx)) then fn = [fn, '_pgm_disk']
	end
   'MAP' : fn = [fn, '_pgm_map']
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
   dist = ''
   range = ''
   if(keyword_set(xy)) then p = tvline(p0=data_to_device(xy), col=ctred()) $
   else p = tvline(col=ctred(), cancel_but=4, cancelled=cancel)
   p = device_to_data(p)
   if(NOT cancel) then $
    begin
     all_names = ''
     val = dblarr(10,10,nfn)

     ;- - - - - - - - - - - - - - - - -
     ; get intersections
     ;- - - - - - - - - - - - - - - - -
     for i=0, nfn-1 do $
      begin
       _xd = call_function(fn[i]+'_test', p, dd, gd=gd, inertial_pt=inertial_pt, surface_pt=surface_pt)

       xd = append_array(xd, transpose(_xd))
       inertial_pts = append_array(inertial_pts, inertial_pt)
       surface_pts = append_array(surface_pts, surface_pt)
      end


     ;- - - - - - - - - - - - - - - - - - - - - - - - - - - 
     ; select nearest intersections where applicable
     ;- - - - - - - - - - - - - - - - - - - - - - - - - - - 
     nearest = [-1,-1]
     dist = [1d100,1d100]
     for i=0, nfn-1 do $
      begin
       inertial_pt0 = inertial_pts[i,*,0]
       inertial_pt1 = inertial_pts[i,*,1]

       if((v_mag(inertial_pt0))[0] NE 0) then $
        if((v_mag(inertial_pt0))[0] LE dist[0]) then nearest[0] = i

      if((v_mag(inertial_pt1))[0] NE 0) then $
        if((v_mag(inertial_pt1))[0] LE dist[1]) then nearest[1] = i
      end

     if((nearest[0] NE -1) AND (nearest[1] NE -1)) then $
      begin
       name = 'INERTIAL'

       dist = v_mag(inertial_pts[nearest[0],*,0] - inertial_pts[nearest[1],*,1])
       value = append_array(value, dist)
       label = append_array(label, 'DISTANCE')
       format = append_array(format, '(1g20.10)')

       cam_pos = bod_pos(gd.cd)
       drange = abs(v_mag(cam_pos - inertial_pts[nearest[0],*,0]) $
                   - v_mag(cam_pos - inertial_pts[nearest[1],*,1]))
       value = append_array(value, drange)
       label = append_array(label, 'dRANGE')
       format = append_array(format, '(1g20.10)')


       value_p = append_array(value_p, nv_ptr_new(value))
       name_p = append_array(name_p, nv_ptr_new(name))
       label_p = append_array(label_p, nv_ptr_new(label))
       format_p = append_array(format_p, nv_ptr_new(format))
       all_names = append_array(all_names, name)


      end


     ;- - - - - - - - - - - - - - - - -
     ; collect all the function data
     ;- - - - - - - - - - - - - - - - -
     for i=0, nfn-1 do $
      begin
       xds = xd[i,*]
       if(ptr_valid(xds[0])) then $  
        begin
         inertial_pt0 = inertial_pts[i,*,0]
         inertial_pt1 = inertial_pts[i,*,1]
print, inertial_pt0
print, inertial_pt1

         call = 1
         if((v_mag(inertial_pt0))[0] NE 0) then $
          if((v_mag(inertial_pt1))[0] NE 0) then $
           if(xds[0] NE xds[1]) then call = 0 $
           else if(nearest[0] NE i) then call = 0 $
           else if(nearest[1] NE i) then call = 0

         if(call) then $
           value = call_function(fn[i], p, dd, xds[0], gd=gd, format=format, $
                  label=label, $
                  inertial_pt=inertial_pts[i,*,*], surface_pt=surface_pts[i,*,*])

         if(nv_test_dd(xds[0])) then names = nv_id_string(xds[0]) $
         else names = cor_name(xds)
         if(n_elements(names) EQ 1) then name = names $
         else $
          begin
           if(names[0] EQ names[1]) then name = names[0] $
           else name = str_comma_list(names, delim='--')
          end

         if(keyword_set(value)) then $
          begin
           value_p = append_array(value_p, nv_ptr_new(value))
           name_p = append_array(name_p, nv_ptr_new(name))
           label_p = append_array(label_p, nv_ptr_new(label))
           format_p = append_array(format_p, nv_ptr_new(format))
           all_names = append_array(all_names, name)
          end
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
         pgm_table(all_names[i], name_p, value_p, label_p, format_p, $
                         label_pad=16, value_pad=12))
 
    end
   if(keyword_set(xy)) then cancel = 1
  endrep until(cancel)

 values = tr(values)
 if(NOT keyword_set(silent)) then print, transpose(string)


end
;=============================================================================
