{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    nativeBuildInputs = [
      pkgs.jekyll
      pkgs.rubyPackages.jekyll-paginate
      pkgs.rubyPackages.jekyll-feed
    ];
}