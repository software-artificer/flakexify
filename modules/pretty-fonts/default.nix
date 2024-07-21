flake:
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.flakexify.pretty-fonts;
in
{
  options = {
    flakexify = {
      pretty-fonts = {
        enable = mkEnableOption ''
          various nicely looking fonts for desktop environtments and web
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    fonts = {
      enableGhostscriptFonts = true;
      packages = with pkgs; [
        (nerdfonts.override { fonts = [ "SourceCodePro" ]; })
        comic-relief
        google-fonts
        libertine
      ];
      fontconfig = {
        allowType1 = true;
        defaultFonts = {
          serif = [ "Linux Libertine" ];
          sansSerif = [ "Arimo" ];
          monospace = [ "SauceCodePro Nerd Font" ];
        };
        localConf = ''
          <?xml version="1.0"?>
          <!DOCTYPE fontconfig SYSTEM "/usr/share/xml/fontconfig/fonts.dtd">
          <fontconfig>
            <config><rescan><int>5</int></rescan></config>
            <!-- Less common web fonts substitution -->
            <alias binding="strong">
              <family>Andale Mono</family>
              <prefer><family>Droid Sans Mono</family></prefer>
            </alias>
            <alias binding="strong">
              <family>Century Schoolbook</family>
              <prefer><family>TeX Gyre Schola</family></prefer>
            </alias>
            <alias binding="strong">
              <family>Garamond</family>
              <prefer><family>EB Garamond</family></prefer>
            </alias>
            <alias binding="strong">
              <family>Bookman</family>
              <prefer><family>TeX Gyre Bonum</family></prefer>
            </alias>
            <alias binding="strong">
              <family>Palatino</family>
              <prefer><family>Adamina</family></prefer>
            </alias>
            <alias binding="strong">
              <family>Georgia</family>
              <prefer><family>Nimbus Roman No9 L</family></prefer>
            </alias>
            <alias binding="strong">
              <family>Avant Garde</family>
              <prefer><family>TeX Gyre Adventor</family></prefer>
            </alias>
            <alias binding="strong">
              <family>Impact</family>
              <prefer><family>Oswald</family></prefer>
            </alias>
            <alias binding="strong">
              <family>Tahoma</family>
              <prefer><family>Arimo</family></prefer>
            </alias>
            <alias binding="strong">
              <family>Verdana</family>
              <prefer><family>Raleway</family></prefer>
            </alias>
            <!-- Common web fonts substitution -->
            <alias binding="strong">
              <family>Helvetica</family>
              <prefer><family>Noto Sans</family></prefer>
            </alias>
            <alias binding="strong">
              <family>Times</family>
              <prefer><family>Liberation Serif</family></prefer>
            </alias>
            <!-- Default Windows font substitutes -->
            <alias binding="strong">
              <family>Times New Roman</family>
              <prefer><family>serif</family></prefer>
            </alias>
            <alias binding="strong">
              <family>Arial Black</family>
              <prefer><family>Noto Sans Black</family></prefer>
            </alias>
            <alias binding="strong">
              <family>Segoe UI</family>
              <prefer><family>Open Sans</family></prefer>
            </alias>
            <alias binding="strong">
              <family>Arial</family>
              <prefer><family>sans-serif</family></prefer>
            </alias>
            <alias binding="strong">
              <family>Comic Sans MS</family>
              <prefer><family>cursive</family></prefer>
            </alias>
            <alias binding="strong">
              <family>Comic Sans</family>
              <prefer><family>cursive</family></prefer>
            </alias>
            <alias binding="strong">
              <family>Courier</family>
              <prefer><family>monospace</family></prefer>
            </alias>
            <alias binding="strong">
              <family>Courier New</family>
              <default><family>monospace</family></default>
            </alias>
            <!-- Set default fonts -->
            <alias binding="strong">
              <family>serif</family>
              <prefer><family>Linux Libertine</family></prefer>
            </alias>
            <alias binding="strong">
              <family>sans-serif</family>
              <prefer><family>Arimo</family></prefer>
            </alias>
            <alias binding="strong">
              <family>monospace</family>
              <prefer><family>SauceCodePro Nerd Font</family></prefer>
            </alias>
            <alias binding="strong">
              <family>cursive</family>
              <prefer><family>Comic Relief</family></prefer>
            </alias>
            <alias binding="strong">
              <family>fantasy</family>
              <prefer><family>Bellota</family></prefer>
            </alias>
            <!-- Default font (no fc-match pattern) -->
            <match>
              <edit name="family" mode="append" binding="strong"><string>Arimo</string></edit>
            </match>
            <!-- Disable font ligatures -->
            <match target="font">
              <test name="family" compare="eq" ignore-blanks="true"><string>Nimbus Mono</string></test>
              <edit name="fontfeatures" mode="append">
                <string>liga off</string>
                <string>dlig off</string>
              </edit>
            </match>
            <!-- Prefer color emoji when black and white is not explicitly requested -->
            <match>
              <test name="lang"><string>und-zsye</string></test>
              <test qual="all" name="color" compare="not_eq"><bool>true</bool></test>
              <test qual="all" name="color" compare="not_eq"><bool>false</bool></test>
              <edit name="color" mode="assign"><bool>true</bool></edit>
            </match>
            <!-- Use Noto Color Emoji and fallback onto Noto Emoji for emoji rendering -->
            <alias binding="strong">
              <family>EmojiOne Color</family>
              <prefer><family>emoji</family></prefer>
            </alias>
            <alias binding="strong">
              <family>Apple Color Emoji</family>
              <prefer><family>emoji</family></prefer>
            </alias>
            <alias binding="strong">
              <family>Segoe UI Emoji</family>
              <prefer><family>emoji</family></prefer>
            </alias>
            <alias binding="strong">
              <family>Twitter Color Emoji</family>
              <prefer><family>emoji</family></prefer>
            </alias>
            <alias binding="strong">
              <family>EmojiOne Mozilla</family>
              <prefer><family>emoji</family></prefer>
            </alias>
            <alias binding="strong">
              <family>Emoji Two</family>
              <prefer><family>emoji</family></prefer>
            </alias>
            <alias binding="strong">
              <family>Emoji One</family>
              <prefer><family>emoji</family></prefer>
            </alias>
            <alias binding="strong">
              <family>Android Emoji</family>
              <prefer><family>emoji</family></prefer>
            </alias>
            <alias binding="strong">
              <family>emoji</family>
              <prefer>
                <family>Noto Color Emoji</family>
                <family>Noto Emoji</family>
              </prefer>
            </alias>
          </fontconfig>
        '';
      };
    };
  };
}
