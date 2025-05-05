FROM node:22.15.0-alpine AS node

ARG UID=1000
ARG GID=1000

# --- Install PNPM globally ---
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable

USER node

WORKDIR /var/www

CMD [""]
