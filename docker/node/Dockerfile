FROM node:22.15.0-alpine AS base
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable
WORKDIR /app
USER node

FROM base AS build
USER root
COPY --chown=node:node . /app
RUN chown -R node:node /app
USER node
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install --frozen-lockfile
RUN pnpm run -r build
