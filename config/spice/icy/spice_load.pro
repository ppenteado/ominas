;=======================================================================================
; spice_load
;
;=======================================================================================
pro spice_load, k_in, uk_in=uk_in

 if(keyword_set(k_in)) then k_in = file_search(k_in)

 n_k_in = 0l
 if(NOT keyword_set(k_in)) then k_in = '' $
 else n_k_in = n_elements(k_in)

 n_uk_in = 0l
 if(NOT keyword_set(uk_in)) then uk_in = '' $
 else n_uk_in = n_elements(uk_in)


 ;-------------------
 ; unload kernels
 ;-------------------
 if(keyword_set(uk_in)) then $
       nv_message, /verb, 'Loading the following kernels:' + uk_in
 if(keyword_set(uk_in)) then for i=0, n_uk_in-1 do cspice_unload, uk_in[i]


 ;-------------------
 ; load kernels
 ;-------------------
 if(keyword_set(k_in)) then $
       nv_message, /verb, 'Loading the following kernels:' + k_in
 if(keyword_set(k_in)) then for i=0, n_k_in-1 do cspice_furnsh, k_in[i]


end
;=======================================================================================
