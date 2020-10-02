FROM ubuntu:latest

ENV DEBIAN_FRONTEND noninteractive

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

RUN apt-get update

RUN apt-get install -y apt-utils build-essential git tmux curl python3-pip

RUN apt-get install -y vim-tiny apt-transport-https software-properties-common 
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
RUN add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"
RUN apt-get update
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
RUN apt-get install -y r-base python3-rpy2

RUN apt-get install -y python3-matplotlib
RUN apt-get install -y python3-pandas

RUN apt-get install -y --no-install-recommends ed locales \
		wget \
		fonts-texgyre \
		libcurl4-openssl-dev \
		libcairo2-dev \
		libssl-dev \
		libxt-dev \
		libxml2-dev
# -------

COPY ./install_from_CRAN.R .

RUN Rscript ./install_from_CRAN.R BiocManager
RUN Rscript ./install_from_CRAN.R RCurl
RUN Rscript ./install_from_CRAN.R XML
RUN Rscript ./install_from_CRAN.R survival
RUN Rscript ./install_from_CRAN.R samr
RUN Rscript ./install_from_CRAN.R combinat
RUN Rscript ./install_from_CRAN.R remotes

COPY ./install_from_bioconductor.R .

RUN Rscript ./install_from_bioconductor.R impute
RUN Rscript ./install_from_bioconductor.R limma
RUN Rscript ./install_from_bioconductor.R edgeR
RUN Rscript ./install_from_bioconductor.R SummarizedExperiment
RUN Rscript ./install_from_bioconductor.R genefilter
RUN Rscript ./install_from_bioconductor.R geneplotter
RUN Rscript ./install_from_bioconductor.R DESeq2
RUN Rscript ./install_from_bioconductor.R Biobase

COPY ./install_from_github.R .
RUN Rscript ./install_from_github.R metaOmics/MetaDE

COPY . .

# Set version correctly so user can install gbox
# Requires bash and sed to set version in yamls
# Can modify if base OS does not support bash/sed
RUN apt-get update
RUN apt-get install -y sed bash
ARG VER=1.0.0
ARG GBOX=granatumx/gbox-differentialexpression:1.0.0
ENV VER=$VER
ENV GBOX=$GBOX
WORKDIR /usr/src/app
RUN ./GBOXtranslateVERinYAMLS.sh
RUN ./GBOXgenTGZ.sh

CMD [ "Rscript", "./greet.R" ]
