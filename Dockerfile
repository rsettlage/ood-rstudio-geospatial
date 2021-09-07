FROM rsettlag/ood-rstudio-basic:4.1.1

LABEL org.label-schema.license="GPL-2.0" \
      org.label-schema.vcs-url="https://github.com/rsettlag" \
      maintainer="Robert Settlage <rsettlag@vt.edu>"
## helpful read: https://divingintogeneticsandgenomics.rbind.io/post/run-rstudio-server-with-singularity-on-hpc/

RUN apt update && apt-get install -y libmpfr-dev

RUN sed -i 's/install2.r/install2.r --repos="http://cran.r-project.org"/' /rocker_scripts/install_geospatial.sh
RUN /rocker_scripts/install_tidyverse.sh
RUN /rocker_scripts/install_verse.sh
RUN /rocker_scripts/install_geospatial.sh
RUN install2.r --error Rmpfr

RUN apt-get clean

