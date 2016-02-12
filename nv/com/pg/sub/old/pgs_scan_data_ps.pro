;===========================================================================
; pgs_scan_data_ps.pro
;
;===========================================================================
pro pgs_scan_data_ps, pp, points_ps=points_ps, $
                      vectors_ps=vectors_ps, $
                      flags_ps=flags_ps, $
                      cc_ps=cc_ps, $
                      data_ps=data_ps

 pgs_points_ps, pp, points_ps=points_ps, $
                    vectors_ps=vectors_ps, $
                    flags_ps=flags_ps, $
                    data_ps=data_ps

 cc_ps = pp.cc_p

end
;===========================================================================
