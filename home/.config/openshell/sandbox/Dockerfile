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

USER root
RUN npx -y -p @playwright/cli@latest playwright install-deps \
  && rm -rf /var/lib/apt/lists/* /root/.npm
USER sandbox

COPY --chown=sandbox:sandbox home/ /sandbox/

RUN git config --file /sandbox/.config/git/config --remove-section url.ssh://git@github.com/ \
  && git config --file /sandbox/.config/git/config --add url.https://github.com/.insteadOf git@github.com: \
  && git config --file /sandbox/.config/git/config --add url.https://github.com/.insteadOf ssh://git@github.com/ \
  && git config --file /sandbox/.config/git/config credential.https://github.com.helper '!gh auth git-credential' \
  && git config --file /sandbox/.config/git/config core.pager cat \
  && git config --file /sandbox/.config/git/config core.editor vi \
  && git config --file /sandbox/.config/git/config interactive.diffFilter cat

# osb mounts a volume at .creds so agent logins outlive the sandbox.
RUN mkdir -p /sandbox/.creds /sandbox/.claude /sandbox/.codex \
  && ln -s ../.creds/claude-credentials.json /sandbox/.claude/.credentials.json \
  && ln -s ../.creds/codex-auth.json /sandbox/.codex/auth.json

COPY --chown=sandbox:sandbox home/.config/openshell/.bashrc /tmp/mise.bashrc
RUN cat /tmp/mise.bashrc >> /sandbox/.bashrc && rm /tmp/mise.bashrc
