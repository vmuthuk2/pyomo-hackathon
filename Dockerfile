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
RUN mkdir /opt/gams && \
    cd /opt/gams && \
    wget -q https://d37drm4t2jghv5.cloudfront.net/distributions/24.9.1/linux/linux_x64_64_sfx.exe && \
    chmod u+x linux_x64_64_sfx.exe && \
    ./linux_x64_64_sfx.exe && \
    rm linux_x64_64_sfx.exe && \
    cd $HOME
ENV PATH=/opt/gams/gams24.9_linux_x64_64_sfx/:$PATH 

# Install the GAMS python bindings
RUN cd /opt/gams/gams24.9_linux_x64_64_sfx/apifiles/Python/api_36 && \
    python setup.py install && \
    cd $HOME
    
# Install the pathampl solver (comes with GAMS but would ideally like to use it independently!)
RUN mkdir /opt/pathampl && \
    cd /opt/pathampl
RUN curl ftp://ftp.cs.wisc.edu/math-prog/solvers/path/ampl/lnx/pathampl -o pathampl
RUN chmod u+x pathampl && \
    cd $HOME
ENV PATH=/opt/pathampl/:$PATH

# Add local files as late as possible to avoid cache busting
COPY *.ipynb $HOME/

USER $NB_USER
