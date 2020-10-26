FROM rocker/geospatial:4.0.2

LABEL org.label-schema.license="GPL-2.0" \
      org.label-schema.vcs-url="https://github.com/rsettlag" \
      maintainer="Robert Settlage <rsettlag@vt.edu>"
## helpful read: https://divingintogeneticsandgenomics.rbind.io/post/run-rstudio-server-with-singularity-on-hpc/

## from the rocker/verse, trying to fix the tex stuff
ARG CTAN_REPO=${CTAN_REPO:-https://www.texlive.info/tlnet-archive/2019/02/27/tlnet}
ENV CTAN_REPO=${CTAN_REPO}

RUN apt update \
  && apt-get install -y gzip curl wget

RUN Rscript -e ".libPaths('/usr/local/lib/R/site-library');BiocManager::install(c('BiocStyle','graph','Rgraphviz','RColorBrewer'))" 
RUN Rscript -e "install.packages(Ncpus=6,lib='/usr/local/lib/R/site-library',c('fgm', 'hsdar', 'reticulate', 'SpatialEpi', 'colorspace', 'ggmap', 'Deriv', 'doParallel', 'fields', 'HKprocess', 'MatrixModels', 'tmap', 'matrixStats', 'mvtnorm', 'numDeriv', 'orthopolynom', 'pixmap', 'sn'), dep=TRUE)"
RUN Rscript -e "install.packages(Ncpus=6,'INLA',lib='/usr/local/lib/R/site-library', repos='https://inla.r-inla-download.org/R/stable', dep=TRUE); install.packages(Ncpus=6, 'INLABMA', dep=TRUE)"

## see if this fixes tex errors -- from rocker verse dockerfile
RUN install2.r --error tinytex \
  ## Admin-based install of TinyTeX:
  && wget -qO- \
    "https://github.com/yihui/tinytex/raw/master/tools/install-unx.sh" | \
    sh -s - --admin --no-path \
  && tlmgr install ae inconsolata listings metafont parskip pdfcrop \
     harvard ctable multirow eurosym comment setspace enumitem \
  && mv ~/.TinyTeX /opt/TinyTeX \
  && if /opt/TinyTeX/bin/*/tex -v | grep -q 'TeX Live 2018'; then \
      ## Patch the Perl modules in the frozen TeX Live 2018 snapshot with the newer
      ## version available for the installer in tlnet/tlpkg/TeXLive, to include the
      ## fix described in https://github.com/yihui/tinytex/issues/77#issuecomment-466584510
      ## as discussed in https://www.preining.info/blog/2019/09/tex-services-at-texlive-info/#comments
      wget -P /tmp/ ${CTAN_REPO}/install-tl-unx.tar.gz \
      && tar -xzf /tmp/install-tl-unx.tar.gz -C /tmp/ \
      && cp -Tr /tmp/install-tl-*/tlpkg/TeXLive /opt/TinyTeX/tlpkg/TeXLive \
      && rm -r /tmp/install-tl-*; \
    fi \
  && /opt/TinyTeX/bin/*/tlmgr path add

## for some reason this line tosses an error, looks more like an info error, but Docker complains
# RUN Rscript -e "tinytex::r_texmf()" \
RUN chown -R root:staff /opt/TinyTeX \
  && chmod -R g+w /opt/TinyTeX \
  && chmod -R g+wx /opt/TinyTeX/bin

RUN apt-get clean

## user needs Seurat with the geospatial stuff
RUN Rscript -e "library(reticulate); install_miniconda(path='/miniconda3',update=TRUE,force=TRUE)"
RUN install2.r --error Seurat \
  && install2.r --error hsdar \
  && install2.r --error lidR \
  && install2.r --error elevtar

RUN sed -i '/^R_LIBS_USER=/d' /usr/local/lib/R/etc/Renviron
RUN echo 'R_ENVIRON=~/.Renviron.OOD \
      \nR_ENVIRON_USER=~/.Renviron.OOD \
      \n' >>/usr/local/lib/R/etc/Renviron
RUN rm /usr/local/lib/R/etc/Rprofile.site

