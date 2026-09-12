{ lib, pkgs, ... }:

let
  mkmfLibs = with pkgs; [
    libyaml
    openssl
    zlib
  ];

  withDirs = p: [
    "--with-${p.pname}-include=${lib.getDev p}/include"
    "--with-${p.pname}-lib=${lib.getLib p}/lib"
  ];

  rubyDeps = mkmfLibs ++ [ pkgs.gmp ];

  rubyPrefix = pkgs.symlinkJoin {
    name = "ruby-build-deps";
    paths = map lib.getDev rubyDeps ++ map lib.getLib rubyDeps;
  };
in
{
  environment.variables.RUBY_CONFIGURE_OPTS = lib.concatStringsSep " " (
    lib.concatMap withDirs mkmfLibs ++ [ "--with-gmp-dir=${rubyPrefix}" ]
  );
}
