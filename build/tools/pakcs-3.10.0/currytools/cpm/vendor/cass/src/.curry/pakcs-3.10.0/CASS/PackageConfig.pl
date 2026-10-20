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

%%%%%%%%%%%% constructor types %%%%%%%%%%%%%%%%%%%
:-multifile constructortype/7.
:-dynamic constructortype/7.

%%%%%%%%%%%% function definitions %%%%%%%%%%%%%%%%%%%
'CASS.PackageConfig.packageVersion'(_34479514,_34479516,_34479518):-freeze(_34479516,'blocked_CASS.PackageConfig.packageVersion'(_34479514,_34479516,_34479518)).
'blocked_CASS.PackageConfig.packageVersion'(['^3',^.,'^0',^.,'^0'],_34480378,_34480378).

'CASS.PackageConfig.packagePath'(_34483004,_34483006,_34483008):-freeze(_34483006,'blocked_CASS.PackageConfig.packagePath'(_34483004,_34483006,_34483008)).
'blocked_CASS.PackageConfig.packagePath'(_34487978,_34487984,_34487990):-hnf('Prelude.apply'('Prelude.apply'('System.FilePath.\'3C\'2F\'3E','Curry.Compiler.Distribution.installDir'),'Prelude.apply'('Prelude.apply'('System.FilePath.\'3C\'2F\'3E',['^c','^u','^r','^r','^y','^t','^o','^o','^l','^s']),'Prelude.apply'('Prelude.apply'('System.FilePath.\'3C\'2F\'3E',['^c','^p','^m']),'Prelude.apply'('Prelude.apply'('System.FilePath.\'3C\'2F\'3E',['^v','^e','^n','^d','^o','^r']),['^c','^a','^s','^s'])))),_34487978,_34487984,_34487990).

'CASS.PackageConfig.packageExecutable'(_34497658,_34497660,_34497662):-freeze(_34497660,'blocked_CASS.PackageConfig.packageExecutable'(_34497658,_34497660,_34497662)).
'blocked_CASS.PackageConfig.packageExecutable'([],_34497752,_34497752).

:-costCenters(['']).




%%%%% Number of shared variables: 0

