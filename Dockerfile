FROM crystallang/crystal
WORKDIR /app
ADD . /app
RUN shards install
RUN crystal build ./src/battlesnake.cr
RUN chmod +x ./battlesnake
CMD ./battlesnake
