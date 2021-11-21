FROM golang:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y wget git
RUN apt-get update \
  && apt-get install -y python3-pip python3-dev \
  && cd /usr/local/bin \
  && ln -s /usr/bin/python3 python \
  && pip3 install --upgrade pip

RUN pip install xml2rfc

WORKDIR /github

RUN git clone https://github.com/mmarkdown/mmark.git
RUN cd mmark \
  && go get \
  && go build \
  && chmod +x mmark \
  && mv mmark /usr/local/bin

COPY make.sh /usr/local/bin/

WORKDIR /data

ENTRYPOINT [ "/bin/bash", "/usr/local/bin/make.sh" ]