%PAKCS3.10 swi9 VARIABLESHARING

:-noSingletonWarnings.
:-noRedefineWarnings.
:-noDiscontiguousWarnings.

:-importModule('Control.Applicative').
:-importModule('Prelude').

:-curryModule('Control.Monad').


%%%%%%%%%%%% function types %%%%%%%%%%%%%%%%%%%
:-multifile functiontype/6.
:-dynamic functiontype/6.
functiontype('Control.Monad.filterM',filterM,2,'Control.Monad.filterM',nofix,notype).
functiontype('Control.Monad.filterM._\'23lambda1','Control.Monad.filterM._#lambda1',3,'Control.Monad.filterM._\'23lambda1',nofix,notype).
functiontype('Control.Monad.filterM._\'23lambda1._\'23lambda2','Control.Monad.filterM._#lambda1._#lambda2',2,'Control.Monad.filterM._\'23lambda1._\'23lambda2',nofix,notype).
functiontype('Control.Monad.\'3E\'3D\'3E',>=>,3,'Control.Monad.\'3E\'3D\'3E',nofix,notype).
functiontype('Control.Monad.\'3E\'3D\'3E._\'23lambda3','Control.Monad.>=>._#lambda3',4,'Control.Monad.\'3E\'3D\'3E._\'23lambda3',nofix,notype).
functiontype('Control.Monad.\'3C\'3D\'3C',<=<,1,'Control.Monad.\'3C\'3D\'3C',nofix,notype).
functiontype('Control.Monad.forever',forever,2,'Control.Monad.forever',nofix,notype).
functiontype('Control.Monad.mapAndUnzipM',mapAndUnzipM,3,'Control.Monad.mapAndUnzipM',nofix,notype).
functiontype('Control.Monad.zipWithM',zipWithM,4,'Control.Monad.zipWithM',nofix,notype).
functiontype('Control.Monad.zipWithM_',zipWithM_,4,'Control.Monad.zipWithM_',nofix,notype).
functiontype('Control.Monad.foldM',foldM,4,'Control.Monad.foldM',nofix,notype).
functiontype('Control.Monad.foldM.f\'27.21','Control.Monad.foldM.f\'.21',5,'Control.Monad.foldM.f\'27.21',nofix,notype).
functiontype('Control.Monad.foldM_',foldM_,4,'Control.Monad.foldM_',nofix,notype).
functiontype('Control.Monad.replicateM',replicateM,3,'Control.Monad.replicateM',nofix,notype).
functiontype('Control.Monad.replicateM.loop.27','Control.Monad.replicateM.loop.27',5,'Control.Monad.replicateM.loop.27',nofix,notype).
functiontype('Control.Monad.replicateM_',replicateM_,3,'Control.Monad.replicateM_',nofix,notype).
functiontype('Control.Monad.replicateM_.loop.31','Control.Monad.replicateM_.loop.31',5,'Control.Monad.replicateM_.loop.31',nofix,notype).
functiontype('Control.Monad.unless',unless,3,'Control.Monad.unless',nofix,notype).
functiontype('Control.Monad.liftM3',liftM3,5,'Control.Monad.liftM3',nofix,notype).
functiontype('Control.Monad.liftM3._\'23lambda7','Control.Monad.liftM3._#lambda7',5,'Control.Monad.liftM3._\'23lambda7',nofix,notype).
functiontype('Control.Monad.liftM3._\'23lambda7._\'23lambda9','Control.Monad.liftM3._#lambda7._#lambda9',5,'Control.Monad.liftM3._\'23lambda7._\'23lambda9',nofix,notype).
functiontype('Control.Monad.liftM3._\'23lambda7._\'23lambda9._\'23lambda11','Control.Monad.liftM3._#lambda7._#lambda9._#lambda11',5,'Control.Monad.liftM3._\'23lambda7._\'23lambda9._\'23lambda11',nofix,notype).
functiontype('Control.Monad.join',join,1,'Control.Monad.join',nofix,notype).
functiontype('Control.Monad.void',void,1,'Control.Monad.void',nofix,notype).
functiontype('Control.Monad.forM',forM,1,'Control.Monad.forM',nofix,notype).
functiontype('Control.Monad.forM_',forM_,1,'Control.Monad.forM_',nofix,notype).

%%%%%%%%%%%% constructor types %%%%%%%%%%%%%%%%%%%
:-multifile constructortype/7.
:-dynamic constructortype/7.

%%%%%%%%%%%% function definitions %%%%%%%%%%%%%%%%%%%
'Control.Monad.filterM'(_4606156,_4606158,_4606160,_4606162,_4606164):-freeze(_4606162,'blocked_Control.Monad.filterM'(_4606156,_4606158,_4606160,_4606162,_4606164)).
'blocked_Control.Monad.filterM'(_4606252,_4606270,_4606846,_4606852,_4606858):-makeShare(_4606252,_4606974),hnf(partcall(1,'Prelude.foldr',['Prelude.apply'('Prelude.pure'(_4606974),[]),partcall(1,'Control.Monad.filterM._\'23lambda1',[_4606270,_4606974])]),_4606846,_4606852,_4606858).

'Control.Monad.filterM._\'23lambda1'(_4610040,_4610042,_4610044,_4610046,_4610048,_4610050):-freeze(_4610048,'blocked_Control.Monad.filterM._\'23lambda1'(_4610040,_4610042,_4610044,_4610046,_4610048,_4610050)).
'blocked_Control.Monad.filterM._\'23lambda1'(_4610146,_4610164,_4610182,_4610828,_4610834,_4610840):-makeShare(_4610182,_4611014),hnf('Prelude.apply'('Prelude.apply'('Prelude.liftA2'(_4610146),partcall(1,'Control.Monad.filterM._\'23lambda1._\'23lambda2',[_4611014])),'Prelude.apply'(_4610164,_4611014)),_4610828,_4610834,_4610840).

'Control.Monad.filterM._\'23lambda1._\'23lambda2'(_4614858,_4614860,_4614862,_4614864,_4614866):-freeze(_4614864,'blocked_Control.Monad.filterM._\'23lambda1._\'23lambda2'(_4614858,_4614860,_4614862,_4614864,_4614866)).
'blocked_Control.Monad.filterM._\'23lambda1._\'23lambda2'(_4614954,_4614972,_4615632,_4615638,_4615644):-hnf(_4614972,_4617638,_4615638,_4617656),'blocked_Control.Monad.filterM._\'23lambda1._\'23lambda2_2'(_4617638,_4614954,_4615632,_4617656,_4615644).

'blocked_Control.Monad.filterM._\'23lambda1._\'23lambda2_2'(_4618182,_4618184,_4618186,_4618188,_4618190):-freeze(_4618188,freeze(_4618182,'blocked_blocked_Control.Monad.filterM._\'23lambda1._\'23lambda2_2'(_4618182,_4618184,_4618186,_4618188,_4618190))).
'blocked_blocked_Control.Monad.filterM._\'23lambda1._\'23lambda2_2'('Prelude.True',_4614954,_4618576,_4618582,_4618588):-hnf('[|]'(_4614954),_4618576,_4618582,_4618588).
'blocked_blocked_Control.Monad.filterM._\'23lambda1._\'23lambda2_2'('Prelude.False',_4614954,_4619570,_4619576,_4619582):-!,hnf(partcall(1,'Prelude.id',[]),_4619570,_4619576,_4619582).
'blocked_blocked_Control.Monad.filterM._\'23lambda1._\'23lambda2_2'('FAIL'(_4620242),_4614954,'FAIL'(_4620242),_4620256,_4620256).

'Control.Monad.\'3E\'3D\'3E'(_4621202,_4621204,_4621206,_4621208,_4621210,_4621212):-freeze(_4621210,'blocked_Control.Monad.\'3E\'3D\'3E'(_4621202,_4621204,_4621206,_4621208,_4621210,_4621212)).
'blocked_Control.Monad.\'3E\'3D\'3E'(_4621308,_4621326,_4621344,_4621584,_4621590,_4621596):-hnf(partcall(1,'Control.Monad.\'3E\'3D\'3E._\'23lambda3',[_4621326,_4621344,_4621308]),_4621584,_4621590,_4621596).

'Control.Monad.\'3E\'3D\'3E._\'23lambda3'(_4623926,_4623928,_4623930,_4623932,_4623934,_4623936,_4623938):-freeze(_4623936,'blocked_Control.Monad.\'3E\'3D\'3E._\'23lambda3'(_4623926,_4623928,_4623930,_4623932,_4623934,_4623936,_4623938)).
'blocked_Control.Monad.\'3E\'3D\'3E._\'23lambda3'(_4624042,_4624060,_4624078,_4624096,_4624658,_4624664,_4624670):-hnf('Prelude.apply'('Prelude.apply'('Prelude.>>='(_4624042),'Prelude.apply'(_4624078,_4624096)),_4624060),_4624658,_4624664,_4624670).

'Control.Monad.\'3C\'3D\'3C'(_4627388,_4627390,_4627392,_4627394):-freeze(_4627392,'blocked_Control.Monad.\'3C\'3D\'3C'(_4627388,_4627390,_4627392,_4627394)).
'blocked_Control.Monad.\'3C\'3D\'3C'(_4627474,_4627658,_4627664,_4627670):-hnf(partcall(2,'Prelude.flip',[partcall(2,'Control.Monad.\'3E\'3D\'3E',[_4627474])]),_4627658,_4627664,_4627670).

'Control.Monad.forever'(_4629400,_4629402,_4629404,_4629406,_4629408):-freeze(_4629406,'blocked_Control.Monad.forever'(_4629400,_4629402,_4629404,_4629406,_4629408)).
'blocked_Control.Monad.forever'(_4629496,_4629514,_4630264,_4630270,_4630276):-makeShare(_4629542,_4630444),hnf('Prelude.cond'(letrec4PAKCS(_4630444,'Prelude.apply'('Prelude.apply'('Prelude.*>'(_4629496),_4629514),_4630444)),_4630444),_4630264,_4630270,_4630276).

'Control.Monad.mapAndUnzipM'(_4633526,_4633528,_4633530,_4633532,_4633534,_4633536):-freeze(_4633534,'blocked_Control.Monad.mapAndUnzipM'(_4633526,_4633528,_4633530,_4633532,_4633534,_4633536)).
'blocked_Control.Monad.mapAndUnzipM'(_4633632,_4633650,_4633668,_4634482,_4634488,_4634494):-makeShare(_4633632,_4634660),hnf('Prelude.apply'('Prelude.apply'('Prelude.<$>'('Prelude._super\'23Prelude.Applicative\'23Prelude.Functor\'230\'23'(_4634660)),partcall(1,'Prelude.unzip',[])),'Control.Applicative.sequenceA'(_4634660,'Prelude.map'(_4633650,_4633668))),_4634482,_4634488,_4634494).

'Control.Monad.zipWithM'(_4638306,_4638308,_4638310,_4638312,_4638314,_4638316,_4638318):-freeze(_4638316,'blocked_Control.Monad.zipWithM'(_4638306,_4638308,_4638310,_4638312,_4638314,_4638316,_4638318)).
'blocked_Control.Monad.zipWithM'(_4638422,_4638440,_4638458,_4638476,_4638870,_4638876,_4638882):-hnf('Control.Applicative.sequenceA'(_4638422,'Prelude.zipWith'(_4638440,_4638458,_4638476)),_4638870,_4638876,_4638882).

'Control.Monad.zipWithM_'(_4641294,_4641296,_4641298,_4641300,_4641302,_4641304,_4641306):-freeze(_4641304,'blocked_Control.Monad.zipWithM_'(_4641294,_4641296,_4641298,_4641300,_4641302,_4641304,_4641306)).
'blocked_Control.Monad.zipWithM_'(_4641410,_4641428,_4641446,_4641464,_4641942,_4641948,_4641954):-hnf('Prelude.apply'('Control.Applicative.sequenceA_'(_4641410),'Prelude.zipWith'(_4641428,_4641446,_4641464)),_4641942,_4641948,_4641954).

'Control.Monad.foldM'(_4644414,_4644416,_4644418,_4644420,_4644422,_4644424,_4644426):-freeze(_4644424,'blocked_Control.Monad.foldM'(_4644414,_4644416,_4644418,_4644420,_4644422,_4644424,_4644426)).
'blocked_Control.Monad.foldM'(_4644530,_4644548,_4644566,_4644584,_4645216,_4645222,_4645228):-makeShare(_4644530,_4645446),hnf('Prelude.apply'('Prelude.foldr'(partcall(3,'Control.Monad.foldM.f\'27.21',[_4644548,_4645446]),'Prelude.return'(_4645446),_4644584),_4644566),_4645216,_4645222,_4645228).

'Control.Monad.foldM.f\'27.21'(_4648424,_4648426,_4648428,_4648430,_4648432,_4648434,_4648436,_4648438):-freeze(_4648436,'blocked_Control.Monad.foldM.f\'27.21'(_4648424,_4648426,_4648428,_4648430,_4648432,_4648434,_4648436,_4648438)).
'blocked_Control.Monad.foldM.f\'27.21'(_4648550,_4648568,_4648586,_4648604,_4648622,_4649338,_4649344,_4649350):-hnf('Prelude.apply'('Prelude.apply'('Prelude.>>='(_4648550),'Prelude.apply'('Prelude.apply'(_4648568,_4648622),_4648586)),_4648604),_4649338,_4649344,_4649350).

'Control.Monad.foldM_'(_4652424,_4652426,_4652428,_4652430,_4652432,_4652434,_4652436):-freeze(_4652434,'blocked_Control.Monad.foldM_'(_4652424,_4652426,_4652428,_4652430,_4652432,_4652434,_4652436)).
'blocked_Control.Monad.foldM_'(_4652540,_4652558,_4652576,_4652594,_4653548,_4653554,_4653560):-makeShare(_4652540,_4653798),hnf('Prelude.apply'('Prelude.apply'('Prelude.>>'(_4653798),'Control.Monad.foldM'(_4653798,_4652558,_4652576,_4652594)),'Prelude.apply'('Prelude.return'(_4653798),'Prelude.()')),_4653548,_4653554,_4653560).

'Control.Monad.replicateM'(_4657312,_4657314,_4657316,_4657318,_4657320,_4657322):-freeze(_4657320,'blocked_Control.Monad.replicateM'(_4657312,_4657314,_4657316,_4657318,_4657320,_4657322)).
'blocked_Control.Monad.replicateM'(_4657418,_4657436,_4657454,_4657862,_4657868,_4657874):-hnf('Control.Monad.replicateM.loop.27'(_4657454,_4657418,partcall(1,'Prelude._inst\'23Prelude.Num\'23Prelude.Int\'23',[]),partcall(1,'Prelude._inst\'23Prelude.Ord\'23Prelude.Int\'23',[]),_4657436),_4657862,_4657868,_4657874).

'Control.Monad.replicateM.loop.27'(_4661016,_4661018,_4661020,_4661022,_4661024,_4661026,_4661028,_4661030):-freeze(_4661028,'blocked_Control.Monad.replicateM.loop.27'(_4661016,_4661018,_4661020,_4661022,_4661024,_4661026,_4661028,_4661030)).
'blocked_Control.Monad.replicateM.loop.27'(_4661142,_4661160,_4661178,_4661196,_4661214,_4668194,_4668200,_4668206):-makeShare(_4661196,_4665012),makeShare(_4661214,_4665032),makeShare(_4661178,_4665052),hnf('Prelude.apply'('Prelude.apply'('Prelude.<='(_4665012),_4665032),'Prelude.apply'('Prelude.fromInt'(_4665052),0)),_4669876,_4668200,_4669824),'blocked_Control.Monad.replicateM.loop.27_ComplexCase'(_4669876,_4661142,_4661160,_4665052,_4665012,_4665032,_4668194,_4669824,_4668206).

'blocked_Control.Monad.replicateM.loop.27_ComplexCase'(_4670400,_4670402,_4670404,_4670406,_4670408,_4670410,_4670412,_4670414,_4670416):-freeze(_4670414,freeze(_4670400,'blocked_blocked_Control.Monad.replicateM.loop.27_ComplexCase'(_4670400,_4670402,_4670404,_4670406,_4670408,_4670410,_4670412,_4670414,_4670416))).
'blocked_blocked_Control.Monad.replicateM.loop.27_ComplexCase'('Prelude.True',_4661142,_4661160,_4665052,_4665012,_4665032,_4670834,_4670840,_4670846):-hnf('Prelude.apply'('Prelude.pure'(_4661160),[]),_4670834,_4670840,_4670846).
'blocked_blocked_Control.Monad.replicateM.loop.27_ComplexCase'('Prelude.False',_4661142,_4661160,_4665052,_4665012,_4665032,_4674150,_4674156,_4674162):-!,hnf('Prelude.otherwise',_4676980,_4674156,_4676928),'blocked_blocked_Control.Monad.replicateM.loop.27_ComplexCase_Prelude.False_ComplexCase'(_4676980,_4661142,_4661160,_4665052,_4665012,_4665032,_4674150,_4676928,_4674162).

'blocked_blocked_Control.Monad.replicateM.loop.27_ComplexCase_Prelude.False_ComplexCase'(_4677690,_4677692,_4677694,_4677696,_4677698,_4677700,_4677702,_4677704,_4677706):-freeze(_4677704,freeze(_4677690,'blocked_blocked_blocked_Control.Monad.replicateM.loop.27_ComplexCase_Prelude.False_ComplexCase'(_4677690,_4677692,_4677694,_4677696,_4677698,_4677700,_4677702,_4677704,_4677706))).
'blocked_blocked_blocked_Control.Monad.replicateM.loop.27_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_4661142,_4661160,_4665052,_4665012,_4665032,_4678124,_4678130,_4678136):-makeShare(_4661160,_4678550),makeShare(_4661142,_4678570),makeShare(_4665052,_4678590),hnf('Prelude.apply'('Prelude.apply'('Prelude.apply'('Prelude.liftA2'(_4678550),'[|]'),_4678570),'Control.Monad.replicateM.loop.27'(_4678570,_4678550,_4678590,_4665012,'Prelude.apply'('Prelude.apply'('Prelude.-'(_4678590),_4665032),'Prelude.apply'('Prelude.fromInt'(_4678590),1)))),_4678124,_4678130,_4678136).
'blocked_blocked_blocked_Control.Monad.replicateM.loop.27_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_4661142,_4661160,_4665052,_4665012,_4665032,_4683336,_4683342,_4683348):-!,hnf(reportFailure4PAKCS('Control.Monad.replicateM.loop.27',['Prelude.False']),_4683336,_4683342,_4683348).
'blocked_blocked_blocked_Control.Monad.replicateM.loop.27_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_4685240),_4661142,_4661160,_4665052,_4665012,_4665032,'FAIL'(_4685240),_4685254,_4685254).
'blocked_blocked_Control.Monad.replicateM.loop.27_ComplexCase'('FAIL'(_4685346),_4661142,_4661160,_4665052,_4665012,_4665032,'FAIL'(_4685346),_4685360,_4685360).

'Control.Monad.replicateM_'(_4686530,_4686532,_4686534,_4686536,_4686538,_4686540):-freeze(_4686538,'blocked_Control.Monad.replicateM_'(_4686530,_4686532,_4686534,_4686536,_4686538,_4686540)).
'blocked_Control.Monad.replicateM_'(_4686636,_4686654,_4686672,_4687080,_4687086,_4687092):-hnf('Control.Monad.replicateM_.loop.31'(_4686672,_4686636,partcall(1,'Prelude._inst\'23Prelude.Num\'23Prelude.Int\'23',[]),partcall(1,'Prelude._inst\'23Prelude.Ord\'23Prelude.Int\'23',[]),_4686654),_4687080,_4687086,_4687092).

'Control.Monad.replicateM_.loop.31'(_4690284,_4690286,_4690288,_4690290,_4690292,_4690294,_4690296,_4690298):-freeze(_4690296,'blocked_Control.Monad.replicateM_.loop.31'(_4690284,_4690286,_4690288,_4690290,_4690292,_4690294,_4690296,_4690298)).
'blocked_Control.Monad.replicateM_.loop.31'(_4690410,_4690428,_4690446,_4690464,_4690482,_4697268,_4697274,_4697280):-makeShare(_4690464,_4694108),makeShare(_4690482,_4694128),makeShare(_4690446,_4694148),hnf('Prelude.apply'('Prelude.apply'('Prelude.<='(_4694108),_4694128),'Prelude.apply'('Prelude.fromInt'(_4694148),0)),_4698986,_4697274,_4698934),'blocked_Control.Monad.replicateM_.loop.31_ComplexCase'(_4698986,_4690410,_4690428,_4694148,_4694108,_4694128,_4697268,_4698934,_4697280).

'blocked_Control.Monad.replicateM_.loop.31_ComplexCase'(_4699516,_4699518,_4699520,_4699522,_4699524,_4699526,_4699528,_4699530,_4699532):-freeze(_4699530,freeze(_4699516,'blocked_blocked_Control.Monad.replicateM_.loop.31_ComplexCase'(_4699516,_4699518,_4699520,_4699522,_4699524,_4699526,_4699528,_4699530,_4699532))).
'blocked_blocked_Control.Monad.replicateM_.loop.31_ComplexCase'('Prelude.True',_4690410,_4690428,_4694148,_4694108,_4694128,_4699950,_4699956,_4699962):-hnf('Prelude.apply'('Prelude.pure'(_4690428),'Prelude.()'),_4699950,_4699956,_4699962).
'blocked_blocked_Control.Monad.replicateM_.loop.31_ComplexCase'('Prelude.False',_4690410,_4690428,_4694148,_4694108,_4694128,_4703302,_4703308,_4703314):-!,hnf('Prelude.otherwise',_4706168,_4703308,_4706116),'blocked_blocked_Control.Monad.replicateM_.loop.31_ComplexCase_Prelude.False_ComplexCase'(_4706168,_4690410,_4690428,_4694148,_4694108,_4694128,_4703302,_4706116,_4703314).

'blocked_blocked_Control.Monad.replicateM_.loop.31_ComplexCase_Prelude.False_ComplexCase'(_4706884,_4706886,_4706888,_4706890,_4706892,_4706894,_4706896,_4706898,_4706900):-freeze(_4706898,freeze(_4706884,'blocked_blocked_blocked_Control.Monad.replicateM_.loop.31_ComplexCase_Prelude.False_ComplexCase'(_4706884,_4706886,_4706888,_4706890,_4706892,_4706894,_4706896,_4706898,_4706900))).
'blocked_blocked_blocked_Control.Monad.replicateM_.loop.31_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_4690410,_4690428,_4694148,_4694108,_4694128,_4707318,_4707324,_4707330):-makeShare(_4690428,_4707740),makeShare(_4690410,_4707760),makeShare(_4694148,_4707780),hnf('Prelude.apply'('Prelude.apply'('Prelude.*>'(_4707740),_4707760),'Control.Monad.replicateM_.loop.31'(_4707760,_4707740,_4707780,_4694108,'Prelude.apply'('Prelude.apply'('Prelude.-'(_4707780),_4694128),'Prelude.apply'('Prelude.fromInt'(_4707780),1)))),_4707318,_4707324,_4707330).
'blocked_blocked_blocked_Control.Monad.replicateM_.loop.31_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_4690410,_4690428,_4694148,_4694108,_4694128,_4712286,_4712292,_4712298):-!,hnf(reportFailure4PAKCS('Control.Monad.replicateM_.loop.31',['Prelude.False']),_4712286,_4712292,_4712298).
'blocked_blocked_blocked_Control.Monad.replicateM_.loop.31_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_4714202),_4690410,_4690428,_4694148,_4694108,_4694128,'FAIL'(_4714202),_4714216,_4714216).
'blocked_blocked_Control.Monad.replicateM_.loop.31_ComplexCase'('FAIL'(_4714308),_4690410,_4690428,_4694148,_4694108,_4694128,'FAIL'(_4714308),_4714322,_4714322).

'Control.Monad.unless'(_4715302,_4715304,_4715306,_4715308,_4715310,_4715312):-freeze(_4715310,'blocked_Control.Monad.unless'(_4715302,_4715304,_4715306,_4715308,_4715310,_4715312)).
'blocked_Control.Monad.unless'(_4715408,_4715426,_4715444,_4716108,_4716114,_4716120):-hnf(_4715426,_4717222,_4716114,_4717246),'blocked_Control.Monad.unless_2'(_4717222,_4715408,_4715444,_4716108,_4717246,_4716120).

'blocked_Control.Monad.unless_2'(_4717630,_4717632,_4717634,_4717636,_4717638,_4717640):-freeze(_4717638,freeze(_4717630,'blocked_blocked_Control.Monad.unless_2'(_4717630,_4717632,_4717634,_4717636,_4717638,_4717640))).
'blocked_blocked_Control.Monad.unless_2'('Prelude.True',_4715408,_4715444,_4718034,_4718040,_4718046):-hnf('Prelude.apply'('Prelude.pure'(_4715408),'Prelude.()'),_4718034,_4718040,_4718046).
'blocked_blocked_Control.Monad.unless_2'('Prelude.False',_4715408,_4715444,_4719372,_4719378,_4719384):-!,hnf(_4715444,_4719372,_4719378,_4719384).
'blocked_blocked_Control.Monad.unless_2'('FAIL'(_4719888),_4715408,_4715444,'FAIL'(_4719888),_4719902,_4719902).

'Control.Monad.liftM3'(_4720858,_4720860,_4720862,_4720864,_4720866,_4720868,_4720870,_4720872):-freeze(_4720870,'blocked_Control.Monad.liftM3'(_4720858,_4720860,_4720862,_4720864,_4720866,_4720868,_4720870,_4720872)).
'blocked_Control.Monad.liftM3'(_4720984,_4721002,_4721020,_4721038,_4721056,_4721758,_4721764,_4721770):-makeShare(_4720984,_4722058),hnf('Prelude.apply'('Prelude.apply'('Prelude.>>='(_4722058),_4721020),partcall(1,'Control.Monad.liftM3._\'23lambda7',[_4721002,_4722058,_4721038,_4721056])),_4721758,_4721764,_4721770).

'Control.Monad.liftM3._\'23lambda7'(_4725484,_4725486,_4725488,_4725490,_4725492,_4725494,_4725496,_4725498):-freeze(_4725496,'blocked_Control.Monad.liftM3._\'23lambda7'(_4725484,_4725486,_4725488,_4725490,_4725492,_4725494,_4725496,_4725498)).
'blocked_Control.Monad.liftM3._\'23lambda7'(_4725610,_4725628,_4725646,_4725664,_4725682,_4726726,_4726732,_4726738):-makeShare(_4725710,_4727142),makeShare(_4725646,_4727162),hnf('Prelude.cond'(letrec4PAKCS(_4727142,_4725682),'Prelude.apply'('Prelude.apply'('Prelude.>>='(_4727162),_4725628),partcall(1,'Control.Monad.liftM3._\'23lambda7._\'23lambda9',[_4725664,_4727162,_4725610,_4727142]))),_4726726,_4726732,_4726738).

'Control.Monad.liftM3._\'23lambda7._\'23lambda9'(_4731986,_4731988,_4731990,_4731992,_4731994,_4731996,_4731998,_4732000):-freeze(_4731998,'blocked_Control.Monad.liftM3._\'23lambda7._\'23lambda9'(_4731986,_4731988,_4731990,_4731992,_4731994,_4731996,_4731998,_4732000)).
'blocked_Control.Monad.liftM3._\'23lambda7._\'23lambda9'(_4732112,_4732130,_4732148,_4732166,_4732184,_4733228,_4733234,_4733240):-makeShare(_4732212,_4733644),makeShare(_4732148,_4733664),hnf('Prelude.cond'(letrec4PAKCS(_4733644,_4732184),'Prelude.apply'('Prelude.apply'('Prelude.>>='(_4733664),_4732130),partcall(1,'Control.Monad.liftM3._\'23lambda7._\'23lambda9._\'23lambda11',[_4732166,_4733664,_4732112,_4733644]))),_4733228,_4733234,_4733240).

'Control.Monad.liftM3._\'23lambda7._\'23lambda9._\'23lambda11'(_4739084,_4739086,_4739088,_4739090,_4739092,_4739094,_4739096,_4739098):-freeze(_4739096,'blocked_Control.Monad.liftM3._\'23lambda7._\'23lambda9._\'23lambda11'(_4739084,_4739086,_4739088,_4739090,_4739092,_4739094,_4739096,_4739098)).
'blocked_Control.Monad.liftM3._\'23lambda7._\'23lambda9._\'23lambda11'(_4739210,_4739228,_4739246,_4739264,_4739282,_4740340,_4740346,_4740352):-makeShare(_4739310,_4740720),hnf('Prelude.cond'(letrec4PAKCS(_4740720,_4739282),'Prelude.apply'('Prelude.return'(_4739246),'Prelude.apply'('Prelude.apply'('Prelude.apply'(_4739264,_4739228),_4739210),_4740720))),_4740340,_4740346,_4740352).

'Control.Monad.join'(_4744418,_4744420,_4744422,_4744424):-freeze(_4744422,'blocked_Control.Monad.join'(_4744418,_4744420,_4744422,_4744424)).
'blocked_Control.Monad.join'(_4744504,_4744772,_4744778,_4744784):-hnf(partcall(1,'Prelude.flip',[partcall(1,'Prelude.id',[]),'Prelude.>>='(_4744504)]),_4744772,_4744778,_4744784).

'Control.Monad.void'(_4746556,_4746558,_4746560,_4746562):-freeze(_4746560,'blocked_Control.Monad.void'(_4746556,_4746558,_4746560,_4746562)).
'blocked_Control.Monad.void'(_4746642,_4746994,_4747000,_4747006):-hnf('Prelude.apply'('Prelude.fmap'(_4746642),partcall(1,'Prelude.const',['Prelude.()'])),_4746994,_4747000,_4747006).

'Control.Monad.forM'(_4748874,_4748876,_4748878,_4748880):-freeze(_4748878,'blocked_Control.Monad.forM'(_4748874,_4748876,_4748878,_4748880)).
'blocked_Control.Monad.forM'(_4748960,_4749144,_4749150,_4749156):-hnf(partcall(2,'Prelude.flip',[partcall(1,'Prelude.mapM',[_4748960])]),_4749144,_4749150,_4749156).

'Control.Monad.forM_'(_4750714,_4750716,_4750718,_4750720):-freeze(_4750718,'blocked_Control.Monad.forM_'(_4750714,_4750716,_4750718,_4750720)).
'blocked_Control.Monad.forM_'(_4750800,_4750984,_4750990,_4750996):-hnf(partcall(2,'Prelude.flip',[partcall(1,'Prelude.mapM_',[_4750800])]),_4750984,_4750990,_4750996).

:-costCenters(['']).




%%%%% Number of shared variables: 24

