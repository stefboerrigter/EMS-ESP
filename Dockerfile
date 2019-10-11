FROM python:3.7-slim

ENV APP_VERSION="4.0.0" \
    APP="platformio-core"

LABEL app.name="${APP}" \
      app.version="${APP_VERSION}" \
      maintainer="Stef Boerrigter <stefboerrigter@gmail.com>"

RUN pip install -U platformio==${APP_VERSION} && \
    mkdir -p /workspace && \
    mkdir -p /.platformio && \
    chmod a+rwx /.platformio

RUN apt-get update && \
	apt-get -y install curl gnupg git && \
	curl -sL https://deb.nodesource.com/setup_11.x  | bash - && \
	apt-get -y install nodejs

WORKDIR /opt/
ADD https://api.github.com/repos/stefboerrigter/EMS-ESP/git/refs/heads/stef/master version.json
WORKDIR /opt/EMS-ESP
RUN mkdir -p /opt/EMS-ESP && \
	git clone -b stef/master https://github.com/stefboerrigter/EMS-ESP.git /opt/EMS-ESP && \
	cd /opt/EMS-ESP && \
	cd tools/webfilesbuilder && \
	npm install && \
	cd /opt/EMS-ESP && \
	pio run

USER 1001

WORKDIR /opt/EMS-ESP

#hold / keep hanging on this.. now you can make changes if requested, or run pio -t upload.
ENTRYPOINT ["tail","-f","/dev/null"]
