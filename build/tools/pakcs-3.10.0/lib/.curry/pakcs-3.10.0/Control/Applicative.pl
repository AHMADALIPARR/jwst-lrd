%PAKCS3.10 swi9 VARIABLESHARING

:-noSingletonWarnings.
:-noRedefineWarnings.
:-noDiscontiguousWarnings.

:-importModule('Prelude').

:-curryModule('Control.Applicative').


%%%%%%%%%%%% function types %%%%%%%%%%%%%%%%%%%
:-multifile functiontype/6.
:-dynamic functiontype/6.
functiontype('Control.Applicative.liftA',liftA,3,'Control.Applicative.liftA',nofix,notype).
functiontype('Control.Applicative.liftA3',liftA3,5,'Control.Applicative.liftA3',nofix,notype).
functiontype('Control.Applicative.when',when,3,'Control.Applicative.when',nofix,notype).
functiontype('Control.Applicative.sequenceA',sequenceA,2,'Control.Applicative.sequenceA',nofix,notype).
functiontype('Control.Applicative.sequenceA_',sequenceA_,1,'Control.Applicative.sequenceA_',nofix,notype).

%%%%%%%%%%%% constructor types %%%%%%%%%%%%%%%%%%%
:-multifile constructortype/7.
:-dynamic constructortype/7.

%%%%%%%%%%%% function definitions %%%%%%%%%%%%%%%%%%%
'Control.Applicative.liftA'(_3414204,_3414206,_3414208,_3414210,_3414212,_3414214):-freeze(_3414212,'blocked_Control.Applicative.liftA'(_3414204,_3414206,_3414208,_3414210,_3414212,_3414214)).
'blocked_Control.Applicative.liftA'(_3414310,_3414328,_3414346,_3414992,_3414998,_3415004):-makeShare(_3414310,_3415166),hnf('Prelude.apply'('Prelude.apply'('Prelude.<*>'(_3415166),'Prelude.apply'('Prelude.pure'(_3415166),_3414328)),_3414346),_3414992,_3414998,_3415004).

'Control.Applicative.liftA3'(_3418202,_3418204,_3418206,_3418208,_3418210,_3418212,_3418214,_3418216):-freeze(_3418214,'blocked_Control.Applicative.liftA3'(_3418202,_3418204,_3418206,_3418208,_3418210,_3418212,_3418214,_3418216)).
'blocked_Control.Applicative.liftA3'(_3418328,_3418346,_3418364,_3418382,_3418400,_3419354,_3419360,_3419366):-makeShare(_3418328,_3419660),hnf('Prelude.apply'('Prelude.apply'('Prelude.<*>'(_3419660),'Prelude.apply'('Prelude.apply'('Prelude.apply'('Prelude.liftA2'(_3419660),_3418346),_3418364),_3418382)),_3418400),_3419354,_3419360,_3419366).

'Control.Applicative.when'(_3423298,_3423300,_3423302,_3423304,_3423306,_3423308):-freeze(_3423306,'blocked_Control.Applicative.when'(_3423298,_3423300,_3423302,_3423304,_3423306,_3423308)).
'blocked_Control.Applicative.when'(_3423404,_3423422,_3423440,_3424128,_3424134,_3424140):-hnf(_3423422,_3425386,_3424134,_3425410),'blocked_Control.Applicative.when_2'(_3425386,_3423404,_3423440,_3424128,_3425410,_3424140).

'blocked_Control.Applicative.when_2'(_3425818,_3425820,_3425822,_3425824,_3425826,_3425828):-freeze(_3425826,freeze(_3425818,'blocked_blocked_Control.Applicative.when_2'(_3425818,_3425820,_3425822,_3425824,_3425826,_3425828))).
'blocked_blocked_Control.Applicative.when_2'('Prelude.True',_3423404,_3423440,_3426222,_3426228,_3426234):-hnf(_3423440,_3426222,_3426228,_3426234).
'blocked_blocked_Control.Applicative.when_2'('Prelude.False',_3423404,_3423440,_3427054,_3427060,_3427066):-!,hnf('Prelude.apply'('Prelude.pure'(_3423404),'Prelude.()'),_3427054,_3427060,_3427066).
'blocked_blocked_Control.Applicative.when_2'('FAIL'(_3428124),_3423404,_3423440,'FAIL'(_3428124),_3428138,_3428138).

'Control.Applicative.sequenceA'(_3429436,_3429438,_3429440,_3429442,_3429444):-freeze(_3429442,'blocked_Control.Applicative.sequenceA'(_3429436,_3429438,_3429440,_3429442,_3429444)).
'blocked_Control.Applicative.sequenceA'(_3429532,_3429550,_3431352,_3431358,_3431364):-hnf(_3429550,_3432782,_3431358,_3432800),'blocked_Control.Applicative.sequenceA_2'(_3432782,_3429532,_3431352,_3432800,_3431364).

'blocked_Control.Applicative.sequenceA_2'(_3433224,_3433226,_3433228,_3433230,_3433232):-freeze(_3433230,'blocked_blocked_Control.Applicative.sequenceA_2'(_3433224,_3433226,_3433228,_3433230,_3433232)).
'blocked_blocked_Control.Applicative.sequenceA_2'([],_3429532,_3433476,_3433482,_3433488):-hnf('Prelude.apply'('Prelude.pure'(_3429532),[]),_3433476,_3433482,_3433488).
'blocked_blocked_Control.Applicative.sequenceA_2'([_3430004|_3430022],_3429532,_3434618,_3434624,_3434630):-!,makeShare(_3429532,_3434806),hnf('Prelude.apply'('Prelude.apply'('Prelude.<*>'(_3434806),'Prelude.apply'('Prelude.apply'('Prelude.<$>'('Prelude._super\'23Prelude.Applicative\'23Prelude.Functor\'230\'23'(_3434806)),'[|]'),_3430004)),'Control.Applicative.sequenceA'(_3434806,_3430022)),_3434618,_3434624,_3434630).
'blocked_blocked_Control.Applicative.sequenceA_2'('FAIL'(_3438040),_3429532,'FAIL'(_3438040),_3438054,_3438054):-nonvar(_3438040).

'Control.Applicative.sequenceA_'(_3439386,_3439388,_3439390,_3439392):-freeze(_3439390,'blocked_Control.Applicative.sequenceA_'(_3439386,_3439388,_3439390,_3439392)).
'blocked_Control.Applicative.sequenceA_'(_3439472,_3439978,_3439984,_3439990):-makeShare(_3439472,_3440072),hnf(partcall(1,'Prelude.foldr',['Prelude.apply'('Prelude.pure'(_3440072),'Prelude.()'),'Prelude.*>'(_3440072)]),_3439978,_3439984,_3439990).

:-costCenters(['']).




%%%%% Number of shared variables: 4

