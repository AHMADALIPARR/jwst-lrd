% Make sure to edit pakcsversion.pl.in, not pakcsversion.pl,
% since the latter is auto-generated!

:- module(pakcsversion,
          [compilerVersion/1, compilerMajorVersion/1, compilerMinorVersion/1,
           compilerRevisionVersion/1, buildVersion/1, buildDate/1, buildDir/1,
           pkgInstallDir/1, baseVersion/1]).

compilerVersion('PAKCS3.10').

compilerMajorVersion(3).

compilerMinorVersion(10).

compilerRevisionVersion(0).

buildVersion(3).

buildDate('2026-10-08').

buildDir('/home/hatch/workspace/jwst-lrd/build/tools/pakcs-3.10.0').

pkgInstallDir('').

baseVersion('3.4.0').
