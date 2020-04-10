#!/bin/bash
set -e

#Build TrinityCore
cd /usr/local/src/TrinityCore && git pull && cd /tmp &&  mkdir build && cd build \
   && cmake /usr/local/src/TrinityCore/ \
      -DBOOST_ROOT=/boost_1_${BOOST_VER}_0 \
      -DBOOST_LIBRARYDIR=/boost_1_${BOOST_VER}_0/stage/lib \
      -DCMAKE_INSTALL_PREFIX=${LOCATION} \
      -DBoost_USE_STATIC_LIBS="ON" \
      -DOPENSSL_SSL_LIBRARIES="/usr/lib/x86_64-linux-gnu/libssl.a" \
      -DOPENSSL_CRYPTO_LIBRARIES="/usr/lib/x86_64-linux-gnu/libcrypto.a" \
      -DZLIB_LIBRARY_RELEASE="/usr/lib/x86_64-linux-gnu/libz.so" \
      -DZLIB_INCLUDE_DIR="/usr/include/" \
      -DMYSQL_LIBRARY="/usr/local/lib/mariadb/libmariadbclient.a" \
      -DMYSQL_EXTRA_LIBRARIES="/usr/lib/x86_64-linux-gnu/libz.a" \
      -DMYSQL_INCLUDE_DIR="/usr/local/include/mariadb/" \
      -DREADLINE_LIBRARY="/usr/lib/x86_64-linux-gnu/libreadline.a" \
      -DZLIB_LIBRARY_RELEASE="/usr/lib/x86_64-linux-gnu/libz.a" \
      -DBZIP2_LIBRARY_RELEASE="/usr/lib/x86_64-linux-gnu/libbz2.a" \
      -DMYSQL_EXECUTABLE=${LOCATION}/bin/mysql \
   && make -j $(nproc) && make install

# Copy MariaDB Client Execurable
cp /usr/local/mysql/bin/mysql ${LOCATION}/bin/

exec "$@"
