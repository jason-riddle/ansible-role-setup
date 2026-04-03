{ pkgs, ... }:

let
  pythonPackages = with pkgs.python313Packages; [
    ansible

    molecule
    molecule-plugins

    # ansible-lint
    # docker
    # molecule
    # yamllint
    # Note: molecule-plugins may need to be installed via pip if not available in nixpkgs
  ];
in
{
  # ============================================================================
  # ENVIRONMENT CONFIGURATION
  # ============================================================================

  # https://devenv.sh/integrations/dotenv/
  dotenv = {
    enable = true;
    filename = [
      ".env"
      ".env.local"
    ];
  };

  # ============================================================================
  # LANGUAGE & RUNTIME
  # ============================================================================

  # https://devenv.sh/languages/

  # languages.ansible = {
  #   enable = false;
  #   package = pkgs.ansible;
  # };

  languages.python = {
    enable = true;
    # package = pkgs.python313;
    venv.enable = true;
  };

  # ============================================================================
  # PACKAGES & TOOLS
  # ============================================================================

  # https://devenv.sh/packages/
  # https://search.nixos.org/packages

  packages = [
    pkgs.docker

    pkgs.pre-commit
  ]
  ++ pythonPackages;

  # ============================================================================
  # SCRIPTS
  # ============================================================================

  # https://devenv.sh/scripts/

  # enterShell = ''
  #   pip3 install ansible molecule molecule-plugins[docker] docker ansible-lint yamllint
  # '';

  # enterShell = ''
  #   pip3 install molecule molecule-plugins[docker]
  # '';

  # ============================================================================
  # GIT HOOKS CONFIGURATION
  # ============================================================================

  # https://devenv.sh/git-hooks/

  git-hooks.hooks = {
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
    nixfmt-rfc-style = {
      enable = true;
    };

    # ==========================================================================
    # SECURITY VALIDATION
    # ==========================================================================

    # Fast regex-based secret detection
    ripsecrets = {
      enable = true;
      excludes = [ "^\\.env$" ];
    };

    # SOPS encryption enforcement
    pre-commit-hook-ensure-sops = {
      enable = true;
    };

    # Comprehensive secrets scanner (slower but thorough)
    # trufflehog = {
    #   enable = true;
    #   pass_filenames = false;
    #   stages = [
    #     "pre-commit"
    #     "manual"
    #   ];
    # };

    # AWS credentials detection
    detect-aws-credentials = {
      enable = true;
      args = [ "--allow-missing-credentials" ];
    };

    # Private key detection
    detect-private-keys = {
      enable = true;
    };

  };
}
