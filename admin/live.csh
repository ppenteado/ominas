cp $OMINAS_DIR/ominas_1.0_all.tar.gz /psi/public_html/code/OMINAS
cp $OMINAS_DIR/ominas_1.0_cmp.tar.gz /psi/public_html/code/OMINAS
cp $OMINAS_DIR/ominas_1.0_src.tar.gz /psi/public_html/code/OMINAS

rsync -avuWz --delete $OMINAS_DIR/doc/html/* /psi/public_html/code/OMINAS/doc
