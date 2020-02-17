FROM rocker/geospatial:3.6.2

LABEL org.label-schema.license="GPL-2.0" \
      org.label-schema.vcs-url="https://github.com/rsettlag" \
      maintainer="Robert Settlage <rsettlag@vt.edu>"
## helpful read: https://divingintogeneticsandgenomics.rbind.io/post/run-rstudio-server-with-singularity-on-hpc/

RUN Rscript -e "install.packages(c('BiocManager', 'SpatialEpi', 'colorspace', 'ggmap', 'Deriv', 'doParallel', 'fields', 'HKprocess', 'MatrixModels', 'matrixStats', 'mvtnorm', 'numDeriv', 'orthopolynom', 'pixmap', 'sn'), dep=TRUE)"
RUN Rscript -e "BiocManager::install(c('RColorBrewer', 'graph', 'Rgraphviz'))"
RUN Rscript -e "install.packages('INLA', repos='https://inla.r-inla-download.org/R/stable', dep=TRUE)"
RUN install2.r --error \
    --deps TRUE \
    INLABMA

RUN tlmgr install url harvard enumerate amsmath float tabularx ctable multirow eurosym graphics comment setspace enumitem \
  && tlmgr path add \
  && Rscript -e "tinytex::r_texmf()"\
  && chown -R root:staff /opt/TinyTeX \
  && chmod -R g+w /opt/TinyTeX \
  && chmod -R g+wx /opt/TinyTeX/bin

RUN apt-get clean

RUN sed -i '/^R_LIBS_USER=/d' /usr/local/lib/R/etc/Renviron
RUN echo 'R_ENVIRON=~/.Renviron.OOD \
      \nR_ENVIRON_USER=~/.Renviron.OOD \
      \n' >>/usr/local/lib/R/etc/Renviron
RUN rm /usr/local/lib/R/etc/Rprofile.site

