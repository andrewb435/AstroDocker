FROM debian:12

ENV TIMEZONE=Etc/UTC \
    DEBIAN_FRONTEND="noninteractive"

VOLUME ["/astroneer"]

RUN dpkg --add-architecture i386 && \
    sed -i 's/Components:\ main/Components:\ main\ contrib\ non-free\ non-free-firmware/' /etc/apt/sources.list.d/debian.sources && \
    apt-get update

RUN apt-get install -y lib32gcc-s1 wine curl crudini wget xvfb tzdata && \
    apt-get clean -y && \
    apt-get autoremove -y

RUN useradd -u 1000 -m abc

VOLUME ["/astroneer", "/astroneer/Astro/Saved"]

COPY start.sh /start.sh
RUN chmod +x /start.sh
COPY user.sh /home/abc/user.sh
RUN chmod +x /home/abc/user.sh
CMD ["/start.sh"]
