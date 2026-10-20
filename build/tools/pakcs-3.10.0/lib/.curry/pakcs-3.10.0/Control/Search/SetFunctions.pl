%PAKCS3.10 swi9 VARIABLESHARING

:-noSingletonWarnings.
:-noRedefineWarnings.
:-noDiscontiguousWarnings.

:-importModule('Control.Search.Unsafe').
:-importModule('Data.List').
:-importModule('Prelude').

:-curryModule('Control.Search.SetFunctions').


%%%%%%%%%%%% function types %%%%%%%%%%%%%%%%%%%
:-multifile functiontype/6.
:-dynamic functiontype/6.
functiontype('Control.Search.SetFunctions._inst\'23Prelude.Data\'23Control.Search.SetFunctions.Values\'230\'23\'23','_inst#Prelude.Data#Control.Search.SetFunctions.Values#0##',2,'Control.Search.SetFunctions._inst\'23Prelude.Data\'23Control.Search.SetFunctions.Values\'230\'23\'23',nofix,notype).
functiontype('Control.Search.SetFunctions._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SetFunctions.Values\'230\'23\'23','_impl#===#Prelude.Data#Control.Search.SetFunctions.Values#0##',3,'Control.Search.SetFunctions._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SetFunctions.Values\'230\'23\'23',nofix,notype).
functiontype('Control.Search.SetFunctions._impl\'23aValue\'23Prelude.Data\'23Control.Search.SetFunctions.Values\'230\'23\'23','_impl#aValue#Prelude.Data#Control.Search.SetFunctions.Values#0##',1,'Control.Search.SetFunctions._impl\'23aValue\'23Prelude.Data\'23Control.Search.SetFunctions.Values\'230\'23\'23',nofix,notype).
functiontype('Control.Search.SetFunctions.set0',set0,1,'Control.Search.SetFunctions.set0',nofix,notype).
functiontype('Control.Search.SetFunctions.set1',set1,2,'Control.Search.SetFunctions.set1',nofix,notype).
functiontype('Control.Search.SetFunctions.set2',set2,3,'Control.Search.SetFunctions.set2',nofix,notype).
functiontype('Control.Search.SetFunctions.set3',set3,4,'Control.Search.SetFunctions.set3',nofix,notype).
functiontype('Control.Search.SetFunctions.set4',set4,5,'Control.Search.SetFunctions.set4',nofix,notype).
functiontype('Control.Search.SetFunctions.set5',set5,6,'Control.Search.SetFunctions.set5',nofix,notype).
functiontype('Control.Search.SetFunctions.set6',set6,7,'Control.Search.SetFunctions.set6',nofix,notype).
functiontype('Control.Search.SetFunctions.set7',set7,8,'Control.Search.SetFunctions.set7',nofix,notype).
functiontype('Control.Search.SetFunctions.isVal','Control.Search.SetFunctions.isVal',1,'Control.Search.SetFunctions.isVal',nofix,notype).
functiontype('Control.Search.SetFunctions.valuesOf','Control.Search.SetFunctions.valuesOf',1,'Control.Search.SetFunctions.valuesOf',nofix,notype).
functiontype('Control.Search.SetFunctions.isEmpty',isEmpty,1,'Control.Search.SetFunctions.isEmpty',nofix,notype).
functiontype('Control.Search.SetFunctions.notEmpty',notEmpty,1,'Control.Search.SetFunctions.notEmpty',nofix,notype).
functiontype('Control.Search.SetFunctions.valueOf',valueOf,3,'Control.Search.SetFunctions.valueOf',nofix,notype).
functiontype('Control.Search.SetFunctions.chooseValue',chooseValue,2,'Control.Search.SetFunctions.chooseValue',nofix,notype).
functiontype('Control.Search.SetFunctions.choose',choose,2,'Control.Search.SetFunctions.choose',nofix,notype).
functiontype('Control.Search.SetFunctions.selectValue',selectValue,1,'Control.Search.SetFunctions.selectValue',nofix,notype).
functiontype('Control.Search.SetFunctions.select',select,1,'Control.Search.SetFunctions.select',nofix,notype).
functiontype('Control.Search.SetFunctions.getSomeValue',getSomeValue,1,'Control.Search.SetFunctions.getSomeValue',nofix,notype).
functiontype('Control.Search.SetFunctions.getSome',getSome,1,'Control.Search.SetFunctions.getSome',nofix,notype).
functiontype('Control.Search.SetFunctions.mapValues',mapValues,2,'Control.Search.SetFunctions.mapValues',nofix,notype).
functiontype('Control.Search.SetFunctions.foldValues',foldValues,3,'Control.Search.SetFunctions.foldValues',nofix,notype).
functiontype('Control.Search.SetFunctions.filterValues',filterValues,2,'Control.Search.SetFunctions.filterValues',nofix,notype).
functiontype('Control.Search.SetFunctions.minValue',minValue,2,'Control.Search.SetFunctions.minValue',nofix,notype).
functiontype('Control.Search.SetFunctions.minValueBy',minValueBy,2,'Control.Search.SetFunctions.minValueBy',nofix,notype).
functiontype('Control.Search.SetFunctions.maxValue',maxValue,2,'Control.Search.SetFunctions.maxValue',nofix,notype).
functiontype('Control.Search.SetFunctions.maxValueBy',maxValueBy,2,'Control.Search.SetFunctions.maxValueBy',nofix,notype).
functiontype('Control.Search.SetFunctions.values2list',values2list,1,'Control.Search.SetFunctions.values2list',nofix,notype).
functiontype('Control.Search.SetFunctions.printValues',printValues,2,'Control.Search.SetFunctions.printValues',nofix,notype).
functiontype('Control.Search.SetFunctions.sortValues',sortValues,1,'Control.Search.SetFunctions.sortValues',nofix,notype).
functiontype('Control.Search.SetFunctions.sortValuesBy',sortValuesBy,2,'Control.Search.SetFunctions.sortValuesBy',nofix,notype).
functiontype('Control.Search.SetFunctions.choose._\'23caseor0','Control.Search.SetFunctions.choose._#caseor0',2,'Control.Search.SetFunctions.choose._\'23caseor0',nofix,notype).
functiontype('Control.Search.SetFunctions.select._\'23caseor0','Control.Search.SetFunctions.select._#caseor0',2,'Control.Search.SetFunctions.select._\'23caseor0',nofix,notype).
functiontype('Control.Search.SetFunctions.getSome._\'23caseor0','Control.Search.SetFunctions.getSome._#caseor0',2,'Control.Search.SetFunctions.getSome._\'23caseor0',nofix,notype).
functiontype('Control.Search.SetFunctions.filterValues._\'23caseor0','Control.Search.SetFunctions.filterValues._#caseor0',2,'Control.Search.SetFunctions.filterValues._\'23caseor0',nofix,notype).

%%%%%%%%%%%% constructor types %%%%%%%%%%%%%%%%%%%
:-multifile constructortype/7.
:-dynamic constructortype/7.
constructortype('Control.Search.SetFunctions.Values','Control.Search.SetFunctions.Values',2,'Search.SetFunctions.Values',0,notype,[]).

%%%%%%%%%%%% function definitions %%%%%%%%%%%%%%%%%%%
'Control.Search.SetFunctions._inst\'23Prelude.Data\'23Control.Search.SetFunctions.Values\'230\'23\'23'(_1304084,_1304086,_1304088,_1304090,_1304092):-freeze(_1304090,'blocked_Control.Search.SetFunctions._inst\'23Prelude.Data\'23Control.Search.SetFunctions.Values\'230\'23\'23'(_1304084,_1304086,_1304088,_1304090,_1304092)).
'blocked_Control.Search.SetFunctions._inst\'23Prelude.Data\'23Control.Search.SetFunctions.Values\'230\'23\'23'(_1304180,_1304198,_1305296,_1305302,_1305308):-hnf(_1304198,_1309102,_1305302,_1309120),'blocked_Control.Search.SetFunctions._inst\'23Prelude.Data\'23Control.Search.SetFunctions.Values\'230\'23\'23_2'(_1309102,_1304180,_1305296,_1309120,_1305308).

'blocked_Control.Search.SetFunctions._inst\'23Prelude.Data\'23Control.Search.SetFunctions.Values\'230\'23\'23_2'(_1309940,_1309942,_1309944,_1309946,_1309948):-freeze(_1309946,'blocked_blocked_Control.Search.SetFunctions._inst\'23Prelude.Data\'23Control.Search.SetFunctions.Values\'230\'23\'23_2'(_1309940,_1309942,_1309944,_1309946,_1309948)).
'blocked_blocked_Control.Search.SetFunctions._inst\'23Prelude.Data\'23Control.Search.SetFunctions.Values\'230\'23\'23_2'('Prelude.()',_1304180,'Prelude._Dict\'23Data'(partcall(2,'Control.Search.SetFunctions._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SetFunctions.Values\'230\'23\'23',[_1310394]),'Control.Search.SetFunctions._impl\'23aValue\'23Prelude.Data\'23Control.Search.SetFunctions.Values\'230\'23\'23'(_1310394)),_1310302,_1310308):-!,makeShare(_1304180,_1310394),_1310302=_1310308.
'blocked_blocked_Control.Search.SetFunctions._inst\'23Prelude.Data\'23Control.Search.SetFunctions.Values\'230\'23\'23_2'('FAIL'(_1313240),_1304180,'FAIL'(_1313240),_1313254,_1313254):-nonvar(_1313240).

'Control.Search.SetFunctions._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SetFunctions.Values\'230\'23\'23'(_1317108,_1317110,_1317112,_1317114,_1317116,_1317118):-freeze(_1317116,'blocked_Control.Search.SetFunctions._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SetFunctions.Values\'230\'23\'23'(_1317108,_1317110,_1317112,_1317114,_1317116,_1317118)).
'blocked_Control.Search.SetFunctions._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SetFunctions.Values\'230\'23\'23'(_1317214,_1317232,_1317250,_1318900,_1318906,_1318912):-hnf(_1317232,_1323146,_1318906,_1323170),'blocked_Control.Search.SetFunctions._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SetFunctions.Values\'230\'23\'23_2'(_1323146,_1317214,_1317250,_1318900,_1323170,_1318912).

'blocked_Control.Search.SetFunctions._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SetFunctions.Values\'230\'23\'23_2'(_1324070,_1324072,_1324074,_1324076,_1324078,_1324080):-freeze(_1324078,'blocked_blocked_Control.Search.SetFunctions._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SetFunctions.Values\'230\'23\'23_2'(_1324070,_1324072,_1324074,_1324076,_1324078,_1324080)).
'blocked_blocked_Control.Search.SetFunctions._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SetFunctions.Values\'230\'23\'23_2'('Control.Search.SetFunctions.Values'(_1317366,_1317384),_1317214,_1317250,_1325554,_1325560,_1325566):-!,hnf(_1317250,_1331210,_1325560,_1331240),'blocked_blocked_Control.Search.SetFunctions._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SetFunctions.Values\'230\'23\'23_2_Control.Search.SetFunctions.Values_4'(_1331210,_1317366,_1317384,_1317214,_1325554,_1331240,_1325566).

'blocked_blocked_Control.Search.SetFunctions._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SetFunctions.Values\'230\'23\'23_2_Control.Search.SetFunctions.Values_4'(_1332436,_1332438,_1332440,_1332442,_1332444,_1332446,_1332448):-freeze(_1332446,'blocked_blocked_blocked_Control.Search.SetFunctions._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SetFunctions.Values\'230\'23\'23_2_Control.Search.SetFunctions.Values_4'(_1332436,_1332438,_1332440,_1332442,_1332444,_1332446,_1332448)).
'blocked_blocked_blocked_Control.Search.SetFunctions._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SetFunctions.Values\'230\'23\'23_2_Control.Search.SetFunctions.Values_4'('Control.Search.SetFunctions.Values'(_1317512,_1317530),_1317366,_1317384,_1317214,_1333126,_1333132,_1333138):-!,makeShare(_1317214,_1333416),hnf('Prelude.&&'('Prelude._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Prelude.Maybe\'230\'23\'23'(_1333416,_1317366,_1317512),'Prelude._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23\'5B\'5D\'230\'23\'23'(_1333416,_1317384,_1317530)),_1333126,_1333132,_1333138).
'blocked_blocked_blocked_Control.Search.SetFunctions._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SetFunctions.Values\'230\'23\'23_2_Control.Search.SetFunctions.Values_4'('FAIL'(_1336670),_1317366,_1317384,_1317214,'FAIL'(_1336670),_1336684,_1336684):-nonvar(_1336670).
'blocked_blocked_Control.Search.SetFunctions._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SetFunctions.Values\'230\'23\'23_2'('FAIL'(_1336764),_1317214,_1317250,'FAIL'(_1336764),_1336778,_1336778):-nonvar(_1336764).

'Control.Search.SetFunctions._impl\'23aValue\'23Prelude.Data\'23Control.Search.SetFunctions.Values\'230\'23\'23'(_1340670,_1340672,_1340674,_1340676):-freeze(_1340674,'blocked_Control.Search.SetFunctions._impl\'23aValue\'23Prelude.Data\'23Control.Search.SetFunctions.Values\'230\'23\'23'(_1340670,_1340672,_1340674,_1340676)).
'blocked_Control.Search.SetFunctions._impl\'23aValue\'23Prelude.Data\'23Control.Search.SetFunctions.Values\'230\'23\'23'(_1340756,'Control.Search.SetFunctions.Values'('Prelude._impl\'23aValue\'23Prelude.Data\'23Prelude.Maybe\'230\'23\'23'(_1341184),'Prelude._impl\'23aValue\'23Prelude.Data\'23\'5B\'5D\'230\'23\'23'(_1341184)),_1341100,_1341106):-makeShare(_1340756,_1341184),_1341100=_1341106.

'Control.Search.SetFunctions.set0'(_1344880,_1344882,_1344884,_1344886):-freeze(_1344884,'blocked_Control.Search.SetFunctions.set0'(_1344880,_1344882,_1344884,_1344886)).
'blocked_Control.Search.SetFunctions.set0'(_1344966,'Control.Search.SetFunctions.Values'('Control.Search.Unsafe.oneValue'(_1345394),'Control.Search.Unsafe.allValues'(_1345394)),_1345310,_1345316):-makeShare(_1344966,_1345394),_1345310=_1345316.

'Control.Search.SetFunctions.set1'(_1348302,_1348304,_1348306,_1348308,_1348310):-freeze(_1348308,'blocked_Control.Search.SetFunctions.set1'(_1348302,_1348304,_1348306,_1348308,_1348310)).
'blocked_Control.Search.SetFunctions.set1'(_1348398,_1348416,_1351086,_1351092,_1351098):-makeShare(_1348416,_1349830),hnf('Control.Search.SetFunctions.isVal'(_1349830),_1352726,_1351092,_1352692),'blocked_Control.Search.SetFunctions.set1_ComplexCase'(_1352726,_1348398,_1349830,_1351086,_1352692,_1351098).

'blocked_Control.Search.SetFunctions.set1_ComplexCase'(_1353220,_1353222,_1353224,_1353226,_1353228,_1353230):-freeze(_1353228,freeze(_1353220,'blocked_blocked_Control.Search.SetFunctions.set1_ComplexCase'(_1353220,_1353222,_1353224,_1353226,_1353228,_1353230))).
'blocked_blocked_Control.Search.SetFunctions.set1_ComplexCase'('Prelude.True',_1348398,_1349830,'Control.Search.SetFunctions.Values'('Control.Search.Unsafe.oneValue'('Prelude.apply'(_1353786,_1353806)),'Control.Search.Unsafe.allValues'('Prelude.apply'(_1353786,_1353806))),_1353630,_1353636):-makeShare(_1348398,_1353786),makeShare(_1349830,_1353806),_1353630=_1353636.
'blocked_blocked_Control.Search.SetFunctions.set1_ComplexCase'('Prelude.False',_1348398,_1349830,_1356612,_1356618,_1356624):-!,hnf(reportFailure4PAKCS('Control.Search.SetFunctions.set1',['Prelude.False']),_1356612,_1356618,_1356624).
'blocked_blocked_Control.Search.SetFunctions.set1_ComplexCase'('FAIL'(_1358090),_1348398,_1349830,'FAIL'(_1358090),_1358104,_1358104).

'Control.Search.SetFunctions.set2'(_1359516,_1359518,_1359520,_1359522,_1359524,_1359526):-freeze(_1359524,'blocked_Control.Search.SetFunctions.set2'(_1359516,_1359518,_1359520,_1359522,_1359524,_1359526)).
'blocked_Control.Search.SetFunctions.set2'(_1359622,_1359640,_1359658,_1363916,_1363922,_1363928):-makeShare(_1359640,_1361734),makeShare(_1359658,_1361754),hnf('Prelude.&'('Control.Search.SetFunctions.isVal'(_1361734),'Control.Search.SetFunctions.isVal'(_1361754)),_1365570,_1363922,_1365530),'blocked_Control.Search.SetFunctions.set2_ComplexCase'(_1365570,_1359622,_1361734,_1361754,_1363916,_1365530,_1363928).

'blocked_Control.Search.SetFunctions.set2_ComplexCase'(_1366078,_1366080,_1366082,_1366084,_1366086,_1366088,_1366090):-freeze(_1366088,freeze(_1366078,'blocked_blocked_Control.Search.SetFunctions.set2_ComplexCase'(_1366078,_1366080,_1366082,_1366084,_1366086,_1366088,_1366090))).
'blocked_blocked_Control.Search.SetFunctions.set2_ComplexCase'('Prelude.True',_1359622,_1361734,_1361754,'Control.Search.SetFunctions.Values'('Control.Search.Unsafe.oneValue'('Prelude.apply'('Prelude.apply'(_1366742,_1366762),_1366782)),'Control.Search.Unsafe.allValues'('Prelude.apply'('Prelude.apply'(_1366742,_1366762),_1366782))),_1366498,_1366504):-makeShare(_1359622,_1366742),makeShare(_1361734,_1366762),makeShare(_1361754,_1366782),_1366498=_1366504.
'blocked_blocked_Control.Search.SetFunctions.set2_ComplexCase'('Prelude.False',_1359622,_1361734,_1361754,_1370400,_1370406,_1370412):-!,hnf(reportFailure4PAKCS('Control.Search.SetFunctions.set2',['Prelude.False']),_1370400,_1370406,_1370412).
'blocked_blocked_Control.Search.SetFunctions.set2_ComplexCase'('FAIL'(_1371952),_1359622,_1361734,_1361754,'FAIL'(_1371952),_1371966,_1371966).

'Control.Search.SetFunctions.set3'(_1373386,_1373388,_1373390,_1373392,_1373394,_1373396,_1373398):-freeze(_1373396,'blocked_Control.Search.SetFunctions.set3'(_1373386,_1373388,_1373390,_1373392,_1373394,_1373396,_1373398)).
'blocked_Control.Search.SetFunctions.set3'(_1373502,_1373520,_1373538,_1373556,_1379438,_1379444,_1379450):-makeShare(_1373520,_1376330),makeShare(_1373538,_1376350),makeShare(_1373556,_1376370),hnf('Prelude.&'('Control.Search.SetFunctions.isVal'(_1376330),'Prelude.&'('Control.Search.SetFunctions.isVal'(_1376350),'Control.Search.SetFunctions.isVal'(_1376370))),_1381106,_1379444,_1381060),'blocked_Control.Search.SetFunctions.set3_ComplexCase'(_1381106,_1373502,_1376330,_1376350,_1376370,_1379438,_1381060,_1379450).

'blocked_Control.Search.SetFunctions.set3_ComplexCase'(_1381628,_1381630,_1381632,_1381634,_1381636,_1381638,_1381640,_1381642):-freeze(_1381640,freeze(_1381628,'blocked_blocked_Control.Search.SetFunctions.set3_ComplexCase'(_1381628,_1381630,_1381632,_1381634,_1381636,_1381638,_1381640,_1381642))).
'blocked_blocked_Control.Search.SetFunctions.set3_ComplexCase'('Prelude.True',_1373502,_1376330,_1376350,_1376370,'Control.Search.SetFunctions.Values'('Control.Search.Unsafe.oneValue'('Prelude.apply'('Prelude.apply'('Prelude.apply'(_1382414,_1382434),_1382454),_1382474)),'Control.Search.Unsafe.allValues'('Prelude.apply'('Prelude.apply'('Prelude.apply'(_1382414,_1382434),_1382454),_1382474))),_1382058,_1382064):-makeShare(_1373502,_1382414),makeShare(_1376330,_1382434),makeShare(_1376350,_1382454),makeShare(_1376370,_1382474),_1382058=_1382064.
'blocked_blocked_Control.Search.SetFunctions.set3_ComplexCase'('Prelude.False',_1373502,_1376330,_1376350,_1376370,_1386904,_1386910,_1386916):-!,hnf(reportFailure4PAKCS('Control.Search.SetFunctions.set3',['Prelude.False']),_1386904,_1386910,_1386916).
'blocked_blocked_Control.Search.SetFunctions.set3_ComplexCase'('FAIL'(_1388530),_1373502,_1376330,_1376350,_1376370,'FAIL'(_1388530),_1388544,_1388544).

'Control.Search.SetFunctions.set4'(_1389972,_1389974,_1389976,_1389978,_1389980,_1389982,_1389984,_1389986):-freeze(_1389984,'blocked_Control.Search.SetFunctions.set4'(_1389972,_1389974,_1389976,_1389978,_1389980,_1389982,_1389984,_1389986)).
'blocked_Control.Search.SetFunctions.set4'(_1390098,_1390116,_1390134,_1390152,_1390170,_1397712,_1397718,_1397724):-makeShare(_1390116,_1393678),makeShare(_1390134,_1393698),makeShare(_1390152,_1393718),makeShare(_1390170,_1393738),hnf('Prelude.&'('Control.Search.SetFunctions.isVal'(_1393678),'Prelude.&'('Control.Search.SetFunctions.isVal'(_1393698),'Prelude.&'('Control.Search.SetFunctions.isVal'(_1393718),'Control.Search.SetFunctions.isVal'(_1393738)))),_1399394,_1397718,_1399342),'blocked_Control.Search.SetFunctions.set4_ComplexCase'(_1399394,_1390098,_1393678,_1393698,_1393718,_1393738,_1397712,_1399342,_1397724).

'blocked_Control.Search.SetFunctions.set4_ComplexCase'(_1399930,_1399932,_1399934,_1399936,_1399938,_1399940,_1399942,_1399944,_1399946):-freeze(_1399944,freeze(_1399930,'blocked_blocked_Control.Search.SetFunctions.set4_ComplexCase'(_1399930,_1399932,_1399934,_1399936,_1399938,_1399940,_1399942,_1399944,_1399946))).
'blocked_blocked_Control.Search.SetFunctions.set4_ComplexCase'('Prelude.True',_1390098,_1393678,_1393698,_1393718,_1393738,'Control.Search.SetFunctions.Values'('Control.Search.Unsafe.oneValue'('Prelude.apply'('Prelude.apply'('Prelude.apply'('Prelude.apply'(_1400862,_1400882),_1400902),_1400922),_1400942)),'Control.Search.Unsafe.allValues'('Prelude.apply'('Prelude.apply'('Prelude.apply'('Prelude.apply'(_1400862,_1400882),_1400902),_1400922),_1400942))),_1400370,_1400376):-makeShare(_1390098,_1400862),makeShare(_1393678,_1400882),makeShare(_1393698,_1400902),makeShare(_1393718,_1400922),makeShare(_1393738,_1400942),_1400370=_1400376.
'blocked_blocked_Control.Search.SetFunctions.set4_ComplexCase'('Prelude.False',_1390098,_1393678,_1393698,_1393718,_1393738,_1406184,_1406190,_1406196):-!,hnf(reportFailure4PAKCS('Control.Search.SetFunctions.set4',['Prelude.False']),_1406184,_1406190,_1406196).
'blocked_blocked_Control.Search.SetFunctions.set4_ComplexCase'('FAIL'(_1407884),_1390098,_1393678,_1393698,_1393718,_1393738,'FAIL'(_1407884),_1407898,_1407898).

'Control.Search.SetFunctions.set5'(_1409334,_1409336,_1409338,_1409340,_1409342,_1409344,_1409346,_1409348,_1409350):-freeze(_1409348,'blocked_Control.Search.SetFunctions.set5'(_1409334,_1409336,_1409338,_1409340,_1409342,_1409344,_1409346,_1409348,_1409350)).
'blocked_Control.Search.SetFunctions.set5'(_1409470,_1409488,_1409506,_1409524,_1409542,_1409560,_1418798,_1418804,_1418810):-makeShare(_1409488,_1413838),makeShare(_1409506,_1413858),makeShare(_1409524,_1413878),makeShare(_1409542,_1413898),makeShare(_1409560,_1413918),hnf('Prelude.&'('Control.Search.SetFunctions.isVal'(_1413838),'Prelude.&'('Control.Search.SetFunctions.isVal'(_1413858),'Prelude.&'('Control.Search.SetFunctions.isVal'(_1413878),'Prelude.&'('Control.Search.SetFunctions.isVal'(_1413898),'Control.Search.SetFunctions.isVal'(_1413918))))),_1420494,_1418804,_1420436),'blocked_Control.Search.SetFunctions.set5_ComplexCase'(_1420494,_1409470,_1413838,_1413858,_1413878,_1413898,_1413918,_1418798,_1420436,_1418810).

'blocked_Control.Search.SetFunctions.set5_ComplexCase'(_1421044,_1421046,_1421048,_1421050,_1421052,_1421054,_1421056,_1421058,_1421060,_1421062):-freeze(_1421060,freeze(_1421044,'blocked_blocked_Control.Search.SetFunctions.set5_ComplexCase'(_1421044,_1421046,_1421048,_1421050,_1421052,_1421054,_1421056,_1421058,_1421060,_1421062))).
'blocked_blocked_Control.Search.SetFunctions.set5_ComplexCase'('Prelude.True',_1409470,_1413838,_1413858,_1413878,_1413898,_1413918,'Control.Search.SetFunctions.Values'('Control.Search.Unsafe.oneValue'('Prelude.apply'('Prelude.apply'('Prelude.apply'('Prelude.apply'('Prelude.apply'(_1422146,_1422166),_1422186),_1422206),_1422226),_1422246)),'Control.Search.Unsafe.allValues'('Prelude.apply'('Prelude.apply'('Prelude.apply'('Prelude.apply'('Prelude.apply'(_1422146,_1422166),_1422186),_1422206),_1422226),_1422246))),_1421494,_1421500):-makeShare(_1409470,_1422146),makeShare(_1413838,_1422166),makeShare(_1413858,_1422186),makeShare(_1413878,_1422206),makeShare(_1413898,_1422226),makeShare(_1413918,_1422246),_1421494=_1421500.
'blocked_blocked_Control.Search.SetFunctions.set5_ComplexCase'('Prelude.False',_1409470,_1413838,_1413858,_1413878,_1413898,_1413918,_1428300,_1428306,_1428312):-!,hnf(reportFailure4PAKCS('Control.Search.SetFunctions.set5',['Prelude.False']),_1428300,_1428306,_1428312).
'blocked_blocked_Control.Search.SetFunctions.set5_ComplexCase'('FAIL'(_1430074),_1409470,_1413838,_1413858,_1413878,_1413898,_1413918,'FAIL'(_1430074),_1430088,_1430088).

'Control.Search.SetFunctions.set6'(_1431532,_1431534,_1431536,_1431538,_1431540,_1431542,_1431544,_1431546,_1431548,_1431550):-freeze(_1431548,'blocked_Control.Search.SetFunctions.set6'(_1431532,_1431534,_1431536,_1431538,_1431540,_1431542,_1431544,_1431546,_1431548,_1431550)).
'blocked_Control.Search.SetFunctions.set6'(_1431678,_1431696,_1431714,_1431732,_1431750,_1431768,_1431786,_1442756,_1442762,_1442768):-makeShare(_1431696,_1436870),makeShare(_1431714,_1436890),makeShare(_1431732,_1436910),makeShare(_1431750,_1436930),makeShare(_1431768,_1436950),makeShare(_1431786,_1436970),hnf('Prelude.&'('Control.Search.SetFunctions.isVal'(_1436870),'Prelude.&'('Control.Search.SetFunctions.isVal'(_1436890),'Prelude.&'('Control.Search.SetFunctions.isVal'(_1436910),'Prelude.&'('Control.Search.SetFunctions.isVal'(_1436930),'Prelude.&'('Control.Search.SetFunctions.isVal'(_1436950),'Control.Search.SetFunctions.isVal'(_1436970)))))),_1444466,_1442762,_1444402),'blocked_Control.Search.SetFunctions.set6_ComplexCase'(_1444466,_1431678,_1436870,_1436890,_1436910,_1436930,_1436950,_1436970,_1442756,_1444402,_1442768).

'blocked_Control.Search.SetFunctions.set6_ComplexCase'(_1445030,_1445032,_1445034,_1445036,_1445038,_1445040,_1445042,_1445044,_1445046,_1445048,_1445050):-freeze(_1445048,freeze(_1445030,'blocked_blocked_Control.Search.SetFunctions.set6_ComplexCase'(_1445030,_1445032,_1445034,_1445036,_1445038,_1445040,_1445042,_1445044,_1445046,_1445048,_1445050))).
'blocked_blocked_Control.Search.SetFunctions.set6_ComplexCase'('Prelude.True',_1431678,_1436870,_1436890,_1436910,_1436930,_1436950,_1436970,'Control.Search.SetFunctions.Values'('Control.Search.Unsafe.oneValue'('Prelude.apply'('Prelude.apply'('Prelude.apply'('Prelude.apply'('Prelude.apply'('Prelude.apply'(_1446326,_1446346),_1446366),_1446386),_1446406),_1446426),_1446446)),'Control.Search.Unsafe.allValues'('Prelude.apply'('Prelude.apply'('Prelude.apply'('Prelude.apply'('Prelude.apply'('Prelude.apply'(_1446326,_1446346),_1446366),_1446386),_1446406),_1446426),_1446446))),_1445490,_1445496):-makeShare(_1431678,_1446326),makeShare(_1436870,_1446346),makeShare(_1436890,_1446366),makeShare(_1436910,_1446386),makeShare(_1436930,_1446406),makeShare(_1436950,_1446426),makeShare(_1436970,_1446446),_1445490=_1445496.
'blocked_blocked_Control.Search.SetFunctions.set6_ComplexCase'('Prelude.False',_1431678,_1436870,_1436890,_1436910,_1436930,_1436950,_1436970,_1453312,_1453318,_1453324):-!,hnf(reportFailure4PAKCS('Control.Search.SetFunctions.set6',['Prelude.False']),_1453312,_1453318,_1453324).
'blocked_blocked_Control.Search.SetFunctions.set6_ComplexCase'('FAIL'(_1455160),_1431678,_1436870,_1436890,_1436910,_1436930,_1436950,_1436970,'FAIL'(_1455160),_1455174,_1455174).

'Control.Search.SetFunctions.set7'(_1456626,_1456628,_1456630,_1456632,_1456634,_1456636,_1456638,_1456640,_1456642,_1456644,_1456646):-freeze(_1456644,'blocked_Control.Search.SetFunctions.set7'(_1456626,_1456628,_1456630,_1456632,_1456634,_1456636,_1456638,_1456640,_1456642,_1456644,_1456646)).
'blocked_Control.Search.SetFunctions.set7'(_1456782,_1456800,_1456818,_1456836,_1456854,_1456872,_1456890,_1456908,_1469646,_1469652,_1469658):-makeShare(_1456800,_1462834),makeShare(_1456818,_1462854),makeShare(_1456836,_1462874),makeShare(_1456854,_1462894),makeShare(_1456872,_1462914),makeShare(_1456890,_1462934),makeShare(_1456908,_1462954),hnf('Prelude.&'('Control.Search.SetFunctions.isVal'(_1462834),'Prelude.&'('Control.Search.SetFunctions.isVal'(_1462854),'Prelude.&'('Control.Search.SetFunctions.isVal'(_1462874),'Prelude.&'('Control.Search.SetFunctions.isVal'(_1462894),'Prelude.&'('Control.Search.SetFunctions.isVal'(_1462914),'Prelude.&'('Control.Search.SetFunctions.isVal'(_1462934),'Control.Search.SetFunctions.isVal'(_1462954))))))),_1471370,_1469652,_1471300),'blocked_Control.Search.SetFunctions.set7_ComplexCase'(_1471370,_1456782,_1462834,_1462854,_1462874,_1462894,_1462914,_1462934,_1462954,_1469646,_1471300,_1469658).

'blocked_Control.Search.SetFunctions.set7_ComplexCase'(_1471948,_1471950,_1471952,_1471954,_1471956,_1471958,_1471960,_1471962,_1471964,_1471966,_1471968,_1471970):-freeze(_1471968,freeze(_1471948,'blocked_blocked_Control.Search.SetFunctions.set7_ComplexCase'(_1471948,_1471950,_1471952,_1471954,_1471956,_1471958,_1471960,_1471962,_1471964,_1471966,_1471968,_1471970))).
'blocked_blocked_Control.Search.SetFunctions.set7_ComplexCase'('Prelude.True',_1456782,_1462834,_1462854,_1462874,_1462894,_1462914,_1462934,_1462954,'Control.Search.SetFunctions.Values'('Control.Search.Unsafe.oneValue'('Prelude.apply'('Prelude.apply'('Prelude.apply'('Prelude.apply'('Prelude.apply'('Prelude.apply'('Prelude.apply'(_1473462,_1473482),_1473502),_1473522),_1473542),_1473562),_1473582),_1473602)),'Control.Search.Unsafe.allValues'('Prelude.apply'('Prelude.apply'('Prelude.apply'('Prelude.apply'('Prelude.apply'('Prelude.apply'('Prelude.apply'(_1473462,_1473482),_1473502),_1473522),_1473542),_1473562),_1473582),_1473602))),_1472418,_1472424):-makeShare(_1456782,_1473462),makeShare(_1462834,_1473482),makeShare(_1462854,_1473502),makeShare(_1462874,_1473522),makeShare(_1462894,_1473542),makeShare(_1462914,_1473562),makeShare(_1462934,_1473582),makeShare(_1462954,_1473602),_1472418=_1472424.
'blocked_blocked_Control.Search.SetFunctions.set7_ComplexCase'('Prelude.False',_1456782,_1462834,_1462854,_1462874,_1462894,_1462914,_1462934,_1462954,_1481280,_1481286,_1481292):-!,hnf(reportFailure4PAKCS('Control.Search.SetFunctions.set7',['Prelude.False']),_1481280,_1481286,_1481292).
'blocked_blocked_Control.Search.SetFunctions.set7_ComplexCase'('FAIL'(_1483202),_1456782,_1462834,_1462854,_1462874,_1462894,_1462914,_1462934,_1462954,'FAIL'(_1483202),_1483216,_1483216).

'Control.Search.SetFunctions.isVal'(_1484714,_1484716,_1484718,_1484720):-freeze(_1484718,'blocked_Control.Search.SetFunctions.isVal'(_1484714,_1484716,_1484718,_1484720)).
'blocked_Control.Search.SetFunctions.isVal'(_1484800,_1485152,_1485158,_1485164):-hnf('Prelude.seq'('Prelude.$##'(partcall(1,'Prelude.id',[]),_1484800),'Prelude.True'),_1485152,_1485158,_1485164).

'Control.Search.SetFunctions.valuesOf'(_1487874,_1487876,_1487878,_1487880):-freeze(_1487878,'blocked_Control.Search.SetFunctions.valuesOf'(_1487874,_1487876,_1487878,_1487880)).
'blocked_Control.Search.SetFunctions.valuesOf'(_1487960,_1488422,_1488428,_1488434):-hnf(_1487960,_1490096,_1488428,_1490108),'blocked_Control.Search.SetFunctions.valuesOf_1'(_1490096,_1488422,_1490108,_1488434).

'blocked_Control.Search.SetFunctions.valuesOf_1'(_1490566,_1490568,_1490570,_1490572):-freeze(_1490570,'blocked_blocked_Control.Search.SetFunctions.valuesOf_1'(_1490566,_1490568,_1490570,_1490572)).
'blocked_blocked_Control.Search.SetFunctions.valuesOf_1'('Control.Search.SetFunctions.Values'(_1488076,_1488094),_1491226,_1491232,_1491238):-!,hnf(_1488094,_1491226,_1491232,_1491238).
'blocked_blocked_Control.Search.SetFunctions.valuesOf_1'('FAIL'(_1491822),'FAIL'(_1491822),_1491836,_1491836):-nonvar(_1491822).

'Control.Search.SetFunctions.isEmpty'(_1493350,_1493352,_1493354,_1493356):-freeze(_1493354,'blocked_Control.Search.SetFunctions.isEmpty'(_1493350,_1493352,_1493354,_1493356)).
'blocked_Control.Search.SetFunctions.isEmpty'(_1493436,_1494134,_1494140,_1494146):-hnf(_1493436,_1495772,_1494140,_1495784),'blocked_Control.Search.SetFunctions.isEmpty_1'(_1495772,_1494134,_1495784,_1494146).

'blocked_Control.Search.SetFunctions.isEmpty_1'(_1496236,_1496238,_1496240,_1496242):-freeze(_1496240,'blocked_blocked_Control.Search.SetFunctions.isEmpty_1'(_1496236,_1496238,_1496240,_1496242)).
'blocked_blocked_Control.Search.SetFunctions.isEmpty_1'('Control.Search.SetFunctions.Values'(_1493552,_1493570),_1497244,_1497250,_1497256):-!,hnf(_1493552,_1500292,_1497250,_1500310),'blocked_blocked_Control.Search.SetFunctions.isEmpty_1_Control.Search.SetFunctions.Values_1'(_1500292,_1493570,_1497244,_1500310,_1497256).

'blocked_blocked_Control.Search.SetFunctions.isEmpty_1_Control.Search.SetFunctions.Values_1'(_1501064,_1501066,_1501068,_1501070,_1501072):-freeze(_1501070,freeze(_1501064,'blocked_blocked_blocked_Control.Search.SetFunctions.isEmpty_1_Control.Search.SetFunctions.Values_1'(_1501064,_1501066,_1501068,_1501070,_1501072))).
'blocked_blocked_blocked_Control.Search.SetFunctions.isEmpty_1_Control.Search.SetFunctions.Values_1'('Prelude.Nothing',_1493570,'Prelude.True',_1501500,_1501500).
'blocked_blocked_blocked_Control.Search.SetFunctions.isEmpty_1_Control.Search.SetFunctions.Values_1'('Prelude.Just'(_1493798),_1493570,'Prelude.False',_1502662,_1502662):-!.
'blocked_blocked_blocked_Control.Search.SetFunctions.isEmpty_1_Control.Search.SetFunctions.Values_1'('FAIL'(_1503594),_1493570,'FAIL'(_1503594),_1503608,_1503608).
'blocked_blocked_Control.Search.SetFunctions.isEmpty_1'('FAIL'(_1503668),'FAIL'(_1503668),_1503682,_1503682):-nonvar(_1503668).

'Control.Search.SetFunctions.notEmpty'(_1505234,_1505236,_1505238,_1505240):-freeze(_1505238,'blocked_Control.Search.SetFunctions.notEmpty'(_1505234,_1505236,_1505238,_1505240)).
'blocked_Control.Search.SetFunctions.notEmpty'(_1505320,_1505504,_1505510,_1505516):-hnf('Prelude.not'('Control.Search.SetFunctions.isEmpty'(_1505320)),_1505504,_1505510,_1505516).

'Control.Search.SetFunctions.valueOf'(_1507910,_1507912,_1507914,_1507916,_1507918,_1507920):-freeze(_1507918,'blocked_Control.Search.SetFunctions.valueOf'(_1507910,_1507912,_1507914,_1507916,_1507918,_1507920)).
'blocked_Control.Search.SetFunctions.valueOf'(_1508016,_1508034,_1508052,_1508460,_1508466,_1508472):-hnf('Prelude.apply'('Prelude.elem'(_1508016,_1508034),'Control.Search.SetFunctions.valuesOf'(_1508052)),_1508460,_1508466,_1508472).

'Control.Search.SetFunctions.chooseValue'(_1511580,_1511582,_1511584,_1511586,_1511588):-freeze(_1511586,'blocked_Control.Search.SetFunctions.chooseValue'(_1511580,_1511582,_1511584,_1511586,_1511588)).
'blocked_Control.Search.SetFunctions.chooseValue'(_1511676,_1511694,_1511948,_1511954,_1511960):-hnf('Prelude.fst'('Control.Search.SetFunctions.choose'(_1511676,_1511694)),_1511948,_1511954,_1511960).

'Control.Search.SetFunctions.choose'(_1514506,_1514508,_1514510,_1514512,_1514514):-freeze(_1514512,'blocked_Control.Search.SetFunctions.choose'(_1514506,_1514508,_1514510,_1514512,_1514514)).
'blocked_Control.Search.SetFunctions.choose'(_1514602,_1514620,_1516858,_1516864,_1516870):-hnf(_1514620,_1518468,_1516864,_1518486),'blocked_Control.Search.SetFunctions.choose_2'(_1518468,_1514602,_1516858,_1518486,_1516870).

'blocked_Control.Search.SetFunctions.choose_2'(_1518940,_1518942,_1518944,_1518946,_1518948):-freeze(_1518946,'blocked_blocked_Control.Search.SetFunctions.choose_2'(_1518940,_1518942,_1518944,_1518946,_1518948)).
'blocked_blocked_Control.Search.SetFunctions.choose_2'('Control.Search.SetFunctions.Values'(_1514736,_1514754),_1514602,_1519610,_1519616,_1519622):-!,makeShare(_1514794,_1519996),makeShare(_1514754,_1520016),makeShare(_1514812,_1520036),hnf('Prelude.cond'(letrec4PAKCS(_1519996,'Prelude.foldr1'(partcall(2,'Prelude.?',[]),_1520016)),'Prelude.cond'(letrec4PAKCS(_1520036,'Prelude.apply'('Prelude.apply'('Data.List.delete'(_1514602),_1519996),_1520016)),'Prelude.(,)'(_1519996,'Control.Search.SetFunctions.Values'('Control.Search.SetFunctions.choose._\'23caseor0'('Prelude.null'(_1520036),_1520036),_1520036)))),_1519610,_1519616,_1519622).
'blocked_blocked_Control.Search.SetFunctions.choose_2'('FAIL'(_1524884),_1514602,'FAIL'(_1524884),_1524898,_1524898):-nonvar(_1524884).

'Control.Search.SetFunctions.selectValue'(_1526572,_1526574,_1526576,_1526578):-freeze(_1526576,'blocked_Control.Search.SetFunctions.selectValue'(_1526572,_1526574,_1526576,_1526578)).
'blocked_Control.Search.SetFunctions.selectValue'(_1526658,_1527702,_1527708,_1527714):-hnf(_1526658,_1529484,_1527708,_1529496),'blocked_Control.Search.SetFunctions.selectValue_1'(_1529484,_1527702,_1529496,_1527714).

'blocked_Control.Search.SetFunctions.selectValue_1'(_1529972,_1529974,_1529976,_1529978):-freeze(_1529976,'blocked_blocked_Control.Search.SetFunctions.selectValue_1'(_1529972,_1529974,_1529976,_1529978)).
'blocked_blocked_Control.Search.SetFunctions.selectValue_1'('Control.Search.SetFunctions.Values'(_1526774,_1526792),_1531004,_1531010,_1531016):-!,hnf(_1526774,_1534196,_1531010,_1534214),'blocked_blocked_Control.Search.SetFunctions.selectValue_1_Control.Search.SetFunctions.Values_1'(_1534196,_1526792,_1531004,_1534214,_1531016).

'blocked_blocked_Control.Search.SetFunctions.selectValue_1_Control.Search.SetFunctions.Values_1'(_1534986,_1534988,_1534990,_1534992,_1534994):-freeze(_1534992,'blocked_blocked_blocked_Control.Search.SetFunctions.selectValue_1_Control.Search.SetFunctions.Values_1'(_1534986,_1534988,_1534990,_1534992,_1534994)).
'blocked_blocked_blocked_Control.Search.SetFunctions.selectValue_1_Control.Search.SetFunctions.Values_1'('Prelude.Just'(_1526920),_1526792,_1535586,_1535592,_1535598):-!,hnf(_1526920,_1535586,_1535592,_1535598).
'blocked_blocked_blocked_Control.Search.SetFunctions.selectValue_1_Control.Search.SetFunctions.Values_1'('Prelude.Nothing',_1526792,_1536812,_1536818,_1536824):-!,hnf(reportFailure4PAKCS('Control.Search.SetFunctions.selectValue',['Prelude.Nothing']),_1536812,_1536818,_1536824).
'blocked_blocked_blocked_Control.Search.SetFunctions.selectValue_1_Control.Search.SetFunctions.Values_1'('FAIL'(_1538522),_1526792,'FAIL'(_1538522),_1538536,_1538536).
'blocked_blocked_Control.Search.SetFunctions.selectValue_1'('FAIL'(_1538596),'FAIL'(_1538596),_1538610,_1538610):-nonvar(_1538596).

'Control.Search.SetFunctions.select'(_1540086,_1540088,_1540090,_1540092):-freeze(_1540090,'blocked_Control.Search.SetFunctions.select'(_1540086,_1540088,_1540090,_1540092)).
'blocked_Control.Search.SetFunctions.select'(_1540172,_1541756,_1541762,_1541768):-hnf(_1540172,_1543358,_1541762,_1543370),'blocked_Control.Search.SetFunctions.select_1'(_1543358,_1541756,_1543370,_1541768).

'blocked_Control.Search.SetFunctions.select_1'(_1543816,_1543818,_1543820,_1543822):-freeze(_1543820,'blocked_blocked_Control.Search.SetFunctions.select_1'(_1543816,_1543818,_1543820,_1543822)).
'blocked_blocked_Control.Search.SetFunctions.select_1'('Control.Search.SetFunctions.Values'(_1540288,_1540306),_1544826,_1544832,_1544838):-!,hnf(_1540306,_1547838,_1544832,_1547856),'blocked_blocked_Control.Search.SetFunctions.select_1_Control.Search.SetFunctions.Values_2'(_1547838,_1540288,_1544826,_1547856,_1544838).

'blocked_blocked_Control.Search.SetFunctions.select_1_Control.Search.SetFunctions.Values_2'(_1548598,_1548600,_1548602,_1548604,_1548606):-freeze(_1548604,'blocked_blocked_blocked_Control.Search.SetFunctions.select_1_Control.Search.SetFunctions.Values_2'(_1548598,_1548600,_1548602,_1548604,_1548606)).
'blocked_blocked_blocked_Control.Search.SetFunctions.select_1_Control.Search.SetFunctions.Values_2'([_1540434|_1540452],_1540288,'Prelude.(,)'(_1540434,'Control.Search.SetFunctions.Values'('Control.Search.SetFunctions.select._\'23caseor0'('Prelude.null'(_1549244),_1549244),_1549244)),_1549086,_1549092):-!,makeShare(_1540452,_1549244),_1549086=_1549092.
'blocked_blocked_blocked_Control.Search.SetFunctions.select_1_Control.Search.SetFunctions.Values_2'([],_1540288,_1551760,_1551766,_1551772):-!,hnf(reportFailure4PAKCS('Control.Search.SetFunctions.select',[[]]),_1551760,_1551766,_1551772).
'blocked_blocked_blocked_Control.Search.SetFunctions.select_1_Control.Search.SetFunctions.Values_2'('FAIL'(_1553316),_1540288,'FAIL'(_1553316),_1553330,_1553330).
'blocked_blocked_Control.Search.SetFunctions.select_1'('FAIL'(_1553390),'FAIL'(_1553390),_1553404,_1553404):-nonvar(_1553390).

'Control.Search.SetFunctions.getSomeValue'(_1555108,_1555110,_1555112,_1555114):-freeze(_1555112,'blocked_Control.Search.SetFunctions.getSomeValue'(_1555108,_1555110,_1555112,_1555114)).
'blocked_Control.Search.SetFunctions.getSomeValue'(_1555194,_1555848,_1555854,_1555860):-hnf(_1555194,_1557666,_1555854,_1557678),'blocked_Control.Search.SetFunctions.getSomeValue_1'(_1557666,_1555848,_1557678,_1555860).

'blocked_Control.Search.SetFunctions.getSomeValue_1'(_1558160,_1558162,_1558164,_1558166):-freeze(_1558164,'blocked_blocked_Control.Search.SetFunctions.getSomeValue_1'(_1558160,_1558162,_1558164,_1558166)).
'blocked_blocked_Control.Search.SetFunctions.getSomeValue_1'('Control.Search.SetFunctions.Values'(_1555310,_1555328),_1558820,_1558826,_1558832):-!,hnf('Prelude.apply'('Prelude._impl\'23return\'23Prelude.Monad\'23Prelude.IO\'23',_1555310),_1558820,_1558826,_1558832).
'blocked_blocked_Control.Search.SetFunctions.getSomeValue_1'('FAIL'(_1560064),'FAIL'(_1560064),_1560078,_1560078):-nonvar(_1560064).

'Control.Search.SetFunctions.getSome'(_1561592,_1561594,_1561596,_1561598):-freeze(_1561596,'blocked_Control.Search.SetFunctions.getSome'(_1561592,_1561594,_1561596,_1561598)).
'blocked_Control.Search.SetFunctions.getSome'(_1561678,_1563352,_1563358,_1563364):-hnf(_1561678,_1564990,_1563358,_1565002),'blocked_Control.Search.SetFunctions.getSome_1'(_1564990,_1563352,_1565002,_1563364).

'blocked_Control.Search.SetFunctions.getSome_1'(_1565454,_1565456,_1565458,_1565460):-freeze(_1565458,'blocked_blocked_Control.Search.SetFunctions.getSome_1'(_1565454,_1565456,_1565458,_1565460)).
'blocked_blocked_Control.Search.SetFunctions.getSome_1'('Control.Search.SetFunctions.Values'(_1561794,_1561812),_1566470,_1566476,_1566482):-!,hnf(_1561812,_1569518,_1566476,_1569536),'blocked_blocked_Control.Search.SetFunctions.getSome_1_Control.Search.SetFunctions.Values_2'(_1569518,_1561794,_1566470,_1569536,_1566482).

'blocked_blocked_Control.Search.SetFunctions.getSome_1_Control.Search.SetFunctions.Values_2'(_1570284,_1570286,_1570288,_1570290,_1570292):-freeze(_1570290,'blocked_blocked_blocked_Control.Search.SetFunctions.getSome_1_Control.Search.SetFunctions.Values_2'(_1570284,_1570286,_1570288,_1570290,_1570292)).
'blocked_blocked_blocked_Control.Search.SetFunctions.getSome_1_Control.Search.SetFunctions.Values_2'([],_1561794,_1570536,_1570542,_1570548):-hnf('Prelude.apply'('Prelude._impl\'23return\'23Prelude.Monad\'23Prelude.IO\'23','Prelude.Nothing'),_1570536,_1570542,_1570548).
'blocked_blocked_blocked_Control.Search.SetFunctions.getSome_1_Control.Search.SetFunctions.Values_2'([_1562208|_1562226],_1561794,_1572240,_1572246,_1572252):-!,makeShare(_1562226,_1572410),hnf('Prelude.apply'('Prelude._impl\'23return\'23Prelude.Monad\'23Prelude.IO\'23','Prelude.Just'('Prelude.(,)'(_1562208,'Control.Search.SetFunctions.Values'('Control.Search.SetFunctions.getSome._\'23caseor0'('Prelude.null'(_1572410),_1572410),_1572410)))),_1572240,_1572246,_1572252).
'blocked_blocked_blocked_Control.Search.SetFunctions.getSome_1_Control.Search.SetFunctions.Values_2'('FAIL'(_1575580),_1561794,'FAIL'(_1575580),_1575594,_1575594):-nonvar(_1575580).
'blocked_blocked_Control.Search.SetFunctions.getSome_1'('FAIL'(_1575658),'FAIL'(_1575658),_1575672,_1575672):-nonvar(_1575658).

'Control.Search.SetFunctions.mapValues'(_1577262,_1577264,_1577266,_1577268,_1577270):-freeze(_1577268,'blocked_Control.Search.SetFunctions.mapValues'(_1577262,_1577264,_1577266,_1577268,_1577270)).
'blocked_Control.Search.SetFunctions.mapValues'(_1577358,_1577376,_1578566,_1578572,_1578578):-hnf(_1577376,_1580284,_1578572,_1580302),'blocked_Control.Search.SetFunctions.mapValues_2'(_1580284,_1577358,_1578566,_1580302,_1578578).

'blocked_Control.Search.SetFunctions.mapValues_2'(_1580774,_1580776,_1580778,_1580780,_1580782):-freeze(_1580780,'blocked_blocked_Control.Search.SetFunctions.mapValues_2'(_1580774,_1580776,_1580778,_1580780,_1580782)).
'blocked_blocked_Control.Search.SetFunctions.mapValues_2'('Control.Search.SetFunctions.Values'(_1577492,_1577510),_1577358,'Control.Search.SetFunctions.Values'('Prelude.maybe'('Prelude.Nothing','Prelude..'('Prelude.Just',_1581612),_1577492),'Prelude.map'(_1581612,_1577510)),_1581450,_1581456):-!,makeShare(_1577358,_1581612),_1581450=_1581456.
'blocked_blocked_Control.Search.SetFunctions.mapValues_2'('FAIL'(_1583926),_1577358,'FAIL'(_1583926),_1583940,_1583940):-nonvar(_1583926).

'Control.Search.SetFunctions.foldValues'(_1585576,_1585578,_1585580,_1585582,_1585584,_1585586):-freeze(_1585584,'blocked_Control.Search.SetFunctions.foldValues'(_1585576,_1585578,_1585580,_1585582,_1585584,_1585586)).
'blocked_Control.Search.SetFunctions.foldValues'(_1585682,_1585700,_1585718,_1586042,_1586048,_1586054):-hnf('Prelude.foldr'(_1585682,_1585700,'Control.Search.SetFunctions.valuesOf'(_1585718)),_1586042,_1586048,_1586054).

'Control.Search.SetFunctions.filterValues'(_1589036,_1589038,_1589040,_1589042,_1589044):-freeze(_1589042,'blocked_Control.Search.SetFunctions.filterValues'(_1589036,_1589038,_1589040,_1589042,_1589044)).
'blocked_Control.Search.SetFunctions.filterValues'(_1589132,_1589150,_1590864,_1590870,_1590876):-hnf(_1589150,_1592690,_1590870,_1592708),'blocked_Control.Search.SetFunctions.filterValues_2'(_1592690,_1589132,_1590864,_1592708,_1590876).

'blocked_Control.Search.SetFunctions.filterValues_2'(_1593198,_1593200,_1593202,_1593204,_1593206):-freeze(_1593204,'blocked_blocked_Control.Search.SetFunctions.filterValues_2'(_1593198,_1593200,_1593202,_1593204,_1593206)).
'blocked_blocked_Control.Search.SetFunctions.filterValues_2'('Control.Search.SetFunctions.Values'(_1589266,_1589284),_1589132,_1593868,_1593874,_1593880):-!,makeShare(_1589324,_1594168),makeShare(_1589342,_1594188),hnf('Prelude.cond'(letrec4PAKCS(_1594168,'Prelude.filter'(_1589132,_1589284)),'Prelude.cond'(letrec4PAKCS(_1594188,'Control.Search.SetFunctions.filterValues._\'23caseor0'('Prelude.null'(_1594168),_1594168)),'Control.Search.SetFunctions.Values'(_1594188,_1594168))),_1593868,_1593874,_1593880).
'blocked_blocked_Control.Search.SetFunctions.filterValues_2'('FAIL'(_1597794),_1589132,'FAIL'(_1597794),_1597808,_1597808):-nonvar(_1597794).

'Control.Search.SetFunctions.minValue'(_1599368,_1599370,_1599372,_1599374,_1599376):-freeze(_1599374,'blocked_Control.Search.SetFunctions.minValue'(_1599368,_1599370,_1599372,_1599374,_1599376)).
'blocked_Control.Search.SetFunctions.minValue'(_1599464,_1599482,_1599736,_1599742,_1599748):-hnf('Data.List.minimum'(_1599464,'Control.Search.SetFunctions.valuesOf'(_1599482)),_1599736,_1599742,_1599748).

'Control.Search.SetFunctions.minValueBy'(_1602476,_1602478,_1602480,_1602482,_1602484):-freeze(_1602482,'blocked_Control.Search.SetFunctions.minValueBy'(_1602476,_1602478,_1602480,_1602482,_1602484)).
'blocked_Control.Search.SetFunctions.minValueBy'(_1602572,_1602590,_1602844,_1602850,_1602856):-hnf('Data.List.minimumBy'(_1602572,'Control.Search.SetFunctions.valuesOf'(_1602590)),_1602844,_1602850,_1602856).

'Control.Search.SetFunctions.maxValue'(_1605532,_1605534,_1605536,_1605538,_1605540):-freeze(_1605538,'blocked_Control.Search.SetFunctions.maxValue'(_1605532,_1605534,_1605536,_1605538,_1605540)).
'blocked_Control.Search.SetFunctions.maxValue'(_1605628,_1605646,_1605900,_1605906,_1605912):-hnf('Data.List.maximum'(_1605628,'Control.Search.SetFunctions.valuesOf'(_1605646)),_1605900,_1605906,_1605912).

'Control.Search.SetFunctions.maxValueBy'(_1608640,_1608642,_1608644,_1608646,_1608648):-freeze(_1608646,'blocked_Control.Search.SetFunctions.maxValueBy'(_1608640,_1608642,_1608644,_1608646,_1608648)).
'blocked_Control.Search.SetFunctions.maxValueBy'(_1608736,_1608754,_1609008,_1609014,_1609020):-hnf('Data.List.maximumBy'(_1608736,'Control.Search.SetFunctions.valuesOf'(_1608754)),_1609008,_1609014,_1609020).

'Control.Search.SetFunctions.values2list'(_1611810,_1611812,_1611814,_1611816):-freeze(_1611814,'blocked_Control.Search.SetFunctions.values2list'(_1611810,_1611812,_1611814,_1611816)).
'blocked_Control.Search.SetFunctions.values2list'(_1611896,_1612164,_1612170,_1612176):-hnf('Prelude.apply'('Prelude._impl\'23return\'23Prelude.Monad\'23Prelude.IO\'23','Control.Search.SetFunctions.valuesOf'(_1611896)),_1612164,_1612170,_1612176).

'Control.Search.SetFunctions.printValues'(_1615194,_1615196,_1615198,_1615200,_1615202):-freeze(_1615200,'blocked_Control.Search.SetFunctions.printValues'(_1615194,_1615196,_1615198,_1615200,_1615202)).
'blocked_Control.Search.SetFunctions.printValues'(_1615290,_1615308,_1615982,_1615988,_1615994):-hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','Control.Search.SetFunctions.values2list'(_1615308)),'Prelude.mapM_'(partcall(1,'Prelude._inst\'23Prelude.Monad\'23Prelude.IO\'23',[]),'Prelude.print'(_1615290))),_1615982,_1615988,_1615994).

'Control.Search.SetFunctions.sortValues'(_1620138,_1620140,_1620142,_1620144):-freeze(_1620142,'blocked_Control.Search.SetFunctions.sortValues'(_1620138,_1620140,_1620142,_1620144)).
'blocked_Control.Search.SetFunctions.sortValues'(_1620224,_1620408,_1620414,_1620420):-hnf(partcall(1,'Control.Search.SetFunctions.sortValuesBy',['Prelude.<='(_1620224)]),_1620408,_1620414,_1620420).

'Control.Search.SetFunctions.sortValuesBy'(_1623110,_1623112,_1623114,_1623116,_1623118):-freeze(_1623116,'blocked_Control.Search.SetFunctions.sortValuesBy'(_1623110,_1623112,_1623114,_1623116,_1623118)).
'blocked_Control.Search.SetFunctions.sortValuesBy'(_1623206,_1623224,_1623646,_1623652,_1623658):-hnf('Prelude.apply'('Prelude.apply'('Data.List.sortBy',_1623206),'Control.Search.SetFunctions.valuesOf'(_1623224)),_1623646,_1623652,_1623658).

'Control.Search.SetFunctions.choose._\'23caseor0'(_1627034,_1627036,_1627038,_1627040,_1627042):-freeze(_1627040,'blocked_Control.Search.SetFunctions.choose._\'23caseor0'(_1627034,_1627036,_1627038,_1627040,_1627042)).
'blocked_Control.Search.SetFunctions.choose._\'23caseor0'(_1627130,_1627148,_1627890,_1627896,_1627902):-hnf(_1627130,_1629932,_1627896,_1629950),'blocked_Control.Search.SetFunctions.choose._\'23caseor0_1'(_1629932,_1627148,_1627890,_1629950,_1627902).

'blocked_Control.Search.SetFunctions.choose._\'23caseor0_1'(_1630482,_1630484,_1630486,_1630488,_1630490):-freeze(_1630488,freeze(_1630482,'blocked_blocked_Control.Search.SetFunctions.choose._\'23caseor0_1'(_1630482,_1630484,_1630486,_1630488,_1630490))).
'blocked_blocked_Control.Search.SetFunctions.choose._\'23caseor0_1'('Prelude.True',_1627148,'Prelude.Nothing',_1630882,_1630882).
'blocked_blocked_Control.Search.SetFunctions.choose._\'23caseor0_1'('Prelude.False',_1627148,'Prelude.Just'('Prelude.head'(_1627148)),_1631860,_1631860):-!.
'blocked_blocked_Control.Search.SetFunctions.choose._\'23caseor0_1'('FAIL'(_1632792),_1627148,'FAIL'(_1632792),_1632806,_1632806).

'Control.Search.SetFunctions.select._\'23caseor0'(_1634694,_1634696,_1634698,_1634700,_1634702):-freeze(_1634700,'blocked_Control.Search.SetFunctions.select._\'23caseor0'(_1634694,_1634696,_1634698,_1634700,_1634702)).
'blocked_Control.Search.SetFunctions.select._\'23caseor0'(_1634790,_1634808,_1635550,_1635556,_1635562):-hnf(_1634790,_1637592,_1635556,_1637610),'blocked_Control.Search.SetFunctions.select._\'23caseor0_1'(_1637592,_1634808,_1635550,_1637610,_1635562).

'blocked_Control.Search.SetFunctions.select._\'23caseor0_1'(_1638142,_1638144,_1638146,_1638148,_1638150):-freeze(_1638148,freeze(_1638142,'blocked_blocked_Control.Search.SetFunctions.select._\'23caseor0_1'(_1638142,_1638144,_1638146,_1638148,_1638150))).
'blocked_blocked_Control.Search.SetFunctions.select._\'23caseor0_1'('Prelude.True',_1634808,'Prelude.Nothing',_1638542,_1638542).
'blocked_blocked_Control.Search.SetFunctions.select._\'23caseor0_1'('Prelude.False',_1634808,'Prelude.Just'('Prelude.head'(_1634808)),_1639520,_1639520):-!.
'blocked_blocked_Control.Search.SetFunctions.select._\'23caseor0_1'('FAIL'(_1640452),_1634808,'FAIL'(_1640452),_1640466,_1640466).

'Control.Search.SetFunctions.getSome._\'23caseor0'(_1642392,_1642394,_1642396,_1642398,_1642400):-freeze(_1642398,'blocked_Control.Search.SetFunctions.getSome._\'23caseor0'(_1642392,_1642394,_1642396,_1642398,_1642400)).
'blocked_Control.Search.SetFunctions.getSome._\'23caseor0'(_1642488,_1642506,_1643254,_1643260,_1643266):-hnf(_1642488,_1645332,_1643260,_1645350),'blocked_Control.Search.SetFunctions.getSome._\'23caseor0_1'(_1645332,_1642506,_1643254,_1645350,_1643266).

'blocked_Control.Search.SetFunctions.getSome._\'23caseor0_1'(_1645888,_1645890,_1645892,_1645894,_1645896):-freeze(_1645894,freeze(_1645888,'blocked_blocked_Control.Search.SetFunctions.getSome._\'23caseor0_1'(_1645888,_1645890,_1645892,_1645894,_1645896))).
'blocked_blocked_Control.Search.SetFunctions.getSome._\'23caseor0_1'('Prelude.True',_1642506,'Prelude.Nothing',_1646288,_1646288).
'blocked_blocked_Control.Search.SetFunctions.getSome._\'23caseor0_1'('Prelude.False',_1642506,'Prelude.Just'('Prelude.head'(_1642506)),_1647272,_1647272):-!.
'blocked_blocked_Control.Search.SetFunctions.getSome._\'23caseor0_1'('FAIL'(_1648210),_1642506,'FAIL'(_1648210),_1648224,_1648224).

'Control.Search.SetFunctions.filterValues._\'23caseor0'(_1650340,_1650342,_1650344,_1650346,_1650348):-freeze(_1650346,'blocked_Control.Search.SetFunctions.filterValues._\'23caseor0'(_1650340,_1650342,_1650344,_1650346,_1650348)).
'blocked_Control.Search.SetFunctions.filterValues._\'23caseor0'(_1650436,_1650454,_1651232,_1651238,_1651244):-hnf(_1650436,_1653490,_1651238,_1653508),'blocked_Control.Search.SetFunctions.filterValues._\'23caseor0_1'(_1653490,_1650454,_1651232,_1653508,_1651244).

'blocked_Control.Search.SetFunctions.filterValues._\'23caseor0_1'(_1654076,_1654078,_1654080,_1654082,_1654084):-freeze(_1654082,freeze(_1654076,'blocked_blocked_Control.Search.SetFunctions.filterValues._\'23caseor0_1'(_1654076,_1654078,_1654080,_1654082,_1654084))).
'blocked_blocked_Control.Search.SetFunctions.filterValues._\'23caseor0_1'('Prelude.True',_1650454,'Prelude.Nothing',_1654476,_1654476).
'blocked_blocked_Control.Search.SetFunctions.filterValues._\'23caseor0_1'('Prelude.False',_1650454,'Prelude.Just'('Prelude.head'(_1650454)),_1655490,_1655490):-!.
'blocked_blocked_Control.Search.SetFunctions.filterValues._\'23caseor0_1'('FAIL'(_1656458),_1650454,'FAIL'(_1656458),_1656472,_1656472).

:-costCenters(['']).




%%%%% Number of shared variables: 75

