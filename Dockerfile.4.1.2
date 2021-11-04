FROM rsettlag/ood-rstudio-basic:4.1.2

LABEL org.label-schema.license="GPL-2.0" \
      org.label-schema.vcs-url="https://github.com/rsettlag" \
      maintainer="Robert Settlage <rsettlag@vt.edu>"
## helpful read: https://divingintogeneticsandgenomics.rbind.io/post/run-rstudio-server-with-singularity-on-hpc/

RUN apt update && apt-get install -y libmpfr-dev

RUN echo "options(repos=structure(c(CRAN='http://cran.r-project.org')))" > /usr/local/lib/R/etc/Rprofile.site
RUN Rscript -e "install.packages('remotes'); remotes::install_github('r-spatial/mapview'); install.packages('BH')"
RUN /rocker_scripts/install_tidyverse.sh
RUN /rocker_scripts/install_verse.sh
RUN sed -i '/maptools/d' /rocker_scripts/install_geospatial.sh
RUN /rocker_scripts/install_geospatial.sh
RUN install2.r --error Rmpfr

RUN apt-get clean
RUN rm /usr/local/lib/R/etc/Rprofile.site
