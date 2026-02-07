#!/bin/bash
set -euo pipefail

mkdir -p "$HOME/apps"

# Inklecate java
APP_VERSION="$(
  curl -fsSL "https://api.github.com/repos/bladecoder/blade-ink-java/releases/latest" \
    | grep -Po '"tag_name": "v\K[^"]*' \
    || true
)"
[ -n "$APP_VERSION" ] || { echo "Unable to resolve Java Inklecate version"; exit 1; }
curl -fsSL -o "$HOME/apps/inklecate-${APP_VERSION}.jar" "https://github.com/bladecoder/blade-ink-java/releases/download/v${APP_VERSION}/inklecate-${APP_VERSION}.jar"

# Create script to run inklecate java in $HOME/.local/bin
cat > "$HOME/.local/bin/inklecate" <<EOF
#!/bin/bash
java -jar $HOME/apps/inklecate-${APP_VERSION}.jar "\$@"
EOF

chmod +x "$HOME/.local/bin/inklecate"
