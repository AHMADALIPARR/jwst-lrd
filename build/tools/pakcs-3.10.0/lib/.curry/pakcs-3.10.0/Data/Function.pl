%PAKCS3.10 swi9 VARIABLESHARING

:-noSingletonWarnings.
:-noRedefineWarnings.
:-noDiscontiguousWarnings.

:-importModule('Prelude').

:-curryModule('Data.Function').


%%%%%%%%%%%% function types %%%%%%%%%%%%%%%%%%%
:-multifile functiontype/6.
:-dynamic functiontype/6.
functiontype('Data.Function.fix',fix,1,'Data.Function.fix',nofix,notype).
functiontype('Data.Function.on',on,4,'Data.Function.on',nofix,notype).

%%%%%%%%%%%% constructor types %%%%%%%%%%%%%%%%%%%
:-multifile constructortype/7.
:-dynamic constructortype/7.

%%%%%%%%%%%% function definitions %%%%%%%%%%%%%%%%%%%
'Data.Function.fix'(_5085564,_5085566,_5085568,_5085570):-freeze(_5085568,'blocked_Data.Function.fix'(_5085564,_5085566,_5085568,_5085570)).
'blocked_Data.Function.fix'(_5085650,_5086162,_5086168,_5086174):-makeShare(_5085678,_5086292),hnf('Prelude.cond'(letrec4PAKCS(_5086292,'Prelude.apply'(_5085650,_5086292)),_5086292),_5086162,_5086168,_5086174).

'Data.Function.on'(_5088402,_5088404,_5088406,_5088408,_5088410,_5088412,_5088414):-freeze(_5088412,'blocked_Data.Function.on'(_5088402,_5088404,_5088406,_5088408,_5088410,_5088412,_5088414)).
'blocked_Data.Function.on'(_5088518,_5088536,_5088554,_5088572,_5089204,_5089210,_5089216):-makeShare(_5088536,_5089446),hnf('Prelude.apply'('Prelude.apply'(_5088518,'Prelude.apply'(_5089446,_5088554)),'Prelude.apply'(_5089446,_5088572)),_5089204,_5089210,_5089216).

:-costCenters(['']).




%%%%% Number of shared variables: 2

