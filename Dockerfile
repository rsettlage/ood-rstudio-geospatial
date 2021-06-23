FROM rsettlag/ood-rstudio-basic:4.1.0

LABEL org.label-schema.license="GPL-2.0" \
      org.label-schema.vcs-url="https://github.com/rsettlag" \
      maintainer="Robert Settlage <rsettlag@vt.edu>"
## helpful read: https://divingintogeneticsandgenomics.rbind.io/post/run-rstudio-server-with-singularity-on-hpc/

RUN apt update
RUN /rocker_scripts/install_geospatial.sh

#RUN Rscript -e ".libPaths('/usr/local/lib/R/site-library');BiocManager::install(c('BiocStyle','graph','Rgraphviz','RColorBrewer'))" 
#RUN Rscript -e "install.packages(Ncpus=6,lib='/usr/local/lib/R/site-library',c('rjags','fgm', 'hsdar', 'reticulate', 'SpatialEpi', 'colorspace', 'ggmap', 'Deriv', 'doParallel', 'fields', 'HKprocess', 'MatrixModels', 'tmap', 'matrixStats', 'mvtnorm', 'numDeriv', 'orthopolynom', 'pixmap', 'sn'), dep=TRUE)"
#RUN Rscript -e "install.packages(Ncpus=6,'INLA',lib='/usr/local/lib/R/site-library', repos='https://inla.r-inla-download.org/R/stable', dep=TRUE); install.packages(Ncpus=6, 'INLABMA', dep=TRUE)"

RUN apt-get clean

## user needs Seurat with the geospatial stuff
#RUN Rscript -e "library(reticulate); install_miniconda(path='/miniconda3',update=TRUE,force=TRUE)"
#RUN install2.r --error Seurat \
#  && install2.r --error hsdar \
#  && install2.r --error lidR \
#  && Rscript -e "library(devtools); install_github('jhollist/elevatr')"

