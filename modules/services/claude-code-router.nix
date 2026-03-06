{ config, pkgs, ... }:

let
  node = pkgs.nodejs_22;
  npmPrefix = "/home/edmondop/.local/share/npm-global";
in
{
  # Install ccr globally via npm on first activation
  system.userActivationScripts.claude-code-router = ''
    export PATH="${node}/bin:$PATH"
    export npm_config_prefix="${npmPrefix}"
    if [ ! -x "${npmPrefix}/bin/ccr" ]; then
      ${node}/bin/npm install -g @musistudio/claude-code-router 2>/dev/null || true
    fi
  '';

  # Ensure npm-global/bin is in PATH for all users
  environment.variables.NPM_CONFIG_PREFIX = npmPrefix;
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "ccr" ''
      export PATH="${node}/bin:${npmPrefix}/bin:$PATH"
      export NODE_PATH="${npmPrefix}/lib/node_modules"
      exec "${npmPrefix}/bin/ccr" "$@"
    '')
  ];

  # Systemd user service
  systemd.user.services.claude-code-router = {
    description = "Claude Code Router - LLM proxy for Claude Code";
    wantedBy = [ "default.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    serviceConfig = {
      Type = "simple";
      ExecStart = "${npmPrefix}/bin/ccr start --foreground";
      Restart = "on-failure";
      RestartSec = 5;
      TimeoutStopSec = 10;
      Environment = [
        "PATH=${node}/bin:${npmPrefix}/bin"
        "NODE_PATH=${npmPrefix}/lib/node_modules"
      ];
      EnvironmentFile = "-%h/.secrets/ccr.env";
    };
  };
}
