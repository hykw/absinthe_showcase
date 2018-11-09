FROM hykw/elixir:1.7.4
ARG ERL_VER=21.1


ARG USER="dockeruser"
ARG MYUID="1000"
ARG PORT=4001
ARG WORKDIR="/showcase/src"

RUN \
  useradd ${USER} -u ${MYUID} -d /showcase && \
  mkdir -p /showcase && \
  chown ${USER} /showcase


WORKDIR ${WORKDIR}
EXPOSE ${PORT}

USER ${USER}

RUN echo "alias ls='ls --color=never'" >> $HOME/.bashrc; \
  echo "PATH=/usr/local/erl/${ERL_VER}/bin:/usr/local/elixir/bin:${PATH}" >> $HOME/.bashrc;
