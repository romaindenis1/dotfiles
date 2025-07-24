{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  packages = [
    pkgs.rustc
    pkgs.cargo
    pkgs.gcc11    
    pkgs.gnumake
    pkgs.pkg-config
  ];

  shellHook = ''
    export CC=cc
  '';
}

#Why is it like this
#im missing something idk
