FROM ghcr.io/divkix/docker-python-base:latest AS build

# Install external packages in base image
FROM build as deb-extractor
RUN cd /tmp \
    && apt-get update \
    && apt-get download $(apt-cache depends --recurse --no-recommends --no-suggests \
    --no-conflicts --no-breaks --no-replaces --no-enhances \
    --no-pre-depends "packages-needed-like-wget" | grep "^\w") \
    && mkdir /dpkg \
    && for deb in *.deb; do dpkg --extract $deb /dpkg || exit 10; done

# Build virtualenv as separate step: Only re-execute this step when pyproject.toml or poetry.lock changes
FROM build AS build-venv
COPY pyproject.toml poetry.lock /
RUN /venv/bin/poetry export -f requirements.txt --without-hashes --output requirements.txt
RUN /venv/bin/pip install --disable-pip-version-check -r /requirements.txt

# Copy the virtualenv into a distroless image
FROM gcr.io/distroless/python3-debian11
WORKDIR /app
COPY --from=deb-extractor /dpkg /
COPY --from=build-venv /venv /venv
COPY . .
ENTRYPOINT ["/venv/bin/python3"]
CMD ["anyfile.py"]
