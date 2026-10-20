%PAKCS3.10 swi9 VARIABLESHARING

:-noSingletonWarnings.
:-noRedefineWarnings.
:-noDiscontiguousWarnings.

:-importModule('Data.Char').
:-importModule('Prelude').
:-importModule('System.Directory').
:-importModule('System.IO').

:-curryModule('Data.PropertyFile').


%%%%%%%%%%%% function types %%%%%%%%%%%%%%%%%%%
:-multifile functiontype/6.
:-dynamic functiontype/6.
functiontype('Data.PropertyFile.readPropertyFile',readPropertyFile,1,'Data.PropertyFile.readPropertyFile',nofix,notype).
functiontype('Data.PropertyFile.readPropertyFile.splitEqs.2','Data.PropertyFile.readPropertyFile.splitEqs.2',1,'Data.PropertyFile.readPropertyFile.splitEqs.2',nofix,notype).
functiontype('Data.PropertyFile.readPropertyFile._\'23lambda3','Data.PropertyFile.readPropertyFile._#lambda3',2,'Data.PropertyFile.readPropertyFile._\'23lambda3',nofix,notype).
functiontype('Data.PropertyFile.readPropertyFile._\'23lambda3._\'23lambda6','Data.PropertyFile.readPropertyFile._#lambda3._#lambda6',1,'Data.PropertyFile.readPropertyFile._\'23lambda3._\'23lambda6',nofix,notype).
functiontype('Data.PropertyFile.readPropertyFile._\'23lambda3._\'23lambda6._\'23lambda8','Data.PropertyFile.readPropertyFile._#lambda3._#lambda6._#lambda8',1,'Data.PropertyFile.readPropertyFile._\'23lambda3._\'23lambda6._\'23lambda8',nofix,notype).
functiontype('Data.PropertyFile.updatePropertyFile',updatePropertyFile,3,'Data.PropertyFile.updatePropertyFile',nofix,notype).
functiontype('Data.PropertyFile.updatePropertyFile._\'23lambda10','Data.PropertyFile.updatePropertyFile._#lambda10',4,'Data.PropertyFile.updatePropertyFile._\'23lambda10',nofix,notype).
functiontype('Data.PropertyFile.changePropertyInFile','Data.PropertyFile.changePropertyInFile',3,'Data.PropertyFile.changePropertyInFile',nofix,notype).
functiontype('Data.PropertyFile.changePropertyInFile.changeProp.20','Data.PropertyFile.changePropertyInFile.changeProp.20',3,'Data.PropertyFile.changePropertyInFile.changeProp.20',nofix,notype).
functiontype('Data.PropertyFile.changePropertyInFile.changeProp.20._\'23selFP2\'23s1','Data.PropertyFile.changePropertyInFile.changeProp.20._#selFP2#s1',1,'Data.PropertyFile.changePropertyInFile.changeProp.20._\'23selFP2\'23s1',nofix,notype).
functiontype('Data.PropertyFile.changePropertyInFile.changeProp.20._\'23selFP3\'23s2','Data.PropertyFile.changePropertyInFile.changeProp.20._#selFP3#s2',1,'Data.PropertyFile.changePropertyInFile.changeProp.20._\'23selFP3\'23s2',nofix,notype).
functiontype('Data.PropertyFile.changePropertyInFile._\'23lambda13','Data.PropertyFile.changePropertyInFile._#lambda13',4,'Data.PropertyFile.changePropertyInFile._\'23lambda13',nofix,notype).
functiontype('Data.PropertyFile.getPropertyFromFile',getPropertyFromFile,2,'Data.PropertyFile.getPropertyFromFile',nofix,notype).
functiontype('Data.PropertyFile.getPropertyFromFile._\'23lambda16','Data.PropertyFile.getPropertyFromFile._#lambda16',2,'Data.PropertyFile.getPropertyFromFile._\'23lambda16',nofix,notype).
functiontype('Data.PropertyFile.getPropertyFromFile._\'23lambda16._\'23lambda18','Data.PropertyFile.getPropertyFromFile._#lambda16._#lambda18',1,'Data.PropertyFile.getPropertyFromFile._\'23lambda16._\'23lambda18',nofix,notype).
functiontype('Data.PropertyFile.getPropertiesFromFile',getPropertiesFromFile,2,'Data.PropertyFile.getPropertiesFromFile',nofix,notype).
functiontype('Data.PropertyFile.getPropertiesFromFile._\'23lambda20','Data.PropertyFile.getPropertiesFromFile._#lambda20',2,'Data.PropertyFile.getPropertiesFromFile._\'23lambda20',nofix,notype).
functiontype('Data.PropertyFile.getPropertiesFromFile._\'23lambda20._\'23lambda22','Data.PropertyFile.getPropertiesFromFile._#lambda20._#lambda22',1,'Data.PropertyFile.getPropertiesFromFile._\'23lambda20._\'23lambda22',nofix,notype).
functiontype('Data.PropertyFile.updatePropertyFile._\'23lambda10._\'23caseor0','Data.PropertyFile.updatePropertyFile._#lambda10._#caseor0',4,'Data.PropertyFile.updatePropertyFile._\'23lambda10._\'23caseor0',nofix,notype).
functiontype('Data.PropertyFile.changePropertyInFile.changeProp.20._\'23caseor0','Data.PropertyFile.changePropertyInFile.changeProp.20._#caseor0',5,'Data.PropertyFile.changePropertyInFile.changeProp.20._\'23caseor0',nofix,notype).

%%%%%%%%%%%% constructor types %%%%%%%%%%%%%%%%%%%
:-multifile constructortype/7.
:-dynamic constructortype/7.

%%%%%%%%%%%% function definitions %%%%%%%%%%%%%%%%%%%
'Data.PropertyFile.readPropertyFile'(_18197886,_18197888,_18197890,_18197892):-freeze(_18197890,'blocked_Data.PropertyFile.readPropertyFile'(_18197886,_18197888,_18197890,_18197892)).
'blocked_Data.PropertyFile.readPropertyFile'(_18197972,_18198478,_18198484,_18198490):-makeShare(_18197972,_18198572),hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','System.Directory.doesFileExist'(_18198572)),partcall(1,'Data.PropertyFile.readPropertyFile._\'23lambda3',[_18198572])),_18198478,_18198484,_18198490).

'Data.PropertyFile.readPropertyFile.splitEqs.2'(_18202598,_18202600,_18202602,_18202604):-freeze(_18202602,'blocked_Data.PropertyFile.readPropertyFile.splitEqs.2'(_18202598,_18202600,_18202602,_18202604)).
'blocked_Data.PropertyFile.readPropertyFile.splitEqs.2'(_18202684,_18204572,_18204578,_18204584):-hnf(_18202684,_18206570,_18204578,_18206582),'blocked_Data.PropertyFile.readPropertyFile.splitEqs.2_1'(_18206570,_18204572,_18206582,_18204584).

'blocked_Data.PropertyFile.readPropertyFile.splitEqs.2_1'(_18207094,_18207096,_18207098,_18207100):-freeze(_18207098,'blocked_blocked_Data.PropertyFile.readPropertyFile.splitEqs.2_1'(_18207094,_18207096,_18207098,_18207100)).
'blocked_blocked_Data.PropertyFile.readPropertyFile.splitEqs.2_1'([],[],_18207342,_18207342).
'blocked_blocked_Data.PropertyFile.readPropertyFile.splitEqs.2_1'([_18202900|_18202918],_18210276,_18210282,_18210288):-!,hnf('Prelude.apply'('Prelude.break'(partcall(1,'Prelude.flip',[^=,partcall(2,'Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Char\'23',[])])),_18202900),_18212856,_18210282,_18212822),'blocked_blocked_Data.PropertyFile.readPropertyFile.splitEqs.2_1_[|]_ComplexCase'(_18212856,_18202900,_18202918,_18210276,_18212822,_18210288).

'blocked_blocked_Data.PropertyFile.readPropertyFile.splitEqs.2_1_[|]_ComplexCase'(_18213518,_18213520,_18213522,_18213524,_18213526,_18213528):-freeze(_18213526,freeze(_18213518,'blocked_blocked_blocked_Data.PropertyFile.readPropertyFile.splitEqs.2_1_[|]_ComplexCase'(_18213518,_18213520,_18213522,_18213524,_18213526,_18213528))).
'blocked_blocked_blocked_Data.PropertyFile.readPropertyFile.splitEqs.2_1_[|]_ComplexCase'('Prelude.(,)'(_18203452,_18203470),_18202900,_18202918,_18214474,_18214480,_18214486):-!,hnf(_18203470,_18218072,_18214480,_18218102),'blocked_blocked_blocked_Data.PropertyFile.readPropertyFile.splitEqs.2_1_[|]_ComplexCase_Prelude.(,)_2'(_18218072,_18203452,_18202900,_18202918,_18214474,_18218102,_18214486).

'blocked_blocked_blocked_Data.PropertyFile.readPropertyFile.splitEqs.2_1_[|]_ComplexCase_Prelude.(,)_2'(_18218938,_18218940,_18218942,_18218944,_18218946,_18218948,_18218950):-freeze(_18218948,freeze(_18218938,'blocked_blocked_blocked_blocked_Data.PropertyFile.readPropertyFile.splitEqs.2_1_[|]_ComplexCase_Prelude.(,)_2'(_18218938,_18218940,_18218942,_18218944,_18218946,_18218948,_18218950))).
'blocked_blocked_blocked_blocked_Data.PropertyFile.readPropertyFile.splitEqs.2_1_[|]_ComplexCase_Prelude.(,)_2'([_18203598|_18203616],_18203452,_18202900,_18202918,['Prelude.(,)'(_18203452,_18203616)|'Data.PropertyFile.readPropertyFile.splitEqs.2'(_18202918)],_18219250,_18219250).
'blocked_blocked_blocked_blocked_Data.PropertyFile.readPropertyFile.splitEqs.2_1_[|]_ComplexCase_Prelude.(,)_2'([],_18203452,_18202900,_18202918,_18221390,_18221396,_18221402):-!,hnf('Data.PropertyFile.readPropertyFile.splitEqs.2'(_18202918),_18221390,_18221396,_18221402).
'blocked_blocked_blocked_blocked_Data.PropertyFile.readPropertyFile.splitEqs.2_1_[|]_ComplexCase_Prelude.(,)_2'('FAIL'(_18222786),_18203452,_18202900,_18202918,'FAIL'(_18222786),_18222800,_18222800).
'blocked_blocked_blocked_Data.PropertyFile.readPropertyFile.splitEqs.2_1_[|]_ComplexCase'('FAIL'(_18222876),_18202900,_18202918,'FAIL'(_18222876),_18222890,_18222890).
'blocked_blocked_Data.PropertyFile.readPropertyFile.splitEqs.2_1'('FAIL'(_18222958),'FAIL'(_18222958),_18222972,_18222972):-nonvar(_18222958).

'Data.PropertyFile.readPropertyFile._\'23lambda3'(_18224856,_18224858,_18224860,_18224862,_18224864):-freeze(_18224862,'blocked_Data.PropertyFile.readPropertyFile._\'23lambda3'(_18224856,_18224858,_18224860,_18224862,_18224864)).
'blocked_Data.PropertyFile.readPropertyFile._\'23lambda3'(_18224952,_18224970,_18226560,_18226566,_18226572):-hnf(_18224970,_18228602,_18226566,_18228620),'blocked_Data.PropertyFile.readPropertyFile._\'23lambda3_2'(_18228602,_18224952,_18226560,_18228620,_18226572).

'blocked_Data.PropertyFile.readPropertyFile._\'23lambda3_2'(_18229152,_18229154,_18229156,_18229158,_18229160):-freeze(_18229158,freeze(_18229152,'blocked_blocked_Data.PropertyFile.readPropertyFile._\'23lambda3_2'(_18229152,_18229154,_18229156,_18229158,_18229160))).
'blocked_blocked_Data.PropertyFile.readPropertyFile._\'23lambda3_2'('Prelude.True',_18224952,_18229546,_18229552,_18229558):-hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','System.IO.openFile'(_18224952,'System.IO.ReadMode')),partcall(1,'System.IO.hGetContents',[]))),partcall(1,'Data.PropertyFile.readPropertyFile._\'23lambda3._\'23lambda6',[])),_18229546,_18229552,_18229558).
'blocked_blocked_Data.PropertyFile.readPropertyFile._\'23lambda3_2'('Prelude.False',_18224952,_18233234,_18233240,_18233246):-!,hnf('Prelude.apply'('Prelude._impl\'23return\'23Prelude.Monad\'23Prelude.IO\'23',[]),_18233234,_18233240,_18233246).
'blocked_blocked_Data.PropertyFile.readPropertyFile._\'23lambda3_2'('FAIL'(_18234468),_18224952,'FAIL'(_18234468),_18234482,_18234482).

'Data.PropertyFile.readPropertyFile._\'23lambda3._\'23lambda6'(_18236778,_18236780,_18236782,_18236784):-freeze(_18236782,'blocked_Data.PropertyFile.readPropertyFile._\'23lambda3._\'23lambda6'(_18236778,_18236780,_18236782,_18236784)).
'blocked_Data.PropertyFile.readPropertyFile._\'23lambda3._\'23lambda6'(_18236864,_18237978,_18237984,_18237990):-makeShare(_18236892,_18238110),hnf('Prelude.cond'(letrec4PAKCS(_18238110,_18236864),'Prelude.$'('Prelude._impl\'23return\'23Prelude.Monad\'23Prelude.IO\'23','Prelude.$'('Prelude..'(partcall(1,'Data.PropertyFile.readPropertyFile.splitEqs.2',[]),'Prelude..'(partcall(1,'Prelude.filter',[partcall(1,'Data.PropertyFile.readPropertyFile._\'23lambda3._\'23lambda6._\'23lambda8',[])]),partcall(1,'Prelude.lines',[]))),_18238110))),_18237978,_18237984,_18237990).

'Data.PropertyFile.readPropertyFile._\'23lambda3._\'23lambda6._\'23lambda8'(_18244648,_18244650,_18244652,_18244654):-freeze(_18244652,'blocked_Data.PropertyFile.readPropertyFile._\'23lambda3._\'23lambda6._\'23lambda8'(_18244648,_18244650,_18244652,_18244654)).
'blocked_Data.PropertyFile.readPropertyFile._\'23lambda3._\'23lambda6._\'23lambda8'(_18244734,_18245240,_18245246,_18245252):-makeShare(_18244734,_18245334),hnf('Prelude.&&'('Prelude.not'('Prelude.null'(_18245334)),'Prelude.isAlpha'('Prelude.head'(_18245334))),_18245240,_18245246,_18245252).

'Data.PropertyFile.updatePropertyFile'(_18248696,_18248698,_18248700,_18248702,_18248704,_18248706):-freeze(_18248704,'blocked_Data.PropertyFile.updatePropertyFile'(_18248696,_18248698,_18248700,_18248702,_18248704,_18248706)).
'blocked_Data.PropertyFile.updatePropertyFile'(_18248802,_18248820,_18248838,_18249484,_18249490,_18249496):-makeShare(_18248802,_18249658),hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','Data.PropertyFile.readPropertyFile'(_18249658)),partcall(1,'Data.PropertyFile.updatePropertyFile._\'23lambda10',[_18248838,_18248820,_18249658])),_18249484,_18249490,_18249496).

'Data.PropertyFile.updatePropertyFile._\'23lambda10'(_18254138,_18254140,_18254142,_18254144,_18254146,_18254148,_18254150):-freeze(_18254148,'blocked_Data.PropertyFile.updatePropertyFile._\'23lambda10'(_18254138,_18254140,_18254142,_18254144,_18254146,_18254148,_18254150)).
'blocked_Data.PropertyFile.updatePropertyFile._\'23lambda10'(_18254254,_18254272,_18254290,_18254308,_18255618,_18255624,_18255630):-makeShare(_18254336,_18255960),makeShare(_18254272,_18255980),hnf('Prelude.cond'(letrec4PAKCS(_18255960,_18254308),'Data.PropertyFile.updatePropertyFile._\'23lambda10._\'23caseor0'('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Maybe\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])]),'Prelude.lookup'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])]),_18255980,_18255960),'Prelude.Nothing'),_18254254,_18255980,_18254290)),_18255618,_18255624,_18255630).

'Data.PropertyFile.changePropertyInFile'(_18262472,_18262474,_18262476,_18262478,_18262480,_18262482):-freeze(_18262480,'blocked_Data.PropertyFile.changePropertyInFile'(_18262472,_18262474,_18262476,_18262478,_18262480,_18262482)).
'blocked_Data.PropertyFile.changePropertyInFile'(_18262578,_18262596,_18262614,_18263680,_18263686,_18263692):-makeShare(_18262578,_18263864),hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','System.IO.openFile'(_18263864,'System.IO.ReadMode')),partcall(1,'System.IO.hGetContents',[]))),partcall(1,'Data.PropertyFile.changePropertyInFile._\'23lambda13',[_18262614,_18262596,_18263864])),_18263680,_18263686,_18263692).

'Data.PropertyFile.changePropertyInFile.changeProp.20'(_18269714,_18269716,_18269718,_18269720,_18269722,_18269724):-freeze(_18269722,'blocked_Data.PropertyFile.changePropertyInFile.changeProp.20'(_18269714,_18269716,_18269718,_18269720,_18269722,_18269724)).
'blocked_Data.PropertyFile.changePropertyInFile.changeProp.20'(_18269820,_18269838,_18269856,_18272544,_18272550,_18272556):-makeShare(_18269884,_18273116),makeShare(_18269856,_18273136),makeShare(_18269902,_18273156),makeShare(_18269920,_18273176),hnf('Prelude.cond'(letrec4PAKCS(_18273116,'Prelude.apply'('Prelude.break'(partcall(1,'Prelude.flip',[^=,partcall(2,'Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Char\'23',[])])),_18273136)),'Prelude.cond'(letrec4PAKCS(_18273156,'Data.PropertyFile.changePropertyInFile.changeProp.20._\'23selFP2\'23s1'(_18273116)),'Prelude.cond'(letrec4PAKCS(_18273176,'Data.PropertyFile.changePropertyInFile.changeProp.20._\'23selFP3\'23s2'(_18273116)),'Data.PropertyFile.changePropertyInFile.changeProp.20._\'23caseor0'('Prelude.||'('Prelude.null'(_18273136),'Prelude.||'('Prelude.not'('Prelude.isAlpha'('Prelude.head'(_18273136))),'Prelude.null'(_18273176))),_18269820,_18273156,_18269838,_18273136)))),_18272544,_18272550,_18272556).

'Data.PropertyFile.changePropertyInFile.changeProp.20._\'23selFP2\'23s1'(_18283522,_18283524,_18283526,_18283528):-freeze(_18283526,'blocked_Data.PropertyFile.changePropertyInFile.changeProp.20._\'23selFP2\'23s1'(_18283522,_18283524,_18283526,_18283528)).
'blocked_Data.PropertyFile.changePropertyInFile.changeProp.20._\'23selFP2\'23s1'(_18283608,_18284262,_18284268,_18284274):-hnf(_18283608,_18287088,_18284268,_18287100),'blocked_Data.PropertyFile.changePropertyInFile.changeProp.20._\'23selFP2\'23s1_1'(_18287088,_18284262,_18287100,_18284274).

'blocked_Data.PropertyFile.changePropertyInFile.changeProp.20._\'23selFP2\'23s1_1'(_18287750,_18287752,_18287754,_18287756):-freeze(_18287754,'blocked_blocked_Data.PropertyFile.changePropertyInFile.changeProp.20._\'23selFP2\'23s1_1'(_18287750,_18287752,_18287754,_18287756)).
'blocked_blocked_Data.PropertyFile.changePropertyInFile.changeProp.20._\'23selFP2\'23s1_1'('Prelude.(,)'(_18283724,_18283742),_18288120,_18288126,_18288132):-!,hnf(_18283724,_18288120,_18288126,_18288132).
'blocked_blocked_Data.PropertyFile.changePropertyInFile.changeProp.20._\'23selFP2\'23s1_1'('FAIL'(_18288908),'FAIL'(_18288908),_18288922,_18288922):-nonvar(_18288908).

'Data.PropertyFile.changePropertyInFile.changeProp.20._\'23selFP3\'23s2'(_18291594,_18291596,_18291598,_18291600):-freeze(_18291598,'blocked_Data.PropertyFile.changePropertyInFile.changeProp.20._\'23selFP3\'23s2'(_18291594,_18291596,_18291598,_18291600)).
'blocked_Data.PropertyFile.changePropertyInFile.changeProp.20._\'23selFP3\'23s2'(_18291680,_18292334,_18292340,_18292346):-hnf(_18291680,_18295160,_18292340,_18295172),'blocked_Data.PropertyFile.changePropertyInFile.changeProp.20._\'23selFP3\'23s2_1'(_18295160,_18292334,_18295172,_18292346).

'blocked_Data.PropertyFile.changePropertyInFile.changeProp.20._\'23selFP3\'23s2_1'(_18295822,_18295824,_18295826,_18295828):-freeze(_18295826,'blocked_blocked_Data.PropertyFile.changePropertyInFile.changeProp.20._\'23selFP3\'23s2_1'(_18295822,_18295824,_18295826,_18295828)).
'blocked_blocked_Data.PropertyFile.changePropertyInFile.changeProp.20._\'23selFP3\'23s2_1'('Prelude.(,)'(_18291796,_18291814),_18296192,_18296198,_18296204):-!,hnf(_18291814,_18296192,_18296198,_18296204).
'blocked_blocked_Data.PropertyFile.changePropertyInFile.changeProp.20._\'23selFP3\'23s2_1'('FAIL'(_18296980),'FAIL'(_18296980),_18296994,_18296994):-nonvar(_18296980).

'Data.PropertyFile.changePropertyInFile._\'23lambda13'(_18299068,_18299070,_18299072,_18299074,_18299076,_18299078,_18299080):-freeze(_18299078,'blocked_Data.PropertyFile.changePropertyInFile._\'23lambda13'(_18299068,_18299070,_18299072,_18299074,_18299076,_18299078,_18299080)).
'blocked_Data.PropertyFile.changePropertyInFile._\'23lambda13'(_18299184,_18299202,_18299220,_18299238,_18300478,_18300484,_18300490):-makeShare(_18299266,_18300782),hnf('Prelude.cond'(letrec4PAKCS(_18300782,_18299238),'Prelude.writeFile'(_18299184,'Prelude.$'('Prelude..'('Prelude.unlines','Prelude..'(partcall(1,'Prelude.map',[partcall(1,'Data.PropertyFile.changePropertyInFile.changeProp.20',[_18299220,_18299202])]),partcall(1,'Prelude.lines',[]))),_18300782))),_18300478,_18300484,_18300490).

'Data.PropertyFile.getPropertyFromFile'(_18305890,_18305892,_18305894,_18305896,_18305898):-freeze(_18305896,'blocked_Data.PropertyFile.getPropertyFromFile'(_18305890,_18305892,_18305894,_18305896,_18305898)).
'blocked_Data.PropertyFile.getPropertyFromFile'(_18305986,_18306004,_18306510,_18306516,_18306522):-hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','Data.PropertyFile.readPropertyFile'(_18305986)),partcall(1,'Data.PropertyFile.getPropertyFromFile._\'23lambda16',[_18306004])),_18306510,_18306516,_18306522).

'Data.PropertyFile.getPropertyFromFile._\'23lambda16'(_18310686,_18310688,_18310690,_18310692,_18310694):-freeze(_18310692,'blocked_Data.PropertyFile.getPropertyFromFile._\'23lambda16'(_18310686,_18310688,_18310690,_18310692,_18310694)).
'blocked_Data.PropertyFile.getPropertyFromFile._\'23lambda16'(_18310782,_18310800,_18311984,_18311990,_18311996):-makeShare(_18310828,_18312162),hnf('Prelude.cond'(letrec4PAKCS(_18312162,_18310800),'Prelude.$'('Prelude._impl\'23return\'23Prelude.Monad\'23Prelude.IO\'23','Prelude.lookup'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])]),'Prelude.map'(partcall(1,'Data.Char.toLower',[]),_18310782),'Prelude.map'(partcall(1,'Data.PropertyFile.getPropertyFromFile._\'23lambda16._\'23lambda18',[]),_18312162)))),_18311984,_18311990,_18311996).

'Data.PropertyFile.getPropertyFromFile._\'23lambda16._\'23lambda18'(_18318688,_18318690,_18318692,_18318694):-freeze(_18318692,'blocked_Data.PropertyFile.getPropertyFromFile._\'23lambda16._\'23lambda18'(_18318688,_18318690,_18318692,_18318694)).
'blocked_Data.PropertyFile.getPropertyFromFile._\'23lambda16._\'23lambda18'(_18318774,_18319720,_18319726,_18319732):-hnf(_18318774,_18322366,_18319726,_18322378),'blocked_Data.PropertyFile.getPropertyFromFile._\'23lambda16._\'23lambda18_1'(_18322366,_18319720,_18322378,_18319732).

'blocked_Data.PropertyFile.getPropertyFromFile._\'23lambda16._\'23lambda18_1'(_18322998,_18323000,_18323002,_18323004):-freeze(_18323002,'blocked_blocked_Data.PropertyFile.getPropertyFromFile._\'23lambda16._\'23lambda18_1'(_18322998,_18323000,_18323002,_18323004)).
'blocked_blocked_Data.PropertyFile.getPropertyFromFile._\'23lambda16._\'23lambda18_1'('Prelude.(,)'(_18318890,_18318908),'Prelude.(,)'('Prelude.map'(partcall(1,'Data.Char.toLower',[]),_18318890),_18318908),_18323374,_18323374):-!.
'blocked_blocked_Data.PropertyFile.getPropertyFromFile._\'23lambda16._\'23lambda18_1'('FAIL'(_18324758),'FAIL'(_18324758),_18324772,_18324772):-nonvar(_18324758).

'Data.PropertyFile.getPropertiesFromFile'(_18326438,_18326440,_18326442,_18326444,_18326446):-freeze(_18326444,'blocked_Data.PropertyFile.getPropertiesFromFile'(_18326438,_18326440,_18326442,_18326444,_18326446)).
'blocked_Data.PropertyFile.getPropertiesFromFile'(_18326534,_18326552,_18327058,_18327064,_18327070):-hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','Data.PropertyFile.readPropertyFile'(_18326534)),partcall(1,'Data.PropertyFile.getPropertiesFromFile._\'23lambda20',[_18326552])),_18327058,_18327064,_18327070).

'Data.PropertyFile.getPropertiesFromFile._\'23lambda20'(_18331334,_18331336,_18331338,_18331340,_18331342):-freeze(_18331340,'blocked_Data.PropertyFile.getPropertiesFromFile._\'23lambda20'(_18331334,_18331336,_18331338,_18331340,_18331342)).
'blocked_Data.PropertyFile.getPropertiesFromFile._\'23lambda20'(_18331430,_18331448,_18332884,_18332890,_18332896):-makeShare(_18331476,_18333068),hnf('Prelude.cond'(letrec4PAKCS(_18333068,_18331448),'Prelude.apply'('Prelude._impl\'23return\'23Prelude.Monad\'23Prelude.IO\'23','Prelude.map'(partcall(1,'Prelude.flip',['Prelude.map'(partcall(1,'Data.PropertyFile.getPropertiesFromFile._\'23lambda20._\'23lambda22',[]),_18333068),partcall(2,'Prelude.lookup',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23',[partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[])])])]),'Prelude.map'(partcall(1,'Prelude.map',[partcall(1,'Data.Char.toLower',[])]),_18331430)))),_18332884,_18332890,_18332896).

'Data.PropertyFile.getPropertiesFromFile._\'23lambda20._\'23lambda22'(_18340228,_18340230,_18340232,_18340234):-freeze(_18340232,'blocked_Data.PropertyFile.getPropertiesFromFile._\'23lambda20._\'23lambda22'(_18340228,_18340230,_18340232,_18340234)).
'blocked_Data.PropertyFile.getPropertiesFromFile._\'23lambda20._\'23lambda22'(_18340314,_18341272,_18341278,_18341284):-hnf(_18340314,_18343990,_18341278,_18344002),'blocked_Data.PropertyFile.getPropertiesFromFile._\'23lambda20._\'23lambda22_1'(_18343990,_18341272,_18344002,_18341284).

'blocked_Data.PropertyFile.getPropertiesFromFile._\'23lambda20._\'23lambda22_1'(_18344634,_18344636,_18344638,_18344640):-freeze(_18344638,'blocked_blocked_Data.PropertyFile.getPropertiesFromFile._\'23lambda20._\'23lambda22_1'(_18344634,_18344636,_18344638,_18344640)).
'blocked_blocked_Data.PropertyFile.getPropertiesFromFile._\'23lambda20._\'23lambda22_1'('Prelude.(,)'(_18340430,_18340448),'Prelude.(,)'('Prelude.map'(partcall(1,'Data.Char.toLower',[]),_18340430),_18340448),_18345010,_18345010):-!.
'blocked_blocked_Data.PropertyFile.getPropertiesFromFile._\'23lambda20._\'23lambda22_1'('FAIL'(_18346406),'FAIL'(_18346406),_18346420,_18346420):-nonvar(_18346406).

'Data.PropertyFile.updatePropertyFile._\'23lambda10._\'23caseor0'(_18348826,_18348828,_18348830,_18348832,_18348834,_18348836,_18348838):-freeze(_18348836,'blocked_Data.PropertyFile.updatePropertyFile._\'23lambda10._\'23caseor0'(_18348826,_18348828,_18348830,_18348832,_18348834,_18348836,_18348838)).
'blocked_Data.PropertyFile.updatePropertyFile._\'23lambda10._\'23caseor0'(_18348942,_18348960,_18348978,_18348996,_18350822,_18350828,_18350834):-hnf(_18348942,_18353420,_18350828,_18353450),'blocked_Data.PropertyFile.updatePropertyFile._\'23lambda10._\'23caseor0_1'(_18353420,_18348960,_18348978,_18348996,_18350822,_18353450,_18350834).

'blocked_Data.PropertyFile.updatePropertyFile._\'23lambda10._\'23caseor0_1'(_18354088,_18354090,_18354092,_18354094,_18354096,_18354098,_18354100):-freeze(_18354098,freeze(_18354088,'blocked_blocked_Data.PropertyFile.updatePropertyFile._\'23lambda10._\'23caseor0_1'(_18354088,_18354090,_18354092,_18354094,_18354096,_18354098,_18354100))).
'blocked_blocked_Data.PropertyFile.updatePropertyFile._\'23lambda10._\'23caseor0_1'('Prelude.True',_18348960,_18348978,_18348996,_18354502,_18354508,_18354514):-hnf('Prelude.appendFile'(_18348960,'Prelude.++'(_18348978,'Prelude.++'([^=],'Prelude.++'(_18348996,['^010'])))),_18354502,_18354508,_18354514).
'blocked_blocked_Data.PropertyFile.updatePropertyFile._\'23lambda10._\'23caseor0_1'('Prelude.False',_18348960,_18348978,_18348996,_18357394,_18357400,_18357406):-!,hnf('Data.PropertyFile.changePropertyInFile'(_18348960,_18348978,_18348996),_18357394,_18357400,_18357406).
'blocked_blocked_Data.PropertyFile.updatePropertyFile._\'23lambda10._\'23caseor0_1'('FAIL'(_18358788),_18348960,_18348978,_18348996,'FAIL'(_18358788),_18358802,_18358802).

'Data.PropertyFile.changePropertyInFile.changeProp.20._\'23caseor0'(_18361390,_18361392,_18361394,_18361396,_18361398,_18361400,_18361402,_18361404):-freeze(_18361402,'blocked_Data.PropertyFile.changePropertyInFile.changeProp.20._\'23caseor0'(_18361390,_18361392,_18361394,_18361396,_18361398,_18361400,_18361402,_18361404)).
'blocked_Data.PropertyFile.changePropertyInFile.changeProp.20._\'23caseor0'(_18361516,_18361534,_18361552,_18361570,_18361588,_18363160,_18363166,_18363172):-hnf(_18361516,_18365874,_18363166,_18365910),'blocked_Data.PropertyFile.changePropertyInFile.changeProp.20._\'23caseor0_1'(_18365874,_18361534,_18361552,_18361570,_18361588,_18363160,_18365910,_18363172).

'blocked_Data.PropertyFile.changePropertyInFile.changeProp.20._\'23caseor0_1'(_18366574,_18366576,_18366578,_18366580,_18366582,_18366584,_18366586,_18366588):-freeze(_18366586,freeze(_18366574,'blocked_blocked_Data.PropertyFile.changePropertyInFile.changeProp.20._\'23caseor0_1'(_18366574,_18366576,_18366578,_18366580,_18366582,_18366584,_18366586,_18366588))).
'blocked_blocked_Data.PropertyFile.changePropertyInFile.changeProp.20._\'23caseor0_1'('Prelude.True',_18361534,_18361552,_18361570,_18361588,_18366998,_18367004,_18367010):-hnf(_18361588,_18366998,_18367004,_18367010).
'blocked_blocked_Data.PropertyFile.changePropertyInFile.changeProp.20._\'23caseor0_1'('Prelude.False',_18361534,_18361552,_18361570,_18361588,_18370550,_18370556,_18370562):-!,makeShare(_18361552,_18368408),hnf('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23\'5B\'5D\'230\'23\'23'(partcall(1,'Prelude._inst\'23Prelude.Eq\'23Prelude.Char\'23',[]),_18368408,_18361534),_18374158,_18370556,_18374112),'blocked_blocked_Data.PropertyFile.changePropertyInFile.changeProp.20._\'23caseor0_1_Prelude.False_ComplexCase'(_18374158,_18361534,_18368408,_18361570,_18361588,_18370550,_18374112,_18370562).

'blocked_blocked_Data.PropertyFile.changePropertyInFile.changeProp.20._\'23caseor0_1_Prelude.False_ComplexCase'(_18375010,_18375012,_18375014,_18375016,_18375018,_18375020,_18375022,_18375024):-freeze(_18375022,freeze(_18375010,'blocked_blocked_blocked_Data.PropertyFile.changePropertyInFile.changeProp.20._\'23caseor0_1_Prelude.False_ComplexCase'(_18375010,_18375012,_18375014,_18375016,_18375018,_18375020,_18375022,_18375024))).
'blocked_blocked_blocked_Data.PropertyFile.changePropertyInFile.changeProp.20._\'23caseor0_1_Prelude.False_ComplexCase'('Prelude.True',_18361534,_18368408,_18361570,_18361588,_18375434,_18375440,_18375446):-hnf('Prelude.++'(_18368408,'Prelude.++'([^=],_18361570)),_18375434,_18375440,_18375446).
'blocked_blocked_blocked_Data.PropertyFile.changePropertyInFile.changeProp.20._\'23caseor0_1_Prelude.False_ComplexCase'('Prelude.False',_18361534,_18368408,_18361570,_18361588,_18377736,_18377742,_18377748):-!,hnf(_18361588,_18377736,_18377742,_18377748).
'blocked_blocked_blocked_Data.PropertyFile.changePropertyInFile.changeProp.20._\'23caseor0_1_Prelude.False_ComplexCase'('FAIL'(_18378868),_18361534,_18368408,_18361570,_18361588,'FAIL'(_18378868),_18378882,_18378882).
'blocked_blocked_Data.PropertyFile.changePropertyInFile.changeProp.20._\'23caseor0_1'('FAIL'(_18378966),_18361534,_18361552,_18361570,_18361588,'FAIL'(_18378966),_18378980,_18378980).

:-costCenters(['']).




%%%%% Number of shared variables: 15

