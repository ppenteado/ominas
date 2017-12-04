pg\_spikes.pro
===================================================================================================



























pg\_spikes
________________________________________________________________________________________________________________________





.. code:: IDL

 result = pg_spikes(dd, nsig=nsig, grad=grad, mask=mask, umask=umask, extend=extend, scale=scale, edge=edge, local=local, nohot=nohot, allpix=allpix)



Description
-----------
	Locates spurious features like cosmic-ray hits.




	Clusters of hot pixels of size 'scale' are identified by looking
	for regions bounded by large gradients.  Each cluster is then
	examined for pixels whose values are larger than nsig standard
	deviations above the local mean.


 STATUS:
	Complete


 SEE ALSO:
	pg_despike, pg_mask










Returns
-------

	POINT containing the detected spike points.










+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Parameters
----------




dd
-----------------------------------------------------------------------------

*in* 

	Data descriptor containing the image to be despiked.





+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++




Keywords
--------


.. _nsig
- nsig *in* 

	Number of standard deviations above the local
			mean data value to flag for removal.  Default is 2.




.. _grad
- grad *in* 

	Minimum data value gradient to use when searching
			for clusters of hot pixels.  Default is 5.




.. _mask
- mask 



.. _umask
- umask *in* 

	Byte image of the same size as the input image
			in which nonzero pixel values indicate locations
			where spikes should not be flagged.




.. _extend
- extend *in* 

	Number of pixels away from masked pixels before
			locations may be flagged as spikes.




.. _scale
- scale *in* 

	Typical size of objects to be flagged.  Default is 10.




.. _edge
- edge *in* 

	Regions closer than this to the edge of the image
			will be ignored.  Default is 10.




.. _local
- local *in* 

	Multiplier that determines the width of the region
			over which the local mean and standard deviation are
			taken.  That width is local * scale.  Default is 5.




.. _nohot
- nohot 



.. _allpix
- allpix *in* 

	If set, all pixels in the spike region are returned
			instead of of the centroids.








Examples
--------

.. code:: IDL

	dd = dat_read(filename)
	spike_ptd = pg_spikes(dd)
	dd1 = pg_despike(dd, spike_ptd)










History
-------

 	Written by:	Spitale, 4/2005





















