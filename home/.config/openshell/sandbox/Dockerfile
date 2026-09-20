ARG BASE=ghcr.io/nvidia/openshell-community/sandboxes/base:latest
ARG NIXPKGS=github:nixos/nixpkgs/nixpkgs-unstable

FROM nixos/nix:latest AS tools
ARG NIXPKGS
RUN NIXPKGS_ALLOW_UNFREE=1 nix --extra-experimental-features 'nix-command flakes' \
  profile install --impure --profile /out \
  ${NIXPKGS}#ripgrep \
  ${NIXPKGS}#fd \
  ${NIXPKGS}#gh \
  ${NIXPKGS}#herdr \
  ${NIXPKGS}#mise \
  ${NIXPKGS}#claude-code \
  ${NIXPKGS}#codex
# Copy only the profile's closure.
RUN mkdir /closure \
  && nix --extra-experimental-features nix-command path-info -r /out \
  | xargs -I{} cp -a --parents {} /closure

FROM ${BASE}
COPY --from=tools /closure/nix /nix
COPY --from=tools /out/bin/ /usr/local/bin/

COPY --chown=sandbox:sandbox home/ /sandbox/

RUN git config --file /sandbox/.config/git/config --remove-section url.ssh://git@github.com/ \
  && git config --file /sandbox/.config/git/config --add url.https://github.com/.insteadOf git@github.com: \
  && git config --file /sandbox/.config/git/config --add url.https://github.com/.insteadOf ssh://git@github.com/ \
  && git config --file /sandbox/.config/git/config credential.https://github.com.helper '!gh auth git-credential' \
  && git config --file /sandbox/.config/git/config core.pager cat \
  && git config --file /sandbox/.config/git/config core.editor vi \
  && git config --file /sandbox/.config/git/config interactive.diffFilter cat

COPY --chown=sandbox:sandbox home/.config/openshell/.bashrc /tmp/mise.bashrc
RUN cat /tmp/mise.bashrc >> /sandbox/.bashrc && rm /tmp/mise.bashrc
