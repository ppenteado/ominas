;===========================================================================
; vgr_iss_vicar_header_info
;
;===========================================================================
function vgr_iss_vicar_header_info, dd

 ndd = n_elements(dd)

 sc_name = vgr_parse_inst(dat_instrument(dd), cam=name)

 time = dblarr(ndd)
 exposure = dblarr(ndd)
 size = make_array(2,ndd, val=1024)
 filters = strarr(2,ndd)
 target = strarr(ndd)
 oaxis = dblarr(2,ndd)
 scale = dblarr(2,ndd)

 for i=0, ndd-1 do $
  begin
   label = dat_header(dd[i])
   if(keyword_set(label)) then $
    begin
     ;-----------------------------------
     ; time
     ;-----------------------------------
     if(NOT keyword_set(_time)) then time[i] = vgr_iss_spice_time(label)

     ;-----------------------------------
     ; exposure time
     ;-----------------------------------
     exposure[i] = vicar_vgrkey(label, 'EXP') / 1000d

     ;-----------------------------------
     ; image size, scale
     ;-----------------------------------

     ;- - - - - - - - - - - - - - - - - - - - - - - -
     ; geom'd image
     ;- - - - - - - - - - - - - - - - - - - - - - - -
     geom = 0
     if(strpos(label,'GEOM') NE -1) then geom = 1
     if(strpos(label,'FARENC') NE -1) then geom = 1
     if(strpos(label,'*** OBJECT SPACE') NE -1) then geom = 1
     s = dat_dim(dd)
     if(s[0] EQ 1000 AND s[1] EQ 1000) then geom = 1
 
     if((geom)) then $
      begin
       scale[*,i] = vgr_iss_pixel_scale(sc_name, name, /geom)
       size[0,i] = 1000d
       size[1,i] = 1000d
      end $
     ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     ; raw image   
     ;  Here we use initial guesses.  That's the best that
     ;  can be done before reseau marks are analyzed.
     ;- - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     else $
      begin
       scale[*,i] = vgr_iss_pixel_scale(sc_name, name)
       size[0,i] = 800d
       size[1,i] = 800d
      end

     ;-----------------------------------
     ; optic axis
     ;-----------------------------------
     oaxis[*,i] = size[*,i]/2d

     ;-----------------------------------
     ; filters
     ;-----------------------------------
     filters[*,i] = vicgetpar(label, 'FILTER_NAME')

     ;-----------------------------------
     ; target
     ;-----------------------------------
     target = strupcase(vicgetpar(label, 'TARGET_NAME'))

    end
  end

 if(NOT keyword_set(_time)) then _time = time


 return, {time: time, $
          exposure: exposure, $
          size: size, $
          filters: filters, $
          scale: scale, $
          target: target, $
          oaxis: oaxis}
end 
;===========================================================================



