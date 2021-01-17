# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
ARG BASE_CONTAINER=jupyter/minimal-notebook
FROM $BASE_CONTAINER

LABEL maintainer="benmp <https://github.com/benmp2>"

USER root

# ffmpeg for matplotlib anim & dvipng+cm-super for latex labels
RUN apt-get update && \
    apt-get install -y --no-install-recommends ffmpeg dvipng cm-super && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER $NB_UID

RUN conda install -c conda-forge --yes \
	pandas \
	numpy \
	matplotlib \
	scikit-learn \
	scikit-image \
	scipy \
	statsmodels \
	seaborn \
	plotly \
	plotly_express \
	nodejs \
	"ipywidgets>=7.5" \
	opencv \
	imutils 
	
RUN	conda clean --all -y -f

RUN jupyter labextension install \
	@jupyter-widgets/jupyterlab-manager \
	jupyterlab-plotly@4.14.3 \
	jupyterlab-execute-time
	
RUN jupyter lab build

### ADDING jupyter lab config: ######
RUN mkdir ~/.jupyter/lab
RUN mkdir ~/.jupyter/lab/user-settings
USER root
ENV NB_UID=$NB_UID \
        NB_GID=$NB_GID
ADD user-settings /home/$NB_USER/.jupyter/lab/user-settings
RUN chown -R $NB_UID:$NB_GID /home/$NB_USER/.jupyter/lab/user-settings

USER $NB_UID
#####################################

EXPOSE 8888

CMD ["bash", "-c", "jupyter lab --notebook-dir=/home/jovyan/work --ip 0.0.0.0 --no-browser --allow-root"]


