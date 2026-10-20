%PAKCS3.10 swi9 VARIABLESHARING

:-noSingletonWarnings.
:-noRedefineWarnings.
:-noDiscontiguousWarnings.

:-importModule('Prelude').

:-curryModule('Text.Show').


%%%%%%%%%%%% function types %%%%%%%%%%%%%%%%%%%
:-multifile functiontype/6.
:-dynamic functiontype/6.
functiontype('Text.Show.showString',showString,1,'Text.Show.showString',nofix,notype).
functiontype('Text.Show.showChar',showChar,1,'Text.Show.showChar',nofix,notype).
functiontype('Text.Show.showParen',showParen,2,'Text.Show.showParen',nofix,notype).
functiontype('Text.Show.shows',shows,1,'Text.Show.shows',nofix,notype).

%%%%%%%%%%%% constructor types %%%%%%%%%%%%%%%%%%%
:-multifile constructortype/7.
:-dynamic constructortype/7.

%%%%%%%%%%%% function definitions %%%%%%%%%%%%%%%%%%%
'Text.Show.showString'(_5181000,_5181002,_5181004,_5181006):-freeze(_5181004,'blocked_Text.Show.showString'(_5181000,_5181002,_5181004,_5181006)).
'blocked_Text.Show.showString'(_5181086,_5181186,_5181192,_5181198):-hnf(partcall(1,'Prelude.++',[_5181086]),_5181186,_5181192,_5181198).

'Text.Show.showChar'(_5182594,_5182596,_5182598,_5182600):-freeze(_5182598,'blocked_Text.Show.showChar'(_5182594,_5182596,_5182598,_5182600)).
'blocked_Text.Show.showChar'(_5182680,_5182780,_5182786,_5182792):-hnf('[|]'(_5182680),_5182780,_5182786,_5182792).

'Text.Show.showParen'(_5184084,_5184086,_5184088,_5184090,_5184092):-freeze(_5184090,'blocked_Text.Show.showParen'(_5184084,_5184086,_5184088,_5184090,_5184092)).
'blocked_Text.Show.showParen'(_5184180,_5184198,_5185072,_5185078,_5185084):-hnf(_5184180,_5186142,_5185078,_5186160),'blocked_Text.Show.showParen_1'(_5186142,_5184198,_5185072,_5186160,_5185084).

'blocked_Text.Show.showParen_1'(_5186524,_5186526,_5186528,_5186530,_5186532):-freeze(_5186530,'blocked_blocked_Text.Show.showParen_1'(_5186524,_5186526,_5186528,_5186530,_5186532)).
'blocked_blocked_Text.Show.showParen_1'('Prelude.True',_5184198,_5186912,_5186918,_5186924):-hnf('Prelude..'('Text.Show.showChar'('^('),'Prelude..'(_5184198,'Text.Show.showChar'('^)'))),_5186912,_5186918,_5186924).
'blocked_blocked_Text.Show.showParen_1'('Prelude.False',_5184198,_5188668,_5188674,_5188680):-!,hnf(_5184198,_5188668,_5188674,_5188680).
'blocked_blocked_Text.Show.showParen_1'('FAIL'(_5189104),_5184198,'FAIL'(_5189104),_5189118,_5189118):-nonvar(_5189104).

'Text.Show.shows'(_5189880,_5189882,_5189884,_5189886):-freeze(_5189884,'blocked_Text.Show.shows'(_5189880,_5189882,_5189884,_5189886)).
'blocked_Text.Show.shows'(_5189966,_5190234,_5190240,_5190246):-hnf('Prelude..'(partcall(1,'Text.Show.showString',[]),'Prelude.show'(_5189966)),_5190234,_5190240,_5190246).

:-costCenters(['']).




%%%%% Number of shared variables: 0

