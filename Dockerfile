FROM dart:latest
WORKDIR /app
COPY . .
RUN dart pub get
CMD ["dart", "bin/main.dart"]