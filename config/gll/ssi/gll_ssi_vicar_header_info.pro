;===========================================================================
; gll_ssi_vicar_header_info
;
;===========================================================================
function gll_ssi_vicar_header_info, dd

 ndd = n_elements(dd)

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
     ;------------------------------
     ; time
     ;------------------------------
     if(NOT keyword_set(_time)) then time[i] = gll_ssi_spice_time(label)

     ;------------------------------
     ; exposure time
     ;------------------------------
     exposure[i] = vicgetpar(label, 'EXP')

     ;------------------------------------------------
     ; image size
     ;------------------------------------------------
     size[0,i] = double(vicgetpar(label, 'NS'))
     size[1,i] = double(vicgetpar(label, 'NL'))

     ;------------------------------------------------
     ; nominal optic axis coordinate, camera scale
     ;------------------------------------------------
     oaxis[*,i] = size[*,i]/2d
     scale[*,i] = [1.016d-05, 1.016d-05]		; from trial and error

     ;------------------------------------------------
     ; detect summation modes
     ;------------------------------------------------
     mode = vicgetpar(label, 'TLMFMT')
     if((mode EQ 'HIS') OR (mode EQ 'AI8')) then $
      begin
       oaxis[*,i] = oaxis[*,i] / 2d
       scale[*,i] = scale[*,i]*2d
      end

;     filters[*,i] = vicgetpar(label, 'FILTER_NAME')


     ;------------------------------------------------
     ; target
     ;------------------------------------------------
     target[i] = strupcase(vicgetpar(label, 'TARGET_NAME'))

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



