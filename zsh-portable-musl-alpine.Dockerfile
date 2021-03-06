FROM alpine
VOLUME /result

ENV ZSH_VER 5.8

RUN mkdir -p /zsh /result

WORKDIR /zsh
RUN apk update && apk add wget mc make alpine-sdk ncurses-dev git python
RUN wget https://downloads.sourceforge.net/project/zsh/zsh/$ZSH_VER/zsh-$ZSH_VER.tar.xz 
RUN tar xf zsh-$ZSH_VER.tar.xz 

#
# Build portable zsh (https://www.zsh.org/mla/workers/2019/msg00866.html)
#
WORKDIR zsh-$ZSH_VER
RUN ./configure --disable-dynamic --prefix=$PWD/run --bindir=$PWD/run --enable-etcdir=./run/etc --enable-scriptdir=./run/scripts --enable-fndir=./run/functions --enable-function-subdirs --disable-site-fndir --with-tcsetpgrp
ADD config.modules ./config.modules-new
RUN cp config.modules-new config.modules
RUN make && make install
WORKDIR run
RUN cp /lib/ld-musl-x86_64.so.1 ./libc.musl-x86_64.so.1 && cp /usr/lib/libncursesw.so.6 ./
ADD zsh.sh .
RUN chmod +x zsh.sh && rm zsh-*
CMD tar -zcf /result/zsh-portable-musl-alpine-`uname`-`uname -m`.tar.gz * && ls -sh1 /result
