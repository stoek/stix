{ pkgs ? import <nixpkgs> {} }:

  pkgs.mkShell {
    shellHook = "
    export NSNAME=HTB
    ";
    # nativeBuildInputs is usually what you want -- tools you need to run
    nativeBuildInputs = [ pkgs.testssl
     pkgs.tcpdump
];
}
