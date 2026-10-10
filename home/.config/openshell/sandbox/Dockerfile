ARG BASE=ghcr.io/nvidia/openshell-community/sandboxes/base:latest
ARG NIXPKGS=github:nixos/nixpkgs/nixos-unstable

FROM nixos/nix:latest AS tools
ARG NIXPKGS
RUN nix --extra-experimental-features 'nix-command flakes' \
  profile install --profile /out \
  ${NIXPKGS}#ripgrep \
  ${NIXPKGS}#fd \
  ${NIXPKGS}#jaq \
  ${NIXPKGS}#gh \
  ${NIXPKGS}#herdr \
  ${NIXPKGS}#mise \
  ${NIXPKGS}#ffmpeg-headless
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
# The base image's agents are stale and would win wherever PATH lacks
# ~/.local/bin; a second codex on PATH also makes its installer edit .profile.
RUN rm /usr/local/bin/claude && npm uninstall -g @openai/codex
USER sandbox

ADD --chown=sandbox:sandbox https://downloads.claude.ai/claude-code-releases/latest /tmp/claude-release
ADD --chown=sandbox:sandbox https://releases.openai.com/codex/channels/latest /tmp/codex-release
RUN export PATH="$HOME/.local/bin:$PATH" \
  && curl -fsSL https://claude.ai/install.sh -o /tmp/claude-install.sh \
  && curl -fsSL https://chatgpt.com/codex/install.sh -o /tmp/codex-install.sh \
  && bash /tmp/claude-install.sh \
  && CODEX_NON_INTERACTIVE=1 sh /tmp/codex-install.sh \
  && rm /tmp/claude-release /tmp/codex-release /tmp/claude-install.sh /tmp/codex-install.sh

COPY --chown=sandbox:sandbox home/ /sandbox/
COPY --chown=sandbox:sandbox home/.config/openshell/claude/settings.json /sandbox/.claude/settings.json
# Claude Code reads skills only from ~/.claude/skills, so this mirrors skillMirrors in modules/dotfiles/default.nix.
COPY --chown=sandbox:sandbox home/.agents/skills/ /sandbox/.claude/skills/

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
