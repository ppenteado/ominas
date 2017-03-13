;=============================================================================
; grim_rc_value
;
;=============================================================================
function grim_rc_value, keywords, value_ps, keyword

 w = where(keywords EQ keyword)
 if(w[0] NE -1) then value = *value_ps[w[0]] $
 else value = ''

 if(n_elements(value) EQ 1) then value = value[0]

 return, value
end
;=============================================================================



;=============================================================================
; grim_rc_settings
;
;=============================================================================
pro grim_rc_settings, rcfile=rcfile, $
	new=new, xsize=xsize, ysize=ysize, mode_init=mode_init, npoints=npoints, $
	zoom=zoom, rotate=rotate, order=order, offset=offset, filter=filter, retain=retain, $
	path=path, save_path=save_path, load_path=load_path, symsize=symsize, $
        overlays=overlays, menu_fname=menu_fname, cursor_swap=cursor_swap, $
	fov=fov, menu_extensions=menu_extensions, button_extensions=button_extensions, $
	trs_cd=trs_cd, trs_pd=trs_pd, trs_rd=trs_rd, trs_sd=trs_sd, trs_std=trs_std, trs_ard=trs_ard, trs_sund=trs_sund, $
	filetype=filetype, hide=hide, mode_args=mode_args, xzero=xzero, rgb=rgb, $
        psym=psym, nhist=nhist, maintain=maintain, ndd=ndd, workdir=workdir, $
        activate=activate, frame=frame, compress=compress, loadct=loadct, max=max, $
	arg_extensions=arg_extensions, extensions=extensions, beta=beta, rendering=rendering, $
        plane_syncing=plane_syncing, tiepoint_syncing=tiepoint_syncing, curve_syncing=curve_syncing, visibility=visibility, channel=channel, $
        render_sample=render_sample, render_pht_min=render_pht_min, slave_overlays=slave_overlays
	

 ;----------------------------------------------------
 ; return if no resource file
 ;----------------------------------------------------
 rcname = getenv('HOME') + '/' + rcfile
 fname = file_search(rcname)
 if(NOT keyword_set(fname)) then $
  begin
   nv_message, verb=0.5, $
    'Resource file not found: ' + rcname +'.  Proceeding without it.'
   return
  end

 ;----------------------------------------------------
 ; read file and strip comments
 ;----------------------------------------------------
 lines = read_txt_file(fname[0])
 w = where(strmid(lines, 0, 1) NE '#')
 if(w[0] NE -1) then lines = lines[w]

 ;----------------------------------------------------
 ; parse the keyvals
 ;----------------------------------------------------
 kv = dat_parse_keyvals(lines)
 keyword_ps = *kv.keywords_p & nv_ptr_free, kv.keywords_p
 value_ps = *kv.values_p & nv_ptr_free, kv.values_p

 nkey = n_elements(keyword_ps)
 keywords = strarr(nkey)
 for i=0, nkey-1 do $
  if(ptr_valid(keyword_ps[i])) then $
   begin
    keywords[i] = *keyword_ps[i]
    nv_ptr_free, keyword_ps[i]
   end
 keywords = strupcase(keywords)

 ;----------------------------------------------------
 ; extract any undefined values
 ;----------------------------------------------------
 if(n_elements(fov) EQ 0) then $
                        _fov = grim_rc_value(keywords, value_ps, 'FOV') $
 else _fov = fov
 if(keyword_set(_fov)) then fov = float(_fov)

 if(n_elements(hide) EQ 0) then $
                        _hide = grim_rc_value(keywords, value_ps, 'HIDE') $
 else _hide = hide
 if(keyword_set(_hide)) then hide = fix(_hide)

 if(n_elements(xzero) EQ 0) then $
                        _xzero = grim_rc_value(keywords, value_ps, 'XZERO') $
 else _xzero = xzero
 if(keyword_set(_xzero)) then xzero = fix(_xzero)

 if(n_elements(new) EQ 0) then $
                        _new = grim_rc_value(keywords, value_ps, 'NEW') $
 else _new = new
 if(keyword_set(_new)) then new = fix(_new)

 if(n_elements(xsize) EQ 0) then $
                        _xsize = grim_rc_value(keywords, value_ps, 'XSIZE') $
 else _xsize = xsize
 if(keyword_set(_xsize)) then xsize = fix(_xsize)

 if(n_elements(ysize) EQ 0) then $
                        _ysize = grim_rc_value(keywords, value_ps, 'YSIZE') $
 else _ysize = ysize
 if(keyword_set(_ysize)) then ysize = fix(_ysize)

 if(n_elements(rotate) EQ 0) then $
                        _rotate = grim_rc_value(keywords, value_ps, 'ROTATE') $
 else _rotate = rotate
 if(keyword_set(_rotate)) then rotate = fix(_rotate)

 if(n_elements(zoom) EQ 0) then $
                        _zoom = grim_rc_value(keywords, value_ps, 'ZOOM') $
 else _zoom = zoom
 if(keyword_set(_zoom)) then zoom = double(_zoom)

 if(n_elements(order) EQ 0) then $
                        _order = grim_rc_value(keywords, value_ps, 'ORDER') $
 else _order = order
 if(keyword_set(_order)) then order = fix(_order)

 if(n_elements(cursor_swap) EQ 0) then $
                 _cursor_swap = grim_rc_value(keywords, value_ps, 'CURSOR_SWAP') $
 else _cursor_swap = cursor_swap
 if(defined(_cursor_swap)) then cursor_swap = fix(_cursor_swap)

 if(n_elements(offset) EQ 0) then $
                        _offset = grim_rc_value(keywords, value_ps, 'OFFSET') $
 else _offset = offset
 if(keyword_set(_offset)) then offset = double(_offset)

 if(n_elements(path) EQ 0) then $
                        _path = grim_rc_value(keywords, value_ps, 'PATH') $
 else _path = path
 if(keyword_set(_path)) then path = _path

 if(n_elements(save_path) EQ 0) then $
                   _save_path = grim_rc_value(keywords, value_ps, 'SAVE_PATH') $
 else _save_path = save_path
 if(keyword_set(_save_path)) then save_path = _save_path

 if(n_elements(load_path) EQ 0) then $
                   _load_path = grim_rc_value(keywords, value_ps, 'LOAD_PATH') $
 else _load_path = load_path
 if(keyword_set(_load_path)) then load_path = _load_path

 if(n_elements(workdir) EQ 0) then $
                   _workdir = grim_rc_value(keywords, value_ps, 'WORKDIR') $
 else _workdir = workdir
 if(keyword_set(_workdir)) then workdir = _workdir

 if(n_elements(menu_fname) EQ 0) then $
                   _menu_fname = grim_rc_value(keywords, value_ps, 'MENU_FNAME') $
 else _menu_fname = menu_fname
 if(keyword_set(_menu_fname)) then menu_fname = _menu_fname

 if(n_elements(filter) EQ 0) then $
                        _filter = grim_rc_value(keywords, value_ps, 'FILTER') $
 else _filter = filter
 if(keyword_set(_filter)) then filter = _filter

 if(n_elements(mode_init) EQ 0) then $
                     _mode_init = grim_rc_value(keywords, value_ps, 'MODE_INIT') $
 else _mode_init = mode_init
 if(keyword_set(_mode_init)) then mode_init = _mode_init

 if(n_elements(retain) EQ 0) then $
                        _retain = grim_rc_value(keywords, value_ps, 'RETAIN') $
 else _retain = retain
 if(keyword_set(_retain)) then retain = fix(_retain)

 if(n_elements(overlays) EQ 0) then $
                   _overlays = grim_rc_value(keywords, value_ps, 'OVERLAYS') $
 else _overlays = overlays
 if(keyword_set(_overlays)) then overlays = _overlays

 if(n_elements(frame) EQ 0) then $
                   _frame = grim_rc_value(keywords, value_ps, 'FRAME') $
 else _frame = frame
 if(keyword_set(_frame)) then frame = _frame

 if(n_elements(menu_extensions) EQ 0) then $
         _menu_extensions = grim_rc_value(keywords, value_ps, 'MENU_EXTENSIONS') $
 else _menu_extensions = menu_extensions
 if(keyword_set(_menu_extensions)) then menu_extensions = _menu_extensions

 if(n_elements(button_extensions) EQ 0) then $
     _button_extensions = grim_rc_value(keywords, value_ps, 'BUTTON_EXTENSIONS') $
 else _button_extensions = button_extensions
 if(keyword_set(_button_extensions)) then button_extensions = _button_extensions

 if(n_elements(arg_extensions) EQ 0) then $
          _arg_extensions = grim_rc_value(keywords, value_ps, 'ARG_EXTENSIONS') $
 else _arg_extensions = arg_extensions
 if(keyword_set(_arg_extensions)) then arg_extensions = _arg_extensions

 if(n_elements(trs_cd) EQ 0) then $
                        _trs_cd = grim_rc_value(keywords, value_ps, 'TRS_CD') $
 else _trs_cd = trs_cd
 if(keyword_set(_trs_cd)) then trs_cd = _trs_cd

 if(n_elements(trs_pd) EQ 0) then $
                        _trs_pd = grim_rc_value(keywords, value_ps, 'TRS_PD') $
 else _trs_pd = trs_pd
 if(keyword_set(_trs_pd)) then trs_pd = _trs_pd

 if(n_elements(trs_rd) EQ 0) then $
                        _trs_rd = grim_rc_value(keywords, value_ps, 'TRS_RD') $
 else _trs_rd = trs_rd
 if(keyword_set(_trs_rd)) then tr_rds = _trs_rd

 if(n_elements(trs_sd) EQ 0) then $
                        _trs_sd = grim_rc_value(keywords, value_ps, 'TRS_SD') $
 else _trs_sd = trs_sd
 if(keyword_set(_trs_sd)) then trs_sd = _trs_sd

 if(n_elements(trs_std) EQ 0) then $
                        _trs_std = grim_rc_value(keywords, value_ps, 'TRS_STD') $
 else _trs_std = trs_std
 if(keyword_set(_trs_std)) then trs_std = _trs_std

 if(n_elements(trs_ard) EQ 0) then $
                        _trs_ard = grim_rc_value(keywords, value_ps, 'TRS_ARD') $
 else _trs_ard = trs_ard
 if(keyword_set(_trs_ard)) then trs_ard = _trs_ard

 if(n_elements(trs_sund) EQ 0) then $
                        _trs_sund = grim_rc_value(keywords, value_ps, 'TRS_SUND') $
 else _trs_sund = trs_sund
 if(keyword_set(_trs_sund)) then trs_sund = _trs_sund

 if(n_elements(filetype) EQ 0) then $
                        _filetype = grim_rc_value(keywords, value_ps, 'FILETYPE') $
 else _filetype = filetype
 if(keyword_set(_filetype)) then filetype = _filetype

 if(n_elements(mode_args) EQ 0) then $
                   _mode_args = grim_rc_value(keywords, value_ps, 'MODE_ARGS') $
 else _mode_args = mode_args
 if(keyword_set(_mode_args)) then mode_args = _mode_args

 if(n_elements(psym) EQ 0) then $
                        _psym = grim_rc_value(keywords, value_ps, 'PSYM') $
 else _psym = psym
 if(keyword_set(_psym)) then psym = long(_psym)

 if(n_elements(symsize) EQ 0) then $
                        _symsize = grim_rc_value(keywords, value_ps, 'SYMSIZE') $
 else _symsize = symsize
 if(keyword_set(_symsize)) then symsize = fix(_symsize)

 if(n_elements(nhist) EQ 0) then $
                        _nhist = grim_rc_value(keywords, value_ps, 'NHIST') $
 else _nhist = nhist
 if(keyword_set(_nhist)) then nhist = fix(_nhist)

 if(n_elements(maintain) EQ 0) then $
                     _maintain = grim_rc_value(keywords, value_ps, 'MAINTAIN') $
 else _maintain = maintain
 if(keyword_set(_maintain)) then maintain = fix(_maintain)

 if(n_elements(compress) EQ 0) then $
                     _compress = grim_rc_value(keywords, value_ps, 'COMPRESS') $
 else _compress = compress
 if(keyword_set(_compress)) then compress = fix(_compress)

 if(n_elements(activate) EQ 0) then $
                     _activate = grim_rc_value(keywords, value_ps, 'ACTIVATE') $
 else _activate = activate
 if(keyword_set(_activate)) then activate = fix(_activate)

 if(n_elements(ndd) EQ 0) then $
                        _ndd = grim_rc_value(keywords, value_ps, 'NDD') $
 else _ndd = ndd
 if(keyword_set(_ndd)) then ndd = long(_ndd)

 if(n_elements(loadct) EQ 0) then $
                        _loadct = grim_rc_value(keywords, value_ps, 'LOADCT') $
 else _loadct = loadct
 if(keyword_set(_loadct)) then loadct = fix(_loadct)

 if(n_elements(max) EQ 0) then $
                        _max = grim_rc_value(keywords, value_ps, 'MAX') $
 else _max = max
 if(keyword_set(_max)) then max = double(_max)

 if(n_elements(extensions) EQ 0) then $
                 _extensions = grim_rc_value(keywords, value_ps, 'EXTENSIONS') $
 else _extensions = extensions
 if(keyword_set(_extensions)) then extensions = _extensions

 if(n_elements(beta) EQ 0) then $
                        _beta = grim_rc_value(keywords, value_ps, 'BETA') $
 else _beta = beta
 if(keyword_set(_beta)) then beta = fix(_beta)

 if(n_elements(rendering) EQ 0) then $
                   _rendering = grim_rc_value(keywords, value_ps, 'RENDERING') $
 else _rendering = rendering
 if(keyword_set(_rendering)) then rendering = fix(_rendering)

 if(n_elements(npoints) EQ 0) then $
                        _npoints = grim_rc_value(keywords, value_ps, 'NPOINTS') $
 else _npoints = npoints
 if(keyword_set(_npoints)) then npoints = fix(_npoints)

 if(n_elements(plane_syncing) EQ 0) then $
            _plane_syncing = grim_rc_value(keywords, value_ps, 'PLANE_SYNCING') $
 else _plane_syncing = plane_syncing
 if(keyword_set(_plane_syncing)) then plane_syncing = fix(_plane_syncing)

 if(n_elements(tiepoint_syncing) EQ 0) then $
      _tiepoint_syncing = grim_rc_value(keywords, value_ps, 'TIEPOINT_SYNCING') $
 else _tiepoint_syncing = tiepoint_syncing
 if(keyword_set(_tiepoint_syncing)) then tiepoint_syncing = fix(_tiepoint_syncing)

 if(n_elements(curve_syncing) EQ 0) then $
         _curve_syncing = grim_rc_value(keywords, value_ps, 'CURVE_SYNCING') $
 else _curve_syncing = curve_syncing
 if(keyword_set(_curve_syncing)) then curve_syncing = fix(_curve_syncing)

 if(n_elements(rgb) EQ 0) then $
                        _rgb = grim_rc_value(keywords, value_ps, 'RGB') $
 else _rgb = rgb
 if(keyword_set(_rgb)) then rgb = fix(_rgb)

 if(n_elements(visibility) EQ 0) then $
                 _visibility = grim_rc_value(keywords, value_ps, 'VISIBILITY') $
 else _visibility = visibility
 if(keyword_set(_visibility)) then visibility = fix(_visibility)

 if(n_elements(channel) EQ 0) then $
                        _channel = grim_rc_value(keywords, value_ps, 'CHANNEL') $
 else _channel = channel
 if(keyword_set(_channel)) then channel = fix(_channel)

 if(n_elements(render_pht_min) EQ 0) then $
          _render_pht_min = grim_rc_value(keywords, value_ps, 'RENDER_PHT_MIN') $
 else _render_pht_min = render_pht_min
 if(keyword_set(_render_pht_min)) then render_pht_min = fix(_render_pht_min)

 if(n_elements(render_sample) EQ 0) then $
             _render_sample = grim_rc_value(keywords, value_ps, 'RENDER_SAMPLE') $
 else _render_sample = render_sample
 if(keyword_set(_render_sample)) then render_sample = fix(_render_sample)

 if(n_elements(slave_overlays) EQ 0) then $
          _slave_overlays = grim_rc_value(keywords, value_ps, 'SLAVE_OVERLAYS') $
 else _slave_overlays = slave_overlays
 if(keyword_set(_slave_overlays)) then slave_overlays = fix(_slave_overlays)


end
;=============================================================================
