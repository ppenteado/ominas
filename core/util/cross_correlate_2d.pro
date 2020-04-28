;=============================================================================
;+
; NAME:
;       cross_correlate_2d
;
;
; PURPOSE:
;       Calculates the correlation coefficient between an image and
;       a model.
;
;
; CATEGORY:
;       UTIL
;
;
; CALLING SEQUENCE:
;       result = c_correlate_2d(image, model)
;
;
; ARGUMENTS:
;  INPUT:
;       image:  Two dimensional image.
;
;       model:  The model to correlelate with the image (sm[1] x sm[2])
;
;  OUTPUT:
;       NONE
;
; KEYWORDS:
;  INPUT:
;       NONE
;
;  OUTPUT:
;       sigma:  The sigma of the image in a box of size sm[1] x sm[2]
;               around each point
;
;        mean:  The mean of the image in a box of size sm[1] x sm[2]
;               around each point
;
;
; RETURN:
;       The array of correlation coefficients.
;
;
; STATUS:
;       Completed.
;
;
; MODIFICATION HISTORY:
;       Written by:     Spitale
;
;-
;=============================================================================
function cross_correlate_2d, image, model, sigma=sigma, mean=mean

 si = size(image)
 sm = size(model)

 ;---------------------------------------
 ; compute localized sum array
 ;---------------------------------------
 box = make_array(sm[1],sm[2],val=1d)
 sum_image = convol(image, box, /center)

 ;---------------------------------------
 ; compute localized sum squared array
 ;---------------------------------------
 sum_sqr_image = convol(image*image, box, /center)

 ;---------------------------------------
 ; compute means and standard deviations
 ;---------------------------------------
 image_sigma = sqrt(sum_sqr_image - sum_image*sum_image/sm[1]/sm[2])/ $
             sqrt(sm[1]*sm[2])
 image_mean = sum_image/(sm[1]*sm[2])
 model_sigma = stdev(model, model_mean)

 ;-------------------------------
 ; correct for degenerate values
 ;-------------------------------
 image_sigma = image_sigma > 1d-6

 ;-----------------------------------------------
 ; compute correlation coefficient at each pixel
 ;-----------------------------------------------
 cc = convol(image-image_mean, model-model_mean, /center) / $
                                   (n_elements(model)*image_sigma*model_sigma)


 if(arg_present(sigma)) then sigma = image_sigma
 if(arg_present(mean)) then mean = image_mean

 return, cc
end
;===========================================================================
