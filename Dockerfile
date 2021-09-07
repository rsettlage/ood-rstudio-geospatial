FROM rsettlag/ood-rstudio-basic:4.1.1

LABEL org.label-schema.license="GPL-2.0" \
      org.label-schema.vcs-url="https://github.com/rsettlag" \
      maintainer="Robert Settlage <rsettlag@vt.edu>"
## helpful read: https://divingintogeneticsandgenomics.rbind.io/post/run-rstudio-server-with-singularity-on-hpc/

RUN apt update && apt-get install -y libmpfr-dev
RUN echo "local({r <- getOption('repos')" >> /usr/lib/R/library/base/R/Rprofile
RUN echo "r['CRAN'] <- 'http://cran.r-project.org' >> /usr/lib/R/library/base/R/Rprofile
RUN echo "options(repos=r)}) >> /usr/lib/R/library/base/R/Rprofile


RUN /rocker_scripts/install_tidyverse.sh
RUN /rocker_scripts/install_verse.sh
RUN /rocker_scripts/install_geospatial.sh
RUN install2.r --error Rmpfr

RUN apt-get clean

