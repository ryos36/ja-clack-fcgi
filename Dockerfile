FROM sinby/ja-sbcl:0.5
MAINTAINER Ryos Suzuki<ryos@sinby.com>

ENV HOME=/root
ARG PORT=5000
ARG FILE=/root/clack/ql-clack-$PORT.lisp

WORKDIR /root

RUN mkdir /root/clack
ADD mk-ql-clack.sh /tmp/mk-ql-clack.sh
RUN sh /tmp/mk-ql-clack.sh $PORT $FILE

RUN /usr/local/bin/sbcl --non-interactive --eval "(ql:quickload :clack)" --eval "(ql:quickload :cl-fastcgi)"
RUN /usr/local/bin/sbcl --load $FILE

