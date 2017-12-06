;=============================================================================
; dh_read_pds.pro
;
;=============================================================================
function dh_read_pds, dd, label, dim, type, min, max, abscissa=abscissa, $
                          nodata=nodata, gff=gff, $
                          sample=sample, returned_samples=returned_samples

 if(keyword_set(sample)) then return, 0
 filename = dat_filename(dd)

 ;--------------------------------------------------------
 ; read label
 ;--------------------------------------------------------
 label = headpds(filename, /silent)

 ;- - - - - - - - - - - - - - - - - - - - -
 ; get rid of CR/LFs included by headpds
 ;- - - - - - - - - - - - - - - - - - - - -
 label = strtrim(str_nnsplit(label, string(13b)), 2)

 ;- - - - - - - - - - - - - - - - - - - - -
 ; determine image dimensions
 ;- - - - - - - - - - - - - - - - - - - - -
 names = pdspar(label, 'OBJECT')

 w = where(names EQ 'IMAGE')
 w = w[0]
 if (w ne -1) then begin
   s = pdspar(label, 'LINE_SAMPLES')
   xsize = long(s[w])

   s = pdspar(label, 'LINES')
   ysize = long(s[w])

   dim = [xsize, ysize]
   
 endif else begin
   s=strsplit(pdspar(label,'CORE_ITEMS'),'() ,',/extract)
;   xsize=long(s[2])
;   ysize=long(s[1])
;   dim = [xsize, ysize]
   zsize=long(s[2])
   xsize=long(s[0])
   ysize=long(s[1])
   dim = [xsize, ysize, zsize]
 endelse

;;; type = pdspar(label, 'SAMPLE_TYPE')
;;; need to convert this to IDL type code
;;; see imagepds.pro
min=0
max=0

 if(keyword_set(nodata)) then return, 0


 ;--------------------------------------------------------
 ; read image
 ;--------------------------------------------------------
 dat = readpds(filename, /silent)

 w=where(tag_names(dat) eq 'IMAGE')
 if w[0] ne -1 then begin
   image = dat.image
 endif else image=dat.qube.core
 type = size(image, /type)
 if(type EQ 8) then image = image.image
 type = size(image, /type)

 return, image











 dat = readpds(filename, label, /silent, dim=dim, nodata=nodata)
 n = dat.objects


 if(n EQ 1) then $
  begin
   return, dat.image
  end

stop

 data = ptrarr(n)
 dim_p = ptrarr(n)

 for i=0, n-1 do $
  begin
;   data[i] = nv_ptr_new(...)
;   dim_p[i] = nv_ptr_new(...)
  end

 return, data
end
;=============================================================================
