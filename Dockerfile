FROM jupyter/pyspark-notebook

USER root
# Add SSL
RUN mkdir -p /etc/ssl/secrets
COPY secrets/ /etc/ssl/secrets/
# Add essential packages
RUN apt-get update
RUN apt-get install -y build-essential
RUN apt-get install -y python-rpy2
RUN conda install -c r r-essentials r-rjson
# Update Node and NPM
RUN conda install -c conda-forge nodejs
RUN node --version
RUN npm --version
# Add password
COPY jupyter/jupyter_notebook_config.json /home/jovyan/.jupyter/
RUN chmod -R 777 /home/jovyan/
USER $NB_USER
# Install Python requirements
COPY requirements.txt /home/joyvan/
RUN pip install -r /home/joyvan/requirements.txt
# Custom styling
RUN mkdir -p /home/jovyan/.jupyter/custom
COPY custom/custom.css /home/jovyan/.jupyter/custom/
# Run the notebook
CMD ["/opt/conda/bin/jupyter", "notebook", "--notebook-dir=/opt/notebooks", "--ip='*'", "--no-browser", "--allow-root", "--port=8558", "--NotebookApp.keyfile=/etc/ssl/secrets/privkey.pem", "--NotebookApp.certfile=/etc/ssl/secrets/fullchain.pem"]
