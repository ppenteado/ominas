;=============================================================================
;+
; NAME:
;	pg_mosaic
;
;
; PURPOSE:
;	Combines two or more maps into one.
;
;
; CATEGORY:
;	NV/PG
;
;
; CALLING SEQUENCE:
;	result = pg_mosaic(dds)
;
;
; ARGUMENTS:
;  INPUT:
;	dds:	Array of data descriptors containing the maps to be combined.
;		Maps must all be of the same size and data type.
;
;  OUTPUT:
;	mosaic:	The mosaic image array.
;
;
; KEYWORDS:
;  INPUT:
;	combine_fn:	Name of function to be called to combine the maps.  
;			Default is 'median'.
;
;	wt_fns:		Names of functions to be called to weight the maps.  
;
;	data:		Data to be passed to combine_fn.
;
;	weight:		Array of weights, one for each input dd.
;
;       pc_xsize:	x size of mosaic work pieces.  Smaller pieces save
;			memory, but increase run time.
;
;       pc_ysize:	y size of mosaic work pieces.
;
;
;  OUTPUT:
;	mosaic:		Image array giving the output mosiac.
;
;
; RETURN:
;	Data descriptor containing the mosaic.
;
;
; STATUS:
;	Complete
;
;
; MODIFICATION HISTORY:
; 	Written by:	Spitale 1/2002
;	
;-
;=============================================================================



;=============================================================================
; pg_mosaic
;
;=============================================================================
function pg_mosaic, dd, combine_fn=_combine_fn, wt_fns=_wt_fns, data=data, mosaic=mosaic, $
          weight=weight, pc_xsize=pc_xsize, pc_ysize=pc_ysize, scales=scales


 if(keyword_set(_combine_fn)) then combine_fn = 'cm_combine_' + _combine_fn $
 else combine_fn = 'cm_combine_median'

 if(keyword_set(_wt_fns)) then wt_fns = 'cm_wt_' + _wt_fns 


 ;---------------------------------------------
 ; set up geomertry
 ;---------------------------------------------
 nmaps = n_elements(dd)

 if(NOT keyword_set(weight)) then weight = make_array(nmaps, val=1.0)

 dim = dat_dim(dd[0])
 mos_xsize = dim[0]
 mos_ysize = dim[1]
 type = size(im, /type)

 if(NOT keyword_set(pc_xsize)) then pc_xsize = mos_xsize
 if(NOT keyword_set(pc_ysize)) then pc_ysize = mos_ysize


 ;---------------------------------------------
 ; construct the mosaic in pieces
 ;---------------------------------------------
 mosaic = make_array(mos_xsize, mos_ysize, type=type)

 pc_xsize = pc_xsize < mos_xsize
 pc_ysize = pc_ysize < mos_ysize

 pc_nx = mos_xsize/pc_xsize
 pc_ny = mos_ysize/pc_ysize
 if(mos_xsize mod pc_xsize NE 0) then pc_nx = pc_nx + 1 
 if(mos_ysize mod pc_ysize NE 0) then pc_ny = pc_ny + 1 

 pc_xsize = long(pc_xsize)
 pc_ysize = long(pc_ysize)


 for j=0, pc_ny-1 do $
  for i=0, pc_nx-1 do $
   begin
    ;------------------------------------
    ; determine the size of this piece
    ;------------------------------------
    xsize = pc_xsize
    ysize = pc_ysize
    if(i EQ pc_nx-1) then xsize = mos_xsize - (pc_nx-1)*pc_xsize
    if(j EQ pc_ny-1) then ysize = mos_ysize - (pc_ny-1)*pc_ysize
    n = xsize*ysize


    ;------------------------------------
    ; construct pixel grid on this piece
    ;------------------------------------
    map_image_pts = dblarr(2,n, /nozero)
    x0 = i*pc_xsize & y0 = j*pc_ysize
    map_image_pts[0,*] = $
        reform((dindgen(xsize) + double(x0))#make_array(ysize,val=1), n, /over)
    map_image_pts[1,*] = $
        reform((dindgen(ysize) + double(y0))##make_array(xsize,val=1), n, /over)

    pc_sub = xy_to_w(0, map_image_pts, sx=mos_xsize, sy=mos_usize)


    ;------------------------------------
    ; construct mosaic on this piece
    ;------------------------------------
    maps = make_array(xsize, ysize, nmaps, type=type, /nozero)
    emm = make_array(xsize, ysize, nmaps, type=type, /nozero)
    inc = make_array(xsize, ysize, nmaps, type=type, /nozero)
    phase = make_array(xsize, ysize, nmaps, type=type, /nozero)
    for ii=0, nmaps-1 do $
     begin
      maps[*,*,ii] = weight[ii] * dat_data(dd[ii], samples=pc_sub)

      emm[*,*,ii] = cor_udata(dd[ii], 'EMM')
      inc[*,*,ii] = cor_udata(dd[ii], 'INC')
      phase[*,*,ii] = cor_udata(dd[ii], 'PHASE')
     end
    aux = create_struct('EMM', emm, 'INC', inc, 'PHASE', phase)

    pc_mosaic = construct_mosaic(maps, combine_fn=combine_fn, wt_fns=wt_fns, data=data, aux=aux)


    ;------------------------------
    ; insert into the main mosaic
    ;------------------------------
    mosaic[pc_sub] = pc_mosaic
   end


 ;--------------------------------------
 ; normalize to first map
 ;--------------------------------------
 map = dat_data(dd[0])
 w = where(map NE 0)
 if(w[0] NE -1) then mosaic = mosaic * mean(map[w])/mean(mosaic[w])


 ;------------------------------------------------------------------------
 ; store the result
 ;------------------------------------------------------------------------
 dd_mosaic = dat_create_descriptors(1, instrument='MAP', data=mosaic, filetype=dat_filetype(dd[0]))


 return, dd_mosaic
end
;=============================================================================



