FROM xxh/zsh-portable-musl-alpine
VOLUME /result
ENV ZSH_VER 5.8
WORKDIR /zsh/zsh-$ZSH_VER/run
RUN sed -i 's/\/lib\/ld-musl/.\/\/\/\/ld-musl/' zsh
CMD tar -zcf /result/zsh-portable-musl-alpine-portable-`uname`-`uname -m`.tar.gz * && ls -sh1 /result
