# Start from a specific tagged Jupyter base image
FROM jupyter/base-notebook:da2c5a4d00fa

LABEL maintainer="davidrpugh <david.pugh@kapsarc.org>"

# Install the Python 3 packages
RUN conda install --quiet --yes \
    'glpk' \
    'pyomo' \
    'pyomo.extras'

# Install GAMS
RUN mkdir $HOME/gams && \
    cd $HOME/gams && \
    wget -q https://d37drm4t2jghv5.cloudfront.net/distributions/24.9.1/linux/linux_x64_64_sfx.exe && \
    chmod u+x linux_x64_64_sfx.exe && \
    ./linux_x64_64_sfx.exe && \
    rm linux_x64_64_sfx.exe && \
    cd $HOME
    
# Add local files as late as possible to avoid cache busting
COPY *.ipynb

USER $NB_USER
