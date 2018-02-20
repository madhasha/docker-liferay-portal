FROM mdelapenya/jdk:8-openjdk
MAINTAINER Manuel de la Peña <manuel.delapenya@liferay.com>

RUN apt-get update \
  && apt-get install -y curl \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && useradd -ms /bin/bash liferay

ENV LIFERAY_HOME=/usr/local/liferay-ce-portal-7.0-ga3

RUN mkdir -p "$LIFERAY_HOME"

ENV CATALINA_HOME=$LIFERAY_HOME/tomcat-8.0.32

ENV PATH=$CATALINA_HOME/bin:$PATH

ENV LIFERAY_TOMCAT_URL=https://sourceforge.net/projects/lportal/files/Liferay%20Portal/7.0.2%20GA3/liferay-ce-portal-tomcat-7.0-ga3-20160804222206210.zip/download

WORKDIR /usr/local

RUN set -x \
			&& curl -kfSL "$LIFERAY_TOMCAT_URL" -o liferay-ce-portal-tomcat-7.0-ga3-20160804222206210.zip \
			&& unzip liferay-ce-portal-tomcat-7.0-ga3-20160804222206210.zip \
			&& rm liferay-ce-portal-tomcat-7.0-ga3-20160804222206210.zip

COPY .configs/setenv.sh $CATALINA_HOME/bin/setenv.sh
RUN chown -R liferay:liferay $LIFERAY_HOME

EXPOSE 8080/tcp
EXPOSE 11311/tcp

USER liferay

ENTRYPOINT ["catalina.sh", "run"]
