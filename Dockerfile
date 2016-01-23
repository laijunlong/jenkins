FROM daocloud.io/ubuntu
MAINTAINER adware
ENV REFRESHED_AT 2016-1-25
RUN apt-get update -qq && apt-get install -qqy curl apt-transport-https
RUN curl -L https://get.docker.io/gpg | apt-key add -
RUN echo deb http://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list
RUN apt-get update -qq
RUN apt-get install -qqy iptables ca-certificates lxc openjdk-6-jdk git-core lxc-docker
ENV JENKINS_HOME /opt/jenkins/data
ENV JENKINS_MIRROR http://mirrors.jenkins-ci.org

RUN mkdir -p $JENKINS_HOME/plugins
RUN curl -sf -o /opt/jenkins/jenkins.war -L $JENKINS_MIRROR/war-stable/latest/jenkins.war
RUN for plugin in chucknorris greenballs scm-api git-client git ws-cleanup ; do curl -o $JENKINS_HOME/plugins/${plugin}.hpi -L http://mirrors.jenkins-ci.org/plugins/${plugin}/latest/${plugin}.hpi ; done

ADD ./dockerjenkins.sh /usr/local/bin/dockerjenkins.sh
RUN chmod +x /usr/local/bin/dockerjenkins.sh

VOLUME /var/lib/docker

EXPOSE 8080

ENTRYPOINT [ "/usr/local/bin/dockerjenkins.sh" ]
