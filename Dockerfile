FROM archlinux:base-devel
LABEL authors="reko"

RUN pacman -Syu --noconfirm

# Use bash for the shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Create a script file sourced by both interactive and non-interactive bash shells
ENV BASH_ENV /home/user/.bash_env
RUN touch "${BASH_ENV}"
RUN echo '. "${BASH_ENV}"' >> ~/.bashrc

# Download and install nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | PROFILE="${BASH_ENV}" bash
RUN echo node > .nvmrc
RUN nvm install 22.14.0

COPY . ./project
WORKDIR /home/user/project

RUN npm install -g corepack
RUN yarn set version stable
RUN yarn install
RUN astro dev

ENTRYPOINT ["top", "-b"]