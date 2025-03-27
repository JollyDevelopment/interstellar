{
description = "Flutter 3.24.x";
inputs = {
  nixpkgs.url = "github:NixOS/nixpkgs/24.11";
  flake-utils.url = "github:numtide/flake-utils";
};
outputs = { self, nixpkgs, flake-utils }:
  flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
        config = {
          android_sdk.accept_license = true;
          allowUnfree = true;
        };
      };
      buildToolsVersion = "35.0.0";
      androidComposition = pkgs.androidenv.composeAndroidPackages {
        buildToolsVersions = [ buildToolsVersion "35.0.0" ];
        platformVersions = [ "35" "34" ];
        abiVersions = [ "armeabi-v7a" "arm64-v8a" ];
      };
      androidSdk = androidComposition.androidsdk;
    in
    {
      devShells.default =
        with pkgs; mkShell rec {
          ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";
          buildInputs = [
            flutter
            androidSdk # The customized SDK that we've made above
            jdk17
          ];
        };
    });
}
