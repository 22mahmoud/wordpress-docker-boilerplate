FROM node:22.15.0-alpine AS base
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable
USER node
WORKDIR /var/www

FROM base AS skin-theme-deps
WORKDIR /var/www/web/app/themes/skin
COPY ./web/app/themes/skin/pnpm-lock.yaml ./web/app/themes/skin/package.json ./
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install --frozen-lockfile

FROM base AS skin-theme-builder
WORKDIR /var/www/web/app/themes/skin
COPY --from=skin-theme-deps /var/www/web/app/themes/skin/node_modules ./node_modules
COPY ./web/app/themes/skin ./
RUN pnpm run build

FROM alpine:latest AS skin-theme-final
COPY --from=skin-theme-builder /var/www/web/app/themes/skin/dist /app/dist
