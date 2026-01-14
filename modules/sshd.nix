{
  config,
  lib,
  pkgs,
  ...
}: let
  gitHubID = "appsforartists";
  sshPort = 2022;
  sshdDir = "${config.home.homeDirectory}/.config/sshd";
  sshDir = "${config.home.homeDirectory}/.ssh";

  preStartScript = pkgs.writeShellScript "sshd-pre-start" ''
    set -e
    mkdir -p "${sshdDir}"
    mkdir -p "${sshDir}"

    # Download keys only if authorized_keys is missing
    if [ ! -f "${sshDir}/authorized_keys" ]; then
      # -f fails on HTTP errors, -S shows errors
      ${pkgs.curl}/bin/curl -fSsL -o "${sshDir}/authorized_keys" "https://github.com/${gitHubID}.keys"
      chmod 600 "${sshDir}/authorized_keys"
    fi

    # Generate config if missing
    if [ ! -f "${sshdDir}/sshd_config" ]; then
      cat > "${sshdDir}/sshd_config" <<CONF
      HostKey ${sshdDir}/ssh_host_ecdsa_key
      HostKey ${sshdDir}/ssh_host_ed25519_key
      HostKey ${sshdDir}/ssh_host_rsa_key
      Port ${toString sshPort}
      UsePAM no
      KbdInteractiveAuthentication no
      PasswordAuthentication no
      PubkeyAuthentication yes
      X11Forwarding yes
      AuthorizedKeysFile ${sshDir}/authorized_keys
      Subsystem sftp ${pkgs.openssh}/libexec/sftp-server
    CONF
    fi

    # Generate host keys if missing
    for type in ecdsa ed25519 rsa; do
      key_file="${sshdDir}/ssh_host_''${type}_key"
      if [ ! -f "$key_file" ]; then
        ${pkgs.openssh}/bin/ssh-keygen -q -N "" -t $type -f "$key_file"
      fi
    done
  '';
in {
  home.packages = with pkgs; [
    rmate
  ];

  systemd.user.services.sshd-user = {
    Unit = {
      Description = "SSH Daemon";
      After = ["network.target"];
    };

    Service = {
      ExecStart = "${pkgs.openssh}/bin/sshd -D -f ${sshdDir}/sshd_config -o \"PidFile=%t/sshd.pid\"";
      ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
      ExecStartPre = "${preStartScript}";
      KillMode = "process";
      Restart = "on-failure";
      RestartSec = "5s";
    };

    Install = {
      WantedBy = ["default.target"];
    };
  };
}
