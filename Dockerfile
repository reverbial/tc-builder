FROM debian:buster

ENV MARIADB_VER=10.4.12
ENV BOOST_VER=72

ENV LOCATION=/opt/trinitycore
ENV SRCLOCATION=/usr/local/src/TrinityCore

VOLUME ["/usr/local/src/TrinityCore"]
VOLUME ["/opt/trinitycore"]

# Install pre-requisites
RUN apt update && apt -y install git clang cmake make gcc g++ libssl-dev libbz2-dev libreadline-dev libncurses-dev p7zip-full zlib1g-dev wget \
               && rm -rf /var/lib/apt/lists/* \
               && update-alternatives --install /usr/bin/cc cc /usr/bin/clang 100 \
               && update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang 100

# Download and compile required boost libraries. Debian's native boost libs wont statically compile into TC for some reason. 
RUN cd / && wget https://dl.bintray.com/boostorg/release/1.${BOOST_VER}.0/source/boost_1_${BOOST_VER}_0.tar.gz \
     && tar -xzvf boost_1_${BOOST_VER}_0.tar.gz  \
     && cd boost_1_${BOOST_VER}_0 \
     && ./bootstrap.sh \
     && ./b2 --with-filesystem --with-system --with-thread  --with-program_options --with-iostreams --with-regex -j $(nproc)

# Download and compile MariaDB C Libs with SSL disabled as it wont statically link otherwise.
RUN  cd /tmp \
     && wget https://downloads.mariadb.org/interstitial/mariadb-${MARIADB_VER}/source/mariadb-${MARIADB_VER}.tar.gz \
     && tar -xzvf mariadb-${MARIADB_VER}.tar.gz && rm mariadb-${MARIADB_VER}.tar.gz \
     && cd /tmp/mariadb-${MARIADB_VER}/libmariadb \
     && cmake . -D WITH_SSL="OFF" \
     && make -j $(nproc) && make install

RUN cd /tmp/mariadb-${MARIADB_VER} \
     && cmake . -D WITH_SSL="OFF" -D WITHOUT_SERVER=ON  \
     && make -j $(nproc) && make install \
     && cd .. && rm -f -r mariadb-${MARIADB_VER}


# MariaDB libs need to have version header renamed so Trinity can find it.
RUN  cp /usr/local/include/mariadb/mariadb_version.h /usr/local/include/mariadb/mysql_version.h


COPY run.sh /usr/bin/run.sh
RUN chmod +x /usr/bin/run.sh
CMD /usr/bin/run.sh

