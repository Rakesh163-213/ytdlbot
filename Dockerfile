FROM python:3.12-alpine AS pybuilder
ADD pyproject.toml pdm.lock requirements.txt /build/
WORKDIR /build
RUN apk add --no-cache alpine-sdk python3-dev musl-dev linux-headers
RUN pip install pdm
RUN pdm install
RUN pdm run pip install --no-cache-dir -r requirements.txt  # Install in the same virtualenv

FROM python:3.12-alpine AS runner
WORKDIR /app

RUN apk update && apk add --no-cache ffmpeg aria2
COPY --from=pybuilder /build/.venv/lib/ /usr/local/lib/
COPY src /app
WORKDIR /app
EXPOSE 8000
CMD gunicorn app:app & python3 main.py
