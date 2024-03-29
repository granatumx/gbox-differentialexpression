FROM granatumx/gbox-r-sdk:1.0.0

#RUN R -e 'remotes::install_version("flexmix", version = "2.3-18", repos = "http://cran.us.r-project.org")'
RUN R -e 'install.packages(c("flexmix"))'

RUN wget https://www.dropbox.com/s/pno78mmlj0exv7s/NODES_0.0.0.9010.tar.gz
RUN R -e 'install.packages(c("jsonlite"))'
RUN R -e 'install.packages("NODES_0.0.0.9010.tar.gz", repos = NULL, type = "source")'
RUN R -e 'BiocManager::install(c("impute"))'
# RUN R -e 'BiocManager::install(c("DESeq2"))'
RUN apt update
RUN apt-get update
RUN apt-get install -y git --fix-missing
# RUN R -e 'remotes::install_bioc(c("DESeq2"))'
RUN apt-get install -y libcairo2-dev libxt-dev
RUN R -e 'BiocManager::install("scde")'
RUN R -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/locfit/locfit_1.5-9.4.tar.gz", repos=NULL, type="source")'
RUN R -e 'remotes::install_bioc("DESeq2")'
RUN R -e 'BiocManager::install("edgeR")'
RUN R -e 'remotes::install_github("metaOmics/MetaDE")'

COPY . .

RUN ./GBOXtranslateVERinYAMLS.sh
RUN tar zcvf /gbox.tgz package.yaml yamls/*.yaml
