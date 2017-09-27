;===========================================================================
; gll_ssi_vicar_header_info
;
;===========================================================================
function gll_ssi_vicar_header_info, dd

 meta = {gll_ssi_spice_label_struct}

 label = dat_header(dd)
 if(NOT keyword_set(label)) then return, 0

 ;------------------------------
 ; time
 ;------------------------------
 meta.time = gll_ssi_spice_time(label)

 ;------------------------------
 ; exposure time
 ;------------------------------
 meta.exposure = vicgetpar(label, 'EXP')

 ;------------------------------------------------
 ; image size
 ;------------------------------------------------
 meta.size[0] = double(vicgetpar(label, 'NS'))
 meta.size[1] = double(vicgetpar(label, 'NL'))

 ;------------------------------------------------
 ; nominal optic axis coordinate, camera scale
 ;------------------------------------------------
 meta.oaxis = meta.size/2d
 meta.scale = [1.016d-05, 1.016d-05]		    ; from trial and error

 ;------------------------------------------------
 ; detect summation modes
 ;------------------------------------------------
 mode = vicgetpar(label, 'TLMFMT')
 if((mode EQ 'HIS') OR (mode EQ 'AI8')) then $
  begin
   meta.oaxis = meta.oaxis / 2d
   meta.scale = meta.scale*2d
  end

; meta.filters = vicgetpar(label, 'FILTER_NAME')


 ;------------------------------------------------
 ; target
 ;------------------------------------------------
 meta.target = strupcase(vicgetpar(label, 'TARGET_NAME'))


 return, meta
end 
;===========================================================================



