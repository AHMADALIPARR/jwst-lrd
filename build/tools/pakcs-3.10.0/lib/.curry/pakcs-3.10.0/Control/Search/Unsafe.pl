%PAKCS3.10 swi9 VARIABLESHARING

:-noSingletonWarnings.
:-noRedefineWarnings.
:-noDiscontiguousWarnings.

:-importModule('Prelude').

:-curryModule('Control.Search.Unsafe').


%%%%%%%%%%%% function types %%%%%%%%%%%%%%%%%%%
:-multifile functiontype/6.
:-dynamic functiontype/6.
functiontype('Control.Search.Unsafe.allValues',allValues,1,'Unsafe.prim_allValues',nofix,notype).
functiontype('Control.Search.Unsafe.allValuesDFS',allValuesDFS,1,'Control.Search.Unsafe.allValuesDFS',nofix,notype).
functiontype('Control.Search.Unsafe.oneValue',oneValue,1,'Unsafe.prim_oneValue',nofix,notype).
functiontype('Control.Search.Unsafe.oneValueDFS',oneValueDFS,1,'Control.Search.Unsafe.oneValueDFS',nofix,notype).
functiontype('Control.Search.Unsafe.someValue',someValue,1,'Control.Search.Unsafe.someValue',nofix,notype).
functiontype('Control.Search.Unsafe.isFail',isFail,1,'Control.Search.Unsafe.isFail',nofix,notype).
functiontype('Control.Search.Unsafe.rewriteAll',rewriteAll,1,'Unsafe.prim_rewriteAll',nofix,notype).
functiontype('Control.Search.Unsafe.rewriteSome',rewriteSome,1,'Unsafe.prim_rewriteSome',nofix,notype).

%%%%%%%%%%%% constructor types %%%%%%%%%%%%%%%%%%%
:-multifile constructortype/7.
:-dynamic constructortype/7.

%%%%%%%%%%%% function definitions %%%%%%%%%%%%%%%%%%%
'Control.Search.Unsafe.allValuesDFS'(_4171512,_4171514,_4171516,_4171518):-freeze(_4171516,'blocked_Control.Search.Unsafe.allValuesDFS'(_4171512,_4171514,_4171516,_4171518)).
'blocked_Control.Search.Unsafe.allValuesDFS'(_4171598,_4171698,_4171704,_4171710):-hnf('Control.Search.Unsafe.allValues'(_4171598),_4171698,_4171704,_4171710).

'Control.Search.Unsafe.oneValueDFS'(_4174002,_4174004,_4174006,_4174008):-freeze(_4174006,'blocked_Control.Search.Unsafe.oneValueDFS'(_4174002,_4174004,_4174006,_4174008)).
'blocked_Control.Search.Unsafe.oneValueDFS'(_4174088,_4174188,_4174194,_4174200):-hnf('Control.Search.Unsafe.oneValue'(_4174088),_4174188,_4174194,_4174200).

'Control.Search.Unsafe.someValue'(_4176218,_4176220,_4176222,_4176224):-freeze(_4176222,'blocked_Control.Search.Unsafe.someValue'(_4176218,_4176220,_4176222,_4176224)).
'blocked_Control.Search.Unsafe.someValue'(_4176304,_4177888,_4177894,_4177900):-hnf('Control.Search.Unsafe.oneValue'(_4176304),_4179478,_4177894,_4179450),'blocked_Control.Search.Unsafe.someValue_ComplexCase'(_4179478,_4176304,_4177888,_4179450,_4177900).

'blocked_Control.Search.Unsafe.someValue_ComplexCase'(_4179952,_4179954,_4179956,_4179958,_4179960):-freeze(_4179958,freeze(_4179952,'blocked_blocked_Control.Search.Unsafe.someValue_ComplexCase'(_4179952,_4179954,_4179956,_4179958,_4179960))).
'blocked_blocked_Control.Search.Unsafe.someValue_ComplexCase'('Prelude.Just'(_4176504),_4176304,_4180356,_4180362,_4180368):-hnf(_4176504,_4180356,_4180362,_4180368).
'blocked_blocked_Control.Search.Unsafe.someValue_ComplexCase'('Prelude.Nothing',_4176304,_4181306,_4181312,_4181318):-!,hnf(reportFailure4PAKCS('Control.Search.Unsafe.someValue',['Prelude.Nothing']),_4181306,_4181312,_4181318).
'blocked_blocked_Control.Search.Unsafe.someValue_ComplexCase'('FAIL'(_4182710),_4176304,'FAIL'(_4182710),_4182724,_4182724).

'Control.Search.Unsafe.isFail'(_4183976,_4183978,_4183980,_4183982):-freeze(_4183980,'blocked_Control.Search.Unsafe.isFail'(_4183976,_4183978,_4183980,_4183982)).
'blocked_Control.Search.Unsafe.isFail'(_4184062,_4185222,_4185228,_4185234):-hnf('Control.Search.Unsafe.oneValue'(_4184062),_4186704,_4185228,_4186676),'blocked_Control.Search.Unsafe.isFail_ComplexCase'(_4186704,_4184062,_4185222,_4186676,_4185234).

'blocked_Control.Search.Unsafe.isFail_ComplexCase'(_4187160,_4187162,_4187164,_4187166,_4187168):-freeze(_4187166,freeze(_4187160,'blocked_blocked_Control.Search.Unsafe.isFail_ComplexCase'(_4187160,_4187162,_4187164,_4187166,_4187168))).
'blocked_blocked_Control.Search.Unsafe.isFail_ComplexCase'('Prelude.Nothing',_4184062,'Prelude.True',_4187596,_4187596).
'blocked_blocked_Control.Search.Unsafe.isFail_ComplexCase'('Prelude.Just'(_4184362),_4184062,'Prelude.False',_4188506,_4188506):-!.
'blocked_blocked_Control.Search.Unsafe.isFail_ComplexCase'('FAIL'(_4189186),_4184062,'FAIL'(_4189186),_4189200,_4189200).

:-costCenters(['']).




%%%%% Number of shared variables: 0

:-style_check(-singleton).
'Unsafe.prim_allValues'(_4189990,_4189992,_4189994,_4189996):-freeze(_4189994,'blocked_Unsafe.prim_allValues'(_4189990,_4189992,_4189994,_4189996)).
'blocked_Unsafe.prim_allValues'(_4190066,_4190068,_4190070,_4190072):-waitUntilGround(_4190066,_4190070,_4190080),'Unsafe.prim_allValues_exec'(_4190066,_4190068,_4190080,_4190072).
'Unsafe.prim_allValues_exec'(_4190488,_4190490,_4190492,_4190494):-freeze(_4190492,'blocked_Unsafe.prim_allValues_exec'(_4190488,_4190490,_4190492,_4190494)).
'blocked_Unsafe.prim_allValues_exec'(_4190564,_4190566,_4190568,_4190570):-hasPrintedFailure->findall((_4190574,_4190576),evalGNF(_4190564,_4190574,_4190568,_4190576),_4190594),extractSolutions(_4190594,_4190566,_4190568,_4190570);asserta(hasPrintedFailure),findall((_4190574,_4190576),evalGNF(_4190564,_4190574,_4190568,_4190576),_4190594),retract(hasPrintedFailure),extractSolutions(_4190594,_4190566,_4190568,_4190570).
evalGNF(_4190960,_4190962,_4190964,_4190966):-freeze(_4190964,blocked_evalGNF(_4190960,_4190962,_4190964,_4190966)).
blocked_evalGNF(_4191036,_4191038,_4191040,_4191042):-nf(_4191036,_4191038,_4191040,_4191052),waitUntilGround(_4191038,_4191052,_4191042).
'Unsafe.prim_oneValue'(_4191422,_4191424,_4191426,_4191428):-freeze(_4191426,'blocked_Unsafe.prim_oneValue'(_4191422,_4191424,_4191426,_4191428)).
'blocked_Unsafe.prim_oneValue'(_4191498,_4191500,_4191502,_4191504):-waitUntilGround(_4191498,_4191502,_4191512),'Unsafe.prim_oneValue_exec'(_4191498,_4191500,_4191512,_4191504).
'Unsafe.prim_oneValue_exec'(_4191914,_4191916,_4191918,_4191920):-freeze(_4191918,'blocked_Unsafe.prim_oneValue_exec'(_4191914,_4191916,_4191918,_4191920)).
'blocked_Unsafe.prim_oneValue_exec'(_4191990,_4191992,_4191994,_4191996):-hasPrintedFailure->findall((_4192000,_4192002),oneNF(_4191990,_4192000,_4191994,_4192002),_4192020),extractSolutions(_4192020,_4192026,_4191994,_4192002),(_4192026=[_4192000]->_4191992='Prelude.Just'(_4192000);_4191992='Prelude.Nothing'),_4191996=_4192002;asserta(hasPrintedFailure),findall((_4192000,_4192002),oneNF(_4191990,_4192000,_4191994,_4192002),_4192020),retract(hasPrintedFailure),extractSolutions(_4192020,_4192026,_4191994,_4192002),(_4192026=[_4192000]->_4191992='Prelude.Just'(_4192000);_4191992='Prelude.Nothing'),_4191996=_4192002.
oneNF(_4192494,_4192496,_4192498,_4192500):-freeze(_4192498,blocked_oneNF(_4192494,_4192496,_4192498,_4192500)).
blocked_oneNF(_4192570,_4192572,_4192574,_4192576):-evalGNF(_4192570,_4192572,_4192574,_4192576),!.
'Unsafe.prim_rewriteAll'(_4192960,_4192962,_4192964,_4192966):-freeze(_4192964,'blocked_Unsafe.prim_rewriteAll'(_4192960,_4192962,_4192964,_4192966)).
'blocked_Unsafe.prim_rewriteAll'(_4193036,_4193038,_4193040,_4193042):-varsInExp(_4193036,[],_4193050),rewriteAllExec(_4193050,_4193036,_4193038,_4193040,_4193062),_4193062=_4193042.
rewriteAllExec(_4193402,_4193404,_4193406,_4193408,_4193410):-freeze(_4193408,blocked_rewriteAllExec(_4193402,_4193404,_4193406,_4193408,_4193410)).
blocked_rewriteAllExec(_4193488,_4193490,_4193492,_4193494,_4193496):-hasPrintedFailure->findall((_4193500,_4193502),(user:nf(_4193490,_4193500,_4193494,_4193502),allUnboundVariables(_4193488)),_4193536),extractSolutions(_4193536,_4193492,_4193494,_4193496);asserta(hasPrintedFailure),findall((_4193500,_4193502),(user:nf(_4193490,_4193500,_4193494,_4193502),allUnboundVariables(_4193488)),_4193536),retract(hasPrintedFailure),extractSolutions(_4193536,_4193492,_4193494,_4193496).
'Unsafe.prim_rewriteSome'(_4194022,_4194024,_4194026,_4194028):-freeze(_4194026,'blocked_Unsafe.prim_rewriteSome'(_4194022,_4194024,_4194026,_4194028)).
'blocked_Unsafe.prim_rewriteSome'(_4194098,_4194100,_4194102,_4194104):-varsInExp(_4194098,[],_4194112),rewriteSomeExec(_4194112,_4194098,_4194100,_4194102,_4194124),_4194124=_4194104.
rewriteSomeExec(_4194470,_4194472,_4194474,_4194476,_4194478):-freeze(_4194476,blocked_rewriteSomeExec(_4194470,_4194472,_4194474,_4194476,_4194478)).
blocked_rewriteSomeExec(_4194556,_4194558,_4194560,_4194562,_4194564):-hasPrintedFailure->rewriteSomeExecWithPF(_4194556,_4194558,_4194560,_4194562,_4194564);asserta(hasPrintedFailure),rewriteSomeExecWithoutPF(_4194556,_4194558,_4194560,_4194562,_4194564).
rewriteSomeExecWithPF(_4194688,_4194690,_4194692,_4194694,_4194696):-on_exception(_4194760,(user:nf(_4194690,_4194702,_4194694,_4194696),allUnboundVariables(_4194688),_4194692='Prelude.Just'(_4194702)),(_4194692='Prelude.Nothing',_4194694=_4194696)),!.
rewriteSomeExecWithPF(_4194848,_4194850,_4194852,_4194854,_4194856):-_4194852='Prelude.Nothing',_4194854=_4194856.
rewriteSomeExecWithoutPF(_4194952,_4194954,_4194956,_4194958,_4194960):-on_exception(_4195024,(user:nf(_4194954,_4194966,_4194958,_4194960),allUnboundVariables(_4194952),_4194956='Prelude.Just'(_4194966)),(_4194956='Prelude.Nothing',_4194958=_4194960)),retract(hasPrintedFailure),!.
rewriteSomeExecWithoutPF(_4195122,_4195124,_4195126,_4195128,_4195130):-retract(hasPrintedFailure),!,_4195126='Prelude.Nothing',_4195128=_4195130.
varsInExp(_4195242,_4195244,_4195244):-var(_4195242),varInList(_4195242,_4195244),!.
varsInExp(_4195332,_4195334,[_4195332|_4195334]):-var(_4195332),!.
varsInExp(share(_4195414),_4195420,_4195422):-!,get_mutable(_4195426,_4195414),(_4195426='$eval'(_4195432)->true;_4195432=_4195426),varsInExp(_4195432,_4195420,_4195422).
varsInExp(_4195544,_4195546,_4195548):-functor(_4195544,_4195554,_4195556),varsInExpArgs(1,_4195556,_4195544,_4195546,_4195548).
varInList(_4195644,[_4195638|_4195640]):-_4195644==_4195638,!.
varInList(_4195720,[_4195714|_4195716]):-varInList(_4195720,_4195716).
varsInExpArgs(_4195782,_4195784,_4195786,_4195788,_4195788):-_4195782>_4195784,!.
varsInExpArgs(_4195880,_4195882,_4195884,_4195886,_4195888):-arg(_4195880,_4195884,_4195896),varsInExp(_4195896,_4195886,_4195904),_4195914 is _4195880+1,varsInExpArgs(_4195914,_4195882,_4195884,_4195904,_4195888).
allUnboundVariables(_4196024):-length(_4196024,_4196030),\+ \+numbervars(_4196024,0,_4196030).
extractSolutions([],[],_4196102,_4196102).
extractSolutions([(_4196164,_4196166)|_4196172],[_4196164|_4196180],_4196188,_4196190):-extractMoreSolutions(_4196172,_4196180,_4196166,_4196188,_4196190).
extractMoreSolutions(_4196560,_4196562,_4196564,_4196566,_4196568):-freeze(_4196564,blocked_extractMoreSolutions(_4196560,_4196562,_4196564,_4196566,_4196568)).
blocked_extractMoreSolutions(_4196646,_4196648,_4196650,_4196652,_4196654):-extractSolutions(_4196646,_4196648,_4196652,_4196654).
