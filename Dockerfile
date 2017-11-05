# Start from a specific tagged Jupyter base image
FROM jupyter/base-notebook:da2c5a4d00fa

LABEL maintainer="davidrpugh <david.pugh@kapsarc.org>"

# Install the Python 3 packages
RUN conda install --quiet --yes \
    'glpk' \
    'pyomo' \
    'pyomo.extras' \
    
# Install GAMS
RUN wget -q https://d37drm4t2jghv5.cloudfront.net/distributions/24.9.1/linux/linux_x64_64_sfx.exe && \
    mkdir /opt/gams && \
    cd /opt/gams && \
    ~/linux_x64_64_sfx.exe && \
    rm linux_x64_64_sfx.exe
    
