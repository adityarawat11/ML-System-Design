FROM python:3.11.9

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PIP_NO_CACHE_DIR=off
ENV PIP_DISABLE_PIP_VERSION_CHECK=on
ENV PIP_DEFAULT_TIMEOUT=100
ENV POETRY_VERSION=1.8.3

WORKDIR .

RUN apt-get update \
    && apt-get install git -y && apt-get install curl -y \
    && apt-get install make  \
    && apt-get install build-essential -y \
    && apt-get install gcc mono-mcs -y \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://ollama.com/install.sh | sh

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir "poetry==$POETRY_VERSION"

COPY poetry.lock pyproject.toml ./
COPY src/ src/
COPY README.md README.md


COPY .env .

RUN poetry config virtualenvs.create false \
    && poetry install --only main --no-interaction --no-ansi \
    && rm -rf ~/.cache/pypoetry/{cache,artifacts}

# RUN ollama pull llama3

EXPOSE 8000

# CMD ["uvicorn", "src.app:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]

