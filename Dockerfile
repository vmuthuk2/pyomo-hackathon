# Start from a specific tagged Jupyter base image
FROM jupyter/scipy-notebook:da2c5a4d00fa

LABEL maintainer="davidrpugh <david.pugh@kapsarc.org>"

# Install the additional Python 3 packages
RUN conda install --quiet --yes \
    'glpk' \
    'pyomo' \
    'pyomo.extras'

USER root

# Install GAMS
ENV GAMS_MAJOR=25 \
    GAMS_MINOR=0 \
    GAMS_PATCH=3
ENV GAMS_VERSION=${GAMS_MAJOR}.${GAMS_MINOR}.${GAMS_PATCH}
RUN mkdir /opt/gams && \
    cd /opt/gams && \
    wget -q https://d37drm4t2jghv5.cloudfront.net/distributions/${GAMS_VERSION}/linux/linux_x64_64_sfx.exe && \
    chmod u+x linux_x64_64_sfx.exe && \
    ./linux_x64_64_sfx.exe && \
    rm linux_x64_64_sfx.exe && \
    cd $HOME
ENV PATH=/opt/gams/gams24.9_linux_x64_64_sfx/:$PATH 

# Install the GAMS python bindings
RUN cd /opt/gams/gams${GAMS_MAJOR}.${GAMS_MINOR}_linux_x64_64_sfx/apifiles/Python/api_36 && \
    python setup.py install && \
    cd $HOME

# Install the pathampl solver (comes with GAMS but would like to use it independently!)
RUN mkdir /opt/pathampl && \
    cd /opt/pathampl && \
    wget -q http://ftp.cs.wisc.edu/math-prog/solvers/path/ampl/lnx/pathampl && \
    chmod a+x pathampl && \
    cd $HOME
ENV PATH=/opt/pathampl/:$PATH

# Set the license string for the PATH solver (valid until December 31, 2020)
ENV PATH_LICENSE_STRING="2617827524&Courtesy&&&USR&64785&11_12_2017&1000&PATH&GEN&31_12_2020&0_0_0&5000&0_0"

# Add local files as late as possible to avoid cache busting
COPY *.ipynb $HOME/

USER $NB_USER
