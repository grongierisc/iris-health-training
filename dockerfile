ARG IMAGE=intersystemsdc/irishealth-community:2020.4.0.547.0-zpm
FROM $IMAGE

ARG IRIS_PASSWORD

USER root
WORKDIR /opt/irisapp
RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/irisapp
USER ${ISC_PACKAGE_MGRUSER}

COPY . /opt/irisapp
COPY iris.script /tmp/iris.script


# run iris and initial 
RUN iris start IRIS \
	&& iris session IRIS < /tmp/iris.script \
	&& iris stop IRIS quietly

