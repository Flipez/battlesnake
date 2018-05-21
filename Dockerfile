FROM crystallang/crystal
WORKDIR /app
ADD . /app
RUN shards install
CMD crystal run ./src/battlesnake.cr
