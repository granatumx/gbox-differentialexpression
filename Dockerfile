FROM ubuntu:latest

ENV DEBIAN_FRONTEND noninteractive

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

RUN apt-get update

RUN apt-get install software-properties-common
RUN add-apt-repository universe
RUN apt-get -y install python-pip
RUN apt-get install -y apt-utils build-essential git tmux curl python-pip

RUN apt-get install -y vim-tiny apt-transport-https software-properties-common 
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
RUN add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran35/"
RUN apt-get update
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
RUN apt-get install -y r-base python-rpy2

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

COPY ./install_from_bioconductor.R .

RUN Rscript ./install_from_bioconductor.R SummarizedExperiment
RUN Rscript ./install_from_bioconductor.R genefilter
RUN Rscript ./install_from_bioconductor.R geneplotter
RUN Rscript ./install_from_bioconductor.R DESeq2

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
