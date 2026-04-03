{ pkgs, ... }:

{
  languages.python = {
    enable = true;
    venv.enable = true;
  };

  packages = [
    pkgs.docker
  ];

  enterShell = ''
    pip3 install ansible molecule molecule-plugins[docker] docker ansible-lint yamllint
  '';

  pre-commit.hooks = {
    check-yaml = {
      enable = true;
    };
    check-json = {
      enable = true;
    };
    check-merge-conflicts = {
      enable = true;
    };
    check-case-conflicts = {
      enable = true;
    };
    check-executables-have-shebangs = {
      enable = true;
    };
    check-shebang-scripts-are-executable = {
      enable = true;
    };
    check-symlinks = {
      enable = true;
    };
    check-added-large-files = {
      enable = true;
      args = [ "--maxkb=1024" ];
    };
    end-of-file-fixer = {
      enable = true;
    };
    fix-byte-order-marker = {
      enable = true;
    };
    mixed-line-endings = {
      enable = true;
    };
    trim-trailing-whitespace = {
      enable = true;
    };
    yamllint = {
      enable = true;
    };
    shellcheck = {
      enable = false;
    };
  };
}
