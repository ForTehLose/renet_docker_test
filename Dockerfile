############################################################
# Dockerfile that builds a Spacewar Gameserver
############################################################
FROM cm2network/steamcmd:root

# LABEL maintainer="walentinlamonos@gmail.com"

ENV STEAMAPPID 480
ENV STEAMAPP Spacewar
ENV STEAMAPPDIR "${HOMEDIR}/${STEAMAPP}-dedicated"

ENV STEAM_BETA_APP 480
ENV STEAM_BETA_PASSWORD ""
ENV STEAM_BETA_BRANCH ""

# ENV WORKSHOPID 393380
# ENV MODPATH "${STEAMAPPDIR}/Spacewar/Plugins/Mods"
# ENV MODS "()"

COPY etc/entry.sh ${HOMEDIR}

RUN set -x \
	&& mkdir -p "${STEAMAPPDIR}" \
	&& chmod 755 "${HOMEDIR}/entry.sh" "${STEAMAPPDIR}" \
	&& chown "${USER}:${USER}" "${HOMEDIR}/entry.sh" "${STEAMAPPDIR}"

# ENV PORT=7787 \
# 	QUERYPORT=27165 \
# 	RCONPORT=21114 \
# 	FIXEDMAXPLAYERS=80 \
# 	FIXEDMAXTICKRATE=50 \
# 	RANDOM=NONE


# Expose ports
# EXPOSE 7787/udp \
# 	27165/tcp \
# 	27165/udp \
# 	21114/tcp \
# 	21114/udp

# git
RUN apt-get -y update
RUN apt-get -y install git

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH \
    RUST_VERSION=1.74.1

RUN apt update -y
RUN apt upgrade -y
RUN apt install curl build-essential gcc make -y
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

WORKDIR ${HOMEDIR}
RUN git clone https://github.com/ForTehLose/renet_docker_test
WORKDIR ${HOMEDIR}/renet_docker_test
RUN cargo build --release
RUN rm /usr/lib/x86_64-linux-gnu/steamclient.so
WORKDIR /root/
RUN mkdir .steam/
RUN mkdir sdk64/
# RUN  ln -s "${STEAMCMDDIR}/linux64/steamclient.so" "/root/.steam/sdk64/steamclient.so"
# Switch to user
USER ${USER}

WORKDIR ${HOMEDIR}

CMD ["bash", "entry.sh"]

