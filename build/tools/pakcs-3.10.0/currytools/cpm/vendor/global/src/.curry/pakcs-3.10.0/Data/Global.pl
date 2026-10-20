%PAKCS3.10 swi9 VARIABLESHARING

:-noSingletonWarnings.
:-noRedefineWarnings.
:-noDiscontiguousWarnings.

:-importModule('Control.Monad').
:-importModule('Prelude').
:-importModule('System.Directory').
:-importModule('System.IO').
:-importModule('System.IO.Unsafe').
:-importModule('System.IOExts').

:-curryModule('Data.Global').


%%%%%%%%%%%% function types %%%%%%%%%%%%%%%%%%%
:-multifile functiontype/6.
:-dynamic functiontype/6.
functiontype('Data.Global._inst\'23Prelude.Data\'23Data.Global.GlobalT\'230\'23\'23','_inst#Prelude.Data#Data.Global.GlobalT#0##',1,'Data.Global._inst\'23Prelude.Data\'23Data.Global.GlobalT\'230\'23\'23',nofix,notype).
functiontype('Data.Global._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Global.GlobalT\'230\'23\'23','_impl#===#Prelude.Data#Data.Global.GlobalT#0##',2,'Data.Global._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Global.GlobalT\'230\'23\'23',nofix,notype).
functiontype('Data.Global._impl\'23aValue\'23Prelude.Data\'23Data.Global.GlobalT\'230\'23\'23','_impl#aValue#Prelude.Data#Data.Global.GlobalT#0##',0,'Data.Global._impl\'23aValue\'23Prelude.Data\'23Data.Global.GlobalT\'230\'23\'23',nofix,notype).
functiontype('Data.Global._inst\'23Prelude.Data\'23Data.Global.GlobalP\'230\'23\'23','_inst#Prelude.Data#Data.Global.GlobalP#0##',1,'Data.Global._inst\'23Prelude.Data\'23Data.Global.GlobalP\'230\'23\'23',nofix,notype).
functiontype('Data.Global._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Global.GlobalP\'230\'23\'23','_impl#===#Prelude.Data#Data.Global.GlobalP#0##',2,'Data.Global._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Global.GlobalP\'230\'23\'23',nofix,notype).
functiontype('Data.Global._impl\'23aValue\'23Prelude.Data\'23Data.Global.GlobalP\'230\'23\'23','_impl#aValue#Prelude.Data#Data.Global.GlobalP#0##',0,'Data.Global._impl\'23aValue\'23Prelude.Data\'23Data.Global.GlobalP\'230\'23\'23',nofix,notype).
functiontype('Data.Global.globalT',globalT,2,'Data.Global.globalT',nofix,notype).
functiontype('Data.Global.prim_globalT','Data.Global.prim_globalT',2,'Data.Global.prim_globalT',nofix,notype).
functiontype('Data.Global.readGlobalT',readGlobalT,1,'Data.Global.readGlobalT',nofix,notype).
functiontype('Data.Global.prim_readGlobalT','Data.Global.prim_readGlobalT',1,'Data.Global.prim_readGlobalT',nofix,notype).
functiontype('Data.Global.writeGlobalT',writeGlobalT,2,'Data.Global.writeGlobalT',nofix,notype).
functiontype('Data.Global.prim_writeGlobalT','Data.Global.prim_writeGlobalT',2,'Data.Global.prim_writeGlobalT',nofix,notype).
functiontype('Data.Global.globalP',globalP,4,'Data.Global.globalP',nofix,notype).
functiontype('Data.Global.globalP._\'23lambda2','Data.Global.globalP._#lambda2',4,'Data.Global.globalP._\'23lambda2',nofix,notype).
functiontype('Data.Global.globalPersistent',globalPersistent,2,'Data.Global.globalPersistent',nofix,notype).
functiontype('Data.Global.readGlobalP',readGlobalP,2,'Data.Global.readGlobalP',nofix,notype).
functiontype('Data.Global.readGlobalP._\'23lambda5','Data.Global.readGlobalP._#lambda5',3,'Data.Global.readGlobalP._\'23lambda5',nofix,notype).
functiontype('Data.Global.safeReadGlobalP',safeReadGlobalP,4,'Data.Global.safeReadGlobalP',nofix,notype).
functiontype('Data.Global.safeReadGlobalP._\'23lambda8','Data.Global.safeReadGlobalP._#lambda8',4,'Data.Global.safeReadGlobalP._\'23lambda8',nofix,notype).
functiontype('Data.Global.writeGlobalP',writeGlobalP,3,'Data.Global.writeGlobalP',nofix,notype).
functiontype('Data.Global.readGlobalP._\'23lambda5._\'23caseor0','Data.Global.readGlobalP._#lambda5._#caseor0',3,'Data.Global.readGlobalP._\'23lambda5._\'23caseor0',nofix,notype).

%%%%%%%%%%%% constructor types %%%%%%%%%%%%%%%%%%%
:-multifile constructortype/7.
:-dynamic constructortype/7.
constructortype('Data.Global.GlobalT','Data.Global.GlobalT',1,'Global.GlobalT',0,notype,[]).
constructortype('Data.Global.GlobalP','Data.Global.GlobalP',1,'Global.GlobalP',0,notype,[]).

%%%%%%%%%%%% function definitions %%%%%%%%%%%%%%%%%%%
'Data.Global._inst\'23Prelude.Data\'23Data.Global.GlobalT\'230\'23\'23'(_44221594,_44221596,_44221598,_44221600):-freeze(_44221598,'blocked_Data.Global._inst\'23Prelude.Data\'23Data.Global.GlobalT\'230\'23\'23'(_44221594,_44221596,_44221598,_44221600)).
'blocked_Data.Global._inst\'23Prelude.Data\'23Data.Global.GlobalT\'230\'23\'23'(_44221680,_44222444,_44222450,_44222456):-hnf(_44221680,_44225126,_44222450,_44225138),'blocked_Data.Global._inst\'23Prelude.Data\'23Data.Global.GlobalT\'230\'23\'23_1'(_44225126,_44222444,_44225138,_44222456).

'blocked_Data.Global._inst\'23Prelude.Data\'23Data.Global.GlobalT\'230\'23\'23_1'(_44225764,_44225766,_44225768,_44225770):-freeze(_44225768,'blocked_blocked_Data.Global._inst\'23Prelude.Data\'23Data.Global.GlobalT\'230\'23\'23_1'(_44225764,_44225766,_44225768,_44225770)).
'blocked_blocked_Data.Global._inst\'23Prelude.Data\'23Data.Global.GlobalT\'230\'23\'23_1'('Prelude.()','Prelude._Dict\'23Data'(partcall(2,'Data.Global._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Global.GlobalT\'230\'23\'23',[]),'Data.Global._impl\'23aValue\'23Prelude.Data\'23Data.Global.GlobalT\'230\'23\'23'),_44226116,_44226116):-!.
'blocked_blocked_Data.Global._inst\'23Prelude.Data\'23Data.Global.GlobalT\'230\'23\'23_1'('FAIL'(_44227974),'FAIL'(_44227974),_44227988,_44227988):-nonvar(_44227974).

'Data.Global._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Global.GlobalT\'230\'23\'23'(_44230656,_44230658,_44230660,_44230662,_44230664):-freeze(_44230662,'blocked_Data.Global._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Global.GlobalT\'230\'23\'23'(_44230656,_44230658,_44230660,_44230662,_44230664)).
'blocked_Data.Global._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Global.GlobalT\'230\'23\'23'(_44230752,_44230770,_44231814,_44231820,_44231826):-hnf(_44230752,_44234936,_44231820,_44234954),'blocked_Data.Global._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Global.GlobalT\'230\'23\'23_1'(_44234936,_44230770,_44231814,_44234954,_44231826).

'blocked_Data.Global._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Global.GlobalT\'230\'23\'23_1'(_44235660,_44235662,_44235664,_44235666,_44235668):-freeze(_44235666,'blocked_blocked_Data.Global._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Global.GlobalT\'230\'23\'23_1'(_44235660,_44235662,_44235664,_44235666,_44235668)).
'blocked_blocked_Data.Global._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Global.GlobalT\'230\'23\'23_1'('Data.Global.GlobalT'(_44230886),_44230770,_44236744,_44236750,_44236756):-!,hnf(_44230770,_44240826,_44236750,_44240844),'blocked_blocked_Data.Global._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Global.GlobalT\'230\'23\'23_1_Data.Global.GlobalT_2'(_44240826,_44230886,_44236744,_44240844,_44236756).

'blocked_blocked_Data.Global._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Global.GlobalT\'230\'23\'23_1_Data.Global.GlobalT_2'(_44241748,_44241750,_44241752,_44241754,_44241756):-freeze(_44241754,'blocked_blocked_blocked_Data.Global._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Global.GlobalT\'230\'23\'23_1_Data.Global.GlobalT_2'(_44241748,_44241750,_44241752,_44241754,_44241756)).
'blocked_blocked_blocked_Data.Global._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Global.GlobalT\'230\'23\'23_1_Data.Global.GlobalT_2'('Data.Global.GlobalT'(_44231008),_44230886,_44242230,_44242236,_44242242):-!,hnf('Prelude._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Data\'23Prelude.Char\'23',[]),_44230886,_44231008),_44242230,_44242236,_44242242).
'blocked_blocked_blocked_Data.Global._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Global.GlobalT\'230\'23\'23_1_Data.Global.GlobalT_2'('FAIL'(_44244218),_44230886,'FAIL'(_44244218),_44244232,_44244232):-nonvar(_44244218).
'blocked_blocked_Data.Global._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Global.GlobalT\'230\'23\'23_1'('FAIL'(_44244296),_44230770,'FAIL'(_44244296),_44244310,_44244310):-nonvar(_44244296).

'Data.Global._impl\'23aValue\'23Prelude.Data\'23Data.Global.GlobalT\'230\'23\'23'(_44247672,_44247674,_44247676):-freeze(_44247674,'blocked_Data.Global._impl\'23aValue\'23Prelude.Data\'23Data.Global.GlobalT\'230\'23\'23'(_44247672,_44247674,_44247676)).
'blocked_Data.Global._impl\'23aValue\'23Prelude.Data\'23Data.Global.GlobalT\'230\'23\'23'('Data.Global.GlobalT'('Prelude._impl\'23aValue\'23Prelude.Data\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Data\'23Prelude.Char\'23',[]))),_44247934,_44247934).

'Data.Global._inst\'23Prelude.Data\'23Data.Global.GlobalP\'230\'23\'23'(_44251832,_44251834,_44251836,_44251838):-freeze(_44251836,'blocked_Data.Global._inst\'23Prelude.Data\'23Data.Global.GlobalP\'230\'23\'23'(_44251832,_44251834,_44251836,_44251838)).
'blocked_Data.Global._inst\'23Prelude.Data\'23Data.Global.GlobalP\'230\'23\'23'(_44251918,_44252682,_44252688,_44252694):-hnf(_44251918,_44255364,_44252688,_44255376),'blocked_Data.Global._inst\'23Prelude.Data\'23Data.Global.GlobalP\'230\'23\'23_1'(_44255364,_44252682,_44255376,_44252694).

'blocked_Data.Global._inst\'23Prelude.Data\'23Data.Global.GlobalP\'230\'23\'23_1'(_44256002,_44256004,_44256006,_44256008):-freeze(_44256006,'blocked_blocked_Data.Global._inst\'23Prelude.Data\'23Data.Global.GlobalP\'230\'23\'23_1'(_44256002,_44256004,_44256006,_44256008)).
'blocked_blocked_Data.Global._inst\'23Prelude.Data\'23Data.Global.GlobalP\'230\'23\'23_1'('Prelude.()','Prelude._Dict\'23Data'(partcall(2,'Data.Global._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Global.GlobalP\'230\'23\'23',[]),'Data.Global._impl\'23aValue\'23Prelude.Data\'23Data.Global.GlobalP\'230\'23\'23'),_44256354,_44256354):-!.
'blocked_blocked_Data.Global._inst\'23Prelude.Data\'23Data.Global.GlobalP\'230\'23\'23_1'('FAIL'(_44258212),'FAIL'(_44258212),_44258226,_44258226):-nonvar(_44258212).

'Data.Global._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Global.GlobalP\'230\'23\'23'(_44260894,_44260896,_44260898,_44260900,_44260902):-freeze(_44260900,'blocked_Data.Global._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Global.GlobalP\'230\'23\'23'(_44260894,_44260896,_44260898,_44260900,_44260902)).
'blocked_Data.Global._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Global.GlobalP\'230\'23\'23'(_44260990,_44261008,_44262052,_44262058,_44262064):-hnf(_44260990,_44265174,_44262058,_44265192),'blocked_Data.Global._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Global.GlobalP\'230\'23\'23_1'(_44265174,_44261008,_44262052,_44265192,_44262064).

'blocked_Data.Global._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Global.GlobalP\'230\'23\'23_1'(_44265898,_44265900,_44265902,_44265904,_44265906):-freeze(_44265904,'blocked_blocked_Data.Global._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Global.GlobalP\'230\'23\'23_1'(_44265898,_44265900,_44265902,_44265904,_44265906)).
'blocked_blocked_Data.Global._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Global.GlobalP\'230\'23\'23_1'('Data.Global.GlobalP'(_44261124),_44261008,_44266982,_44266988,_44266994):-!,hnf(_44261008,_44271064,_44266988,_44271082),'blocked_blocked_Data.Global._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Global.GlobalP\'230\'23\'23_1_Data.Global.GlobalP_2'(_44271064,_44261124,_44266982,_44271082,_44266994).

'blocked_blocked_Data.Global._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Global.GlobalP\'230\'23\'23_1_Data.Global.GlobalP_2'(_44271986,_44271988,_44271990,_44271992,_44271994):-freeze(_44271992,'blocked_blocked_blocked_Data.Global._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Global.GlobalP\'230\'23\'23_1_Data.Global.GlobalP_2'(_44271986,_44271988,_44271990,_44271992,_44271994)).
'blocked_blocked_blocked_Data.Global._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Global.GlobalP\'230\'23\'23_1_Data.Global.GlobalP_2'('Data.Global.GlobalP'(_44261246),_44261124,_44272468,_44272474,_44272480):-!,hnf('Prelude._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Data\'23Prelude.Char\'23',[]),_44261124,_44261246),_44272468,_44272474,_44272480).
'blocked_blocked_blocked_Data.Global._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Global.GlobalP\'230\'23\'23_1_Data.Global.GlobalP_2'('FAIL'(_44274456),_44261124,'FAIL'(_44274456),_44274470,_44274470):-nonvar(_44274456).
'blocked_blocked_Data.Global._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Data.Global.GlobalP\'230\'23\'23_1'('FAIL'(_44274534),_44261008,'FAIL'(_44274534),_44274548,_44274548):-nonvar(_44274534).

'Data.Global._impl\'23aValue\'23Prelude.Data\'23Data.Global.GlobalP\'230\'23\'23'(_44277254,_44277256,_44277258):-freeze(_44277256,'blocked_Data.Global._impl\'23aValue\'23Prelude.Data\'23Data.Global.GlobalP\'230\'23\'23'(_44277254,_44277256,_44277258)).
'blocked_Data.Global._impl\'23aValue\'23Prelude.Data\'23Data.Global.GlobalP\'230\'23\'23'('Data.Global.GlobalP'('Prelude._impl\'23aValue\'23Prelude.Data\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Data\'23Prelude.Char\'23',[]))),_44277516,_44277516).

'Data.Global.globalT'(_44279916,_44279918,_44279920,_44279922,_44279924):-freeze(_44279922,'blocked_Data.Global.globalT'(_44279916,_44279918,_44279920,_44279922,_44279924)).
'blocked_Data.Global.globalT'(_44280012,_44280030,_44280368,_44280374,_44280380):-hnf('Prelude.apply'('Prelude.$##'(partcall(2,'Data.Global.prim_globalT',[]),_44280012),_44280030),_44280368,_44280374,_44280380).

'Data.Global.prim_globalT'(_44282034,_44282036,_44282038,_44282040,_44282042):-freeze(_44282040,'blocked_Data.Global.prim_globalT'(_44282034,_44282036,_44282038,_44282040,_44282042)).
'blocked_Data.Global.prim_globalT'(_44282124,_44282130,_44282136,_44282142,_44282148):-derefAll(_44282124,_44282194),derefAll(_44282130,_44282200),'Data.Global.prim_globalT'(_44282194,_44282200,_44282136),_44282142=_44282148.

'Data.Global.readGlobalT'(_44283344,_44283346,_44283348,_44283350):-freeze(_44283348,'blocked_Data.Global.readGlobalT'(_44283344,_44283346,_44283348,_44283350)).
'blocked_Data.Global.readGlobalT'(_44283430,_44283614,_44283620,_44283626):-hnf('Prelude.$#'(partcall(1,'Data.Global.prim_readGlobalT',[]),_44283430),_44283614,_44283620,_44283626).

'Data.Global.prim_readGlobalT'(_44284706,partcall(1,'Data.Global.prim_readGlobalT$WORLD',[_44284706]),_44285114,_44285114).
'Data.Global.prim_readGlobalT$WORLD'(_44285470,_44285472,_44285474,_44285476,_44285478):-freeze(_44285476,'blocked_Data.Global.prim_readGlobalT$WORLD'(_44285470,_44285472,_44285474,_44285476,_44285478)).
'blocked_Data.Global.prim_readGlobalT$WORLD'(_44285560,_44285566,'$io'(_44285578),_44285582,_44285114):-derefAll(_44285560,_44284706),'Data.Global.prim_readGlobalT'(_44284706,_44285578),_44285582=_44285114.

'Data.Global.writeGlobalT'(_44286758,_44286760,_44286762,_44286764,_44286766):-freeze(_44286764,'blocked_Data.Global.writeGlobalT'(_44286758,_44286760,_44286762,_44286764,_44286766)).
'blocked_Data.Global.writeGlobalT'(_44286854,_44286872,_44287210,_44287216,_44287222):-hnf('Prelude.$##'('Prelude.$#'(partcall(2,'Data.Global.prim_writeGlobalT',[]),_44286854),_44286872),_44287210,_44287216,_44287222).

'Data.Global.prim_writeGlobalT'(_44288762,_44288768,partcall(1,'Data.Global.prim_writeGlobalT$WORLD',[_44288768,_44288762]),_44289194,_44289194).
'Data.Global.prim_writeGlobalT$WORLD'(_44289564,_44289566,_44289568,_44289570,_44289572,_44289574):-freeze(_44289572,'blocked_Data.Global.prim_writeGlobalT$WORLD'(_44289564,_44289566,_44289568,_44289570,_44289572,_44289574)).
'blocked_Data.Global.prim_writeGlobalT$WORLD'(_44289664,_44289670,_44289676,'$io'(_44289688),_44289692,_44289194):-derefAll(_44289664,_44288762),derefAll(_44289670,_44288768),'Data.Global.prim_writeGlobalT'(_44288762,_44288768,_44289688),_44289692=_44289194.

'Data.Global.globalP'(_44290726,_44290728,_44290730,_44290732,_44290734,_44290736,_44290738):-freeze(_44290736,'blocked_Data.Global.globalP'(_44290726,_44290728,_44290730,_44290732,_44290734,_44290736,_44290738)).
'blocked_Data.Global.globalP'(_44290842,_44290860,_44290878,_44290896,_44291710,_44291716,_44291722):-makeShare(_44290878,_44291896),hnf('Prelude.$'(partcall(1,'System.IO.Unsafe.unsafePerformIO',[]),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','System.Directory.doesFileExist'(_44291896)),partcall(1,'Data.Global.globalP._\'23lambda2',[_44290860,_44291896,_44290896]))),_44291710,_44291716,_44291722).

'Data.Global.globalP._\'23lambda2'(_44296028,_44296030,_44296032,_44296034,_44296036,_44296038,_44296040):-freeze(_44296038,'blocked_Data.Global.globalP._\'23lambda2'(_44296028,_44296030,_44296032,_44296034,_44296036,_44296038,_44296040)).
'blocked_Data.Global.globalP._\'23lambda2'(_44296144,_44296162,_44296180,_44296198,_44297760,_44297766,_44297772):-makeShare(_44296226,_44298120),makeShare(_44296162,_44298140),hnf('Prelude.cond'(letrec4PAKCS(_44298120,_44296198),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'23Prelude.Monad\'23Prelude.IO\'23','Prelude.$'(partcall(1,'Control.Monad.unless',[_44298120,partcall(1,'Prelude._inst\'23Prelude.Applicative\'23Prelude.IO\'23',[])]),'Data.Global.writeGlobalP'(_44296180,'Data.Global.GlobalP'(_44298140),_44296144))),'Prelude.$'('Prelude._impl\'23return\'23Prelude.Monad\'23Prelude.IO\'23','Data.Global.GlobalP'(_44298140)))),_44297760,_44297766,_44297772).

'Data.Global.globalPersistent'(_44304270,_44304272,_44304274,_44304276,_44304278):-freeze(_44304276,'blocked_Data.Global.globalPersistent'(_44304270,_44304272,_44304274,_44304276,_44304278)).
'blocked_Data.Global.globalPersistent'(_44304366,_44304384,_44304554,_44304560,_44304566):-hnf(partcall(2,'Data.Global.globalP',[_44304384,_44304366]),_44304554,_44304560,_44304566).

'Data.Global.readGlobalP'(_44306372,_44306374,_44306376,_44306378,_44306380):-freeze(_44306378,'blocked_Data.Global.readGlobalP'(_44306372,_44306374,_44306376,_44306378,_44306380)).
'blocked_Data.Global.readGlobalP'(_44306468,_44306486,_44309010,_44309016,_44309022):-hnf(_44306486,_44310224,_44309016,_44310242),'blocked_Data.Global.readGlobalP_2'(_44310224,_44306468,_44309010,_44310242,_44309022).

'blocked_Data.Global.readGlobalP_2'(_44310630,_44310632,_44310634,_44310636,_44310638):-freeze(_44310636,'blocked_blocked_Data.Global.readGlobalP_2'(_44310630,_44310632,_44310634,_44310636,_44310638)).
'blocked_blocked_Data.Global.readGlobalP_2'('Data.Global.GlobalP'(_44306602),_44306468,_44311112,_44311118,_44311124):-!,makeShare(_44306602,_44311292),hnf('Prelude.$'(partcall(1,'System.IOExts.exclusiveIO',['Prelude.++'(_44311292,[^.,'^L','^O','^C','^K'])]),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','System.IO.openFile'(_44311292,'System.IO.ReadMode')),partcall(1,'System.IO.hGetContents',[]))),partcall(1,'Data.Global.readGlobalP._\'23lambda5',[_44306468,_44311292]))),_44311112,_44311118,_44311124).
'blocked_blocked_Data.Global.readGlobalP_2'('FAIL'(_44316650),_44306468,'FAIL'(_44316650),_44316664,_44316664):-nonvar(_44316650).

'Data.Global.readGlobalP._\'23lambda5'(_44318138,_44318140,_44318142,_44318144,_44318146,_44318148):-freeze(_44318146,'blocked_Data.Global.readGlobalP._\'23lambda5'(_44318138,_44318140,_44318142,_44318144,_44318146,_44318148)).
'blocked_Data.Global.readGlobalP._\'23lambda5'(_44318244,_44318262,_44318280,_44319100,_44319106,_44319112):-makeShare(_44318308,_44319338),hnf('Prelude.cond'(letrec4PAKCS(_44319338,_44318280),'Data.Global.readGlobalP._\'23lambda5._\'23caseor0'('Prelude.apply'('Prelude.reads'(_44318262),_44319338),_44318244,_44319338)),_44319100,_44319106,_44319112).

'Data.Global.safeReadGlobalP'(_44322850,_44322852,_44322854,_44322856,_44322858,_44322860,_44322862):-freeze(_44322860,'blocked_Data.Global.safeReadGlobalP'(_44322850,_44322852,_44322854,_44322856,_44322858,_44322860,_44322862)).
'blocked_Data.Global.safeReadGlobalP'(_44322966,_44322984,_44323002,_44323020,_44323568,_44323574,_44323580):-makeShare(_44323002,_44323808),hnf('Prelude.catch'('Data.Global.readGlobalP'(_44322966,_44323808),partcall(1,'Data.Global.safeReadGlobalP._\'23lambda8',[_44322984,_44323808,_44323020])),_44323568,_44323574,_44323580).

'Data.Global.safeReadGlobalP._\'23lambda8'(_44327234,_44327236,_44327238,_44327240,_44327242,_44327244,_44327246):-freeze(_44327244,'blocked_Data.Global.safeReadGlobalP._\'23lambda8'(_44327234,_44327236,_44327238,_44327240,_44327242,_44327244,_44327246)).
'blocked_Data.Global.safeReadGlobalP._\'23lambda8'(_44327350,_44327368,_44327386,_44327404,_44334350,_44334356,_44334362):-makeShare(_44327350,_44334778),hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'23Prelude.Monad\'23Prelude.IO\'23','Prelude.$'(partcall(1,'System.IO.hPutStrLn',['System.IO.stderr']),'Prelude.++'(['^E','^r','^r','^o','^r','^ ','^c','^a','^u','^g','^h','^t','^ ','^i','^n','^ ','^\'','^s','^a','^f','^e','^R','^e','^a','^d','^G','^l','^o','^b','^a','^l','^P','^\'',^:,'^010'],'Prelude._impl\'23show\'23Prelude.Show\'23Prelude.IOError\'23'(_44327404)))),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'23Prelude.Monad\'23Prelude.IO\'23','Data.Global.writeGlobalP'(_44327386,_44327368,_44334778)),'Prelude.apply'('Prelude._impl\'23return\'23Prelude.Monad\'23Prelude.IO\'23',_44334778))),_44334350,_44334356,_44334362).

'Data.Global.writeGlobalP'(_44347806,_44347808,_44347810,_44347812,_44347814,_44347816):-freeze(_44347814,'blocked_Data.Global.writeGlobalP'(_44347806,_44347808,_44347810,_44347812,_44347814,_44347816)).
'blocked_Data.Global.writeGlobalP'(_44347912,_44347930,_44347948,_44350212,_44350218,_44350224):-hnf(_44347930,_44351470,_44350218,_44351494),'blocked_Data.Global.writeGlobalP_2'(_44351470,_44347912,_44347948,_44350212,_44351494,_44350224).

'blocked_Data.Global.writeGlobalP_2'(_44351896,_44351898,_44351900,_44351902,_44351904,_44351906):-freeze(_44351904,'blocked_blocked_Data.Global.writeGlobalP_2'(_44351896,_44351898,_44351900,_44351902,_44351904,_44351906)).
'blocked_blocked_Data.Global.writeGlobalP_2'('Data.Global.GlobalP'(_44348064),_44347912,_44347948,_44352388,_44352394,_44352400):-!,makeShare(_44348064,_44352594),hnf('Prelude.$'(partcall(1,'System.IOExts.exclusiveIO',['Prelude.++'(_44352594,[^.,'^L','^O','^C','^K'])]),'Prelude.writeFile'(_44352594,'Prelude.++'('Prelude.apply'('Prelude.show'(_44347912),_44347948),['^010']))),_44352388,_44352394,_44352400).
'blocked_blocked_Data.Global.writeGlobalP_2'('FAIL'(_44356496),_44347912,_44347948,'FAIL'(_44356496),_44356510,_44356510):-nonvar(_44356496).

'Data.Global.readGlobalP._\'23lambda5._\'23caseor0'(_44358400,_44358402,_44358404,_44358406,_44358408,_44358410):-freeze(_44358408,'blocked_Data.Global.readGlobalP._\'23lambda5._\'23caseor0'(_44358400,_44358402,_44358404,_44358406,_44358408,_44358410)).
'blocked_Data.Global.readGlobalP._\'23lambda5._\'23caseor0'(_44358506,_44358524,_44358542,_44380126,_44380132,_44380138):-hnf(_44358506,_44382212,_44380132,_44382236),'blocked_Data.Global.readGlobalP._\'23lambda5._\'23caseor0_1'(_44382212,_44358524,_44358542,_44380126,_44382236,_44380138).

'blocked_Data.Global.readGlobalP._\'23lambda5._\'23caseor0_1'(_44382782,_44382784,_44382786,_44382788,_44382790,_44382792):-freeze(_44382790,freeze(_44382782,'blocked_blocked_Data.Global.readGlobalP._\'23lambda5._\'23caseor0_1'(_44382782,_44382784,_44382786,_44382788,_44382790,_44382792))).
'blocked_blocked_Data.Global.readGlobalP._\'23lambda5._\'23caseor0_1'([_44358658|_44358676],_44358524,_44358542,_44383498,_44383504,_44383510):-hnf(_44358658,_44386064,_44383504,_44386094),'blocked_blocked_Data.Global.readGlobalP._\'23lambda5._\'23caseor0_1_[|]_1'(_44386064,_44358676,_44358524,_44358542,_44383498,_44386094,_44383510).

'blocked_blocked_Data.Global.readGlobalP._\'23lambda5._\'23caseor0_1_[|]_1'(_44386732,_44386734,_44386736,_44386738,_44386740,_44386742,_44386744):-freeze(_44386742,freeze(_44386732,'blocked_blocked_blocked_Data.Global.readGlobalP._\'23lambda5._\'23caseor0_1_[|]_1'(_44386732,_44386734,_44386736,_44386738,_44386740,_44386742,_44386744))).
'blocked_blocked_blocked_Data.Global.readGlobalP._\'23lambda5._\'23caseor0_1_[|]_1'('Prelude.(,)'(_44358804,_44358822),_44358676,_44358524,_44358542,_44387658,_44387664,_44387670):-!,hnf(_44358676,_44390976,_44387664,_44391012),'blocked_blocked_blocked_Data.Global.readGlobalP._\'23lambda5._\'23caseor0_1_[|]_1_Prelude.(,)_3'(_44390976,_44358804,_44358822,_44358524,_44358542,_44387658,_44391012,_44387670).

'blocked_blocked_blocked_Data.Global.readGlobalP._\'23lambda5._\'23caseor0_1_[|]_1_Prelude.(,)_3'(_44391808,_44391810,_44391812,_44391814,_44391816,_44391818,_44391820,_44391822):-freeze(_44391820,freeze(_44391808,'blocked_blocked_blocked_blocked_Data.Global.readGlobalP._\'23lambda5._\'23caseor0_1_[|]_1_Prelude.(,)_3'(_44391808,_44391810,_44391812,_44391814,_44391816,_44391818,_44391820,_44391822))).
'blocked_blocked_blocked_blocked_Data.Global.readGlobalP._\'23lambda5._\'23caseor0_1_[|]_1_Prelude.(,)_3'([],_44358804,_44358822,_44358524,_44358542,_44392096,_44392102,_44392108):-hnf('Prelude.apply'('Prelude._impl\'23return\'23Prelude.Monad\'23Prelude.IO\'23',_44358804),_44392096,_44392102,_44392108).
'blocked_blocked_blocked_blocked_Data.Global.readGlobalP._\'23lambda5._\'23caseor0_1_[|]_1_Prelude.(,)_3'([_44359204|_44359222],_44358804,_44358822,_44358524,_44358542,_44393934,_44393940,_44393946):-!,hnf('Prelude.$'(partcall(1,'Prelude.error',[]),'Prelude.++'(['^C','^a','^n','^n','^o','^t','^ ','^r','^e','^a','^d','^ ','^p','^e','^r','^s','^i','^s','^t','^e','^n','^t','^ ','^g','^l','^o','^b','^a','^l','^ ','^e','^n','^t','^i','^t','^y','^ ','^i','^n','^ ','^f','^i','^l','^e',^:,'^ '],'Prelude.++'(_44358524,'Prelude.++'(['^010','^F','^i','^l','^e','^ ','^c','^o','^n','^t','^e','^n','^t','^s',^:,'^010'],_44358542)))),_44393934,_44393940,_44393946).
'blocked_blocked_blocked_blocked_Data.Global.readGlobalP._\'23lambda5._\'23caseor0_1_[|]_1_Prelude.(,)_3'('FAIL'(_44409064),_44358804,_44358822,_44358524,_44358542,'FAIL'(_44409064),_44409078,_44409078).
'blocked_blocked_blocked_Data.Global.readGlobalP._\'23lambda5._\'23caseor0_1_[|]_1'('FAIL'(_44409162),_44358676,_44358524,_44358542,'FAIL'(_44409162),_44409176,_44409176).
'blocked_blocked_Data.Global.readGlobalP._\'23lambda5._\'23caseor0_1'([],_44358524,_44358542,_44409414,_44409420,_44409426):-!,hnf('Prelude.$'(partcall(1,'Prelude.error',[]),'Prelude.++'(['^C','^a','^n','^n','^o','^t','^ ','^r','^e','^a','^d','^ ','^p','^e','^r','^s','^i','^s','^t','^e','^n','^t','^ ','^g','^l','^o','^b','^a','^l','^ ','^e','^n','^t','^i','^t','^y','^ ','^i','^n','^ ','^f','^i','^l','^e',^:,'^ '],'Prelude.++'(_44358524,'Prelude.++'(['^010','^F','^i','^l','^e','^ ','^c','^o','^n','^t','^e','^n','^t','^s',^:,'^010'],_44358542)))),_44409414,_44409420,_44409426).
'blocked_blocked_Data.Global.readGlobalP._\'23lambda5._\'23caseor0_1'('FAIL'(_44424048),_44358524,_44358542,'FAIL'(_44424048),_44424062,_44424062).

:-costCenters(['']).




%%%%% Number of shared variables: 8

:-style_check(-singleton).
:-dynamic globalsStore/2.
'Data.Global.prim_globalT'(_44424188,_44424190,_44424192):-basics:string2Atom(_44424188,_44424198),(globalsStore(_44424198,_44424210)->true;initGlobalT(_44424198,_44424190)),!,_44424192='Data.Global.GlobalT'(_44424188).
initGlobalT(_44424318,_44424320):-evalToken(_44424324),user:nf(_44424320,_44424330,_44424324,_44424334),user:waitUntilGround(_44424330,_44424334,_44424348),assert(globalsStore(_44424318,_44424330)),!.
'Data.Global.prim_readGlobalT'(_44424442,_44424444):-checkGlobalEntity(_44424442,_44424450),globalsStore(_44424450,_44424444),!.
'Data.Global.prim_readGlobalT'(_44424522,_44424524):-errorGlobalUninitialized(_44424522).
'Data.Global.prim_writeGlobalT'(_44424582,_44424584,'Prelude.()'):-checkGlobalEntity(_44424582,_44424592),retract(globalsStore(_44424592,_44424598)),assert(globalsStore(_44424592,_44424584)),!.
'Data.Global.prim_writeGlobalT'(_44424692,_44424694,_44424696):-errorGlobalUninitialized(_44424692).
errorGlobalUninitialized(_44424762):-checkGlobalEntity(_44424762,_44424768),basics:appendAtoms(['Internal error in Data.Global: global value ',_44424768,' not initialized!'],_44424794),raise_exception(_44424794).
checkGlobalEntity('Data.Global.GlobalT'(_44424862),_44424868):-basics:string2Atom(_44424862,_44424868),!.
checkGlobalEntity(_44424940,_44424942):-raise_exception('Illegal global entity occurred (maybe overloaded?)').
