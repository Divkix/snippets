###############################################
# Base Image
###############################################
FROM python:3.10-slim as python-base

# Set env variables for base image
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100 \
    POETRY_HOME="/opt/poetry" \
    POETRY_VIRTUALENVS_IN_PROJECT=true \
    POETRY_NO_INTERACTION=1 \
    PYSETUP_PATH="/opt/pysetup" \
    VENV_PATH="/opt/pysetup/.venv"

# prepend poetry and venv to path
ENV PATH="$POETRY_HOME/bin:$VENV_PATH/bin:$PATH"

###############################################
# Builder Image
###############################################
FROM python-base as builder-base
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    curl \
    build-essential

# install poetry - respects $POETRY_VERSION & $POETRY_HOME
RUN curl -sSL https://install.python-poetry.org | python3 -

# copy project requirement files here to ensure they will be cached.
WORKDIR $PYSETUP_PATH
COPY poetry.lock pyproject.toml ./

# setup ffmpeg
COPY ffmpeg-setup.sh ffmpeg-setup.sh
RUN ./ffmpeg-setup.sh

# install runtime deps - uses $POETRY_VIRTUALENVS_IN_PROJECT internally
RUN poetry install --no-dev

###############################################
# Production Image
###############################################
FROM python-base as production

# Set a new user
RUN groupadd -g 999 python && \
    useradd -r -u 999 -g python python

# give permissions to user
RUN mkdir /usr/app && chown python:python /usr/app
WORKDIR /usr/app

# copy project requirement files here to ensure they will be cached.
COPY --chown=python:python --from=builder-base $PYSETUP_PATH $PYSETUP_PATH
COPY --chown=python:python . .
COPY --from=ffmpeg-build /static-ffmpeg/* /usr/local/bin/

# switch to user
USER 999

CMD [ "python", "app.py" ]
