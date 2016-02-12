cp $OMINAS_DIR/ominas_1.0_all.tar.gz /psi/public_html/OMINAS
cp $OMINAS_DIR/ominas_1.0_cmp.tar.gz /psi/public_html/OMINAS
cp $OMINAS_DIR/ominas_1.0_src.tar.gz /psi/public_html/OMINAS

srsync -avuWz --delete $OMINAS_DIR/doc/html/* /psi/public_html/OMINAS/doc
