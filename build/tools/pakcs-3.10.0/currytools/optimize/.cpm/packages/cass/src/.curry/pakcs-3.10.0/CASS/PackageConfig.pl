%PAKCS3.10 swi9 VARIABLESHARING

:-noSingletonWarnings.
:-noRedefineWarnings.
:-noDiscontiguousWarnings.

:-importModule('Curry.Compiler.Distribution').
:-importModule('Prelude').
:-importModule('System.FilePath').

:-curryModule('CASS.PackageConfig').


%%%%%%%%%%%% function types %%%%%%%%%%%%%%%%%%%
:-multifile functiontype/6.
:-dynamic functiontype/6.
functiontype('CASS.PackageConfig.packageVersion',packageVersion,0,'CASS.PackageConfig.packageVersion',nofix,notype).
functiontype('CASS.PackageConfig.packagePath',packagePath,0,'CASS.PackageConfig.packagePath',nofix,notype).
functiontype('CASS.PackageConfig.packageExecutable',packageExecutable,0,'CASS.PackageConfig.packageExecutable',nofix,notype).
functiontype('CASS.PackageConfig.packageLoadPath',packageLoadPath,0,'CASS.PackageConfig.packageLoadPath',nofix,notype).

%%%%%%%%%%%% constructor types %%%%%%%%%%%%%%%%%%%
:-multifile constructortype/7.
:-dynamic constructortype/7.

%%%%%%%%%%%% function definitions %%%%%%%%%%%%%%%%%%%
'CASS.PackageConfig.packageVersion'(_22945906,_22945908,_22945910):-freeze(_22945908,'blocked_CASS.PackageConfig.packageVersion'(_22945906,_22945908,_22945910)).
'blocked_CASS.PackageConfig.packageVersion'(['^3',^.,'^0',^.,'^0'],_22946770,_22946770).

'CASS.PackageConfig.packagePath'(_22949396,_22949398,_22949400):-freeze(_22949398,'blocked_CASS.PackageConfig.packagePath'(_22949396,_22949398,_22949400)).
'blocked_CASS.PackageConfig.packagePath'(_22956400,_22956406,_22956412):-hnf('Prelude.apply'('Prelude.apply'('System.FilePath.\'3C\'2F\'3E','Curry.Compiler.Distribution.installDir'),'Prelude.apply'('Prelude.apply'('System.FilePath.\'3C\'2F\'3E',['^c','^u','^r','^r','^y','^t','^o','^o','^l','^s']),'Prelude.apply'('Prelude.apply'('System.FilePath.\'3C\'2F\'3E',['^o','^p','^t','^i','^m','^i','^z','^e']),'Prelude.apply'('Prelude.apply'('System.FilePath.\'3C\'2F\'3E',[^.,'^c','^p','^m']),'Prelude.apply'('Prelude.apply'('System.FilePath.\'3C\'2F\'3E',['^p','^a','^c','^k','^a','^g','^e','^s']),['^c','^a','^s','^s']))))),_22956400,_22956406,_22956412).

'CASS.PackageConfig.packageExecutable'(_22969040,_22969042,_22969044):-freeze(_22969042,'blocked_CASS.PackageConfig.packageExecutable'(_22969040,_22969042,_22969044)).
'blocked_CASS.PackageConfig.packageExecutable'([],_22969134,_22969134).

'CASS.PackageConfig.packageLoadPath'(_22970920,_22970922,_22970924):-freeze(_22970922,'blocked_CASS.PackageConfig.packageLoadPath'(_22970920,_22970922,_22970924)).
'blocked_CASS.PackageConfig.packageLoadPath'([],_22971014,_22971014).

:-costCenters(['']).




%%%%% Number of shared variables: 0

