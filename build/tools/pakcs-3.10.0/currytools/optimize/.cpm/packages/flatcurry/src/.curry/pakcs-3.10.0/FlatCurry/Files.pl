%PAKCS3.10 swi9 VARIABLESHARING

:-noSingletonWarnings.
:-noRedefineWarnings.
:-noDiscontiguousWarnings.

:-importModule('Control.Monad').
:-importModule('FlatCurry.Types').
:-importModule('Prelude').
:-importModule('ReadShowTerm').
:-importModule('System.CurryPath').
:-importModule('System.Directory').
:-importModule('System.FilePath').
:-importModule('System.FrontendExec').

:-curryModule('FlatCurry.Files').


%%%%%%%%%%%% function types %%%%%%%%%%%%%%%%%%%
:-multifile functiontype/6.
:-dynamic functiontype/6.
functiontype('FlatCurry.Files.readFlatCurry',readFlatCurry,1,'FlatCurry.Files.readFlatCurry',nofix,notype).
functiontype('FlatCurry.Files.readFlatCurryWithParseOptions',readFlatCurryWithParseOptions,2,'FlatCurry.Files.readFlatCurryWithParseOptions',nofix,notype).
functiontype('FlatCurry.Files.readFlatCurryWithParseOptions._\'23lambda2','FlatCurry.Files.readFlatCurryWithParseOptions._#lambda2',3,'FlatCurry.Files.readFlatCurryWithParseOptions._\'23lambda2',nofix,notype).
functiontype('FlatCurry.Files.readFlatCurryWithParseOptions._\'23lambda2._\'23lambda7','FlatCurry.Files.readFlatCurryWithParseOptions._#lambda2._#lambda7',2,'FlatCurry.Files.readFlatCurryWithParseOptions._\'23lambda2._\'23lambda7',nofix,notype).
functiontype('FlatCurry.Files.readFlatCurryWithParseOptions._\'23lambda2._\'23lambda7._\'23lambda9','FlatCurry.Files.readFlatCurryWithParseOptions._#lambda2._#lambda7._#lambda9',1,'FlatCurry.Files.readFlatCurryWithParseOptions._\'23lambda2._\'23lambda7._\'23lambda9',nofix,notype).
functiontype('FlatCurry.Files.flatCurryFileName',flatCurryFileName,1,'FlatCurry.Files.flatCurryFileName',nofix,notype).
functiontype('FlatCurry.Files.flatCurryIntName',flatCurryIntName,1,'FlatCurry.Files.flatCurryIntName',nofix,notype).
functiontype('FlatCurry.Files.readFlatCurryFile',readFlatCurryFile,1,'FlatCurry.Files.readFlatCurryFile',nofix,notype).
functiontype('FlatCurry.Files.readFlatCurryFile.readExistingFCY.20','FlatCurry.Files.readFlatCurryFile.readExistingFCY.20',2,'FlatCurry.Files.readFlatCurryFile.readExistingFCY.20',nofix,notype).
functiontype('FlatCurry.Files.readFlatCurryFile.readExistingFCY.20._\'23lambda12','FlatCurry.Files.readFlatCurryFile.readExistingFCY.20._#lambda12',2,'FlatCurry.Files.readFlatCurryFile.readExistingFCY.20._\'23lambda12',nofix,notype).
functiontype('FlatCurry.Files.readFlatCurryFile._\'23lambda15','FlatCurry.Files.readFlatCurryFile._#lambda15',2,'FlatCurry.Files.readFlatCurryFile._\'23lambda15',nofix,notype).
functiontype('FlatCurry.Files.readFlatCurryFile._\'23lambda15._\'23lambda18','FlatCurry.Files.readFlatCurryFile._#lambda15._#lambda18',3,'FlatCurry.Files.readFlatCurryFile._\'23lambda15._\'23lambda18',nofix,notype).
functiontype('FlatCurry.Files.readFlatCurryInt',readFlatCurryInt,1,'FlatCurry.Files.readFlatCurryInt',nofix,notype).
functiontype('FlatCurry.Files.readFlatCurryIntWithParseOptions',readFlatCurryIntWithParseOptions,2,'FlatCurry.Files.readFlatCurryIntWithParseOptions',nofix,notype).
functiontype('FlatCurry.Files.readFlatCurryIntWithParseOptions._\'23lambda21','FlatCurry.Files.readFlatCurryIntWithParseOptions._#lambda21',3,'FlatCurry.Files.readFlatCurryIntWithParseOptions._\'23lambda21',nofix,notype).
functiontype('FlatCurry.Files.readFlatCurryIntWithParseOptions._\'23lambda21._\'23lambda26','FlatCurry.Files.readFlatCurryIntWithParseOptions._#lambda21._#lambda26',2,'FlatCurry.Files.readFlatCurryIntWithParseOptions._\'23lambda21._\'23lambda26',nofix,notype).
functiontype('FlatCurry.Files.readFlatCurryIntWithParseOptions._\'23lambda21._\'23lambda26._\'23lambda28','FlatCurry.Files.readFlatCurryIntWithParseOptions._#lambda21._#lambda26._#lambda28',1,'FlatCurry.Files.readFlatCurryIntWithParseOptions._\'23lambda21._\'23lambda26._\'23lambda28',nofix,notype).
functiontype('FlatCurry.Files.writeFlatCurry',writeFlatCurry,1,'FlatCurry.Files.writeFlatCurry',nofix,notype).
functiontype('FlatCurry.Files.writeFlatCurry._\'23lambda31','FlatCurry.Files.writeFlatCurry._#lambda31',3,'FlatCurry.Files.writeFlatCurry._\'23lambda31',nofix,notype).
functiontype('FlatCurry.Files.writeFlatCurryFile',writeFlatCurryFile,2,'FlatCurry.Files.writeFlatCurryFile',nofix,notype).
functiontype('FlatCurry.Files.writeFCY',writeFCY,0,'FlatCurry.Files.writeFCY',nofix,notype).
functiontype('FlatCurry.Files.lookupFlatCurryFileInLoadPath',lookupFlatCurryFileInLoadPath,1,'FlatCurry.Files.lookupFlatCurryFileInLoadPath',nofix,notype).
functiontype('FlatCurry.Files.getFlatCurryFileInLoadPath',getFlatCurryFileInLoadPath,1,'FlatCurry.Files.getFlatCurryFileInLoadPath',nofix,notype).

%%%%%%%%%%%% constructor types %%%%%%%%%%%%%%%%%%%
:-multifile constructortype/7.
:-dynamic constructortype/7.

%%%%%%%%%%%% function definitions %%%%%%%%%%%%%%%%%%%
'FlatCurry.Files.readFlatCurry'(_31072740,_31072742,_31072744,_31072746):-freeze(_31072744,'blocked_FlatCurry.Files.readFlatCurry'(_31072740,_31072742,_31072744,_31072746)).
'blocked_FlatCurry.Files.readFlatCurry'(_31072826,_31073178,_31073184,_31073190):-hnf('FlatCurry.Files.readFlatCurryWithParseOptions'(_31072826,'System.FrontendExec.setQuiet'('Prelude.True','System.FrontendExec.defaultParams')),_31073178,_31073184,_31073190).

'FlatCurry.Files.readFlatCurryWithParseOptions'(_31076570,_31076572,_31076574,_31076576,_31076578):-freeze(_31076576,'blocked_FlatCurry.Files.readFlatCurryWithParseOptions'(_31076570,_31076572,_31076574,_31076576,_31076578)).
'blocked_FlatCurry.Files.readFlatCurryWithParseOptions'(_31076666,_31076684,_31084582,_31084588,_31084594):-makeShare(_31076666,_31084922),hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'23Prelude.Monad\'23Prelude.IO\'23','Prelude.$'(partcall(1,'Control.Monad.unless',['Prelude.apply'('System.CurryPath.isValidModuleName',_31084922),partcall(1,'Prelude._inst\'23Prelude.Applicative\'23Prelude.IO\'23',[])]),'Prelude.$'(partcall(1,'Prelude.putStrLn',[]),'Prelude.++'(['^W','^A','^R','^N','^I','^N','^G',^:,'^ ','^\''],'Prelude.++'(_31084922,['^\'','^ ','^i','^s','^ ','^n','^o','^t','^ ','^a','^ ','^v','^a','^l','^i','^d','^ ','^m','^o','^d','^u','^l','^e','^ ','^n','^a','^m','^e','^!']))))),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','System.CurryPath.lookupModuleSourceInLoadPath'(_31084922)),partcall(1,'FlatCurry.Files.readFlatCurryWithParseOptions._\'23lambda2',[_31084922,_31076684]))),_31084582,_31084588,_31084594).

'FlatCurry.Files.readFlatCurryWithParseOptions._\'23lambda2'(_31100842,_31100844,_31100846,_31100848,_31100850,_31100852):-freeze(_31100850,'blocked_FlatCurry.Files.readFlatCurryWithParseOptions._\'23lambda2'(_31100842,_31100844,_31100846,_31100848,_31100850,_31100852)).
'blocked_FlatCurry.Files.readFlatCurryWithParseOptions._\'23lambda2'(_31100948,_31100966,_31100984,_31105140,_31105146,_31105152):-hnf(_31100984,_31107586,_31105146,_31107610),'blocked_FlatCurry.Files.readFlatCurryWithParseOptions._\'23lambda2_3'(_31107586,_31100948,_31100966,_31105140,_31107610,_31105152).

'blocked_FlatCurry.Files.readFlatCurryWithParseOptions._\'23lambda2_3'(_31108216,_31108218,_31108220,_31108222,_31108224,_31108226):-freeze(_31108224,freeze(_31108216,'blocked_blocked_FlatCurry.Files.readFlatCurryWithParseOptions._\'23lambda2_3'(_31108216,_31108218,_31108220,_31108222,_31108224,_31108226))).
'blocked_blocked_FlatCurry.Files.readFlatCurryWithParseOptions._\'23lambda2_3'('Prelude.Nothing',_31100948,_31100966,_31108656,_31108662,_31108668):-makeShare(_31100966,_31108766),hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','System.CurryPath.getLoadPathForModule'(_31108766)),partcall(1,'FlatCurry.Files.readFlatCurryWithParseOptions._\'23lambda2._\'23lambda7',[_31108766])),_31108656,_31108662,_31108668).
'blocked_blocked_FlatCurry.Files.readFlatCurryWithParseOptions._\'23lambda2_3'('Prelude.Just'(_31101676),_31100948,_31100966,_31112186,_31112192,_31112198):-!,hnf(_31101676,_31115382,_31112192,_31115406),'blocked_blocked_FlatCurry.Files.readFlatCurryWithParseOptions._\'23lambda2_3_Prelude.Just_1'(_31115382,_31100948,_31100966,_31112186,_31115406,_31112198).

'blocked_blocked_FlatCurry.Files.readFlatCurryWithParseOptions._\'23lambda2_3_Prelude.Just_1'(_31116168,_31116170,_31116172,_31116174,_31116176,_31116178):-freeze(_31116176,freeze(_31116168,'blocked_blocked_blocked_FlatCurry.Files.readFlatCurryWithParseOptions._\'23lambda2_3_Prelude.Just_1'(_31116168,_31116170,_31116172,_31116174,_31116176,_31116178))).
'blocked_blocked_blocked_FlatCurry.Files.readFlatCurryWithParseOptions._\'23lambda2_3_Prelude.Just_1'('Prelude.(,)'(_31101798,_31101816),_31100948,_31100966,_31116564,_31116570,_31116576):-!,makeShare(_31100948,_31116900),makeShare(_31100966,_31116920),makeShare(_31102410,_31116940),hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'23Prelude.Monad\'23Prelude.IO\'23','System.FrontendExec.callFrontendWithParams'('System.FrontendExec.FCY',_31116900,_31116920)),'Prelude.cond'(letrec4PAKCS(_31116940,'Prelude.apply'('Prelude.apply'('System.FilePath.\'3C\'2F\'3E',_31101798),'Prelude.apply'('Prelude.apply'('System.FilePath.\'3C\'2F\'3E','System.FrontendExec.outdir'(_31116900)),'Prelude.apply'('Prelude.apply'('System.FilePath.\'3C.\'3E','Prelude.apply'('System.CurryPath.modNameToPath','Prelude.apply'('System.FilePath.takeFileName',_31116920))),['^f','^c','^y'])))),'FlatCurry.Files.readFlatCurryFile'(_31116940))),_31116564,_31116570,_31116576).
'blocked_blocked_blocked_FlatCurry.Files.readFlatCurryWithParseOptions._\'23lambda2_3_Prelude.Just_1'('FAIL'(_31124950),_31100948,_31100966,'FAIL'(_31124950),_31124964,_31124964).
'blocked_blocked_FlatCurry.Files.readFlatCurryWithParseOptions._\'23lambda2_3'('FAIL'(_31125032),_31100948,_31100966,'FAIL'(_31125032),_31125046,_31125046).

'FlatCurry.Files.readFlatCurryWithParseOptions._\'23lambda2._\'23lambda7'(_31127768,_31127770,_31127772,_31127774,_31127776):-freeze(_31127774,'blocked_FlatCurry.Files.readFlatCurryWithParseOptions._\'23lambda2._\'23lambda7'(_31127768,_31127770,_31127772,_31127774,_31127776)).
'blocked_FlatCurry.Files.readFlatCurryWithParseOptions._\'23lambda2._\'23lambda7'(_31127864,_31127882,_31129234,_31129240,_31129246):-makeShare(_31127910,_31129416),hnf('Prelude.cond'(letrec4PAKCS(_31129416,_31127882),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','System.Directory.getFileWithSuffix'('FlatCurry.Files.flatCurryFileName'('Prelude.apply'('System.FilePath.takeFileName',_31127864)),[[]],_31129416)),partcall(1,'FlatCurry.Files.readFlatCurryWithParseOptions._\'23lambda2._\'23lambda7._\'23lambda9',[]))),_31129234,_31129240,_31129246).

'FlatCurry.Files.readFlatCurryWithParseOptions._\'23lambda2._\'23lambda7._\'23lambda9'(_31136860,_31136862,_31136864,_31136866):-freeze(_31136864,'blocked_FlatCurry.Files.readFlatCurryWithParseOptions._\'23lambda2._\'23lambda7._\'23lambda9'(_31136860,_31136862,_31136864,_31136866)).
'blocked_FlatCurry.Files.readFlatCurryWithParseOptions._\'23lambda2._\'23lambda7._\'23lambda9'(_31136946,_31137388,_31137394,_31137400):-makeShare(_31136974,_31137504),hnf('Prelude.cond'(letrec4PAKCS(_31137504,_31136946),'FlatCurry.Files.readFlatCurryFile'(_31137504)),_31137388,_31137394,_31137400).

'FlatCurry.Files.flatCurryFileName'(_31140686,_31140688,_31140690,_31140692):-freeze(_31140690,'blocked_FlatCurry.Files.flatCurryFileName'(_31140686,_31140688,_31140690,_31140692)).
'blocked_FlatCurry.Files.flatCurryFileName'(_31140772,_31141754,_31141760,_31141766):-hnf('Prelude.apply'('Prelude.apply'('System.FilePath.\'3C.\'3E','System.CurryPath.inCurrySubdir'('System.CurryPath.stripCurrySuffix'(_31140772))),['^f','^c','^y']),_31141754,_31141760,_31141766).

'FlatCurry.Files.flatCurryIntName'(_31145462,_31145464,_31145466,_31145468):-freeze(_31145466,'blocked_FlatCurry.Files.flatCurryIntName'(_31145462,_31145464,_31145466,_31145468)).
'blocked_FlatCurry.Files.flatCurryIntName'(_31145548,_31146684,_31146690,_31146696):-hnf('Prelude.apply'('Prelude.apply'('System.FilePath.\'3C.\'3E','System.CurryPath.inCurrySubdir'('System.CurryPath.stripCurrySuffix'(_31145548))),['^f','^i','^n','^t']),_31146684,_31146690,_31146696).

'FlatCurry.Files.readFlatCurryFile'(_31150626,_31150628,_31150630,_31150632):-freeze(_31150630,'blocked_FlatCurry.Files.readFlatCurryFile'(_31150626,_31150628,_31150630,_31150632)).
'blocked_FlatCurry.Files.readFlatCurryFile'(_31150712,_31151218,_31151224,_31151230):-makeShare(_31150712,_31151312),hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','System.Directory.doesFileExist'(_31151312)),partcall(1,'FlatCurry.Files.readFlatCurryFile._\'23lambda15',[_31151312])),_31151218,_31151224,_31151230).

'FlatCurry.Files.readFlatCurryFile.readExistingFCY.20'(_31155598,_31155600,_31155602,_31155604,_31155606):-freeze(_31155604,'blocked_FlatCurry.Files.readFlatCurryFile.readExistingFCY.20'(_31155598,_31155600,_31155602,_31155604,_31155606)).
'blocked_FlatCurry.Files.readFlatCurryFile.readExistingFCY.20'(_31155694,_31155712,_31156218,_31156224,_31156230):-hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','Prelude.readFile'(_31155712)),partcall(1,'FlatCurry.Files.readFlatCurryFile.readExistingFCY.20._\'23lambda12',[_31155694])),_31156218,_31156224,_31156230).

'FlatCurry.Files.readFlatCurryFile.readExistingFCY.20._\'23lambda12'(_31161036,_31161038,_31161040,_31161042,_31161044):-freeze(_31161042,'blocked_FlatCurry.Files.readFlatCurryFile.readExistingFCY.20._\'23lambda12'(_31161036,_31161038,_31161040,_31161042,_31161044)).
'blocked_FlatCurry.Files.readFlatCurryFile.readExistingFCY.20._\'23lambda12'(_31161132,_31161150,_31165638,_31165644,_31165650):-makeShare(_31161178,_31165902),hnf('Prelude.cond'(letrec4PAKCS(_31165902,_31161150),'Prelude.apply'('Prelude._impl\'23return\'23Prelude.Monad\'23Prelude.IO\'23','ReadShowTerm.readUnqualifiedTerm'(_31161132,[['^F','^l','^a','^t','^C','^u','^r','^r','^y',^.,'^T','^y','^p','^e','^s'],['^P','^r','^e','^l','^u','^d','^e']],_31165902))),_31165638,_31165644,_31165650).

'FlatCurry.Files.readFlatCurryFile._\'23lambda15'(_31175076,_31175078,_31175080,_31175082,_31175084):-freeze(_31175082,'blocked_FlatCurry.Files.readFlatCurryFile._\'23lambda15'(_31175076,_31175078,_31175080,_31175082,_31175084)).
'blocked_FlatCurry.Files.readFlatCurryFile._\'23lambda15'(_31175172,_31175190,_31176912,_31176918,_31176924):-hnf(_31175190,_31178954,_31176918,_31178972),'blocked_FlatCurry.Files.readFlatCurryFile._\'23lambda15_2'(_31178954,_31175172,_31176912,_31178972,_31176924).

'blocked_FlatCurry.Files.readFlatCurryFile._\'23lambda15_2'(_31179504,_31179506,_31179508,_31179510,_31179512):-freeze(_31179510,freeze(_31179504,'blocked_blocked_FlatCurry.Files.readFlatCurryFile._\'23lambda15_2'(_31179504,_31179506,_31179508,_31179510,_31179512))).
'blocked_blocked_FlatCurry.Files.readFlatCurryFile._\'23lambda15_2'('Prelude.True',_31175172,_31179898,_31179904,_31179910):-hnf('FlatCurry.Files.readFlatCurryFile.readExistingFCY.20'(partcall(1,'FlatCurry.Types._inst\'23Prelude.Data\'23FlatCurry.Types.Prog\'23',[]),_31175172),_31179898,_31179904,_31179910).
'blocked_blocked_FlatCurry.Files.readFlatCurryFile._\'23lambda15_2'('Prelude.False',_31175172,_31181694,_31181700,_31181706):-!,makeShare(_31175570,_31181868),makeShare(_31175172,_31181888),hnf('Prelude.cond'(letrec4PAKCS(_31181868,'System.CurryPath.inCurrySubdir'(_31181888)),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','System.Directory.doesFileExist'(_31181868)),partcall(1,'FlatCurry.Files.readFlatCurryFile._\'23lambda15._\'23lambda18',[_31181868,_31181888]))),_31181694,_31181700,_31181706).
'blocked_blocked_FlatCurry.Files.readFlatCurryFile._\'23lambda15_2'('FAIL'(_31185496),_31175172,'FAIL'(_31185496),_31185510,_31185510).

'FlatCurry.Files.readFlatCurryFile._\'23lambda15._\'23lambda18'(_31187844,_31187846,_31187848,_31187850,_31187852,_31187854):-freeze(_31187852,'blocked_FlatCurry.Files.readFlatCurryFile._\'23lambda15._\'23lambda18'(_31187844,_31187846,_31187848,_31187850,_31187852,_31187854)).
'blocked_FlatCurry.Files.readFlatCurryFile._\'23lambda15._\'23lambda18'(_31187950,_31187968,_31187986,_31196774,_31196780,_31196786):-hnf(_31187986,_31199292,_31196780,_31199316),'blocked_FlatCurry.Files.readFlatCurryFile._\'23lambda15._\'23lambda18_3'(_31199292,_31187950,_31187968,_31196774,_31199316,_31196786).

'blocked_FlatCurry.Files.readFlatCurryFile._\'23lambda15._\'23lambda18_3'(_31199934,_31199936,_31199938,_31199940,_31199942,_31199944):-freeze(_31199942,freeze(_31199934,'blocked_blocked_FlatCurry.Files.readFlatCurryFile._\'23lambda15._\'23lambda18_3'(_31199934,_31199936,_31199938,_31199940,_31199942,_31199944))).
'blocked_blocked_FlatCurry.Files.readFlatCurryFile._\'23lambda15._\'23lambda18_3'('Prelude.True',_31187950,_31187968,_31200338,_31200344,_31200350):-hnf('FlatCurry.Files.readFlatCurryFile.readExistingFCY.20'(partcall(1,'FlatCurry.Types._inst\'23Prelude.Data\'23FlatCurry.Types.Prog\'23',[]),_31187968),_31200338,_31200344,_31200350).
'blocked_blocked_FlatCurry.Files.readFlatCurryFile._\'23lambda15._\'23lambda18_3'('Prelude.False',_31187950,_31187968,_31202286,_31202292,_31202298):-!,hnf('Prelude.error'('Prelude.++'(['^E','^X','^I','^S','^T','^E','^N','^C','^E','^ ','^E','^R','^R','^O','^R',^:,'^ ','^F','^l','^a','^t','^C','^u','^r','^r','^y','^ ','^f','^i','^l','^e','^ ','^\''],'Prelude.++'(_31187950,['^\'','^ ','^d','^o','^e','^s','^ ','^n','^o','^t','^ ','^e','^x','^i','^s','^t']))),_31202286,_31202292,_31202298).
'blocked_blocked_FlatCurry.Files.readFlatCurryFile._\'23lambda15._\'23lambda18_3'('FAIL'(_31213798),_31187950,_31187968,'FAIL'(_31213798),_31213812,_31213812).

'FlatCurry.Files.readFlatCurryInt'(_31215224,_31215226,_31215228,_31215230):-freeze(_31215228,'blocked_FlatCurry.Files.readFlatCurryInt'(_31215224,_31215226,_31215228,_31215230)).
'blocked_FlatCurry.Files.readFlatCurryInt'(_31215310,_31215662,_31215668,_31215674):-hnf('FlatCurry.Files.readFlatCurryIntWithParseOptions'(_31215310,'System.FrontendExec.setQuiet'('Prelude.True','System.FrontendExec.defaultParams')),_31215662,_31215668,_31215674).

'FlatCurry.Files.readFlatCurryIntWithParseOptions'(_31219204,_31219206,_31219208,_31219210,_31219212):-freeze(_31219210,'blocked_FlatCurry.Files.readFlatCurryIntWithParseOptions'(_31219204,_31219206,_31219208,_31219210,_31219212)).
'blocked_FlatCurry.Files.readFlatCurryIntWithParseOptions'(_31219300,_31219318,_31227216,_31227222,_31227228):-makeShare(_31219300,_31227556),hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'23Prelude.Monad\'23Prelude.IO\'23','Prelude.$'(partcall(1,'Control.Monad.unless',['Prelude.apply'('System.CurryPath.isValidModuleName',_31227556),partcall(1,'Prelude._inst\'23Prelude.Applicative\'23Prelude.IO\'23',[])]),'Prelude.$'(partcall(1,'Prelude.putStrLn',[]),'Prelude.++'(['^W','^A','^R','^N','^I','^N','^G',^:,'^ ','^\''],'Prelude.++'(_31227556,['^\'','^ ','^i','^s','^ ','^n','^o','^t','^ ','^a','^ ','^v','^a','^l','^i','^d','^ ','^m','^o','^d','^u','^l','^e','^ ','^n','^a','^m','^e','^!']))))),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','System.CurryPath.lookupModuleSourceInLoadPath'(_31227556)),partcall(1,'FlatCurry.Files.readFlatCurryIntWithParseOptions._\'23lambda21',[_31227556,_31219318]))),_31227216,_31227222,_31227228).

'FlatCurry.Files.readFlatCurryIntWithParseOptions._\'23lambda21'(_31243670,_31243672,_31243674,_31243676,_31243678,_31243680):-freeze(_31243678,'blocked_FlatCurry.Files.readFlatCurryIntWithParseOptions._\'23lambda21'(_31243670,_31243672,_31243674,_31243676,_31243678,_31243680)).
'blocked_FlatCurry.Files.readFlatCurryIntWithParseOptions._\'23lambda21'(_31243776,_31243794,_31243812,_31248146,_31248152,_31248158):-hnf(_31243812,_31250736,_31248152,_31250760),'blocked_FlatCurry.Files.readFlatCurryIntWithParseOptions._\'23lambda21_3'(_31250736,_31243776,_31243794,_31248146,_31250760,_31248158).

'blocked_FlatCurry.Files.readFlatCurryIntWithParseOptions._\'23lambda21_3'(_31251390,_31251392,_31251394,_31251396,_31251398,_31251400):-freeze(_31251398,freeze(_31251390,'blocked_blocked_FlatCurry.Files.readFlatCurryIntWithParseOptions._\'23lambda21_3'(_31251390,_31251392,_31251394,_31251396,_31251398,_31251400))).
'blocked_blocked_FlatCurry.Files.readFlatCurryIntWithParseOptions._\'23lambda21_3'('Prelude.Nothing',_31243776,_31243794,_31251830,_31251836,_31251842):-makeShare(_31243794,_31251940),hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','System.CurryPath.getLoadPathForModule'(_31251940)),partcall(1,'FlatCurry.Files.readFlatCurryIntWithParseOptions._\'23lambda21._\'23lambda26',[_31251940])),_31251830,_31251836,_31251842).
'blocked_blocked_FlatCurry.Files.readFlatCurryIntWithParseOptions._\'23lambda21_3'('Prelude.Just'(_31244504),_31243776,_31243794,_31255438,_31255444,_31255450):-!,hnf(_31244504,_31258778,_31255444,_31258802),'blocked_blocked_FlatCurry.Files.readFlatCurryIntWithParseOptions._\'23lambda21_3_Prelude.Just_1'(_31258778,_31243776,_31243794,_31255438,_31258802,_31255450).

'blocked_blocked_FlatCurry.Files.readFlatCurryIntWithParseOptions._\'23lambda21_3_Prelude.Just_1'(_31259588,_31259590,_31259592,_31259594,_31259596,_31259598):-freeze(_31259596,freeze(_31259588,'blocked_blocked_blocked_FlatCurry.Files.readFlatCurryIntWithParseOptions._\'23lambda21_3_Prelude.Just_1'(_31259588,_31259590,_31259592,_31259594,_31259596,_31259598))).
'blocked_blocked_blocked_FlatCurry.Files.readFlatCurryIntWithParseOptions._\'23lambda21_3_Prelude.Just_1'('Prelude.(,)'(_31244626,_31244644),_31243776,_31243794,_31259984,_31259990,_31259996):-!,makeShare(_31243776,_31260324),makeShare(_31243794,_31260344),makeShare(_31245238,_31260364),hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'23Prelude.Monad\'23Prelude.IO\'23','System.FrontendExec.callFrontendWithParams'('System.FrontendExec.FINT',_31260324,_31260344)),'Prelude.cond'(letrec4PAKCS(_31260364,'Prelude.apply'('Prelude.apply'('System.FilePath.\'3C\'2F\'3E',_31244626),'Prelude.apply'('Prelude.apply'('System.FilePath.\'3C\'2F\'3E','System.FrontendExec.outdir'(_31260324)),'Prelude.apply'('Prelude.apply'('System.FilePath.\'3C.\'3E','Prelude.apply'('System.CurryPath.modNameToPath','Prelude.apply'('System.FilePath.takeFileName',_31260344))),['^f','^i','^n','^t'])))),'FlatCurry.Files.readFlatCurryFile'(_31260364))),_31259984,_31259990,_31259996).
'blocked_blocked_blocked_FlatCurry.Files.readFlatCurryIntWithParseOptions._\'23lambda21_3_Prelude.Just_1'('FAIL'(_31268602),_31243776,_31243794,'FAIL'(_31268602),_31268616,_31268616).
'blocked_blocked_FlatCurry.Files.readFlatCurryIntWithParseOptions._\'23lambda21_3'('FAIL'(_31268684),_31243776,_31243794,'FAIL'(_31268684),_31268698,_31268698).

'FlatCurry.Files.readFlatCurryIntWithParseOptions._\'23lambda21._\'23lambda26'(_31271610,_31271612,_31271614,_31271616,_31271618):-freeze(_31271616,'blocked_FlatCurry.Files.readFlatCurryIntWithParseOptions._\'23lambda21._\'23lambda26'(_31271610,_31271612,_31271614,_31271616,_31271618)).
'blocked_FlatCurry.Files.readFlatCurryIntWithParseOptions._\'23lambda21._\'23lambda26'(_31271706,_31271724,_31273076,_31273082,_31273088):-makeShare(_31271752,_31273258),hnf('Prelude.cond'(letrec4PAKCS(_31273258,_31271724),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','System.Directory.getFileWithSuffix'('FlatCurry.Files.flatCurryIntName'('Prelude.apply'('System.FilePath.takeFileName',_31271706)),[[]],_31273258)),partcall(1,'FlatCurry.Files.readFlatCurryIntWithParseOptions._\'23lambda21._\'23lambda26._\'23lambda28',[]))),_31273076,_31273082,_31273088).

'FlatCurry.Files.readFlatCurryIntWithParseOptions._\'23lambda21._\'23lambda26._\'23lambda28'(_31280990,_31280992,_31280994,_31280996):-freeze(_31280994,'blocked_FlatCurry.Files.readFlatCurryIntWithParseOptions._\'23lambda21._\'23lambda26._\'23lambda28'(_31280990,_31280992,_31280994,_31280996)).
'blocked_FlatCurry.Files.readFlatCurryIntWithParseOptions._\'23lambda21._\'23lambda26._\'23lambda28'(_31281076,_31281518,_31281524,_31281530):-makeShare(_31281104,_31281634),hnf('Prelude.cond'(letrec4PAKCS(_31281634,_31281076),'FlatCurry.Files.readFlatCurryFile'(_31281634)),_31281518,_31281524,_31281530).

'FlatCurry.Files.writeFlatCurry'(_31284738,_31284740,_31284742,_31284744):-freeze(_31284742,'blocked_FlatCurry.Files.writeFlatCurry'(_31284738,_31284740,_31284742,_31284744)).
'blocked_FlatCurry.Files.writeFlatCurry'(_31284824,_31286358,_31286364,_31286370):-makeShare(_31284824,_31285626),hnf(_31285626,_31287816,_31286364,_31287834),'blocked_FlatCurry.Files.writeFlatCurry_1'(_31287816,_31287816,_31286358,_31287834,_31286370).

'blocked_FlatCurry.Files.writeFlatCurry_1'(_31288276,_31288278,_31288280,_31288282,_31288284):-freeze(_31288282,'blocked_blocked_FlatCurry.Files.writeFlatCurry_1'(_31288276,_31288278,_31288280,_31288282,_31288284)).
'blocked_blocked_FlatCurry.Files.writeFlatCurry_1'('FlatCurry.Types.Prog'(_31284940,_31284958,_31284976,_31284994,_31285012),_31285626,_31288802,_31288808,_31288814):-!,makeShare(_31284940,_31288930),hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','System.CurryPath.lookupModuleSourceInLoadPath'(_31288930)),partcall(1,'FlatCurry.Files.writeFlatCurry._\'23lambda31',[_31288930,_31285626])),_31288802,_31288808,_31288814).
'blocked_blocked_FlatCurry.Files.writeFlatCurry_1'('FAIL'(_31291656),_31285626,'FAIL'(_31291656),_31291670,_31291670):-nonvar(_31291656).

'FlatCurry.Files.writeFlatCurry._\'23lambda31'(_31293448,_31293450,_31293452,_31293454,_31293456,_31293458):-freeze(_31293456,'blocked_FlatCurry.Files.writeFlatCurry._\'23lambda31'(_31293448,_31293450,_31293452,_31293454,_31293456,_31293458)).
'blocked_FlatCurry.Files.writeFlatCurry._\'23lambda31'(_31293554,_31293572,_31293590,_31301856,_31301862,_31301868):-hnf(_31293590,_31303798,_31301862,_31303822),'blocked_FlatCurry.Files.writeFlatCurry._\'23lambda31_3'(_31303798,_31293554,_31293572,_31301856,_31303822,_31301868).

'blocked_FlatCurry.Files.writeFlatCurry._\'23lambda31_3'(_31304344,_31304346,_31304348,_31304350,_31304352,_31304354):-freeze(_31304352,freeze(_31304344,'blocked_blocked_FlatCurry.Files.writeFlatCurry._\'23lambda31_3'(_31304344,_31304346,_31304348,_31304350,_31304352,_31304354))).
'blocked_blocked_FlatCurry.Files.writeFlatCurry._\'23lambda31_3'('Prelude.Nothing',_31293554,_31293572,_31304784,_31304790,_31304796):-hnf('Prelude.$'(partcall(1,'Prelude.error',[]),'Prelude.++'(['^C','^u','^r','^r','^y','^ ','^s','^o','^u','^r','^c','^e','^ ','^f','^i','^l','^e','^ ','^f','^o','^r','^ ','^m','^o','^d','^u','^l','^e','^ ','^\''],'Prelude.++'(_31293572,['^\'','^ ','^n','^o','^t','^ ','^f','^o','^u','^n','^d','^!']))),_31304784,_31304790,_31304796).
'blocked_blocked_FlatCurry.Files.writeFlatCurry._\'23lambda31_3'('Prelude.Just'(_31300764),_31293554,_31293572,_31315678,_31315684,_31315690):-!,hnf(_31300764,_31318370,_31315684,_31318394),'blocked_blocked_FlatCurry.Files.writeFlatCurry._\'23lambda31_3_Prelude.Just_1'(_31318370,_31293554,_31293572,_31315678,_31318394,_31315690).

'blocked_blocked_FlatCurry.Files.writeFlatCurry._\'23lambda31_3_Prelude.Just_1'(_31319072,_31319074,_31319076,_31319078,_31319080,_31319082):-freeze(_31319080,freeze(_31319072,'blocked_blocked_blocked_FlatCurry.Files.writeFlatCurry._\'23lambda31_3_Prelude.Just_1'(_31319072,_31319074,_31319076,_31319078,_31319080,_31319082))).
'blocked_blocked_blocked_FlatCurry.Files.writeFlatCurry._\'23lambda31_3_Prelude.Just_1'('Prelude.(,)'(_31300886,_31300904),_31293554,_31293572,_31319468,_31319474,_31319480):-!,hnf('FlatCurry.Files.writeFlatCurryFile'('FlatCurry.Files.flatCurryFileName'('Prelude.apply'('Prelude.apply'('System.FilePath.\'3C\'2F\'3E',_31300886),_31293572)),_31293554),_31319468,_31319474,_31319480).
'blocked_blocked_blocked_FlatCurry.Files.writeFlatCurry._\'23lambda31_3_Prelude.Just_1'('FAIL'(_31321868),_31293554,_31293572,'FAIL'(_31321868),_31321882,_31321882).
'blocked_blocked_FlatCurry.Files.writeFlatCurry._\'23lambda31_3'('FAIL'(_31321950),_31293554,_31293572,'FAIL'(_31321950),_31321964,_31321964).

'FlatCurry.Files.writeFlatCurryFile'(_31323452,_31323454,_31323456,_31323458,_31323460):-freeze(_31323458,'blocked_FlatCurry.Files.writeFlatCurryFile'(_31323452,_31323454,_31323456,_31323458,_31323460)).
'blocked_FlatCurry.Files.writeFlatCurryFile'(_31323548,_31323566,_31323904,_31323910,_31323916):-hnf('Prelude.writeFile'(_31323548,'ReadShowTerm.showTerm'(partcall(1,'FlatCurry.Types._inst\'23Prelude.Data\'23FlatCurry.Types.Prog\'23',[]),_31323566)),_31323904,_31323910,_31323916).

'FlatCurry.Files.writeFCY'(_31326494,_31326496,_31326498):-freeze(_31326496,'blocked_FlatCurry.Files.writeFCY'(_31326494,_31326496,_31326498)).
'blocked_FlatCurry.Files.writeFCY'(_31326582,_31326588,_31326594):-hnf(partcall(2,'FlatCurry.Files.writeFlatCurryFile',[]),_31326582,_31326588,_31326594).

'FlatCurry.Files.lookupFlatCurryFileInLoadPath'(_31328950,_31328952,_31328954,_31328956):-freeze(_31328954,'blocked_FlatCurry.Files.lookupFlatCurryFileInLoadPath'(_31328950,_31328952,_31328954,_31328956)).
'blocked_FlatCurry.Files.lookupFlatCurryFileInLoadPath'(_31329036,_31329878,_31329884,_31329890):-makeShare(_31329036,_31329980),hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','System.CurryPath.getLoadPathForModule'(_31329980)),partcall(1,'System.Directory.findFileWithSuffix',[[[]],'FlatCurry.Files.flatCurryFileName'(_31329980)])),_31329878,_31329884,_31329890).

'FlatCurry.Files.getFlatCurryFileInLoadPath'(_31334556,_31334558,_31334560,_31334562):-freeze(_31334560,'blocked_FlatCurry.Files.getFlatCurryFileInLoadPath'(_31334556,_31334558,_31334560,_31334562)).
'blocked_FlatCurry.Files.getFlatCurryFileInLoadPath'(_31334642,_31335484,_31335490,_31335496):-makeShare(_31334642,_31335586),hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','System.CurryPath.getLoadPathForModule'(_31335586)),partcall(1,'System.Directory.getFileWithSuffix',[[[]],'FlatCurry.Files.flatCurryFileName'(_31335586)])),_31335484,_31335490,_31335496).

:-costCenters(['']).




%%%%% Number of shared variables: 21

