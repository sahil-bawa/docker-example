FROM openjdk:15-slim AS build
ARG MAVEN_VERSION=3.5.3
ARG MAVEN_HOME=/usr/apache-maven-$MAVEN_VERSION
ENV PATH $PATH:$MAVEN_HOME/bin
RUN apt-get update && \
    #### Install Maven 3
    apt-get install -y curl && \
    curl -sL http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz \
    | gunzip \
    | tar x -C /usr/ \
    && ln -s $MAVEN_HOME /usr/maven && \
    ls
COPY . run-program

RUN mvn -f run-program/sample-java-programs clean package

FROM alpine
COPY --from=build /run-program /run

CMD ["/run"]
