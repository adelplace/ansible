FROM ubuntu AS base
WORKDIR /usr/local/bin
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get -y install sudo && \
    apt-get install -y software-properties-common curl git build-essential && \
    apt-add-repository -y ppa:ansible/ansible && \
    apt-get update && \
    apt-get install -y curl git ansible build-essential && \
    apt-get clean autoclean && \
    apt-get autoremove --yes

FROM base AS image
ARG TAGS
RUN addgroup --gid 1001 adelplace
RUN adduser --gecos adelplace --uid 1001 --gid 1001 --disabled-password adelplace
RUN usermod -aG sudo adelplace
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER adelplace
WORKDIR /home/adelplace

FROM image
COPY --chown=adelplace:adelplace . .
CMD ["sh", "-c", "ansible-playbook $TAGS local.yml"]
