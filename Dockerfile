FROM ubuntu:latest

RUN apt-get -y update && apt-get -y install curl apt-utils zip
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash
RUN apt-get -y install git golang-go
RUN apt-get install openssl

COPY build.sh /tmp/build.sh
RUN chmod +x /tmp/build.sh
RUN /tmp/build.sh

RUN mkdir /encrypt
RUN chmod +x /encrypt
COPY cert.cer /encrypt/cert.cer

COPY run.sh /tmp/run.sh
RUN chmod +x /tmp/run.sh
ENTRYPOINT ["/bin/bash"]
CMD ["-c", "/tmp/run.sh"]
