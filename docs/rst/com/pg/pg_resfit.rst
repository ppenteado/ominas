pg\_resfit.pro
===================================================================================================









	Computes polynomial coefficients for a camera distortion model by
	comparing detected reseaus with the known focal plane locations.



	First, candidate reseaus are associated with nominal reseaus by
	choosing the candidate with the highest correlation coefficient
	within a given number of pixels surrounding each known reseau.

	Next, coefficients for a polynomial of order n are derived using a
	least-squares fit.


 STATUS:
	Complete


 SEE ALSO:
	pg_resloc, pg_linearize_image, pg_blemish




















History
-------

 	Written by:	Spitale, 5/2002















