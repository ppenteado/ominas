;=============================================================================
; colormap_descriptor__define
;
;=============================================================================
pro colormap_descriptor__define

 struct = $
    { colormap_descriptor, $
	 gamma		:	1d, $
	 shade		:	1d, $
	 n_colors	:	0l, $
	 top		:	0l, $
	 bottom		:	0l, $
	 data		:	0l $		; user data
	}

end
;=============================================================================



