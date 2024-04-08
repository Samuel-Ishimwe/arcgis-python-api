ARG python_version=3.9
# lambda python image, defaults to python 3.9
FROM public.ecr.aws/lambda/python:${python_version}

# set metadata
LABEL org.opencontainers.image.authors="jroebuck@esri.com"
LABEL org.opencontainers.image.description="AWS Lambda image with arcgis Python API and its Linux dependencies preinstalled"
LABEL org.opencontainers.image.licenses=Apache
LABEL org.opencontainers.image.source=https://github.com/esri/arcgis-python-api

# install dependencies, then clean yum cache
RUN yum -y install gcc krb5-devel krb5-server krb5-libs && yum clean all && rm -rf /var/cache/yum
# install arcgis
ARG arcgis_version="2.2.0"
RUN  pip3 install "arcgis==${arcgis_version}.*" --target "${LAMBDA_TASK_ROOT}"
# set entrypoint to app.py handler method
# (note that app.py is missing from this base image)
CMD [ "app.handler" ]
# to use this base image, use FROM to specify its url
# and `COPY app.py ${LAMBDA_TASK_ROOT}`
# (copy your code into the lambda task root)
