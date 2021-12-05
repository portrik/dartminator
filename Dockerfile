FROM dart:latest
WORKDIR /app
COPY . .
RUN dart pub install
CMD ["dart", "--enable-asserts=true", "bin/main.dart"]