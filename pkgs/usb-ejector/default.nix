{ writeScriptBin, symlinkJoin, coreutils, util-linuxMinimal, makeWrapper, ... }:
let
  runtimeInputs = [ coreutils util-linuxMinimal ];
  name = "usb-ejector";
  scriptName = "${name}.sh";
  script = (writeScriptBin scriptName (
    builtins.readFile (./. + "/${scriptName}")
  )).overrideAttrs(orig: {
    buildCommand = ''
      ${orig.buildCommand}
      patchShebangs $out
    '';
  });
in
{
  name = name;
  supportedSystems = [ "x86_64-linux" ];
  derivation = symlinkJoin {
    name = name;
    version = "0.0.1";
    paths = [ script ] ++ runtimeInputs;
    buildInputs = [ makeWrapper ];
    postBuild = "wrapProgram $out/bin/${scriptName} --prefix PATH : $out/bin";
  };
}
