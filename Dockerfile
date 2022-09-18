FROM fuzzers/afl:2.52

RUN apt-get update
RUN apt install -y build-essential wget git clang cmake  automake autotools-dev  libtool zlib1g zlib1g-dev libexif-dev libjpeg-dev libpng-dev bison
RUN git clone https://github.com/Genivia/RE-flex.git
WORKDIR /RE-flex
RUN CC=afl-gcc CXX=afl-g++ ./configure --enable-examples=yes
RUN make
RUN make install
RUN mkdir /txtCorpus
RUN cp /RE-flex/*.txt /txtCorpus
RUN cp /RE-flex/examples/*.txt /txtCorpus

ENTRYPOINT ["afl-fuzz", "-i", "/txtCorpus", "-o", "/cvt2utfOut"]
CMD  ["/RE-flex/examples/cvt2utf", "-t", "UTF-16", "@@"]
