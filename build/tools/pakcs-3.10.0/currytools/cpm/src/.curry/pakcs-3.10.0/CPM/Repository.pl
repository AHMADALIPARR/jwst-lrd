%PAKCS3.10 swi9 VARIABLESHARING

:-noSingletonWarnings.
:-noRedefineWarnings.
:-noDiscontiguousWarnings.

:-importModule('CPM.Config').
:-importModule('CPM.ErrorLogger').
:-importModule('CPM.FileUtil').
:-importModule('CPM.Package').
:-importModule('CPM.Resolution').
:-importModule('Control.Applicative').
:-importModule('Data.Char').
:-importModule('Data.Either').
:-importModule('Data.List').
:-importModule('Data.Time').
:-importModule('Prelude').
:-importModule('System.Directory').
:-importModule('System.FilePath').
:-importModule('System.IO').
:-importModule('System.Process').

:-curryModule('CPM.Repository').


%%%%%%%%%%%% function types %%%%%%%%%%%%%%%%%%%
:-multifile functiontype/6.
:-dynamic functiontype/6.
functiontype('CPM.Repository._inst\'23Prelude.Data\'23CPM.Repository.Repository\'23','_inst#Prelude.Data#CPM.Repository.Repository#',1,'CPM.Repository._inst\'23Prelude.Data\'23CPM.Repository.Repository\'23',nofix,notype).
functiontype('CPM.Repository._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Repository.Repository\'23','_impl#===#Prelude.Data#CPM.Repository.Repository#',2,'CPM.Repository._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Repository.Repository\'23',nofix,notype).
functiontype('CPM.Repository._impl\'23aValue\'23Prelude.Data\'23CPM.Repository.Repository\'23','_impl#aValue#Prelude.Data#CPM.Repository.Repository#',0,'CPM.Repository._impl\'23aValue\'23Prelude.Data\'23CPM.Repository.Repository\'23',nofix,notype).
functiontype('CPM.Repository.emptyRepository',emptyRepository,0,'CPM.Repository.emptyRepository',nofix,notype).
functiontype('CPM.Repository.allPackages',allPackages,1,'CPM.Repository.allPackages',nofix,notype).
functiontype('CPM.Repository.pkgsToRepository',pkgsToRepository,1,'CPM.Repository.pkgsToRepository',nofix,notype).
functiontype('CPM.Repository.findAllVersions',findAllVersions,3,'CPM.Repository.findAllVersions',nofix,notype).
functiontype('CPM.Repository.findAllVersions._\'23lambda1','CPM.Repository.findAllVersions._#lambda1',2,'CPM.Repository.findAllVersions._\'23lambda1',nofix,notype).
functiontype('CPM.Repository.findAllVersions.filterPre.8','CPM.Repository.findAllVersions.filterPre.8',2,'CPM.Repository.findAllVersions.filterPre.8',nofix,notype).
functiontype('CPM.Repository.searchPackages',searchPackages,4,'CPM.Repository.searchPackages',nofix,notype).
functiontype('CPM.Repository.searchPackages.matches.16','CPM.Repository.searchPackages.matches.16',3,'CPM.Repository.searchPackages.matches.16',nofix,notype).
functiontype('CPM.Repository.searchPackages._\'23lambda2','CPM.Repository.searchPackages._#lambda2',2,'CPM.Repository.searchPackages._\'23lambda2',nofix,notype).
functiontype('CPM.Repository.searchPackages._\'23lambda3','CPM.Repository.searchPackages._#lambda3',3,'CPM.Repository.searchPackages._\'23lambda3',nofix,notype).
functiontype('CPM.Repository.searchPackages._\'23lambda4','CPM.Repository.searchPackages._#lambda4',2,'CPM.Repository.searchPackages._\'23lambda4',nofix,notype).
functiontype('CPM.Repository.searchPackages._\'23lambda5','CPM.Repository.searchPackages._#lambda5',2,'CPM.Repository.searchPackages._\'23lambda5',nofix,notype).
functiontype('CPM.Repository.listPackages',listPackages,1,'CPM.Repository.listPackages',nofix,notype).
functiontype('CPM.Repository.listPackages._\'23lambda6','CPM.Repository.listPackages._#lambda6',2,'CPM.Repository.listPackages._\'23lambda6',nofix,notype).
functiontype('CPM.Repository.listPackages._\'23lambda7','CPM.Repository.listPackages._#lambda7',2,'CPM.Repository.listPackages._\'23lambda7',nofix,notype).
functiontype('CPM.Repository.findLatestVersion',findLatestVersion,4,'CPM.Repository.findLatestVersion',nofix,notype).
functiontype('CPM.Repository.findVersion',findVersion,3,'CPM.Repository.findVersion',nofix,notype).
functiontype('CPM.Repository.findVersion.maybeHead.41','CPM.Repository.findVersion.maybeHead.41',1,'CPM.Repository.findVersion.maybeHead.41',nofix,notype).
functiontype('CPM.Repository.warnIfRepositoryOld',warnIfRepositoryOld,1,'CPM.Repository.warnIfRepositoryOld',nofix,notype).
functiontype('CPM.Repository.warnIfRepositoryOld._\'23lambda10','CPM.Repository.warnIfRepositoryOld._#lambda10',2,'CPM.Repository.warnIfRepositoryOld._\'23lambda10',nofix,notype).
functiontype('CPM.Repository.warnIfRepositoryOld._\'23lambda10._\'23lambda14','CPM.Repository.warnIfRepositoryOld._#lambda10._#lambda14',1,'CPM.Repository.warnIfRepositoryOld._\'23lambda10._\'23lambda14',nofix,notype).
functiontype('CPM.Repository.warnIfRepositoryOld._\'23lambda10._\'23lambda14._\'23lambda16','CPM.Repository.warnIfRepositoryOld._#lambda10._#lambda14._#lambda16',2,'CPM.Repository.warnIfRepositoryOld._\'23lambda10._\'23lambda14._\'23lambda16',nofix,notype).
functiontype('CPM.Repository.useUpdateHelp',useUpdateHelp,0,'CPM.Repository.useUpdateHelp',nofix,notype).
functiontype('CPM.Repository.readRepositoryFrom',readRepositoryFrom,1,'CPM.Repository.readRepositoryFrom',nofix,notype).
functiontype('CPM.Repository.readRepositoryFrom._\'23lambda19','CPM.Repository.readRepositoryFrom._#lambda19',1,'CPM.Repository.readRepositoryFrom._\'23lambda19',nofix,notype).
functiontype('CPM.Repository.tryReadRepositoryFrom','CPM.Repository.tryReadRepositoryFrom',1,'CPM.Repository.tryReadRepositoryFrom',nofix,notype).
functiontype('CPM.Repository.tryReadRepositoryFrom.readPackageFile.65','CPM.Repository.tryReadRepositoryFrom.readPackageFile.65',1,'CPM.Repository.tryReadRepositoryFrom.readPackageFile.65',nofix,notype).
functiontype('CPM.Repository.tryReadRepositoryFrom.readPackageFile.65._\'23lambda22','CPM.Repository.tryReadRepositoryFrom.readPackageFile.65._#lambda22',2,'CPM.Repository.tryReadRepositoryFrom.readPackageFile.65._\'23lambda22',nofix,notype).
functiontype('CPM.Repository.tryReadRepositoryFrom.getDir.65','CPM.Repository.tryReadRepositoryFrom.getDir.65',1,'CPM.Repository.tryReadRepositoryFrom.getDir.65',nofix,notype).
functiontype('CPM.Repository.tryReadRepositoryFrom.getDir.65._\'23lambda25','CPM.Repository.tryReadRepositoryFrom.getDir.65._#lambda25',2,'CPM.Repository.tryReadRepositoryFrom.getDir.65._\'23lambda25',nofix,notype).
functiontype('CPM.Repository.tryReadRepositoryFrom._\'23lambda32','CPM.Repository.tryReadRepositoryFrom._#lambda32',2,'CPM.Repository.tryReadRepositoryFrom._\'23lambda32',nofix,notype).
functiontype('CPM.Repository.tryReadRepositoryFrom._\'23lambda32._\'23lambda34','CPM.Repository.tryReadRepositoryFrom._#lambda32._#lambda34',1,'CPM.Repository.tryReadRepositoryFrom._\'23lambda32._\'23lambda34',nofix,notype).
functiontype('CPM.Repository.tryReadRepositoryFrom._\'23lambda32._\'23lambda34._\'23lambda36','CPM.Repository.tryReadRepositoryFrom._#lambda32._#lambda34._#lambda36',2,'CPM.Repository.tryReadRepositoryFrom._\'23lambda32._\'23lambda34._\'23lambda36',nofix,notype).
functiontype('CPM.Repository.tryReadRepositoryFrom._\'23lambda32._\'23lambda34._\'23lambda36._\'23lambda38','CPM.Repository.tryReadRepositoryFrom._#lambda32._#lambda34._#lambda36._#lambda38',1,'CPM.Repository.tryReadRepositoryFrom._\'23lambda32._\'23lambda34._\'23lambda36._\'23lambda38',nofix,notype).
functiontype('CPM.Repository.tryReadRepositoryFrom._\'23lambda32._\'23lambda34._\'23lambda36._\'23lambda39','CPM.Repository.tryReadRepositoryFrom._#lambda32._#lambda34._#lambda36._#lambda39',1,'CPM.Repository.tryReadRepositoryFrom._\'23lambda32._\'23lambda34._\'23lambda36._\'23lambda39',nofix,notype).
functiontype('CPM.Repository.tryReadRepositoryFrom._\'23lambda32._\'23lambda34._\'23lambda36._\'23lambda39._\'23lambda41','CPM.Repository.tryReadRepositoryFrom._#lambda32._#lambda34._#lambda36._#lambda39._#lambda41',1,'CPM.Repository.tryReadRepositoryFrom._\'23lambda32._\'23lambda34._\'23lambda36._\'23lambda39._\'23lambda41',nofix,notype).
functiontype('CPM.Repository.tryReadRepositoryFrom._\'23lambda32._\'23lambda34._\'23lambda36._\'23lambda39._\'23lambda41._\'23lambda43','CPM.Repository.tryReadRepositoryFrom._#lambda32._#lambda34._#lambda36._#lambda39._#lambda41._#lambda43',1,'CPM.Repository.tryReadRepositoryFrom._\'23lambda32._\'23lambda34._\'23lambda36._\'23lambda39._\'23lambda41._\'23lambda43',nofix,notype).
functiontype('CPM.Repository.repositoryCacheFilePrefix',repositoryCacheFilePrefix,1,'CPM.Repository.repositoryCacheFilePrefix',nofix,notype).
functiontype('CPM.Repository.cleanRepositoryCache',cleanRepositoryCache,1,'CPM.Repository.cleanRepositoryCache',nofix,notype).
functiontype('CPM.Repository.readPackageFromRepository',readPackageFromRepository,2,'CPM.Repository.readPackageFromRepository',nofix,notype).
functiontype('CPM.Repository.searchPackages._\'23caseor0','CPM.Repository.searchPackages._#caseor0',6,'CPM.Repository.searchPackages._\'23caseor0',nofix,notype).
functiontype('CPM.Repository.tryReadRepositoryFrom.readPackageFile.65._\'23lambda22._\'23caseor0','CPM.Repository.tryReadRepositoryFrom.readPackageFile.65._#lambda22._#caseor0',2,'CPM.Repository.tryReadRepositoryFrom.readPackageFile.65._\'23lambda22._\'23caseor0',nofix,notype).
functiontype('CPM.Repository.tryReadRepositoryFrom.getDir.65._\'23lambda25._\'23caseor0','CPM.Repository.tryReadRepositoryFrom.getDir.65._#lambda25._#caseor0',2,'CPM.Repository.tryReadRepositoryFrom.getDir.65._\'23lambda25._\'23caseor0',nofix,notype).

%%%%%%%%%%%% constructor types %%%%%%%%%%%%%%%%%%%
:-multifile constructortype/7.
:-dynamic constructortype/7.
constructortype('CPM.Repository.Repository','CPM.Repository.Repository',1,'Repository.Repository',0,notype,[]).

%%%%%%%%%%%% function definitions %%%%%%%%%%%%%%%%%%%
'CPM.Repository._inst\'23Prelude.Data\'23CPM.Repository.Repository\'23'(_57895640,_57895642,_57895644,_57895646):-freeze(_57895644,'blocked_CPM.Repository._inst\'23Prelude.Data\'23CPM.Repository.Repository\'23'(_57895640,_57895642,_57895644,_57895646)).
'blocked_CPM.Repository._inst\'23Prelude.Data\'23CPM.Repository.Repository\'23'(_57895726,_57896502,_57896508,_57896514):-hnf(_57895726,_57899256,_57896508,_57899268),'blocked_CPM.Repository._inst\'23Prelude.Data\'23CPM.Repository.Repository\'23_1'(_57899256,_57896502,_57899268,_57896514).

'blocked_CPM.Repository._inst\'23Prelude.Data\'23CPM.Repository.Repository\'23_1'(_57899906,_57899908,_57899910,_57899912):-freeze(_57899910,'blocked_blocked_CPM.Repository._inst\'23Prelude.Data\'23CPM.Repository.Repository\'23_1'(_57899906,_57899908,_57899910,_57899912)).
'blocked_blocked_CPM.Repository._inst\'23Prelude.Data\'23CPM.Repository.Repository\'23_1'('Prelude.()','Prelude._Dict\'23Data'(partcall(2,'CPM.Repository._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Repository.Repository\'23',[]),'CPM.Repository._impl\'23aValue\'23Prelude.Data\'23CPM.Repository.Repository\'23'),_57900258,_57900258):-!.
'blocked_blocked_CPM.Repository._inst\'23Prelude.Data\'23CPM.Repository.Repository\'23_1'('FAIL'(_57902152),'FAIL'(_57902152),_57902166,_57902166):-nonvar(_57902152).

'CPM.Repository._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Repository.Repository\'23'(_57905006,_57905008,_57905010,_57905012,_57905014):-freeze(_57905012,'blocked_CPM.Repository._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Repository.Repository\'23'(_57905006,_57905008,_57905010,_57905012,_57905014)).
'blocked_CPM.Repository._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Repository.Repository\'23'(_57905102,_57905120,_57906176,_57906182,_57906188):-hnf(_57905102,_57909370,_57906182,_57909388),'blocked_CPM.Repository._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Repository.Repository\'23_1'(_57909370,_57905120,_57906176,_57909388,_57906188).

'blocked_CPM.Repository._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Repository.Repository\'23_1'(_57910106,_57910108,_57910110,_57910112,_57910114):-freeze(_57910112,'blocked_blocked_CPM.Repository._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Repository.Repository\'23_1'(_57910106,_57910108,_57910110,_57910112,_57910114)).
'blocked_blocked_CPM.Repository._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Repository.Repository\'23_1'('CPM.Repository.Repository'(_57905236),_57905120,_57911274,_57911280,_57911286):-!,hnf(_57905120,_57915608,_57911280,_57915626),'blocked_blocked_CPM.Repository._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Repository.Repository\'23_1_CPM.Repository.Repository_2'(_57915608,_57905236,_57911274,_57915626,_57911286).

'blocked_blocked_CPM.Repository._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Repository.Repository\'23_1_CPM.Repository.Repository_2'(_57916578,_57916580,_57916582,_57916584,_57916586):-freeze(_57916584,'blocked_blocked_blocked_CPM.Repository._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Repository.Repository\'23_1_CPM.Repository.Repository_2'(_57916578,_57916580,_57916582,_57916584,_57916586)).
'blocked_blocked_blocked_CPM.Repository._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Repository.Repository\'23_1_CPM.Repository.Repository_2'('CPM.Repository.Repository'(_57905358),_57905236,_57917132,_57917138,_57917144):-!,hnf('Prelude._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23\'5B\'5D\'230\'23\'23'(partcall(1,'CPM.Package._inst\'23Prelude.Data\'23CPM.Package.Package\'23',[]),_57905236,_57905358),_57917132,_57917138,_57917144).
'blocked_blocked_blocked_CPM.Repository._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Repository.Repository\'23_1_CPM.Repository.Repository_2'('FAIL'(_57919230),_57905236,'FAIL'(_57919230),_57919244,_57919244):-nonvar(_57919230).
'blocked_blocked_CPM.Repository._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23CPM.Repository.Repository\'23_1'('FAIL'(_57919308),_57905120,'FAIL'(_57919308),_57919322,_57919322):-nonvar(_57919308).

'CPM.Repository._impl\'23aValue\'23Prelude.Data\'23CPM.Repository.Repository\'23'(_57922200,_57922202,_57922204):-freeze(_57922202,'blocked_CPM.Repository._impl\'23aValue\'23Prelude.Data\'23CPM.Repository.Repository\'23'(_57922200,_57922202,_57922204)).
'blocked_CPM.Repository._impl\'23aValue\'23Prelude.Data\'23CPM.Repository.Repository\'23'('CPM.Repository.Repository'('Prelude._impl\'23aValue\'23Prelude.Data\'23\'5B\'5D\'230\'23\'23'(partcall(1,'CPM.Package._inst\'23Prelude.Data\'23CPM.Package.Package\'23',[]))),_57922462,_57922462).

'CPM.Repository.emptyRepository'(_57925390,_57925392,_57925394):-freeze(_57925392,'blocked_CPM.Repository.emptyRepository'(_57925390,_57925392,_57925394)).
'blocked_CPM.Repository.emptyRepository'('CPM.Repository.Repository'([]),_57925568,_57925568).

'CPM.Repository.allPackages'(_57927274,_57927276,_57927278,_57927280):-freeze(_57927278,'blocked_CPM.Repository.allPackages'(_57927274,_57927276,_57927278,_57927280)).
'blocked_CPM.Repository.allPackages'(_57927360,_57927738,_57927744,_57927750):-hnf(_57927360,_57929052,_57927744,_57929064),'blocked_CPM.Repository.allPackages_1'(_57929052,_57927738,_57929064,_57927750).

'blocked_CPM.Repository.allPackages_1'(_57929462,_57929464,_57929466,_57929468):-freeze(_57929466,'blocked_blocked_CPM.Repository.allPackages_1'(_57929462,_57929464,_57929466,_57929468)).
'blocked_blocked_CPM.Repository.allPackages_1'('CPM.Repository.Repository'(_57927476),_57930006,_57930012,_57930018):-!,hnf(_57927476,_57930006,_57930012,_57930018).
'blocked_blocked_CPM.Repository.allPackages_1'('FAIL'(_57930476),'FAIL'(_57930476),_57930490,_57930490):-nonvar(_57930476).

'CPM.Repository.pkgsToRepository'(_57931852,_57931854,_57931856,_57931858):-freeze(_57931856,'blocked_CPM.Repository.pkgsToRepository'(_57931852,_57931854,_57931856,_57931858)).
'blocked_CPM.Repository.pkgsToRepository'(_57931938,'CPM.Repository.Repository'(_57931938),_57932044,_57932044).

'CPM.Repository.findAllVersions'(_57933970,_57933972,_57933974,_57933976,_57933978,_57933980):-freeze(_57933978,'blocked_CPM.Repository.findAllVersions'(_57933970,_57933972,_57933974,_57933976,_57933978,_57933980)).
'blocked_CPM.Repository.findAllVersions'(_57934076,_57934094,_57934112,_57936836,_57936842,_57936848):-hnf(_57934076,_57938310,_57936842,_57938334),'blocked_CPM.Repository.findAllVersions_1'(_57938310,_57934094,_57934112,_57936836,_57938334,_57936848).

'blocked_CPM.Repository.findAllVersions_1'(_57938772,_57938774,_57938776,_57938778,_57938780,_57938782):-freeze(_57938780,'blocked_blocked_CPM.Repository.findAllVersions_1'(_57938772,_57938774,_57938776,_57938778,_57938780,_57938782)).
'blocked_blocked_CPM.Repository.findAllVersions_1'('CPM.Repository.Repository'(_57934228),_57934094,_57934112,_57939336,_57939342,_57939348):-!,makeShare(_57934262,_57939802),makeShare(_57934280,_57939822),makeShare(_57934298,_57939842),hnf('Prelude.cond'(letrec4PAKCS(_57939802,'Prelude.apply'('Data.List.sortBy',partcall(2,'CPM.Repository.findAllVersions._\'23lambda1',[]))),'Prelude.cond'(letrec4PAKCS(_57939822,partcall(1,'Prelude.filter',[partcall(1,'CPM.Repository.findAllVersions.filterPre.8',[_57934112])])),'Prelude.cond'(letrec4PAKCS(_57939842,partcall(1,'Prelude.filter',['Prelude..'(partcall(1,'Prelude.flip',[_57934094,partcall(2,'Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])])]),partcall(1,'CPM.Package.name',[]))])),'Prelude.$'(_57939802,'Prelude.$'(_57939822,'Prelude.apply'(_57939842,_57934228)))))),_57939336,_57939342,_57939348).
'blocked_blocked_CPM.Repository.findAllVersions_1'('FAIL'(_57946524),_57934094,_57934112,'FAIL'(_57946524),_57946538,_57946538):-nonvar(_57946524).

'CPM.Repository.findAllVersions._\'23lambda1'(_57948286,_57948288,_57948290,_57948292,_57948294):-freeze(_57948292,'blocked_CPM.Repository.findAllVersions._\'23lambda1'(_57948286,_57948288,_57948290,_57948292,_57948294)).
'blocked_CPM.Repository.findAllVersions._\'23lambda1'(_57948382,_57948400,_57948738,_57948744,_57948750):-hnf('CPM.Package.vgt'('CPM.Package.version'(_57948382),'CPM.Package.version'(_57948400)),_57948738,_57948744,_57948750).

'CPM.Repository.findAllVersions.filterPre.8'(_57951776,_57951778,_57951780,_57951782,_57951784):-freeze(_57951782,'blocked_CPM.Repository.findAllVersions.filterPre.8'(_57951776,_57951778,_57951780,_57951782,_57951784)).
'blocked_CPM.Repository.findAllVersions.filterPre.8'(_57951872,_57951890,_57952564,_57952570,_57952576):-hnf('Prelude.||'(_57951872,'Prelude.apply'('Prelude..'(partcall(1,'Prelude.not',[]),'Prelude..'(partcall(1,'CPM.Package.isPreRelease',[]),partcall(1,'CPM.Package.version',[]))),_57951890)),_57952564,_57952570,_57952576).

'CPM.Repository.searchPackages'(_57955950,_57955952,_57955954,_57955956,_57955958,_57955960,_57955962):-freeze(_57955960,'blocked_CPM.Repository.searchPackages'(_57955950,_57955952,_57955954,_57955956,_57955958,_57955960,_57955962)).
'blocked_CPM.Repository.searchPackages'(_57956066,_57956084,_57956102,_57956120,_57959044,_57959050,_57959056):-hnf(_57956066,_57960490,_57959050,_57960520),'blocked_CPM.Repository.searchPackages_1'(_57960490,_57956084,_57956102,_57956120,_57959044,_57960520,_57959056).

'blocked_CPM.Repository.searchPackages_1'(_57960960,_57960962,_57960964,_57960966,_57960968,_57960970,_57960972):-freeze(_57960970,'blocked_blocked_CPM.Repository.searchPackages_1'(_57960960,_57960962,_57960964,_57960966,_57960968,_57960970,_57960972)).
'blocked_blocked_CPM.Repository.searchPackages_1'('CPM.Repository.Repository'(_57956236),_57956084,_57956102,_57956120,_57961534,_57961540,_57961546):-!,makeShare(_57956270,_57962338),makeShare(_57956288,_57962358),makeShare(_57956120,_57962378),makeShare(_57956306,_57962398),makeShare(_57956324,_57962418),hnf('Prelude.cond'(letrec4PAKCS(_57962338,partcall(1,'Prelude.map',[partcall(1,'Data.Char.toLower',[])])),'Prelude.cond'(letrec4PAKCS(_57962358,'Prelude.apply'(_57962338,_57962378)),'Prelude.cond'(letrec4PAKCS(_57962398,'CPM.Repository.searchPackages._\'23caseor0'(_57956084,_57962378,_57956102,_57962338,_57962358,_57956236)),'Prelude.cond'(letrec4PAKCS(_57962418,'Prelude.apply'('Data.List.sortBy',partcall(2,'CPM.Repository.searchPackages._\'23lambda4',[]))),'Prelude.map'(_57962418,'Data.List.groupBy'(partcall(2,'CPM.Repository.searchPackages._\'23lambda5',[]),_57962398)))))),_57961534,_57961540,_57961546).
'blocked_blocked_CPM.Repository.searchPackages_1'('FAIL'(_57969312),_57956084,_57956102,_57956120,'FAIL'(_57969312),_57969326,_57969326):-nonvar(_57969312).

'CPM.Repository.searchPackages.matches.16'(_57971054,_57971056,_57971058,_57971060,_57971062,_57971064):-freeze(_57971062,'blocked_CPM.Repository.searchPackages.matches.16'(_57971054,_57971056,_57971058,_57971060,_57971062,_57971064)).
'blocked_CPM.Repository.searchPackages.matches.16'(_57971160,_57971178,_57971196,_57973032,_57973038,_57973044):-makeShare(_57971178,_57973368),makeShare(_57971160,_57973388),makeShare(_57971196,_57973408),hnf('Prelude.||'('Data.List.isInfixOf'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[]),_57973368,'Prelude.$'(_57973388,'CPM.Package.name'(_57973408))),'Prelude.||'('Data.List.isInfixOf'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[]),_57973368,'Prelude.$'(_57973388,'CPM.Package.synopsis'(_57973408))),'Data.List.isInfixOf'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[]),_57973368,'Prelude.$'(_57973388,'Prelude.unwords'('CPM.Package.exportedModules'(_57973408)))))),_57973032,_57973038,_57973044).

'CPM.Repository.searchPackages._\'23lambda2'(_57980652,_57980654,_57980656,_57980658,_57980660):-freeze(_57980658,'blocked_CPM.Repository.searchPackages._\'23lambda2'(_57980652,_57980654,_57980656,_57980658,_57980660)).
'blocked_CPM.Repository.searchPackages._\'23lambda2'(_57980748,_57980766,_57981272,_57981278,_57981284):-hnf('Prelude.apply'('Prelude.elem'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])]),_57980748),'CPM.Package.exportedModules'(_57980766)),_57981272,_57981278,_57981284).

'CPM.Repository.searchPackages._\'23lambda3'(_57984982,_57984984,_57984986,_57984988,_57984990,_57984992):-freeze(_57984990,'blocked_CPM.Repository.searchPackages._\'23lambda3'(_57984982,_57984984,_57984986,_57984988,_57984990,_57984992)).
'blocked_CPM.Repository.searchPackages._\'23lambda3'(_57985088,_57985106,_57985124,_57985616,_57985622,_57985628):-hnf('Data.List.isInfixOf'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[]),_57985088,'Prelude.$'(_57985106,'CPM.Package.execOfPackage'(_57985124))),_57985616,_57985622,_57985628).

'CPM.Repository.searchPackages._\'23lambda4'(_57989172,_57989174,_57989176,_57989178,_57989180):-freeze(_57989178,'blocked_CPM.Repository.searchPackages._\'23lambda4'(_57989172,_57989174,_57989176,_57989178,_57989180)).
'blocked_CPM.Repository.searchPackages._\'23lambda4'(_57989268,_57989286,_57989624,_57989630,_57989636):-hnf('CPM.Package.vgt'('CPM.Package.version'(_57989268),'CPM.Package.version'(_57989286)),_57989624,_57989630,_57989636).

'CPM.Repository.searchPackages._\'23lambda5'(_57992570,_57992572,_57992574,_57992576,_57992578):-freeze(_57992576,'blocked_CPM.Repository.searchPackages._\'23lambda5'(_57992570,_57992572,_57992574,_57992576,_57992578)).
'blocked_CPM.Repository.searchPackages._\'23lambda5'(_57992666,_57992684,_57993106,_57993112,_57993118):-hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[]),'CPM.Package.name'(_57992666),'CPM.Package.name'(_57992684)),_57993106,_57993112,_57993118).

'CPM.Repository.listPackages'(_57996150,_57996152,_57996154,_57996156):-freeze(_57996154,'blocked_CPM.Repository.listPackages'(_57996150,_57996152,_57996154,_57996156)).
'blocked_CPM.Repository.listPackages'(_57996236,_57997466,_57997472,_57997478):-hnf(_57996236,_57998816,_57997472,_57998828),'blocked_CPM.Repository.listPackages_1'(_57998816,_57997466,_57998828,_57997478).

'blocked_CPM.Repository.listPackages_1'(_57999232,_57999234,_57999236,_57999238):-freeze(_57999236,'blocked_blocked_CPM.Repository.listPackages_1'(_57999232,_57999234,_57999236,_57999238)).
'blocked_blocked_CPM.Repository.listPackages_1'('CPM.Repository.Repository'(_57996352),_57999776,_57999782,_57999788):-!,makeShare(_57996386,_57999902),hnf('Prelude.cond'(letrec4PAKCS(_57999902,'Prelude.apply'('Data.List.sortBy',partcall(2,'CPM.Repository.listPackages._\'23lambda6',[]))),'Prelude.map'(_57999902,'Data.List.groupBy'(partcall(2,'CPM.Repository.listPackages._\'23lambda7',[]),_57996352))),_57999776,_57999782,_57999788).
'blocked_blocked_CPM.Repository.listPackages_1'('FAIL'(_58002610),'FAIL'(_58002610),_58002624,_58002624):-nonvar(_58002610).

'CPM.Repository.listPackages._\'23lambda6'(_58004242,_58004244,_58004246,_58004248,_58004250):-freeze(_58004248,'blocked_CPM.Repository.listPackages._\'23lambda6'(_58004242,_58004244,_58004246,_58004248,_58004250)).
'blocked_CPM.Repository.listPackages._\'23lambda6'(_58004338,_58004356,_58004694,_58004700,_58004706):-hnf('CPM.Package.vgt'('CPM.Package.version'(_58004338),'CPM.Package.version'(_58004356)),_58004694,_58004700,_58004706).

'CPM.Repository.listPackages._\'23lambda7'(_58007552,_58007554,_58007556,_58007558,_58007560):-freeze(_58007558,'blocked_CPM.Repository.listPackages._\'23lambda7'(_58007552,_58007554,_58007556,_58007558,_58007560)).
'blocked_CPM.Repository.listPackages._\'23lambda7'(_58007648,_58007666,_58008088,_58008094,_58008100):-hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[]),'CPM.Package.name'(_58007648),'CPM.Package.name'(_58007666)),_58008088,_58008094,_58008100).

'CPM.Repository.findLatestVersion'(_58011310,_58011312,_58011314,_58011316,_58011318,_58011320,_58011322):-freeze(_58011320,'blocked_CPM.Repository.findLatestVersion'(_58011310,_58011312,_58011314,_58011316,_58011318,_58011320,_58011322)).
'blocked_CPM.Repository.findLatestVersion'(_58011426,_58011444,_58011462,_58011480,_58014304,_58014310,_58014316):-hnf('Prelude.filter'(partcall(1,'CPM.Resolution.isCompatibleToCompiler',[_58011426]),'CPM.Repository.findAllVersions'(_58011444,_58011462,_58011480)),_58015972,_58014310,_58015926),'blocked_CPM.Repository.findLatestVersion_ComplexCase'(_58015972,_58011426,_58011444,_58011462,_58011480,_58014304,_58015926,_58014316).

'blocked_CPM.Repository.findLatestVersion_ComplexCase'(_58016458,_58016460,_58016462,_58016464,_58016466,_58016468,_58016470,_58016472):-freeze(_58016470,freeze(_58016458,'blocked_blocked_CPM.Repository.findLatestVersion_ComplexCase'(_58016458,_58016460,_58016462,_58016464,_58016466,_58016468,_58016470,_58016472))).
'blocked_blocked_CPM.Repository.findLatestVersion_ComplexCase'([],_58011426,_58011444,_58011462,_58011480,'Prelude.Nothing',_58016752,_58016752).
'blocked_blocked_CPM.Repository.findLatestVersion_ComplexCase'([_58012158|_58012176],_58011426,_58011444,_58011462,_58011480,'Prelude.Just'(_58012158),_58017808,_58017808):-!.
'blocked_blocked_CPM.Repository.findLatestVersion_ComplexCase'('FAIL'(_58018888),_58011426,_58011444,_58011462,_58011480,'FAIL'(_58018888),_58018902,_58018902).

'CPM.Repository.findVersion'(_58020102,_58020104,_58020106,_58020108,_58020110,_58020112):-freeze(_58020110,'blocked_CPM.Repository.findVersion'(_58020102,_58020104,_58020106,_58020108,_58020110,_58020112)).
'blocked_CPM.Repository.findVersion'(_58020208,_58020226,_58020244,_58021744,_58021750,_58021756):-hnf('Prelude.$'(partcall(1,'CPM.Repository.findVersion.maybeHead.41',[]),'Prelude.$'(partcall(1,'Prelude.filter',['Prelude..'(partcall(1,'Prelude.flip',[_58020244,partcall(2,'Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'28\'2C\'2C\'2C\'29\'230\'23\'231\'23\'232\'23\'233\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Maybe\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])])]),partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Int\'23',[]),partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Int\'23',[]),partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Int\'23',[])])]),partcall(1,'CPM.Package.version',[]))]),'CPM.Repository.findAllVersions'(_58020208,_58020226,'Prelude.True'))),_58021744,_58021750,_58021756).

'CPM.Repository.findVersion.maybeHead.41'(_58029120,_58029122,_58029124,_58029126):-freeze(_58029124,'blocked_CPM.Repository.findVersion.maybeHead.41'(_58029120,_58029122,_58029124,_58029126)).
'blocked_CPM.Repository.findVersion.maybeHead.41'(_58029206,_58029870,_58029876,_58029882):-hnf(_58029206,_58031652,_58029876,_58031664),'blocked_CPM.Repository.findVersion.maybeHead.41_1'(_58031652,_58029870,_58031664,_58029882).

'blocked_CPM.Repository.findVersion.maybeHead.41_1'(_58032140,_58032142,_58032144,_58032146):-freeze(_58032144,'blocked_blocked_CPM.Repository.findVersion.maybeHead.41_1'(_58032140,_58032142,_58032144,_58032146)).
'blocked_blocked_CPM.Repository.findVersion.maybeHead.41_1'([],'Prelude.Nothing',_58032388,_58032388).
'blocked_blocked_CPM.Repository.findVersion.maybeHead.41_1'([_58029422|_58029440],'Prelude.Just'(_58029422),_58033130,_58033130):-!.
'blocked_blocked_CPM.Repository.findVersion.maybeHead.41_1'('FAIL'(_58033896),'FAIL'(_58033896),_58033910,_58033910):-nonvar(_58033896).

'CPM.Repository.warnIfRepositoryOld'(_58035386,_58035388,_58035390,_58035392):-freeze(_58035390,'blocked_CPM.Repository.warnIfRepositoryOld'(_58035386,_58035388,_58035390,_58035392)).
'blocked_CPM.Repository.warnIfRepositoryOld'(_58035472,_58045560,_58045566,_58045572):-makeShare(_58042928,_58045936),hnf('Prelude.apply'('Prelude.apply'('CPM.ErrorLogger._impl\'23\'3E\'3E\'23Prelude.Monad\'23CPM.ErrorLogger.ErrorLogger\'23','Prelude.apply'('CPM.ErrorLogger.logDebug',['^C','^h','^e','^c','^k','^ ','^l','^a','^s','^t','^ ','^u','^p','^d','^a','^t','^e','^ ','^t','^i','^m','^e','^ ','^o','^f','^ ','^r','^e','^p','^o','^s','^i','^t','^o','^r','^y','^ ','^i','^n','^d','^e','^x',^.,^.,^.])),'Prelude.cond'(letrec4PAKCS(_58045936,'Prelude.apply'('Prelude.apply'('System.FilePath.\'3C\'2F\'3E','CPM.Config.repositoryDir'(_58035472)),['^R','^E','^A','^D','^M','^E',^.,'^m','^d'])),'CPM.ErrorLogger._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23CPM.ErrorLogger.ErrorLogger\'23'('Prelude.$'(partcall(1,'CPM.ErrorLogger.liftIOEL',[]),'System.Directory.doesFileExist'(_58045936)),partcall(1,'CPM.Repository.warnIfRepositoryOld._\'23lambda10',[_58045936])))),_58045560,_58045566,_58045572).

'CPM.Repository.warnIfRepositoryOld._\'23lambda10'(_58063996,_58063998,_58064000,_58064002,_58064004):-freeze(_58064002,'blocked_CPM.Repository.warnIfRepositoryOld._\'23lambda10'(_58063996,_58063998,_58064000,_58064002,_58064004)).
'blocked_CPM.Repository.warnIfRepositoryOld._\'23lambda10'(_58064092,_58064110,_58074652,_58074658,_58074664):-hnf(_58064110,_58076730,_58074658,_58076748),'blocked_CPM.Repository.warnIfRepositoryOld._\'23lambda10_2'(_58076730,_58064092,_58074652,_58076748,_58074664).

'blocked_CPM.Repository.warnIfRepositoryOld._\'23lambda10_2'(_58077286,_58077288,_58077290,_58077292,_58077294):-freeze(_58077292,freeze(_58077286,'blocked_blocked_CPM.Repository.warnIfRepositoryOld._\'23lambda10_2'(_58077286,_58077288,_58077290,_58077292,_58077294))).
'blocked_blocked_CPM.Repository.warnIfRepositoryOld._\'23lambda10_2'('Prelude.True',_58064092,_58077680,_58077686,_58077692):-hnf('CPM.ErrorLogger._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23CPM.ErrorLogger.ErrorLogger\'23'('Prelude.$'(partcall(1,'CPM.ErrorLogger.liftIOEL',[]),'System.Directory.getModificationTime'(_58064092)),partcall(1,'CPM.Repository.warnIfRepositoryOld._\'23lambda10._\'23lambda14',[])),_58077680,_58077686,_58077692).
'blocked_blocked_CPM.Repository.warnIfRepositoryOld._\'23lambda10_2'('Prelude.False',_58064092,_58080436,_58080442,_58080448):-!,hnf('Prelude.apply'('Prelude.apply'('CPM.ErrorLogger._impl\'23\'3E\'3E\'23Prelude.Monad\'23CPM.ErrorLogger.ErrorLogger\'23','Prelude.$'('CPM.ErrorLogger.logError','Prelude.++'(['^I','^t','^ ','^s','^e','^e','^m','^s','^ ','^t','^h','^a','^t','^ ','^t','^h','^e','^ ','^r','^e','^p','^o','^s','^i','^t','^o','^r','^y','^ ','^o','^f','^ ','^C','^P','^M','^ ','^i','^s','^ ','^n','^o','^t','^ ','^i','^n','^i','^t','^i','^a','^l','^i','^z','^e','^d',^.,'^010'],'CPM.Repository.useUpdateHelp'))),'Prelude.$'(partcall(1,'CPM.ErrorLogger.liftIOEL',[]),'System.Process.exitWith'(1))),_58080436,_58080442,_58080448).
'blocked_blocked_CPM.Repository.warnIfRepositoryOld._\'23lambda10_2'('FAIL'(_58095088),_58064092,'FAIL'(_58095088),_58095102,_58095102).

'CPM.Repository.warnIfRepositoryOld._\'23lambda10._\'23lambda14'(_58097474,_58097476,_58097478,_58097480):-freeze(_58097478,'blocked_CPM.Repository.warnIfRepositoryOld._\'23lambda10._\'23lambda14'(_58097474,_58097476,_58097478,_58097480)).
'blocked_CPM.Repository.warnIfRepositoryOld._\'23lambda10._\'23lambda14'(_58097560,_58098338,_58098344,_58098350):-makeShare(_58097588,_58098462),hnf('Prelude.cond'(letrec4PAKCS(_58098462,_58097560),'CPM.ErrorLogger._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23CPM.ErrorLogger.ErrorLogger\'23'('Prelude.$'(partcall(1,'CPM.ErrorLogger.liftIOEL',[]),'Data.Time.getClockTime'),partcall(1,'CPM.Repository.warnIfRepositoryOld._\'23lambda10._\'23lambda14._\'23lambda16',[_58098462]))),_58098338,_58098344,_58098350).

'CPM.Repository.warnIfRepositoryOld._\'23lambda10._\'23lambda14._\'23lambda16'(_58104434,_58104436,_58104438,_58104440,_58104442):-freeze(_58104440,'blocked_CPM.Repository.warnIfRepositoryOld._\'23lambda10._\'23lambda14._\'23lambda16'(_58104434,_58104436,_58104438,_58104440,_58104442)).
'blocked_CPM.Repository.warnIfRepositoryOld._\'23lambda10._\'23lambda14._\'23lambda16'(_58104530,_58104548,_58116510,_58116516,_58116522):-makeShare(_58104576,_58117372),makeShare(_58104594,_58117392),makeShare(_58104530,_58117412),makeShare(_58106030,_58117432),makeShare(_58106048,_58117452),hnf('Prelude.cond'(letrec4PAKCS(_58117372,_58104548),'Prelude.cond'(letrec4PAKCS(_58117392,'Data.Time.addDays'(10,_58117412)),'Prelude.$'(partcall(1,'Control.Applicative.when',['Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Ordering\'23'('Data.Time.compareClockTime'(_58117372,_58117392),'Prelude.GT'),partcall(1,'CPM.ErrorLogger._inst\'23Prelude.Applicative\'23CPM.ErrorLogger.ErrorLogger\'23',[])]),'Prelude.cond'(letrec4PAKCS(_58117432,'Prelude._impl\'23\'2D\'23Prelude.Num\'23Prelude.Int\'23'('Data.Time.clockTimeToInt'(_58117372),'Data.Time.clockTimeToInt'(_58117412))),'Prelude.cond'(letrec4PAKCS(_58117452,'Prelude.apply'('Prelude.apply'('Prelude._impl\'23div\'23Prelude.Integral\'23Prelude.Int\'23',_58117432),'Prelude._impl\'23\'2A\'23Prelude.Num\'23Prelude.Int\'23'('Prelude._impl\'23\'2A\'23Prelude.Num\'23Prelude.Int\'23'(60,60),24))),'Prelude.$'('CPM.ErrorLogger.logInfo','Prelude.++'(['^W','^a','^r','^n','^i','^n','^g',^:,'^ ','^y','^o','^u','^r','^ ','^r','^e','^p','^o','^s','^i','^t','^o','^r','^y','^ ','^i','^n','^d','^e','^x','^ ','^i','^s','^ ','^o','^l','^d','^e','^r','^ ','^t','^h','^a','^n','^ '],'Prelude.++'('Prelude.apply'('Prelude._impl\'23show\'23Prelude.Show\'23Prelude.Int\'23',_58117452),'Prelude.++'(['^ ','^d','^a','^y','^s',^.,'^010'],'CPM.Repository.useUpdateHelp'))))))))),_58116510,_58116516,_58116522).

'CPM.Repository.useUpdateHelp'(_58140574,_58140576,_58140578):-freeze(_58140576,'blocked_CPM.Repository.useUpdateHelp'(_58140574,_58140576,_58140578)).
'blocked_CPM.Repository.useUpdateHelp'(['^U','^s','^e','^ ','^\'','^c','^y','^p','^m','^ ','^u','^p','^d','^a','^t','^e','^\'','^ ','^t','^o','^ ','^d','^o','^w','^n','^l','^o','^a','^d','^ ','^t','^h','^e','^ ','^n','^e','^w','^e','^s','^t','^ ','^p','^a','^c','^k','^a','^g','^e','^ ','^i','^n','^d','^e','^x',^.],_58149138,_58149138).

'CPM.Repository.readRepositoryFrom'(_58161948,_58161950,_58161952,_58161954):-freeze(_58161952,'blocked_CPM.Repository.readRepositoryFrom'(_58161948,_58161950,_58161952,_58161954)).
'blocked_CPM.Repository.readRepositoryFrom'(_58162034,_58162302,_58162308,_58162314):-hnf('CPM.ErrorLogger._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23CPM.ErrorLogger.ErrorLogger\'23'('CPM.Repository.tryReadRepositoryFrom'(_58162034),partcall(1,'CPM.Repository.readRepositoryFrom._\'23lambda19',[])),_58162302,_58162308,_58162314).

'CPM.Repository.readRepositoryFrom._\'23lambda19'(_58165880,_58165882,_58165884,_58165886):-freeze(_58165884,'blocked_CPM.Repository.readRepositoryFrom._\'23lambda19'(_58165880,_58165882,_58165884,_58165886)).
'blocked_CPM.Repository.readRepositoryFrom._\'23lambda19'(_58165966,_58174574,_58174580,_58174586):-hnf(_58165966,_58176608,_58174580,_58176620),'blocked_CPM.Repository.readRepositoryFrom._\'23lambda19_1'(_58176608,_58174574,_58176620,_58174586).

'blocked_CPM.Repository.readRepositoryFrom._\'23lambda19_1'(_58177144,_58177146,_58177148,_58177150):-freeze(_58177148,freeze(_58177144,'blocked_blocked_CPM.Repository.readRepositoryFrom._\'23lambda19_1'(_58177144,_58177146,_58177148,_58177150))).
'blocked_blocked_CPM.Repository.readRepositoryFrom._\'23lambda19_1'('Prelude.(,)'(_58166082,_58166100),_58180150,_58180156,_58180162):-!,makeShare(_58166100,_58177804),hnf('Prelude.null'(_58177804),_58183006,_58180156,_58182972),'blocked_blocked_CPM.Repository.readRepositoryFrom._\'23lambda19_1_Prelude.(,)_ComplexCase'(_58183006,_58166082,_58177804,_58180150,_58182972,_58180162).

'blocked_blocked_CPM.Repository.readRepositoryFrom._\'23lambda19_1_Prelude.(,)_ComplexCase'(_58183734,_58183736,_58183738,_58183740,_58183742,_58183744):-freeze(_58183742,freeze(_58183734,'blocked_blocked_blocked_CPM.Repository.readRepositoryFrom._\'23lambda19_1_Prelude.(,)_ComplexCase'(_58183734,_58183736,_58183738,_58183740,_58183742,_58183744))).
'blocked_blocked_blocked_CPM.Repository.readRepositoryFrom._\'23lambda19_1_Prelude.(,)_ComplexCase'('Prelude.True',_58166082,_58177804,_58184138,_58184144,_58184150):-hnf('CPM.ErrorLogger._impl\'23return\'23Prelude.Monad\'23CPM.ErrorLogger.ErrorLogger\'23'(_58166082),_58184138,_58184144,_58184150).
'blocked_blocked_blocked_CPM.Repository.readRepositoryFrom._\'23lambda19_1_Prelude.(,)_ComplexCase'('Prelude.False',_58166082,_58177804,_58185878,_58185884,_58185890):-!,hnf('Prelude.apply'('Prelude.apply'('CPM.ErrorLogger._impl\'23\'3E\'3E\'23Prelude.Monad\'23CPM.ErrorLogger.ErrorLogger\'23','Prelude.apply'('CPM.ErrorLogger.logError',['^P','^r','^o','^b','^l','^e','^m','^s','^ ','^w','^h','^i','^l','^e','^ ','^r','^e','^a','^d','^i','^n','^g','^ ','^t','^h','^e','^ ','^p','^a','^c','^k','^a','^g','^e','^ ','^i','^n','^d','^e','^x',^:])),'Prelude.apply'('Prelude.apply'('CPM.ErrorLogger._impl\'23\'3E\'3E\'23Prelude.Monad\'23CPM.ErrorLogger.ErrorLogger\'23','Prelude.apply'('Prelude.mapM_'(partcall(1,'CPM.ErrorLogger._inst\'23Prelude.Monad\'23CPM.ErrorLogger.ErrorLogger\'23',[]),'CPM.ErrorLogger.logError'),_58177804)),'Prelude.$'(partcall(1,'CPM.ErrorLogger.liftIOEL',[]),'System.Process.exitWith'(1)))),_58185878,_58185884,_58185890).
'blocked_blocked_blocked_CPM.Repository.readRepositoryFrom._\'23lambda19_1_Prelude.(,)_ComplexCase'('FAIL'(_58199432),_58166082,_58177804,'FAIL'(_58199432),_58199446,_58199446).
'blocked_blocked_CPM.Repository.readRepositoryFrom._\'23lambda19_1'('FAIL'(_58199514),'FAIL'(_58199514),_58199528,_58199528).

'CPM.Repository.tryReadRepositoryFrom'(_58201076,_58201078,_58201080,_58201082):-freeze(_58201080,'blocked_CPM.Repository.tryReadRepositoryFrom'(_58201076,_58201078,_58201080,_58201082)).
'blocked_CPM.Repository.tryReadRepositoryFrom'(_58201162,_58207884,_58207890,_58207896):-makeShare(_58201162,_58208150),hnf('Prelude.apply'('Prelude.apply'('CPM.ErrorLogger._impl\'23\'3E\'3E\'23Prelude.Monad\'23CPM.ErrorLogger.ErrorLogger\'23','Prelude.$'('CPM.ErrorLogger.logDebug','Prelude.++'(['^R','^e','^a','^d','^i','^n','^g','^ ','^r','^e','^p','^o','^s','^i','^t','^o','^r','^y','^ ','^i','^n','^d','^e','^x','^ ','^f','^r','^o','^m','^ ','^\''],'Prelude.++'(_58208150,['^\'',^.,^.,^.])))),'CPM.ErrorLogger._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23CPM.ErrorLogger.ErrorLogger\'23'('Prelude.$'(partcall(1,'CPM.ErrorLogger.liftIOEL',[]),'CPM.FileUtil.checkAndGetVisibleDirectoryContents'(_58208150)),partcall(1,'CPM.Repository.tryReadRepositoryFrom._\'23lambda32',[_58208150]))),_58207884,_58207890,_58207896).

'CPM.Repository.tryReadRepositoryFrom.readPackageFile.65'(_58222006,_58222008,_58222010,_58222012):-freeze(_58222010,'blocked_CPM.Repository.tryReadRepositoryFrom.readPackageFile.65'(_58222006,_58222008,_58222010,_58222012)).
'blocked_CPM.Repository.tryReadRepositoryFrom.readPackageFile.65'(_58222092,_58222598,_58222604,_58222610):-makeShare(_58222092,_58222692),hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','CPM.Repository.tryReadRepositoryFrom.readPackageFile.65'(_58222692)),partcall(1,'CPM.Repository.tryReadRepositoryFrom.readPackageFile.65._\'23lambda22',[_58222692])),_58222598,_58222604,_58222610).

'CPM.Repository.tryReadRepositoryFrom.readPackageFile.65._\'23lambda22'(_58227952,_58227954,_58227956,_58227958,_58227960):-freeze(_58227958,'blocked_CPM.Repository.tryReadRepositoryFrom.readPackageFile.65._\'23lambda22'(_58227952,_58227954,_58227956,_58227958,_58227960)).
'blocked_CPM.Repository.tryReadRepositoryFrom.readPackageFile.65._\'23lambda22'(_58228048,_58228066,_58229894,_58229900,_58229906):-makeShare(_58228094,_58230100),hnf('Prelude.cond'(letrec4PAKCS(_58230100,_58228066),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'23Prelude.Monad\'23Prelude.IO\'23','Prelude.seq'('Prelude.$!!'(partcall(1,'Prelude.id',[]),_58230100),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'23Prelude.Monad\'23Prelude.IO\'23','Prelude.putChar'(^.)),'System.IO.hFlush'('System.IO.stdout')))),'Prelude.$'('Prelude._impl\'23return\'23Prelude.Monad\'23Prelude.IO\'23','CPM.Repository.tryReadRepositoryFrom.readPackageFile.65._\'23lambda22._\'23caseor0'(_58230100,_58228048)))),_58229894,_58229900,_58229906).

'CPM.Repository.tryReadRepositoryFrom.getDir.65'(_58237756,_58237758,_58237760,_58237762):-freeze(_58237760,'blocked_CPM.Repository.tryReadRepositoryFrom.getDir.65'(_58237756,_58237758,_58237760,_58237762)).
'blocked_CPM.Repository.tryReadRepositoryFrom.getDir.65'(_58237842,_58238348,_58238354,_58238360):-makeShare(_58237842,_58238442),hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','System.Directory.doesDirectoryExist'(_58238442)),partcall(1,'CPM.Repository.tryReadRepositoryFrom.getDir.65._\'23lambda25',[_58238442])),_58238348,_58238354,_58238360).

'CPM.Repository.tryReadRepositoryFrom.getDir.65._\'23lambda25'(_58243132,_58243134,_58243136,_58243138,_58243140):-freeze(_58243138,'blocked_CPM.Repository.tryReadRepositoryFrom.getDir.65._\'23lambda25'(_58243132,_58243134,_58243136,_58243138,_58243140)).
'blocked_CPM.Repository.tryReadRepositoryFrom.getDir.65._\'23lambda25'(_58243228,_58243246,_58243584,_58243590,_58243596):-hnf('Prelude.$'('Prelude._impl\'23return\'23Prelude.Monad\'23Prelude.IO\'23','CPM.Repository.tryReadRepositoryFrom.getDir.65._\'23lambda25._\'23caseor0'(_58243246,_58243228)),_58243584,_58243590,_58243596).

'CPM.Repository.tryReadRepositoryFrom._\'23lambda32'(_58247470,_58247472,_58247474,_58247476,_58247478):-freeze(_58247476,'blocked_CPM.Repository.tryReadRepositoryFrom._\'23lambda32'(_58247470,_58247472,_58247474,_58247476,_58247478)).
'blocked_CPM.Repository.tryReadRepositoryFrom._\'23lambda32'(_58247566,_58247584,_58249440,_58249446,_58249452):-makeShare(_58247612,_58249634),hnf('Prelude.cond'(letrec4PAKCS(_58249634,_58247584),'CPM.ErrorLogger._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23CPM.ErrorLogger.ErrorLogger\'23'('Prelude.$'(partcall(1,'CPM.ErrorLogger.liftIOEL',[]),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','Prelude.apply'('Prelude.mapM'(partcall(1,'Prelude._inst\'23Prelude.Monad\'23Prelude.IO\'23',[]),partcall(1,'CPM.Repository.tryReadRepositoryFrom.getDir.65',[])),'Prelude.map'('Prelude.apply'('System.FilePath.\'3C\'2F\'3E',_58247566),_58249634))),'Prelude..'('Prelude._impl\'23return\'23Prelude.Monad\'23Prelude.IO\'23','Prelude.concat'))),partcall(1,'CPM.Repository.tryReadRepositoryFrom._\'23lambda32._\'23lambda34',[]))),_58249440,_58249446,_58249452).

'CPM.Repository.tryReadRepositoryFrom._\'23lambda32._\'23lambda34'(_58258414,_58258416,_58258418,_58258420):-freeze(_58258418,'blocked_CPM.Repository.tryReadRepositoryFrom._\'23lambda32._\'23lambda34'(_58258414,_58258416,_58258418,_58258420)).
'blocked_CPM.Repository.tryReadRepositoryFrom._\'23lambda32._\'23lambda34'(_58258500,_58259600,_58259606,_58259612):-makeShare(_58258528,_58259744),hnf('Prelude.cond'(letrec4PAKCS(_58259744,_58258500),'CPM.ErrorLogger._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23CPM.ErrorLogger.ErrorLogger\'23'('Prelude.$'(partcall(1,'CPM.ErrorLogger.liftIOEL',[]),'Prelude.apply'('Prelude.mapM'(partcall(1,'Prelude._inst\'23Prelude.Monad\'23Prelude.IO\'23',[]),partcall(1,'CPM.FileUtil.checkAndGetVisibleDirectoryContents',[])),_58259744)),partcall(1,'CPM.Repository.tryReadRepositoryFrom._\'23lambda32._\'23lambda34._\'23lambda36',[_58259744]))),_58259600,_58259606,_58259612).

'CPM.Repository.tryReadRepositoryFrom._\'23lambda32._\'23lambda34._\'23lambda36'(_58266804,_58266806,_58266808,_58266810,_58266812):-freeze(_58266810,'blocked_CPM.Repository.tryReadRepositoryFrom._\'23lambda32._\'23lambda34._\'23lambda36'(_58266804,_58266806,_58266808,_58266810,_58266812)).
'blocked_CPM.Repository.tryReadRepositoryFrom._\'23lambda32._\'23lambda34._\'23lambda36'(_58266900,_58266918,_58268018,_58268024,_58268030):-makeShare(_58266946,_58268194),hnf('Prelude.cond'(letrec4PAKCS(_58268194,_58266918),'CPM.ErrorLogger._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23CPM.ErrorLogger.ErrorLogger\'23'('Prelude.$'(partcall(1,'CPM.ErrorLogger._impl\'23return\'23Prelude.Monad\'23CPM.ErrorLogger.ErrorLogger\'23',[]),'Prelude.$'('Prelude.concatMap'(partcall(1,'CPM.Repository.tryReadRepositoryFrom._\'23lambda32._\'23lambda34._\'23lambda36._\'23lambda38',[])),'Prelude.zip'(_58266900,_58268194))),partcall(1,'CPM.Repository.tryReadRepositoryFrom._\'23lambda32._\'23lambda34._\'23lambda36._\'23lambda39',[]))),_58268018,_58268024,_58268030).

'CPM.Repository.tryReadRepositoryFrom._\'23lambda32._\'23lambda34._\'23lambda36._\'23lambda38'(_58276330,_58276332,_58276334,_58276336):-freeze(_58276334,'blocked_CPM.Repository.tryReadRepositoryFrom._\'23lambda32._\'23lambda34._\'23lambda36._\'23lambda38'(_58276330,_58276332,_58276334,_58276336)).
'blocked_CPM.Repository.tryReadRepositoryFrom._\'23lambda32._\'23lambda34._\'23lambda36._\'23lambda38'(_58276416,_58277512,_58277518,_58277524):-hnf(_58276416,_58281058,_58277518,_58281070),'blocked_CPM.Repository.tryReadRepositoryFrom._\'23lambda32._\'23lambda34._\'23lambda36._\'23lambda38_1'(_58281058,_58277512,_58281070,_58277524).

'blocked_CPM.Repository.tryReadRepositoryFrom._\'23lambda32._\'23lambda34._\'23lambda36._\'23lambda38_1'(_58281840,_58281842,_58281844,_58281846):-freeze(_58281844,'blocked_blocked_CPM.Repository.tryReadRepositoryFrom._\'23lambda32._\'23lambda34._\'23lambda36._\'23lambda38_1'(_58281840,_58281842,_58281844,_58281846)).
'blocked_blocked_CPM.Repository.tryReadRepositoryFrom._\'23lambda32._\'23lambda34._\'23lambda36._\'23lambda38_1'('Prelude.(,)'(_58276532,_58276550),_58282210,_58282216,_58282222):-!,hnf('Prelude.map'('Prelude.apply'('System.FilePath.\'3C\'2F\'3E',_58276532),_58276550),_58282210,_58282216,_58282222).
'blocked_blocked_CPM.Repository.tryReadRepositoryFrom._\'23lambda32._\'23lambda34._\'23lambda36._\'23lambda38_1'('FAIL'(_58283844),'FAIL'(_58283844),_58283858,_58283858):-nonvar(_58283844).

'CPM.Repository.tryReadRepositoryFrom._\'23lambda32._\'23lambda34._\'23lambda36._\'23lambda39'(_58287194,_58287196,_58287198,_58287200):-freeze(_58287198,'blocked_CPM.Repository.tryReadRepositoryFrom._\'23lambda32._\'23lambda34._\'23lambda36._\'23lambda39'(_58287194,_58287196,_58287198,_58287200)).
'blocked_CPM.Repository.tryReadRepositoryFrom._\'23lambda32._\'23lambda34._\'23lambda36._\'23lambda39'(_58287280,_58288310,_58288316,_58288322):-makeShare(_58287308,_58288440),hnf('Prelude.cond'(letrec4PAKCS(_58288440,_58287280),'CPM.ErrorLogger._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23CPM.ErrorLogger.ErrorLogger\'23'('Prelude.$'(partcall(1,'CPM.ErrorLogger._impl\'23return\'23Prelude.Monad\'23CPM.ErrorLogger.ErrorLogger\'23',[]),'Prelude.map'(partcall(1,'Prelude.flip',['CPM.Package.packageSpecFile','System.FilePath.\'3C\'2F\'3E']),_58288440)),partcall(1,'CPM.Repository.tryReadRepositoryFrom._\'23lambda32._\'23lambda34._\'23lambda36._\'23lambda39._\'23lambda41',[]))),_58288310,_58288316,_58288322).

'CPM.Repository.tryReadRepositoryFrom._\'23lambda32._\'23lambda34._\'23lambda36._\'23lambda39._\'23lambda41'(_58296692,_58296694,_58296696,_58296698):-freeze(_58296696,'blocked_CPM.Repository.tryReadRepositoryFrom._\'23lambda32._\'23lambda34._\'23lambda36._\'23lambda39._\'23lambda41'(_58296692,_58296694,_58296696,_58296698)).
'blocked_CPM.Repository.tryReadRepositoryFrom._\'23lambda32._\'23lambda34._\'23lambda36._\'23lambda39._\'23lambda41'(_58296778,_58302470,_58302476,_58302482):-makeShare(_58296806,_58302720),hnf('Prelude.cond'(letrec4PAKCS(_58302720,_58296778),'Prelude.apply'('Prelude.apply'('CPM.ErrorLogger._impl\'23\'3E\'3E\'23Prelude.Monad\'23CPM.ErrorLogger.ErrorLogger\'23','Prelude.apply'('CPM.ErrorLogger.logInfo',['^R','^e','^a','^d','^i','^n','^g','^ ','^r','^e','^p','^o','^s','^i','^t','^o','^r','^y','^ ','^i','^n','^d','^e','^x',^.,^.,^.])),'CPM.ErrorLogger._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23CPM.ErrorLogger.ErrorLogger\'23'('Prelude.$'(partcall(1,'CPM.ErrorLogger.liftIOEL',[]),'Prelude.apply'('Prelude.mapM'(partcall(1,'Prelude._inst\'23Prelude.Monad\'23Prelude.IO\'23',[]),partcall(1,'CPM.Repository.tryReadRepositoryFrom.readPackageFile.65',[])),_58302720)),partcall(1,'CPM.Repository.tryReadRepositoryFrom._\'23lambda32._\'23lambda34._\'23lambda36._\'23lambda39._\'23lambda41._\'23lambda43',[])))),_58302470,_58302476,_58302482).

'CPM.Repository.tryReadRepositoryFrom._\'23lambda32._\'23lambda34._\'23lambda36._\'23lambda39._\'23lambda41._\'23lambda43'(_58318376,_58318378,_58318380,_58318382):-freeze(_58318380,'blocked_CPM.Repository.tryReadRepositoryFrom._\'23lambda32._\'23lambda34._\'23lambda36._\'23lambda39._\'23lambda41._\'23lambda43'(_58318376,_58318378,_58318380,_58318382)).
'blocked_CPM.Repository.tryReadRepositoryFrom._\'23lambda32._\'23lambda34._\'23lambda36._\'23lambda39._\'23lambda41._\'23lambda43'(_58318462,_58324630,_58324636,_58324642):-makeShare(_58318490,_58324916),hnf('Prelude.cond'(letrec4PAKCS(_58324916,_58318462),'Prelude.apply'('Prelude.apply'('CPM.ErrorLogger._impl\'23\'3E\'3E\'23Prelude.Monad\'23CPM.ErrorLogger.ErrorLogger\'23','Prelude.$'(partcall(1,'Control.Applicative.when',['Prelude.null'('Data.Either.lefts'(_58324916)),partcall(1,'CPM.ErrorLogger._inst\'23Prelude.Applicative\'23CPM.ErrorLogger.ErrorLogger\'23',[])]),'Prelude.apply'('CPM.ErrorLogger.logDebug',['^F','^i','^n','^i','^s','^h','^e','^d','^ ','^r','^e','^a','^d','^i','^n','^g','^ ','^r','^e','^p','^o','^s','^i','^t','^o','^r','^y']))),'Prelude.$'(partcall(1,'CPM.ErrorLogger._impl\'23return\'23Prelude.Monad\'23CPM.ErrorLogger.ErrorLogger\'23',[]),'Prelude.(,)'('Prelude.$'('CPM.Repository.Repository','Data.Either.rights'(_58324916)),'Data.Either.lefts'(_58324916))))),_58324630,_58324636,_58324642).

'CPM.Repository.repositoryCacheFilePrefix'(_58338498,_58338500,_58338502,_58338504):-freeze(_58338502,'blocked_CPM.Repository.repositoryCacheFilePrefix'(_58338498,_58338500,_58338502,_58338504)).
'blocked_CPM.Repository.repositoryCacheFilePrefix'(_58338584,_58341484,_58341490,_58341496):-hnf('Prelude.apply'('Prelude.apply'('System.FilePath.\'3C\'2F\'3E','CPM.Config.repositoryDir'(_58338584)),['^R','^E','^P','^O','^S','^I','^T','^O','^R','^Y','^_','^C','^A','^C','^H','^E']),_58341484,_58341490,_58341496).

'CPM.Repository.cleanRepositoryCache'(_58347642,_58347644,_58347646,_58347648):-freeze(_58347646,'blocked_CPM.Repository.cleanRepositoryCache'(_58347642,_58347644,_58347646,_58347648)).
'blocked_CPM.Repository.cleanRepositoryCache'(_58347728,_58356060,_58356066,_58356072):-makeShare(_58347728,_58356354),hnf('Prelude.apply'('Prelude.apply'('CPM.ErrorLogger._impl\'23\'3E\'3E\'23Prelude.Monad\'23CPM.ErrorLogger.ErrorLogger\'23','Prelude.$'('CPM.ErrorLogger.logDebug','Prelude.++'(['^C','^l','^e','^a','^n','^i','^n','^g','^ ','^r','^e','^p','^o','^s','^i','^t','^o','^r','^y','^ ','^c','^a','^c','^h','^e','^ ','^\''],'Prelude.++'('CPM.Repository.repositoryCacheFilePrefix'(_58356354),[^*,'^\''])))),'Prelude.apply'('Prelude.apply'('CPM.ErrorLogger._impl\'23\'3E\'3E\'23Prelude.Monad\'23CPM.ErrorLogger.ErrorLogger\'23','Prelude.$'(partcall(1,'CPM.ErrorLogger.showExecCmd',[]),'Prelude.++'([^/,'^b','^i','^n',^/,'^r','^m','^ ',^-,'^f','^ '],'Prelude.++'('CPM.FileUtil.quote'('CPM.Repository.repositoryCacheFilePrefix'(_58356354)),[^*])))),'CPM.ErrorLogger._impl\'23return\'23Prelude.Monad\'23CPM.ErrorLogger.ErrorLogger\'23'('Prelude.()'))),_58356060,_58356066,_58356072).

'CPM.Repository.readPackageFromRepository'(_58372630,_58372632,_58372634,_58372636,_58372638):-freeze(_58372636,'blocked_CPM.Repository.readPackageFromRepository'(_58372630,_58372632,_58372634,_58372636,_58372638)).
'blocked_CPM.Repository.readPackageFromRepository'(_58372726,_58372744,_58374166,_58374172,_58374178):-makeShare(_58372772,_58374386),makeShare(_58372744,_58374406),hnf('Prelude.cond'(letrec4PAKCS(_58374386,'Prelude.apply'('Prelude.apply'('System.FilePath.\'3C\'2F\'3E','CPM.Config.repositoryDir'(_58372726)),'Prelude.apply'('Prelude.apply'('System.FilePath.\'3C\'2F\'3E','CPM.Package.name'(_58374406)),'CPM.Package.showVersion'('CPM.Package.version'(_58374406))))),'CPM.Package.loadPackageSpec'(_58374386)),_58374166,_58374172,_58374178).

'CPM.Repository.searchPackages._\'23caseor0'(_58380188,_58380190,_58380192,_58380194,_58380196,_58380198,_58380200,_58380202,_58380204):-freeze(_58380202,'blocked_CPM.Repository.searchPackages._\'23caseor0'(_58380188,_58380190,_58380192,_58380194,_58380196,_58380198,_58380200,_58380202,_58380204)).
'blocked_CPM.Repository.searchPackages._\'23caseor0'(_58380324,_58380342,_58380360,_58380378,_58380396,_58380414,_58381988,_58381994,_58382000):-hnf(_58380324,_58383882,_58381994,_58383924),'blocked_CPM.Repository.searchPackages._\'23caseor0_1'(_58383882,_58380342,_58380360,_58380378,_58380396,_58380414,_58381988,_58383924,_58382000).

'blocked_CPM.Repository.searchPackages._\'23caseor0_1'(_58384458,_58384460,_58384462,_58384464,_58384466,_58384468,_58384470,_58384472,_58384474):-freeze(_58384472,freeze(_58384458,'blocked_blocked_CPM.Repository.searchPackages._\'23caseor0_1'(_58384458,_58384460,_58384462,_58384464,_58384466,_58384468,_58384470,_58384472,_58384474))).
'blocked_blocked_CPM.Repository.searchPackages._\'23caseor0_1'('Prelude.True',_58380342,_58380360,_58380378,_58380396,_58380414,_58384892,_58384898,_58384904):-hnf('Prelude.filter'(partcall(1,'CPM.Repository.searchPackages._\'23lambda2',[_58380342]),_58380414),_58384892,_58384898,_58384904).
'blocked_blocked_CPM.Repository.searchPackages._\'23caseor0_1'('Prelude.False',_58380342,_58380360,_58380378,_58380396,_58380414,_58387100,_58387106,_58387112):-!,hnf(_58380360,_58389774,_58387106,_58389810),'blocked_blocked_CPM.Repository.searchPackages._\'23caseor0_1_Prelude.False_2'(_58389774,_58380342,_58380378,_58380396,_58380414,_58387100,_58389810,_58387112).

'blocked_blocked_CPM.Repository.searchPackages._\'23caseor0_1_Prelude.False_2'(_58390498,_58390500,_58390502,_58390504,_58390506,_58390508,_58390510,_58390512):-freeze(_58390510,freeze(_58390498,'blocked_blocked_blocked_CPM.Repository.searchPackages._\'23caseor0_1_Prelude.False_2'(_58390498,_58390500,_58390502,_58390504,_58390506,_58390508,_58390510,_58390512))).
'blocked_blocked_blocked_CPM.Repository.searchPackages._\'23caseor0_1_Prelude.False_2'('Prelude.True',_58380342,_58380378,_58380396,_58380414,_58390922,_58390928,_58390934):-hnf('Prelude.filter'(partcall(1,'CPM.Repository.searchPackages._\'23lambda3',[_58380378,_58380396]),_58380414),_58390922,_58390928,_58390934).
'blocked_blocked_blocked_CPM.Repository.searchPackages._\'23caseor0_1_Prelude.False_2'('Prelude.False',_58380342,_58380378,_58380396,_58380414,_58392928,_58392934,_58392940):-!,hnf('Prelude.filter'(partcall(1,'CPM.Repository.searchPackages.matches.16',[_58380396,_58380378]),_58380414),_58392928,_58392934,_58392940).
'blocked_blocked_blocked_CPM.Repository.searchPackages._\'23caseor0_1_Prelude.False_2'('FAIL'(_58394636),_58380342,_58380378,_58380396,_58380414,'FAIL'(_58394636),_58394650,_58394650).
'blocked_blocked_CPM.Repository.searchPackages._\'23caseor0_1'('FAIL'(_58394734),_58380342,_58380360,_58380378,_58380396,_58380414,'FAIL'(_58394734),_58394748,_58394748).

'CPM.Repository.tryReadRepositoryFrom.readPackageFile.65._\'23lambda22._\'23caseor0'(_58397912,_58397914,_58397916,_58397918,_58397920):-freeze(_58397918,'blocked_CPM.Repository.tryReadRepositoryFrom.readPackageFile.65._\'23lambda22._\'23caseor0'(_58397912,_58397914,_58397916,_58397918,_58397920)).
'blocked_CPM.Repository.tryReadRepositoryFrom.readPackageFile.65._\'23lambda22._\'23caseor0'(_58398008,_58398026,_58402660,_58402666,_58402672):-hnf(_58398008,_58405926,_58402666,_58405944),'blocked_CPM.Repository.tryReadRepositoryFrom.readPackageFile.65._\'23lambda22._\'23caseor0_1'(_58405926,_58398026,_58402660,_58405944,_58402672).

'blocked_CPM.Repository.tryReadRepositoryFrom.readPackageFile.65._\'23lambda22._\'23caseor0_1'(_58406680,_58406682,_58406684,_58406686,_58406688):-freeze(_58406686,freeze(_58406680,'blocked_blocked_CPM.Repository.tryReadRepositoryFrom.readPackageFile.65._\'23lambda22._\'23caseor0_1'(_58406680,_58406682,_58406684,_58406686,_58406688))).
'blocked_blocked_CPM.Repository.tryReadRepositoryFrom.readPackageFile.65._\'23lambda22._\'23caseor0_1'('Prelude.Left'(_58398142),_58398026,_58407084,_58407090,_58407096):-hnf('Prelude.$'('Prelude.Left','Prelude.++'(['^P','^r','^o','^b','^l','^e','^m','^ ','^r','^e','^a','^d','^i','^n','^g','^ ','^\''],'Prelude.++'(_58398026,'Prelude.++'(['^\'',^:,'^ '],_58398142)))),_58407084,_58407090,_58407096).
'blocked_blocked_CPM.Repository.tryReadRepositoryFrom.readPackageFile.65._\'23lambda22._\'23caseor0_1'('Prelude.Right'(_58401990),_58398026,'Prelude.Right'(_58401990),_58413698,_58413698):-!.
'blocked_blocked_CPM.Repository.tryReadRepositoryFrom.readPackageFile.65._\'23lambda22._\'23caseor0_1'('FAIL'(_58414724),_58398026,'FAIL'(_58414724),_58414738,_58414738).

'CPM.Repository.tryReadRepositoryFrom.getDir.65._\'23lambda25._\'23caseor0'(_58417528,_58417530,_58417532,_58417534,_58417536):-freeze(_58417534,'blocked_CPM.Repository.tryReadRepositoryFrom.getDir.65._\'23lambda25._\'23caseor0'(_58417528,_58417530,_58417532,_58417534,_58417536)).
'blocked_CPM.Repository.tryReadRepositoryFrom.getDir.65._\'23lambda25._\'23caseor0'(_58417624,_58417642,_58418534,_58418540,_58418546):-hnf(_58417624,_58421476,_58418540,_58421494),'blocked_CPM.Repository.tryReadRepositoryFrom.getDir.65._\'23lambda25._\'23caseor0_1'(_58421476,_58417642,_58418534,_58421494,_58418546).

'blocked_CPM.Repository.tryReadRepositoryFrom.getDir.65._\'23lambda25._\'23caseor0_1'(_58422176,_58422178,_58422180,_58422182,_58422184):-freeze(_58422182,freeze(_58422176,'blocked_blocked_CPM.Repository.tryReadRepositoryFrom.getDir.65._\'23lambda25._\'23caseor0_1'(_58422176,_58422178,_58422180,_58422182,_58422184))).
'blocked_blocked_CPM.Repository.tryReadRepositoryFrom.getDir.65._\'23lambda25._\'23caseor0_1'('Prelude.True',_58417642,[_58417642],_58422576,_58422576).
'blocked_blocked_CPM.Repository.tryReadRepositoryFrom.getDir.65._\'23lambda25._\'23caseor0_1'('Prelude.False',_58417642,[],_58423812,_58423812):-!.
'blocked_blocked_CPM.Repository.tryReadRepositoryFrom.getDir.65._\'23lambda25._\'23caseor0_1'('FAIL'(_58424542),_58417642,'FAIL'(_58424542),_58424556,_58424556).

:-costCenters(['']).




%%%%% Number of shared variables: 33

