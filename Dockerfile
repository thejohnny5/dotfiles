FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive



# Install Git (since it's needed to clone the dotfiles repo)
RUN apt update && apt install -y git


# Switch to the new user
WORKDIR /home/dev

COPY bootstrap.sh bootstrap.sh
COPY . .
RUN chmod +x bootstrap.sh

ENTRYPOINT [ "/bin/bash" ]