%PAKCS3.10 swi9 VARIABLESHARING

:-noSingletonWarnings.
:-noRedefineWarnings.
:-noDiscontiguousWarnings.

:-importModule('Data.List').
:-importModule('Prelude').
:-importModule('System.Directory').
:-importModule('System.Environment').
:-importModule('System.FilePath').

:-curryModule('System.Path').


%%%%%%%%%%%% function types %%%%%%%%%%%%%%%%%%%
:-multifile functiontype/6.
:-dynamic functiontype/6.
functiontype('System.Path.dirsInPath',dirsInPath,0,'System.Path.dirsInPath',nofix,notype).
functiontype('System.Path.dirsInPath._\'23lambda2','System.Path.dirsInPath._#lambda2',1,'System.Path.dirsInPath._\'23lambda2',nofix,notype).
functiontype('System.Path.fileInPath',fileInPath,1,'System.Path.fileInPath',nofix,notype).
functiontype('System.Path.fileInPath._\'23lambda5','System.Path.fileInPath._#lambda5',2,'System.Path.fileInPath._\'23lambda5',nofix,notype).
functiontype('System.Path.getFileInPath',getFileInPath,1,'System.Path.getFileInPath',nofix,notype).
functiontype('System.Path.getFileInPath.checkPath.8','System.Path.getFileInPath.checkPath.8',2,'System.Path.getFileInPath.checkPath.8',nofix,notype).
functiontype('System.Path.getFileInPath.checkPath.8._\'23lambda8','System.Path.getFileInPath.checkPath.8._#lambda8',4,'System.Path.getFileInPath.checkPath.8._\'23lambda8',nofix,notype).

%%%%%%%%%%%% constructor types %%%%%%%%%%%%%%%%%%%
:-multifile constructortype/7.
:-dynamic constructortype/7.

%%%%%%%%%%%% function definitions %%%%%%%%%%%%%%%%%%%
'System.Path.dirsInPath'(_21887522,_21887524,_21887526):-freeze(_21887524,'blocked_System.Path.dirsInPath'(_21887522,_21887524,_21887526)).
'blocked_System.Path.dirsInPath'(_21888646,_21888652,_21888658):-hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','System.Environment.getEnv'(['^P','^A','^T','^H'])),partcall(1,'System.Path.dirsInPath._\'23lambda2',[])),_21888646,_21888652,_21888658).

'System.Path.dirsInPath._\'23lambda2'(_21892538,_21892540,_21892542,_21892544):-freeze(_21892542,'blocked_System.Path.dirsInPath._\'23lambda2'(_21892538,_21892540,_21892542,_21892544)).
'blocked_System.Path.dirsInPath._\'23lambda2'(_21892624,_21893486,_21893492,_21893498):-makeShare(_21892652,_21893612),hnf('Prelude.cond'(letrec4PAKCS(_21893612,_21892624),'Prelude.$'('Prelude._impl\'23return\'23Prelude.Monad\'23Prelude.IO\'23','Data.List.split'(partcall(1,'Prelude.flip',['System.FilePath.searchPathSeparator',partcall(2,'Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Char\'23',[])]),_21893612))),_21893486,_21893492,_21893498).

'System.Path.fileInPath'(_21897560,_21897562,_21897564,_21897566):-freeze(_21897564,'blocked_System.Path.fileInPath'(_21897560,_21897562,_21897564,_21897566)).
'blocked_System.Path.fileInPath'(_21897646,_21898082,_21898088,_21898094):-hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','System.Path.dirsInPath'),partcall(1,'System.Path.fileInPath._\'23lambda5',[_21897646])),_21898082,_21898088,_21898094).

'System.Path.fileInPath._\'23lambda5'(_21901212,_21901214,_21901216,_21901218,_21901220):-freeze(_21901218,'blocked_System.Path.fileInPath._\'23lambda5'(_21901212,_21901214,_21901216,_21901218,_21901220)).
'blocked_System.Path.fileInPath._\'23lambda5'(_21901308,_21901326,_21902762,_21902768,_21902774):-makeShare(_21901354,_21902946),hnf('Prelude.cond'(letrec4PAKCS(_21902946,_21901326),'Prelude.apply'('Prelude.apply'('Prelude.<$>'(partcall(1,'Prelude._inst\'23Prelude.Functor\'23Prelude.IO\'23',[])),'Prelude.or'),'Prelude.apply'('Prelude.mapM'(partcall(1,'Prelude._inst\'23Prelude.Monad\'23Prelude.IO\'23',[]),'Prelude..'(partcall(1,'System.Directory.doesFileExist',[]),partcall(1,'Prelude.flip',[_21901308,'System.FilePath.\'3C\'2F\'3E']))),_21902946))),_21902762,_21902768,_21902774).

'System.Path.getFileInPath'(_21908270,_21908272,_21908274,_21908276):-freeze(_21908274,'blocked_System.Path.getFileInPath'(_21908270,_21908272,_21908274,_21908276)).
'blocked_System.Path.getFileInPath'(_21908356,_21908792,_21908798,_21908804):-hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','System.Path.dirsInPath'),partcall(1,'System.Path.getFileInPath.checkPath.8',[_21908356])),_21908792,_21908798,_21908804).

'System.Path.getFileInPath.checkPath.8'(_21912120,_21912122,_21912124,_21912126,_21912128):-freeze(_21912126,'blocked_System.Path.getFileInPath.checkPath.8'(_21912120,_21912122,_21912124,_21912126,_21912128)).
'blocked_System.Path.getFileInPath.checkPath.8'(_21912216,_21912234,_21914272,_21914278,_21914284):-hnf(_21912234,_21915990,_21914278,_21916008),'blocked_System.Path.getFileInPath.checkPath.8_2'(_21915990,_21912216,_21914272,_21916008,_21914284).

'blocked_System.Path.getFileInPath.checkPath.8_2'(_21916480,_21916482,_21916484,_21916486,_21916488):-freeze(_21916486,'blocked_blocked_System.Path.getFileInPath.checkPath.8_2'(_21916480,_21916482,_21916484,_21916486,_21916488)).
'blocked_blocked_System.Path.getFileInPath.checkPath.8_2'([],_21912216,_21916732,_21916738,_21916744):-hnf('Prelude.apply'('Prelude._impl\'23return\'23Prelude.Monad\'23Prelude.IO\'23','Prelude.Nothing'),_21916732,_21916738,_21916744).
'blocked_blocked_System.Path.getFileInPath.checkPath.8_2'([_21912618|_21912636],_21912216,_21918178,_21918184,_21918190):-!,makeShare(_21912676,_21918456),makeShare(_21912216,_21918476),hnf('Prelude.cond'(letrec4PAKCS(_21918456,'Prelude.apply'('Prelude.apply'('System.FilePath.\'3C\'2F\'3E',_21912618),_21918476)),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','System.Directory.doesFileExist'(_21918456)),partcall(1,'System.Path.getFileInPath.checkPath.8._\'23lambda8',[_21912636,_21918476,_21918456]))),_21918178,_21918184,_21918190).
'blocked_blocked_System.Path.getFileInPath.checkPath.8_2'('FAIL'(_21922614),_21912216,'FAIL'(_21922614),_21922628,_21922628):-nonvar(_21922614).

'System.Path.getFileInPath.checkPath.8._\'23lambda8'(_21924634,_21924636,_21924638,_21924640,_21924642,_21924644,_21924646):-freeze(_21924644,'blocked_System.Path.getFileInPath.checkPath.8._\'23lambda8'(_21924634,_21924636,_21924638,_21924640,_21924642,_21924644,_21924646)).
'blocked_System.Path.getFileInPath.checkPath.8._\'23lambda8'(_21924750,_21924768,_21924786,_21924804,_21926148,_21926154,_21926160):-hnf(_21924804,_21928314,_21926154,_21928344),'blocked_System.Path.getFileInPath.checkPath.8._\'23lambda8_4'(_21928314,_21924750,_21924768,_21924786,_21926148,_21928344,_21926160).

'blocked_System.Path.getFileInPath.checkPath.8._\'23lambda8_4'(_21928910,_21928912,_21928914,_21928916,_21928918,_21928920,_21928922):-freeze(_21928920,freeze(_21928910,'blocked_blocked_System.Path.getFileInPath.checkPath.8._\'23lambda8_4'(_21928910,_21928912,_21928914,_21928916,_21928918,_21928920,_21928922))).
'blocked_blocked_System.Path.getFileInPath.checkPath.8._\'23lambda8_4'('Prelude.True',_21924750,_21924768,_21924786,_21929324,_21929330,_21929336):-hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','System.Directory.getAbsolutePath'(_21924750)),'Prelude..'('Prelude._impl\'23return\'23Prelude.Monad\'23Prelude.IO\'23','Prelude.Just')),_21929324,_21929330,_21929336).
'blocked_blocked_System.Path.getFileInPath.checkPath.8._\'23lambda8_4'('Prelude.False',_21924750,_21924768,_21924786,_21932332,_21932338,_21932344):-!,hnf('System.Path.getFileInPath.checkPath.8'(_21924768,_21924786),_21932332,_21932338,_21932344).
'blocked_blocked_System.Path.getFileInPath.checkPath.8._\'23lambda8_4'('FAIL'(_21933532),_21924750,_21924768,_21924786,'FAIL'(_21933532),_21933546,_21933546).

:-costCenters(['']).




%%%%% Number of shared variables: 4

