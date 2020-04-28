;============================================================================
; cm_image
;
;
;============================================================================
function cm_image, image, n_colors=n_colors, top=top, bottom=bottom, gamma=gamma

 cmd = colormap_descriptor(top=top, n_colors=n_colors, bottom=bottom, gamma=gamma)
 cm = compute_colormap(cmd)

 return, apply_colormap(image, cm)
end
;============================================================================
