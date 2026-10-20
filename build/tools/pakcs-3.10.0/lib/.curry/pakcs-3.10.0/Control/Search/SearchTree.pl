%PAKCS3.10 swi9 VARIABLESHARING

:-noSingletonWarnings.
:-noRedefineWarnings.
:-noDiscontiguousWarnings.

:-importModule('Control.Search.Unsafe').
:-importModule('Data.List').
:-importModule('Prelude').
:-importModule('System.IO').

:-curryModule('Control.Search.SearchTree').


%%%%%%%%%%%% function types %%%%%%%%%%%%%%%%%%%
:-multifile functiontype/6.
:-dynamic functiontype/6.
functiontype('Control.Search.SearchTree._inst\'23Prelude.Data\'23Control.Search.SearchTree.SearchTree\'230\'23\'23','_inst#Prelude.Data#Control.Search.SearchTree.SearchTree#0##',2,'Control.Search.SearchTree._inst\'23Prelude.Data\'23Control.Search.SearchTree.SearchTree\'230\'23\'23',nofix,notype).
functiontype('Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.SearchTree\'230\'23\'23','_impl#===#Prelude.Data#Control.Search.SearchTree.SearchTree#0##',3,'Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.SearchTree\'230\'23\'23',nofix,notype).
functiontype('Control.Search.SearchTree._impl\'23aValue\'23Prelude.Data\'23Control.Search.SearchTree.SearchTree\'230\'23\'23','_impl#aValue#Prelude.Data#Control.Search.SearchTree.SearchTree#0##',1,'Control.Search.SearchTree._impl\'23aValue\'23Prelude.Data\'23Control.Search.SearchTree.SearchTree\'230\'23\'23',nofix,notype).
functiontype('Control.Search.SearchTree._inst\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23','_inst#Prelude.Data#Control.Search.SearchTree.AbortList#0##',2,'Control.Search.SearchTree._inst\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23',nofix,notype).
functiontype('Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23','_impl#===#Prelude.Data#Control.Search.SearchTree.AbortList#0##',3,'Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23',nofix,notype).
functiontype('Control.Search.SearchTree._impl\'23aValue\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23','_impl#aValue#Prelude.Data#Control.Search.SearchTree.AbortList#0##',1,'Control.Search.SearchTree._impl\'23aValue\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23',nofix,notype).
functiontype('Control.Search.SearchTree._inst\'23Prelude.Data\'23Control.Search.SearchTree.ValueSequence\'230\'23\'23','_inst#Prelude.Data#Control.Search.SearchTree.ValueSequence#0##',2,'Control.Search.SearchTree._inst\'23Prelude.Data\'23Control.Search.SearchTree.ValueSequence\'230\'23\'23',nofix,notype).
functiontype('Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.ValueSequence\'230\'23\'23','_impl#===#Prelude.Data#Control.Search.SearchTree.ValueSequence#0##',3,'Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.ValueSequence\'230\'23\'23',nofix,notype).
functiontype('Control.Search.SearchTree._impl\'23aValue\'23Prelude.Data\'23Control.Search.SearchTree.ValueSequence\'230\'23\'23','_impl#aValue#Prelude.Data#Control.Search.SearchTree.ValueSequence#0##',1,'Control.Search.SearchTree._impl\'23aValue\'23Prelude.Data\'23Control.Search.SearchTree.ValueSequence\'230\'23\'23',nofix,notype).
functiontype('Control.Search.SearchTree.getSearchTree',getSearchTree,1,'Control.Search.SearchTree.getSearchTree',nofix,notype).
functiontype('Control.Search.SearchTree.someSearchTree',someSearchTree,0,'Control.Search.SearchTree.someSearchTree',nofix,notype).
functiontype('Control.Search.SearchTree.someSearchTree.list2st.4','Control.Search.SearchTree.someSearchTree.list2st.4',1,'Control.Search.SearchTree.someSearchTree.list2st.4',nofix,notype).
functiontype('Control.Search.SearchTree.isDefined',isDefined,1,'Control.Search.SearchTree.isDefined',nofix,notype).
functiontype('Control.Search.SearchTree.isDefined.hasValue.12','Control.Search.SearchTree.isDefined.hasValue.12',1,'Control.Search.SearchTree.isDefined.hasValue.12',nofix,notype).
functiontype('Control.Search.SearchTree.showSearchTree',showSearchTree,2,'Control.Search.SearchTree.showSearchTree',nofix,notype).
functiontype('Control.Search.SearchTree.showSearchTree.showChar.24','Control.Search.SearchTree.showSearchTree.showChar.24',1,'Control.Search.SearchTree.showSearchTree.showChar.24',nofix,notype).
functiontype('Control.Search.SearchTree.showSearchTree.showString.24','Control.Search.SearchTree.showSearchTree.showString.24',1,'Control.Search.SearchTree.showSearchTree.showString.24',nofix,notype).
functiontype('Control.Search.SearchTree.showSearchTree.indent.24','Control.Search.SearchTree.showSearchTree.indent.24',1,'Control.Search.SearchTree.showSearchTree.indent.24',nofix,notype).
functiontype('Control.Search.SearchTree.showSearchTree.indent.24.showIndent.35','Control.Search.SearchTree.showSearchTree.indent.24.showIndent.35',1,'Control.Search.SearchTree.showSearchTree.indent.24.showIndent.35',nofix,notype).
functiontype('Control.Search.SearchTree.showSearchTree.shows.24','Control.Search.SearchTree.showSearchTree.shows.24',2,'Control.Search.SearchTree.showSearchTree.shows.24',nofix,notype).
functiontype('Control.Search.SearchTree.showSearchTree.showsST.24','Control.Search.SearchTree.showSearchTree.showsST.24',4,'Control.Search.SearchTree.showSearchTree.showsST.24',nofix,notype).
functiontype('Control.Search.SearchTree.searchTreeSize',searchTreeSize,1,'Control.Search.SearchTree.searchTreeSize',nofix,notype).
functiontype('Control.Search.SearchTree.searchTreeSize._\'23selFP6\'23v1','Control.Search.SearchTree.searchTreeSize._#selFP6#v1',1,'Control.Search.SearchTree.searchTreeSize._\'23selFP6\'23v1',nofix,notype).
functiontype('Control.Search.SearchTree.searchTreeSize._\'23selFP7\'23f1','Control.Search.SearchTree.searchTreeSize._#selFP7#f1',1,'Control.Search.SearchTree.searchTreeSize._\'23selFP7\'23f1',nofix,notype).
functiontype('Control.Search.SearchTree.searchTreeSize._\'23selFP8\'23o1','Control.Search.SearchTree.searchTreeSize._#selFP8#o1',1,'Control.Search.SearchTree.searchTreeSize._\'23selFP8\'23o1',nofix,notype).
functiontype('Control.Search.SearchTree.searchTreeSize._\'23selFP3\'23v2','Control.Search.SearchTree.searchTreeSize._#selFP3#v2',1,'Control.Search.SearchTree.searchTreeSize._\'23selFP3\'23v2',nofix,notype).
functiontype('Control.Search.SearchTree.searchTreeSize._\'23selFP4\'23f2','Control.Search.SearchTree.searchTreeSize._#selFP4#f2',1,'Control.Search.SearchTree.searchTreeSize._\'23selFP4\'23f2',nofix,notype).
functiontype('Control.Search.SearchTree.searchTreeSize._\'23selFP5\'23o2','Control.Search.SearchTree.searchTreeSize._#selFP5#o2',1,'Control.Search.SearchTree.searchTreeSize._\'23selFP5\'23o2',nofix,notype).
functiontype('Control.Search.SearchTree.limitSearchTree',limitSearchTree,2,'Control.Search.SearchTree.limitSearchTree',nofix,notype).
functiontype('Control.Search.SearchTree.dfsStrategy',dfsStrategy,1,'Control.Search.SearchTree.dfsStrategy',nofix,notype).
functiontype('Control.Search.SearchTree.bfsStrategy',bfsStrategy,1,'Control.Search.SearchTree.bfsStrategy',nofix,notype).
functiontype('Control.Search.SearchTree.allBFS','Control.Search.SearchTree.allBFS',1,'Control.Search.SearchTree.allBFS',nofix,notype).
functiontype('Control.Search.SearchTree.children','Control.Search.SearchTree.children',1,'Control.Search.SearchTree.children',nofix,notype).
functiontype('Control.Search.SearchTree.values','Control.Search.SearchTree.values',1,'Control.Search.SearchTree.values',nofix,notype).
functiontype('Control.Search.SearchTree.idsStrategy',idsStrategy,1,'Control.Search.SearchTree.idsStrategy',nofix,notype).
functiontype('Control.Search.SearchTree.defIDSDepth','Control.Search.SearchTree.defIDSDepth',0,'Control.Search.SearchTree.defIDSDepth',nofix,notype).
functiontype('Control.Search.SearchTree.defIDSInc','Control.Search.SearchTree.defIDSInc',0,'Control.Search.SearchTree.defIDSInc',nofix,notype).
functiontype('Control.Search.SearchTree.idsStrategyWith',idsStrategyWith,3,'Control.Search.SearchTree.idsStrategyWith',nofix,notype).
functiontype('Control.Search.SearchTree.idsStrategyWith.iterIDS.109','Control.Search.SearchTree.idsStrategyWith.iterIDS.109',4,'Control.Search.SearchTree.idsStrategyWith.iterIDS.109',nofix,notype).
functiontype('Control.Search.SearchTree.collectInBounds','Control.Search.SearchTree.collectInBounds',3,'Control.Search.SearchTree.collectInBounds',nofix,notype).
functiontype('Control.Search.SearchTree.collectInBounds.collectLevel.122','Control.Search.SearchTree.collectInBounds.collectLevel.122',4,'Control.Search.SearchTree.collectInBounds.collectLevel.122',nofix,notype).
functiontype('Control.Search.SearchTree.concA','Control.Search.SearchTree.concA',2,'Control.Search.SearchTree.concA',nofix,notype).
functiontype('Control.Search.SearchTree.diagStrategy',diagStrategy,1,'Control.Search.SearchTree.diagStrategy',nofix,notype).
functiontype('Control.Search.SearchTree.levels','Control.Search.SearchTree.levels',1,'Control.Search.SearchTree.levels',nofix,notype).
functiontype('Control.Search.SearchTree.levels._\'23lambda4','Control.Search.SearchTree.levels._#lambda4',2,'Control.Search.SearchTree.levels._\'23lambda4',nofix,notype).
functiontype('Control.Search.SearchTree.levels._\'23lambda4._\'23lambda6','Control.Search.SearchTree.levels._#lambda4._#lambda6',1,'Control.Search.SearchTree.levels._\'23lambda4._\'23lambda6',nofix,notype).
functiontype('Control.Search.SearchTree.allValuesWith',allValuesWith,2,'Control.Search.SearchTree.allValuesWith',nofix,notype).
functiontype('Control.Search.SearchTree.allValuesDFS',allValuesDFS,0,'Control.Search.SearchTree.allValuesDFS',nofix,notype).
functiontype('Control.Search.SearchTree.allValuesBFS',allValuesBFS,0,'Control.Search.SearchTree.allValuesBFS',nofix,notype).
functiontype('Control.Search.SearchTree.allValuesIDS',allValuesIDS,0,'Control.Search.SearchTree.allValuesIDS',nofix,notype).
functiontype('Control.Search.SearchTree.allValuesIDSwith',allValuesIDSwith,2,'Control.Search.SearchTree.allValuesIDSwith',nofix,notype).
functiontype('Control.Search.SearchTree.allValuesDiag',allValuesDiag,0,'Control.Search.SearchTree.allValuesDiag',nofix,notype).
functiontype('Control.Search.SearchTree.getAllValuesWith',getAllValuesWith,2,'Control.Search.SearchTree.getAllValuesWith',nofix,notype).
functiontype('Control.Search.SearchTree.getAllValuesWith._\'23lambda8','Control.Search.SearchTree.getAllValuesWith._#lambda8',2,'Control.Search.SearchTree.getAllValuesWith._\'23lambda8',nofix,notype).
functiontype('Control.Search.SearchTree.printAllValuesWith',printAllValuesWith,3,'Control.Search.SearchTree.printAllValuesWith',nofix,notype).
functiontype('Control.Search.SearchTree.printValuesWith',printValuesWith,3,'Control.Search.SearchTree.printValuesWith',nofix,notype).
functiontype('Control.Search.SearchTree.printValuesWith.printValues.167','Control.Search.SearchTree.printValuesWith.printValues.167',2,'Control.Search.SearchTree.printValuesWith.printValues.167',nofix,notype).
functiontype('Control.Search.SearchTree.printValuesWith.printValues.167._\'23lambda11','Control.Search.SearchTree.printValuesWith.printValues.167._#lambda11',3,'Control.Search.SearchTree.printValuesWith.printValues.167._\'23lambda11',nofix,notype).
functiontype('Control.Search.SearchTree.someValue',someValue,0,'Control.Search.SearchTree.someValue',nofix,notype).
functiontype('Control.Search.SearchTree.someValueWith',someValueWith,2,'Control.Search.SearchTree.someValueWith',nofix,notype).
functiontype('Control.Search.SearchTree.emptyVS',emptyVS,0,'Control.Search.SearchTree.emptyVS',nofix,notype).
functiontype('Control.Search.SearchTree.addVS',addVS,0,'Control.Search.SearchTree.addVS',nofix,notype).
functiontype('Control.Search.SearchTree.failVS',failVS,1,'Control.Search.SearchTree.failVS',nofix,notype).
functiontype('Control.Search.SearchTree.\'7C\'2B\'2B\'7C','|++|',2,'Control.Search.SearchTree.\'7C\'2B\'2B\'7C',nofix,notype).
functiontype('Control.Search.SearchTree.vsToList',vsToList,1,'Control.Search.SearchTree.vsToList',nofix,notype).
functiontype('Control.Search.SearchTree.showSearchTree.indent.24._\'23caseor0','Control.Search.SearchTree.showSearchTree.indent.24._#caseor0',1,'Control.Search.SearchTree.showSearchTree.indent.24._\'23caseor0',nofix,notype).
functiontype('Control.Search.SearchTree.showSearchTree.indent.24.showIndent.35._\'23caseor0','Control.Search.SearchTree.showSearchTree.indent.24.showIndent.35._#caseor0',1,'Control.Search.SearchTree.showSearchTree.indent.24.showIndent.35._\'23caseor0',nofix,notype).

%%%%%%%%%%%% constructor types %%%%%%%%%%%%%%%%%%%
:-multifile constructortype/7.
:-dynamic constructortype/7.
constructortype('Control.Search.SearchTree.Value','Value',1,'Search.SearchTree.Value',0,notype,['Control.Search.SearchTree.Fail'/1,'Control.Search.SearchTree.Or'/2]).
constructortype('Control.Search.SearchTree.Fail','Fail',1,'Search.SearchTree.Fail',1,notype,['Control.Search.SearchTree.Value'/1,'Control.Search.SearchTree.Or'/2]).
constructortype('Control.Search.SearchTree.Or','Or',2,'Search.SearchTree.Or',2,notype,['Control.Search.SearchTree.Value'/1,'Control.Search.SearchTree.Fail'/1]).
constructortype('Control.Search.SearchTree.Nil','Control.Search.SearchTree.Nil',0,'Search.SearchTree.Nil',0,notype,['Control.Search.SearchTree.Cons'/2,'Control.Search.SearchTree.FCons'/2,'Control.Search.SearchTree.Abort'/0]).
constructortype('Control.Search.SearchTree.Cons','Control.Search.SearchTree.Cons',2,'Search.SearchTree.Cons',1,notype,['Control.Search.SearchTree.Nil'/0,'Control.Search.SearchTree.FCons'/2,'Control.Search.SearchTree.Abort'/0]).
constructortype('Control.Search.SearchTree.FCons','Control.Search.SearchTree.FCons',2,'Search.SearchTree.FCons',2,notype,['Control.Search.SearchTree.Nil'/0,'Control.Search.SearchTree.Cons'/2,'Control.Search.SearchTree.Abort'/0]).
constructortype('Control.Search.SearchTree.Abort','Control.Search.SearchTree.Abort',0,'Search.SearchTree.Abort',3,notype,['Control.Search.SearchTree.Nil'/0,'Control.Search.SearchTree.Cons'/2,'Control.Search.SearchTree.FCons'/2]).
constructortype('Control.Search.SearchTree.EmptyVS','Control.Search.SearchTree.EmptyVS',0,'Search.SearchTree.EmptyVS',0,notype,['Control.Search.SearchTree.ConsVS'/2]).
constructortype('Control.Search.SearchTree.ConsVS','Control.Search.SearchTree.ConsVS',2,'Search.SearchTree.ConsVS',1,notype,['Control.Search.SearchTree.EmptyVS'/0]).

%%%%%%%%%%%% function definitions %%%%%%%%%%%%%%%%%%%
'Control.Search.SearchTree._inst\'23Prelude.Data\'23Control.Search.SearchTree.SearchTree\'230\'23\'23'(_6377130,_6377132,_6377134,_6377136,_6377138):-freeze(_6377136,'blocked_Control.Search.SearchTree._inst\'23Prelude.Data\'23Control.Search.SearchTree.SearchTree\'230\'23\'23'(_6377130,_6377132,_6377134,_6377136,_6377138)).
'blocked_Control.Search.SearchTree._inst\'23Prelude.Data\'23Control.Search.SearchTree.SearchTree\'230\'23\'23'(_6377226,_6377244,_6378342,_6378348,_6378354):-hnf(_6377244,_6382148,_6378348,_6382166),'blocked_Control.Search.SearchTree._inst\'23Prelude.Data\'23Control.Search.SearchTree.SearchTree\'230\'23\'23_2'(_6382148,_6377226,_6378342,_6382166,_6378354).

'blocked_Control.Search.SearchTree._inst\'23Prelude.Data\'23Control.Search.SearchTree.SearchTree\'230\'23\'23_2'(_6382986,_6382988,_6382990,_6382992,_6382994):-freeze(_6382992,'blocked_blocked_Control.Search.SearchTree._inst\'23Prelude.Data\'23Control.Search.SearchTree.SearchTree\'230\'23\'23_2'(_6382986,_6382988,_6382990,_6382992,_6382994)).
'blocked_blocked_Control.Search.SearchTree._inst\'23Prelude.Data\'23Control.Search.SearchTree.SearchTree\'230\'23\'23_2'('Prelude.()',_6377226,'Prelude._Dict\'23Data'(partcall(2,'Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.SearchTree\'230\'23\'23',[_6383440]),'Control.Search.SearchTree._impl\'23aValue\'23Prelude.Data\'23Control.Search.SearchTree.SearchTree\'230\'23\'23'(_6383440)),_6383348,_6383354):-!,makeShare(_6377226,_6383440),_6383348=_6383354.
'blocked_blocked_Control.Search.SearchTree._inst\'23Prelude.Data\'23Control.Search.SearchTree.SearchTree\'230\'23\'23_2'('FAIL'(_6386286),_6377226,'FAIL'(_6386286),_6386300,_6386300):-nonvar(_6386286).

'Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.SearchTree\'230\'23\'23'(_6390154,_6390156,_6390158,_6390160,_6390162,_6390164):-freeze(_6390162,'blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.SearchTree\'230\'23\'23'(_6390154,_6390156,_6390158,_6390160,_6390162,_6390164)).
'blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.SearchTree\'230\'23\'23'(_6390260,_6390278,_6390296,_6393928,_6393934,_6393940):-hnf(_6390278,_6398174,_6393934,_6398198),'blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.SearchTree\'230\'23\'23_2'(_6398174,_6390260,_6390296,_6393928,_6398198,_6393940).

'blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.SearchTree\'230\'23\'23_2'(_6399098,_6399100,_6399102,_6399104,_6399106,_6399108):-freeze(_6399106,'blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.SearchTree\'230\'23\'23_2'(_6399098,_6399100,_6399102,_6399104,_6399106,_6399108)).
'blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.SearchTree\'230\'23\'23_2'('Control.Search.SearchTree.Value'(_6390412),_6390260,_6390296,_6400530,_6400536,_6400542):-hnf(_6390296,_6406096,_6400536,_6406120),'blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.SearchTree\'230\'23\'23_2_Control.Search.SearchTree.Value_3'(_6406096,_6390412,_6390260,_6400530,_6406120,_6400542).

'blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.SearchTree\'230\'23\'23_2_Control.Search.SearchTree.Value_3'(_6407272,_6407274,_6407276,_6407278,_6407280,_6407282):-freeze(_6407280,'blocked_blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.SearchTree\'230\'23\'23_2_Control.Search.SearchTree.Value_3'(_6407272,_6407274,_6407276,_6407278,_6407280,_6407282)).
'blocked_blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.SearchTree\'230\'23\'23_2_Control.Search.SearchTree.Value_3'('Control.Search.SearchTree.Value'(_6390534),_6390412,_6390260,_6407908,_6407914,_6407920):-hnf('Prelude.apply'('Prelude.apply'('Prelude.==='(_6390260),_6390412),_6390534),_6407908,_6407914,_6407920).
'blocked_blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.SearchTree\'230\'23\'23_2_Control.Search.SearchTree.Value_3'('Control.Search.SearchTree.Fail'(_6391036),_6390412,_6390260,'Prelude.False',_6410636,_6410636).
'blocked_blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.SearchTree\'230\'23\'23_2_Control.Search.SearchTree.Value_3'('Control.Search.SearchTree.Or'(_6391160,_6391178),_6390412,_6390260,'Prelude.False',_6412558,_6412558):-!.
'blocked_blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.SearchTree\'230\'23\'23_2_Control.Search.SearchTree.Value_3'('FAIL'(_6414044),_6390412,_6390260,'FAIL'(_6414044),_6414058,_6414058):-nonvar(_6414044).
'blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.SearchTree\'230\'23\'23_2'('Control.Search.SearchTree.Fail'(_6391314),_6390260,_6390296,_6415450,_6415456,_6415462):-hnf(_6390296,_6420986,_6415456,_6421010),'blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.SearchTree\'230\'23\'23_2_Control.Search.SearchTree.Fail_3'(_6420986,_6391314,_6390260,_6415450,_6421010,_6415462).

'blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.SearchTree\'230\'23\'23_2_Control.Search.SearchTree.Fail_3'(_6422156,_6422158,_6422160,_6422162,_6422164,_6422166):-freeze(_6422164,'blocked_blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.SearchTree\'230\'23\'23_2_Control.Search.SearchTree.Fail_3'(_6422156,_6422158,_6422160,_6422162,_6422164,_6422166)).
'blocked_blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.SearchTree\'230\'23\'23_2_Control.Search.SearchTree.Fail_3'('Control.Search.SearchTree.Value'(_6391436),_6391314,_6390260,'Prelude.False',_6422798,_6422798).
'blocked_blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.SearchTree\'230\'23\'23_2_Control.Search.SearchTree.Fail_3'('Control.Search.SearchTree.Fail'(_6391560),_6391314,_6390260,_6424724,_6424730,_6424736):-hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Prelude.Int\'23',_6391314),_6391560),_6424724,_6424730,_6424736).
'blocked_blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.SearchTree\'230\'23\'23_2_Control.Search.SearchTree.Fail_3'('Control.Search.SearchTree.Or'(_6391992,_6392010),_6391314,_6390260,'Prelude.False',_6427504,_6427504):-!.
'blocked_blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.SearchTree\'230\'23\'23_2_Control.Search.SearchTree.Fail_3'('FAIL'(_6428984),_6391314,_6390260,'FAIL'(_6428984),_6428998,_6428998):-nonvar(_6428984).
'blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.SearchTree\'230\'23\'23_2'('Control.Search.SearchTree.Or'(_6392146,_6392164),_6390260,_6390296,_6430382,_6430388,_6430394):-!,hnf(_6390296,_6435858,_6430388,_6435888),'blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.SearchTree\'230\'23\'23_2_Control.Search.SearchTree.Or_4'(_6435858,_6392146,_6392164,_6390260,_6430382,_6435888,_6430394).

'blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.SearchTree\'230\'23\'23_2_Control.Search.SearchTree.Or_4'(_6437048,_6437050,_6437052,_6437054,_6437056,_6437058,_6437060):-freeze(_6437058,'blocked_blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.SearchTree\'230\'23\'23_2_Control.Search.SearchTree.Or_4'(_6437048,_6437050,_6437052,_6437054,_6437056,_6437058,_6437060)).
'blocked_blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.SearchTree\'230\'23\'23_2_Control.Search.SearchTree.Or_4'('Control.Search.SearchTree.Value'(_6392292),_6392146,_6392164,_6390260,'Prelude.False',_6437700,_6437700).
'blocked_blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.SearchTree\'230\'23\'23_2_Control.Search.SearchTree.Or_4'('Control.Search.SearchTree.Fail'(_6392416),_6392146,_6392164,_6390260,'Prelude.False',_6439694,_6439694).
'blocked_blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.SearchTree\'230\'23\'23_2_Control.Search.SearchTree.Or_4'('Control.Search.SearchTree.Or'(_6392540,_6392558),_6392146,_6392164,_6390260,_6441666,_6441672,_6441678):-!,makeShare(_6390260,_6441956),hnf('Prelude.&&'('Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.SearchTree\'230\'23\'23'(_6441956,_6392146,_6392540),'Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.SearchTree\'230\'23\'23'(_6441956,_6392164,_6392558)),_6441666,_6441672,_6441678).
'blocked_blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.SearchTree\'230\'23\'23_2_Control.Search.SearchTree.Or_4'('FAIL'(_6445700),_6392146,_6392164,_6390260,'FAIL'(_6445700),_6445714,_6445714):-nonvar(_6445700).
'blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.SearchTree\'230\'23\'23_2'('FAIL'(_6445794),_6390260,_6390296,'FAIL'(_6445794),_6445808,_6445808):-nonvar(_6445794).

'Control.Search.SearchTree._impl\'23aValue\'23Prelude.Data\'23Control.Search.SearchTree.SearchTree\'230\'23\'23'(_6449700,_6449702,_6449704,_6449706):-freeze(_6449704,'blocked_Control.Search.SearchTree._impl\'23aValue\'23Prelude.Data\'23Control.Search.SearchTree.SearchTree\'230\'23\'23'(_6449700,_6449702,_6449704,_6449706)).
'blocked_Control.Search.SearchTree._impl\'23aValue\'23Prelude.Data\'23Control.Search.SearchTree.SearchTree\'230\'23\'23'(_6449786,'Control.Search.SearchTree.Value'('Prelude.aValue'(_6449786)),_6450640,_6450640).
'blocked_Control.Search.SearchTree._impl\'23aValue\'23Prelude.Data\'23Control.Search.SearchTree.SearchTree\'230\'23\'23'(_6449786,'Control.Search.SearchTree.Fail'('Prelude._impl\'23aValue\'23Prelude.Data\'23Prelude.Int\'23'),_6451966,_6451966).
'blocked_Control.Search.SearchTree._impl\'23aValue\'23Prelude.Data\'23Control.Search.SearchTree.SearchTree\'230\'23\'23'(_6449786,'Control.Search.SearchTree.Or'('Control.Search.SearchTree._impl\'23aValue\'23Prelude.Data\'23Control.Search.SearchTree.SearchTree\'230\'23\'23'(_6453520),'Control.Search.SearchTree._impl\'23aValue\'23Prelude.Data\'23Control.Search.SearchTree.SearchTree\'230\'23\'23'(_6453520)),_6453436,_6453442):-makeShare(_6449786,_6453520),_6453436=_6453442.

'Control.Search.SearchTree._inst\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23'(_6459850,_6459852,_6459854,_6459856,_6459858):-freeze(_6459856,'blocked_Control.Search.SearchTree._inst\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23'(_6459850,_6459852,_6459854,_6459856,_6459858)).
'blocked_Control.Search.SearchTree._inst\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23'(_6459946,_6459964,_6461056,_6461062,_6461068):-hnf(_6459964,_6464826,_6461062,_6464844),'blocked_Control.Search.SearchTree._inst\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23_2'(_6464826,_6459946,_6461056,_6464844,_6461068).

'blocked_Control.Search.SearchTree._inst\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23_2'(_6465658,_6465660,_6465662,_6465664,_6465666):-freeze(_6465664,'blocked_blocked_Control.Search.SearchTree._inst\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23_2'(_6465658,_6465660,_6465662,_6465664,_6465666)).
'blocked_blocked_Control.Search.SearchTree._inst\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23_2'('Prelude.()',_6459946,'Prelude._Dict\'23Data'(partcall(2,'Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23',[_6466112]),'Control.Search.SearchTree._impl\'23aValue\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23'(_6466112)),_6466020,_6466026):-!,makeShare(_6459946,_6466112),_6466020=_6466026.
'blocked_blocked_Control.Search.SearchTree._inst\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23_2'('FAIL'(_6468940),_6459946,'FAIL'(_6468940),_6468954,_6468954):-nonvar(_6468940).

'Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23'(_6472770,_6472772,_6472774,_6472776,_6472778,_6472780):-freeze(_6472778,'blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23'(_6472770,_6472772,_6472774,_6472776,_6472778,_6472780)).
'blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23'(_6472876,_6472894,_6472912,_6477606,_6477612,_6477618):-hnf(_6472894,_6481816,_6477612,_6481840),'blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23_2'(_6481816,_6472876,_6472912,_6477606,_6481840,_6477618).

'blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23_2'(_6482734,_6482736,_6482738,_6482740,_6482742,_6482744):-freeze(_6482742,'blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23_2'(_6482734,_6482736,_6482738,_6482740,_6482742,_6482744)).
'blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23_2'('Control.Search.SearchTree.Nil',_6472876,_6472912,_6484118,_6484124,_6484130):-hnf(_6472912,_6489588,_6484124,_6489606),'blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23_2_Control.Search.SearchTree.Nil_2'(_6489588,_6472876,_6484118,_6489606,_6484130).

'blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23_2_Control.Search.SearchTree.Nil_2'(_6490732,_6490734,_6490736,_6490738,_6490740):-freeze(_6490738,'blocked_blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23_2_Control.Search.SearchTree.Nil_2'(_6490732,_6490734,_6490736,_6490738,_6490740)).
'blocked_blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23_2_Control.Search.SearchTree.Nil_2'('Control.Search.SearchTree.Nil',_6472876,'Prelude.True',_6491330,_6491330).
'blocked_blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23_2_Control.Search.SearchTree.Nil_2'('Control.Search.SearchTree.Cons'(_6473226,_6473244),_6472876,'Prelude.False',_6493112,_6493112).
'blocked_blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23_2_Control.Search.SearchTree.Nil_2'('Control.Search.SearchTree.FCons'(_6473374,_6473392),_6472876,'Prelude.False',_6495044,_6495044).
'blocked_blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23_2_Control.Search.SearchTree.Nil_2'('Control.Search.SearchTree.Abort',_6472876,'Prelude.False',_6496958,_6496958):-!.
'blocked_blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23_2_Control.Search.SearchTree.Nil_2'('FAIL'(_6498220),_6472876,'FAIL'(_6498220),_6498234,_6498234):-nonvar(_6498220).
'blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23_2'('Control.Search.SearchTree.Cons'(_6473628,_6473646),_6472876,_6472912,_6499628,_6499634,_6499640):-hnf(_6472912,_6505128,_6499634,_6505158),'blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23_2_Control.Search.SearchTree.Cons_4'(_6505128,_6473628,_6473646,_6472876,_6499628,_6505158,_6499640).

'blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23_2_Control.Search.SearchTree.Cons_4'(_6506306,_6506308,_6506310,_6506312,_6506314,_6506316,_6506318):-freeze(_6506316,'blocked_blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23_2_Control.Search.SearchTree.Cons_4'(_6506306,_6506308,_6506310,_6506312,_6506314,_6506316,_6506318)).
'blocked_blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23_2_Control.Search.SearchTree.Cons_4'('Control.Search.SearchTree.Nil',_6473628,_6473646,_6472876,'Prelude.False',_6506924,_6506924).
'blocked_blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23_2_Control.Search.SearchTree.Cons_4'('Control.Search.SearchTree.Cons'(_6473874,_6473892),_6473628,_6473646,_6472876,_6508860,_6508866,_6508872):-makeShare(_6472876,_6509154),hnf('Prelude.&&'('Prelude.apply'('Prelude.apply'('Prelude.==='(_6509154),_6473628),_6473874),'Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23'(_6509154,_6473646,_6473892)),_6508860,_6508866,_6508872).
'blocked_blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23_2_Control.Search.SearchTree.Cons_4'('Control.Search.SearchTree.FCons'(_6474778,_6474796),_6473628,_6473646,_6472876,'Prelude.False',_6513314,_6513314).
'blocked_blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23_2_Control.Search.SearchTree.Cons_4'('Control.Search.SearchTree.Abort',_6473628,_6473646,_6472876,'Prelude.False',_6515382,_6515382):-!.
'blocked_blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23_2_Control.Search.SearchTree.Cons_4'('FAIL'(_6516798),_6473628,_6473646,_6472876,'FAIL'(_6516798),_6516812,_6516812):-nonvar(_6516798).
'blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23_2'('Control.Search.SearchTree.FCons'(_6475032,_6475050),_6472876,_6472912,_6518234,_6518240,_6518246):-hnf(_6472912,_6523764,_6518240,_6523794),'blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23_2_Control.Search.SearchTree.FCons_4'(_6523764,_6475032,_6475050,_6472876,_6518234,_6523794,_6518246).

'blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23_2_Control.Search.SearchTree.FCons_4'(_6524948,_6524950,_6524952,_6524954,_6524956,_6524958,_6524960):-freeze(_6524958,'blocked_blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23_2_Control.Search.SearchTree.FCons_4'(_6524948,_6524950,_6524952,_6524954,_6524956,_6524958,_6524960)).
'blocked_blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23_2_Control.Search.SearchTree.FCons_4'('Control.Search.SearchTree.Nil',_6475032,_6475050,_6472876,'Prelude.False',_6525566,_6525566).
'blocked_blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23_2_Control.Search.SearchTree.FCons_4'('Control.Search.SearchTree.Cons'(_6475278,_6475296),_6475032,_6475050,_6472876,'Prelude.False',_6527514,_6527514).
'blocked_blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23_2_Control.Search.SearchTree.FCons_4'('Control.Search.SearchTree.FCons'(_6475426,_6475444),_6475032,_6475050,_6472876,_6529600,_6529606,_6529612):-hnf('Prelude.&&'('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Prelude.Int\'23',_6475032),_6475426),'Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23'(_6472876,_6475050,_6475444)),_6529600,_6529606,_6529612).
'blocked_blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23_2_Control.Search.SearchTree.FCons_4'('Control.Search.SearchTree.Abort',_6475032,_6475050,_6472876,'Prelude.False',_6533902,_6533902):-!.
'blocked_blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23_2_Control.Search.SearchTree.FCons_4'('FAIL'(_6535324),_6475032,_6475050,_6472876,'FAIL'(_6535324),_6535338,_6535338):-nonvar(_6535324).
'blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23_2'('Control.Search.SearchTree.Abort',_6472876,_6472912,_6536726,_6536732,_6536738):-!,hnf(_6472912,_6542256,_6536732,_6542274),'blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23_2_Control.Search.SearchTree.Abort_2'(_6542256,_6472876,_6536726,_6542274,_6536738).

'blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23_2_Control.Search.SearchTree.Abort_2'(_6543430,_6543432,_6543434,_6543436,_6543438):-freeze(_6543436,'blocked_blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23_2_Control.Search.SearchTree.Abort_2'(_6543430,_6543432,_6543434,_6543436,_6543438)).
'blocked_blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23_2_Control.Search.SearchTree.Abort_2'('Control.Search.SearchTree.Nil',_6472876,'Prelude.False',_6544028,_6544028).
'blocked_blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23_2_Control.Search.SearchTree.Abort_2'('Control.Search.SearchTree.Cons'(_6476564,_6476582),_6472876,'Prelude.False',_6545828,_6545828).
'blocked_blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23_2_Control.Search.SearchTree.Abort_2'('Control.Search.SearchTree.FCons'(_6476712,_6476730),_6472876,'Prelude.False',_6547772,_6547772).
'blocked_blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23_2_Control.Search.SearchTree.Abort_2'('Control.Search.SearchTree.Abort',_6472876,'Prelude.True',_6549698,_6549698):-!.
'blocked_blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23_2_Control.Search.SearchTree.Abort_2'('FAIL'(_6550966),_6472876,'FAIL'(_6550966),_6550980,_6550980):-nonvar(_6550966).
'blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23_2'('FAIL'(_6551044),_6472876,_6472912,'FAIL'(_6551044),_6551058,_6551058):-nonvar(_6551044).

'Control.Search.SearchTree._impl\'23aValue\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23'(_6554912,_6554914,_6554916,_6554918):-freeze(_6554916,'blocked_Control.Search.SearchTree._impl\'23aValue\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23'(_6554912,_6554914,_6554916,_6554918)).
'blocked_Control.Search.SearchTree._impl\'23aValue\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23'(_6554998,'Control.Search.SearchTree.Nil',_6556132,_6556132).
'blocked_Control.Search.SearchTree._impl\'23aValue\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23'(_6554998,'Control.Search.SearchTree.Cons'('Prelude.aValue'(_6557236),'Control.Search.SearchTree._impl\'23aValue\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23'(_6557236)),_6557152,_6557158):-makeShare(_6554998,_6557236),_6557152=_6557158.
'blocked_Control.Search.SearchTree._impl\'23aValue\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23'(_6554998,'Control.Search.SearchTree.FCons'('Prelude._impl\'23aValue\'23Prelude.Data\'23Prelude.Int\'23','Control.Search.SearchTree._impl\'23aValue\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23'(_6554998)),_6559538,_6559538).
'blocked_Control.Search.SearchTree._impl\'23aValue\'23Prelude.Data\'23Control.Search.SearchTree.AbortList\'230\'23\'23'(_6554998,'Control.Search.SearchTree.Abort',_6561828,_6561828).

'Control.Search.SearchTree._inst\'23Prelude.Data\'23Control.Search.SearchTree.ValueSequence\'230\'23\'23'(_6566500,_6566502,_6566504,_6566506,_6566508):-freeze(_6566506,'blocked_Control.Search.SearchTree._inst\'23Prelude.Data\'23Control.Search.SearchTree.ValueSequence\'230\'23\'23'(_6566500,_6566502,_6566504,_6566506,_6566508)).
'blocked_Control.Search.SearchTree._inst\'23Prelude.Data\'23Control.Search.SearchTree.ValueSequence\'230\'23\'23'(_6566596,_6566614,_6567730,_6567736,_6567742):-hnf(_6566614,_6571644,_6567736,_6571662),'blocked_Control.Search.SearchTree._inst\'23Prelude.Data\'23Control.Search.SearchTree.ValueSequence\'230\'23\'23_2'(_6571644,_6566596,_6567730,_6571662,_6567742).

'blocked_Control.Search.SearchTree._inst\'23Prelude.Data\'23Control.Search.SearchTree.ValueSequence\'230\'23\'23_2'(_6572500,_6572502,_6572504,_6572506,_6572508):-freeze(_6572506,'blocked_blocked_Control.Search.SearchTree._inst\'23Prelude.Data\'23Control.Search.SearchTree.ValueSequence\'230\'23\'23_2'(_6572500,_6572502,_6572504,_6572506,_6572508)).
'blocked_blocked_Control.Search.SearchTree._inst\'23Prelude.Data\'23Control.Search.SearchTree.ValueSequence\'230\'23\'23_2'('Prelude.()',_6566596,'Prelude._Dict\'23Data'(partcall(2,'Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.ValueSequence\'230\'23\'23',[_6572954]),'Control.Search.SearchTree._impl\'23aValue\'23Prelude.Data\'23Control.Search.SearchTree.ValueSequence\'230\'23\'23'(_6572954)),_6572862,_6572868):-!,makeShare(_6566596,_6572954),_6572862=_6572868.
'blocked_blocked_Control.Search.SearchTree._inst\'23Prelude.Data\'23Control.Search.SearchTree.ValueSequence\'230\'23\'23_2'('FAIL'(_6575854),_6566596,'FAIL'(_6575854),_6575868,_6575868):-nonvar(_6575854).

'Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.ValueSequence\'230\'23\'23'(_6579836,_6579838,_6579840,_6579842,_6579844,_6579846):-freeze(_6579844,'blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.ValueSequence\'230\'23\'23'(_6579836,_6579838,_6579840,_6579842,_6579844,_6579846)).
'blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.ValueSequence\'230\'23\'23'(_6579942,_6579960,_6579978,_6582266,_6582272,_6582278):-hnf(_6579960,_6586620,_6582272,_6586644),'blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.ValueSequence\'230\'23\'23_2'(_6586620,_6579942,_6579978,_6582266,_6586644,_6582278).

'blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.ValueSequence\'230\'23\'23_2'(_6587562,_6587564,_6587566,_6587568,_6587570,_6587572):-freeze(_6587570,'blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.ValueSequence\'230\'23\'23_2'(_6587562,_6587564,_6587566,_6587568,_6587570,_6587572)).
'blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.ValueSequence\'230\'23\'23_2'('Control.Search.SearchTree.EmptyVS',_6579942,_6579978,_6589018,_6589024,_6589030):-hnf(_6579978,_6594752,_6589024,_6594770),'blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.ValueSequence\'230\'23\'23_2_Control.Search.SearchTree.EmptyVS_2'(_6594752,_6579942,_6589018,_6594770,_6589030).

'blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.ValueSequence\'230\'23\'23_2_Control.Search.SearchTree.EmptyVS_2'(_6595944,_6595946,_6595948,_6595950,_6595952):-freeze(_6595950,'blocked_blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.ValueSequence\'230\'23\'23_2_Control.Search.SearchTree.EmptyVS_2'(_6595944,_6595946,_6595948,_6595950,_6595952)).
'blocked_blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.ValueSequence\'230\'23\'23_2_Control.Search.SearchTree.EmptyVS_2'('Control.Search.SearchTree.EmptyVS',_6579942,'Prelude.True',_6596590,_6596590).
'blocked_blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.ValueSequence\'230\'23\'23_2_Control.Search.SearchTree.EmptyVS_2'('Control.Search.SearchTree.ConsVS'(_6580292,_6580310),_6579942,'Prelude.False',_6598444,_6598444):-!.
'blocked_blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.ValueSequence\'230\'23\'23_2_Control.Search.SearchTree.EmptyVS_2'('FAIL'(_6599886),_6579942,'FAIL'(_6599886),_6599900,_6599900):-nonvar(_6599886).
'blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.ValueSequence\'230\'23\'23_2'('Control.Search.SearchTree.ConsVS'(_6580446,_6580464),_6579942,_6579978,_6601342,_6601348,_6601354):-!,hnf(_6579978,_6607046,_6601348,_6607076),'blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.ValueSequence\'230\'23\'23_2_Control.Search.SearchTree.ConsVS_4'(_6607046,_6580446,_6580464,_6579942,_6601342,_6607076,_6601354).

'blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.ValueSequence\'230\'23\'23_2_Control.Search.SearchTree.ConsVS_4'(_6608278,_6608280,_6608282,_6608284,_6608286,_6608288,_6608290):-freeze(_6608288,'blocked_blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.ValueSequence\'230\'23\'23_2_Control.Search.SearchTree.ConsVS_4'(_6608278,_6608280,_6608282,_6608284,_6608286,_6608288,_6608290)).
'blocked_blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.ValueSequence\'230\'23\'23_2_Control.Search.SearchTree.ConsVS_4'('Control.Search.SearchTree.EmptyVS',_6580446,_6580464,_6579942,'Prelude.False',_6608944,_6608944).
'blocked_blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.ValueSequence\'230\'23\'23_2_Control.Search.SearchTree.ConsVS_4'('Control.Search.SearchTree.ConsVS'(_6580692,_6580710),_6580446,_6580464,_6579942,_6610940,_6610946,_6610952):-!,makeShare(_6579942,_6611234),hnf('Prelude.&&'('Prelude.apply'('Prelude.apply'('Prelude.==='(_6611234),_6580446),_6580692),'Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.ValueSequence\'230\'23\'23'(_6611234,_6580464,_6580710)),_6610940,_6610946,_6610952).
'blocked_blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.ValueSequence\'230\'23\'23_2_Control.Search.SearchTree.ConsVS_4'('FAIL'(_6614922),_6580446,_6580464,_6579942,'FAIL'(_6614922),_6614936,_6614936):-nonvar(_6614922).
'blocked_blocked_Control.Search.SearchTree._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23Control.Search.SearchTree.ValueSequence\'230\'23\'23_2'('FAIL'(_6615016),_6579942,_6579978,'FAIL'(_6615016),_6615030,_6615030):-nonvar(_6615016).

'Control.Search.SearchTree._impl\'23aValue\'23Prelude.Data\'23Control.Search.SearchTree.ValueSequence\'230\'23\'23'(_6619036,_6619038,_6619040,_6619042):-freeze(_6619040,'blocked_Control.Search.SearchTree._impl\'23aValue\'23Prelude.Data\'23Control.Search.SearchTree.ValueSequence\'230\'23\'23'(_6619036,_6619038,_6619040,_6619042)).
'blocked_Control.Search.SearchTree._impl\'23aValue\'23Prelude.Data\'23Control.Search.SearchTree.ValueSequence\'230\'23\'23'(_6619122,'Control.Search.SearchTree.EmptyVS',_6619554,_6619554).
'blocked_Control.Search.SearchTree._impl\'23aValue\'23Prelude.Data\'23Control.Search.SearchTree.ValueSequence\'230\'23\'23'(_6619122,'Control.Search.SearchTree.ConsVS'('Prelude.aValue'(_6620706),'Control.Search.SearchTree._impl\'23aValue\'23Prelude.Data\'23Control.Search.SearchTree.ValueSequence\'230\'23\'23'(_6620706)),_6620622,_6620628):-makeShare(_6619122,_6620706),_6620622=_6620628.

'Control.Search.SearchTree.getSearchTree'(_6624678,_6624680,_6624682,_6624684):-freeze(_6624682,'blocked_Control.Search.SearchTree.getSearchTree'(_6624678,_6624680,_6624682,_6624684)).
'blocked_Control.Search.SearchTree.getSearchTree'(_6624764,_6625116,_6625122,_6625128):-hnf('Prelude.apply'('Prelude._impl\'23return\'23Prelude.Monad\'23Prelude.IO\'23','Prelude.apply'('Control.Search.SearchTree.someSearchTree',_6624764)),_6625116,_6625122,_6625128).

'Control.Search.SearchTree.someSearchTree'(_6628394,_6628396,_6628398):-freeze(_6628396,'blocked_Control.Search.SearchTree.someSearchTree'(_6628394,_6628396,_6628398)).
'blocked_Control.Search.SearchTree.someSearchTree'(_6628650,_6628656,_6628662):-hnf('Prelude..'(partcall(1,'Control.Search.SearchTree.someSearchTree.list2st.4',[]),partcall(1,'Control.Search.Unsafe.allValues',[])),_6628650,_6628656,_6628662).

'Control.Search.SearchTree.someSearchTree.list2st.4'(_6631902,_6631904,_6631906,_6631908):-freeze(_6631906,'blocked_Control.Search.SearchTree.someSearchTree.list2st.4'(_6631902,_6631904,_6631906,_6631908)).
'blocked_Control.Search.SearchTree.someSearchTree.list2st.4'(_6631988,_6633502,_6633508,_6633514):-hnf(_6631988,_6635680,_6633508,_6635692),'blocked_Control.Search.SearchTree.someSearchTree.list2st.4_1'(_6635680,_6633502,_6635692,_6633514).

'blocked_Control.Search.SearchTree.someSearchTree.list2st.4_1'(_6636234,_6636236,_6636238,_6636240):-freeze(_6636238,'blocked_blocked_Control.Search.SearchTree.someSearchTree.list2st.4_1'(_6636234,_6636236,_6636238,_6636240)).
'blocked_blocked_Control.Search.SearchTree.someSearchTree.list2st.4_1'([],'Control.Search.SearchTree.Fail'(0),_6636482,_6636482).
'blocked_blocked_Control.Search.SearchTree.someSearchTree.list2st.4_1'([_6632274|_6632292],_6637902,_6637908,_6637914):-!,hnf(_6632292,_6640560,_6637908,_6640578),'blocked_blocked_Control.Search.SearchTree.someSearchTree.list2st.4_1_[|]_2'(_6640560,_6632274,_6637902,_6640578,_6637914).

'blocked_blocked_Control.Search.SearchTree.someSearchTree.list2st.4_1_[|]_2'(_6641230,_6641232,_6641234,_6641236,_6641238):-freeze(_6641236,'blocked_blocked_blocked_Control.Search.SearchTree.someSearchTree.list2st.4_1_[|]_2'(_6641230,_6641232,_6641234,_6641236,_6641238)).
'blocked_blocked_blocked_Control.Search.SearchTree.someSearchTree.list2st.4_1_[|]_2'([],_6632274,'Control.Search.SearchTree.Value'(_6632274),_6641488,_6641488).
'blocked_blocked_blocked_Control.Search.SearchTree.someSearchTree.list2st.4_1_[|]_2'([_6632590|_6632608],_6632274,'Control.Search.SearchTree.Or'('Control.Search.SearchTree.Value'(_6632274),'Control.Search.SearchTree.someSearchTree.list2st.4'([_6632590|_6632608])),_6642644,_6642644):-!.
'blocked_blocked_blocked_Control.Search.SearchTree.someSearchTree.list2st.4_1_[|]_2'('FAIL'(_6644766),_6632274,'FAIL'(_6644766),_6644780,_6644780):-nonvar(_6644766).
'blocked_blocked_Control.Search.SearchTree.someSearchTree.list2st.4_1'('FAIL'(_6644844),'FAIL'(_6644844),_6644858,_6644858):-nonvar(_6644844).

'Control.Search.SearchTree.isDefined'(_6646372,_6646374,_6646376,_6646378):-freeze(_6646376,'blocked_Control.Search.SearchTree.isDefined'(_6646372,_6646374,_6646376,_6646378)).
'blocked_Control.Search.SearchTree.isDefined'(_6646458,_6646726,_6646732,_6646738):-hnf('Control.Search.SearchTree.isDefined.hasValue.12'('Prelude.apply'('Control.Search.SearchTree.someSearchTree',_6646458)),_6646726,_6646732,_6646738).

'Control.Search.SearchTree.isDefined.hasValue.12'(_6650014,_6650016,_6650018,_6650020):-freeze(_6650018,'blocked_Control.Search.SearchTree.isDefined.hasValue.12'(_6650014,_6650016,_6650018,_6650020)).
'blocked_Control.Search.SearchTree.isDefined.hasValue.12'(_6650100,_6651198,_6651204,_6651210):-hnf(_6650100,_6653268,_6651204,_6653280),'blocked_Control.Search.SearchTree.isDefined.hasValue.12_1'(_6653268,_6651198,_6653280,_6651210).

'blocked_Control.Search.SearchTree.isDefined.hasValue.12_1'(_6653810,_6653812,_6653814,_6653816):-freeze(_6653814,freeze(_6653810,'blocked_blocked_Control.Search.SearchTree.isDefined.hasValue.12_1'(_6653810,_6653812,_6653814,_6653816))).
'blocked_blocked_Control.Search.SearchTree.isDefined.hasValue.12_1'('Control.Search.SearchTree.Value'(_6650216),'Prelude.True',_6654438,_6654438).
'blocked_blocked_Control.Search.SearchTree.isDefined.hasValue.12_1'('Control.Search.SearchTree.Fail'(_6650340),'Prelude.False',_6655610,_6655610).
'blocked_blocked_Control.Search.SearchTree.isDefined.hasValue.12_1'('Control.Search.SearchTree.Or'(_6650464,_6650482),_6656766,_6656772,_6656778):-!,hnf('Prelude.||'('Control.Search.SearchTree.isDefined.hasValue.12'(_6650464),'Control.Search.SearchTree.isDefined.hasValue.12'(_6650482)),_6656766,_6656772,_6656778).
'blocked_blocked_Control.Search.SearchTree.isDefined.hasValue.12_1'('FAIL'(_6658550),'FAIL'(_6658550),_6658564,_6658564).

'Control.Search.SearchTree.showSearchTree'(_6660264,_6660266,_6660268,_6660270,_6660272):-freeze(_6660270,'blocked_Control.Search.SearchTree.showSearchTree'(_6660264,_6660266,_6660268,_6660270,_6660272)).
'blocked_Control.Search.SearchTree.showSearchTree'(_6660360,_6660378,_6661296,_6661302,_6661308):-makeShare(_6660406,_6661468),hnf('Prelude.cond'(letrec4PAKCS(_6661468,'Control.Search.SearchTree.showSearchTree.showChar.24'('^010')),'Prelude.apply'('Control.Search.SearchTree.showSearchTree.showsST.24'(_6661468,_6660360,[],_6660378),[])),_6661296,_6661302,_6661308).

'Control.Search.SearchTree.showSearchTree.showChar.24'(_6666296,_6666298,_6666300,_6666302):-freeze(_6666300,'blocked_Control.Search.SearchTree.showSearchTree.showChar.24'(_6666296,_6666298,_6666300,_6666302)).
'blocked_Control.Search.SearchTree.showSearchTree.showChar.24'(_6666382,_6666482,_6666488,_6666494):-hnf('[|]'(_6666382),_6666482,_6666488,_6666494).

'Control.Search.SearchTree.showSearchTree.showString.24'(_6669320,_6669322,_6669324,_6669326):-freeze(_6669324,'blocked_Control.Search.SearchTree.showSearchTree.showString.24'(_6669320,_6669322,_6669324,_6669326)).
'blocked_Control.Search.SearchTree.showSearchTree.showString.24'(_6669406,_6669506,_6669512,_6669518):-hnf(partcall(1,'Prelude.++',[_6669406]),_6669506,_6669512,_6669518).

'Control.Search.SearchTree.showSearchTree.indent.24'(_6672334,_6672336,_6672338,_6672340):-freeze(_6672338,'blocked_Control.Search.SearchTree.showSearchTree.indent.24'(_6672334,_6672336,_6672338,_6672340)).
'blocked_Control.Search.SearchTree.showSearchTree.indent.24'(_6672420,_6674452,_6674458,_6674464):-hnf(_6672420,_6676630,_6674458,_6676642),'blocked_Control.Search.SearchTree.showSearchTree.indent.24_1'(_6676630,_6674452,_6676642,_6674464).

'blocked_Control.Search.SearchTree.showSearchTree.indent.24_1'(_6677184,_6677186,_6677188,_6677190):-freeze(_6677188,'blocked_blocked_Control.Search.SearchTree.showSearchTree.indent.24_1'(_6677184,_6677186,_6677188,_6677190)).
'blocked_blocked_Control.Search.SearchTree.showSearchTree.indent.24_1'([],_6677426,_6677432,_6677438):-hnf(partcall(1,'Prelude.id',[]),_6677426,_6677432,_6677438).
'blocked_blocked_Control.Search.SearchTree.showSearchTree.indent.24_1'([_6672636|_6672654],_6678226,_6678232,_6678238):-!,hnf('Prelude..'('Control.Search.SearchTree.showSearchTree.showString.24'('Prelude.$'('Prelude.concatMap'(partcall(1,'Control.Search.SearchTree.showSearchTree.indent.24.showIndent.35',[])),'Prelude.apply'('Prelude.reverse',_6672654))),'Prelude..'('Control.Search.SearchTree.showSearchTree.showChar.24'('Control.Search.SearchTree.showSearchTree.indent.24._\'23caseor0'(_6672636)),'Control.Search.SearchTree.showSearchTree.showString.24'(['^09472','^ ']))),_6678226,_6678232,_6678238).
'blocked_blocked_Control.Search.SearchTree.showSearchTree.indent.24_1'('FAIL'(_6683020),'FAIL'(_6683020),_6683034,_6683034):-nonvar(_6683020).

'Control.Search.SearchTree.showSearchTree.indent.24.showIndent.35'(_6685650,_6685652,_6685654,_6685656):-freeze(_6685654,'blocked_Control.Search.SearchTree.showSearchTree.indent.24.showIndent.35'(_6685650,_6685652,_6685654,_6685656)).
'blocked_Control.Search.SearchTree.showSearchTree.indent.24.showIndent.35'(_6685736,['Control.Search.SearchTree.showSearchTree.indent.24.showIndent.35._\'23caseor0'(_6685736),'^ ','^ '],_6686318,_6686318).

'Control.Search.SearchTree.showSearchTree.shows.24'(_6690088,_6690090,_6690092,_6690094,_6690096):-freeze(_6690094,'blocked_Control.Search.SearchTree.showSearchTree.shows.24'(_6690088,_6690090,_6690092,_6690094,_6690096)).
'blocked_Control.Search.SearchTree.showSearchTree.shows.24'(_6690184,_6690202,_6690540,_6690546,_6690552):-hnf('Control.Search.SearchTree.showSearchTree.showString.24'('Prelude.apply'('Prelude.show'(_6690184),_6690202)),_6690540,_6690546,_6690552).

'Control.Search.SearchTree.showSearchTree.showsST.24'(_6694118,_6694120,_6694122,_6694124,_6694126,_6694128,_6694130):-freeze(_6694128,'blocked_Control.Search.SearchTree.showSearchTree.showsST.24'(_6694118,_6694120,_6694122,_6694124,_6694126,_6694128,_6694130)).
'blocked_Control.Search.SearchTree.showSearchTree.showsST.24'(_6694234,_6694252,_6694270,_6694288,_6697814,_6697820,_6697826):-hnf(_6694288,_6700052,_6697820,_6700082),'blocked_Control.Search.SearchTree.showSearchTree.showsST.24_4'(_6700052,_6694234,_6694252,_6694270,_6697814,_6700082,_6697826).

'blocked_Control.Search.SearchTree.showSearchTree.showsST.24_4'(_6700654,_6700656,_6700658,_6700660,_6700662,_6700664,_6700666):-freeze(_6700664,'blocked_blocked_Control.Search.SearchTree.showSearchTree.showsST.24_4'(_6700654,_6700656,_6700658,_6700660,_6700662,_6700664,_6700666)).
'blocked_blocked_Control.Search.SearchTree.showSearchTree.showsST.24_4'('Control.Search.SearchTree.Value'(_6694404),_6694234,_6694252,_6694270,_6701300,_6701306,_6701312):-hnf('Prelude..'('Control.Search.SearchTree.showSearchTree.indent.24'(_6694270),'Prelude..'('Control.Search.SearchTree.showSearchTree.shows.24'(_6694252,_6694404),_6694234)),_6701300,_6701306,_6701312).
'blocked_blocked_Control.Search.SearchTree.showSearchTree.showsST.24_4'('Control.Search.SearchTree.Fail'(_6695060),_6694234,_6694252,_6694270,_6704218,_6704224,_6704230):-hnf('Prelude..'('Control.Search.SearchTree.showSearchTree.indent.24'(_6694270),'Prelude..'('Control.Search.SearchTree.showSearchTree.showChar.24'('^!'),_6694234)),_6704218,_6704224,_6704230).
'blocked_blocked_Control.Search.SearchTree.showSearchTree.showsST.24_4'('Control.Search.SearchTree.Or'(_6695646,_6695664),_6694234,_6694252,_6694270,_6706986,_6706992,_6706998):-!,makeShare(_6694270,_6707400),makeShare(_6694234,_6707420),makeShare(_6694252,_6707440),hnf('Prelude..'('Control.Search.SearchTree.showSearchTree.indent.24'(_6707400),'Prelude..'('Control.Search.SearchTree.showSearchTree.showChar.24'(^?),'Prelude..'(_6707420,'Prelude..'('Control.Search.SearchTree.showSearchTree.showsST.24'(_6707420,_6707440,['Prelude.False'|_6707400],_6695646),'Control.Search.SearchTree.showSearchTree.showsST.24'(_6707420,_6707440,['Prelude.True'|_6707400],_6695664))))),_6706986,_6706992,_6706998).
'blocked_blocked_Control.Search.SearchTree.showSearchTree.showsST.24_4'('FAIL'(_6712762),_6694234,_6694252,_6694270,'FAIL'(_6712762),_6712776,_6712776):-nonvar(_6712762).

'Control.Search.SearchTree.searchTreeSize'(_6714504,_6714506,_6714508,_6714510):-freeze(_6714508,'blocked_Control.Search.SearchTree.searchTreeSize'(_6714504,_6714506,_6714508,_6714510)).
'blocked_Control.Search.SearchTree.searchTreeSize'(_6714590,_6719922,_6719928,_6719934):-hnf(_6714590,_6721740,_6719928,_6721752),'blocked_Control.Search.SearchTree.searchTreeSize_1'(_6721740,_6719922,_6721752,_6719934).

'blocked_Control.Search.SearchTree.searchTreeSize_1'(_6722234,_6722236,_6722238,_6722240):-freeze(_6722238,'blocked_blocked_Control.Search.SearchTree.searchTreeSize_1'(_6722234,_6722236,_6722238,_6722240)).
'blocked_blocked_Control.Search.SearchTree.searchTreeSize_1'('Control.Search.SearchTree.Value'(_6714706),'Prelude.(,,)'(1,0,0),_6722856,_6722856).
'blocked_blocked_Control.Search.SearchTree.searchTreeSize_1'('Control.Search.SearchTree.Fail'(_6715040),'Prelude.(,,)'(0,1,0),_6724208,_6724208).
'blocked_blocked_Control.Search.SearchTree.searchTreeSize_1'('Control.Search.SearchTree.Or'(_6715374,_6715392),_6725538,_6725544,_6725550):-!,makeShare(_6715432,_6727078),makeShare(_6715450,_6727098),makeShare(_6715468,_6727118),makeShare(_6715486,_6727138),makeShare(_6715504,_6727158),makeShare(_6715522,_6727178),makeShare(_6715540,_6727198),makeShare(_6715558,_6727218),hnf('Prelude.cond'(letrec4PAKCS(_6727078,'Control.Search.SearchTree.searchTreeSize'(_6715374)),'Prelude.cond'(letrec4PAKCS(_6727098,'Control.Search.SearchTree.searchTreeSize._\'23selFP6\'23v1'(_6727078)),'Prelude.cond'(letrec4PAKCS(_6727118,'Control.Search.SearchTree.searchTreeSize._\'23selFP7\'23f1'(_6727078)),'Prelude.cond'(letrec4PAKCS(_6727138,'Control.Search.SearchTree.searchTreeSize._\'23selFP8\'23o1'(_6727078)),'Prelude.cond'(letrec4PAKCS(_6727158,'Control.Search.SearchTree.searchTreeSize'(_6715392)),'Prelude.cond'(letrec4PAKCS(_6727178,'Control.Search.SearchTree.searchTreeSize._\'23selFP3\'23v2'(_6727158)),'Prelude.cond'(letrec4PAKCS(_6727198,'Control.Search.SearchTree.searchTreeSize._\'23selFP4\'23f2'(_6727158)),'Prelude.cond'(letrec4PAKCS(_6727218,'Control.Search.SearchTree.searchTreeSize._\'23selFP5\'23o2'(_6727158)),'Prelude.(,,)'('Prelude._impl\'23\'2B\'23Prelude.Num\'23Prelude.Int\'23'(_6727098,_6727178),'Prelude._impl\'23\'2B\'23Prelude.Num\'23Prelude.Int\'23'(_6727118,_6727198),'Prelude._impl\'23\'2B\'23Prelude.Num\'23Prelude.Int\'23'('Prelude._impl\'23\'2B\'23Prelude.Num\'23Prelude.Int\'23'(_6727138,_6727218),1)))))))))),_6725538,_6725544,_6725550).
'blocked_blocked_Control.Search.SearchTree.searchTreeSize_1'('FAIL'(_6739838),'FAIL'(_6739838),_6739852,_6739852):-nonvar(_6739838).

'Control.Search.SearchTree.searchTreeSize._\'23selFP6\'23v1'(_6742068,_6742070,_6742072,_6742074):-freeze(_6742072,'blocked_Control.Search.SearchTree.searchTreeSize._\'23selFP6\'23v1'(_6742068,_6742070,_6742072,_6742074)).
'blocked_Control.Search.SearchTree.searchTreeSize._\'23selFP6\'23v1'(_6742154,_6742760,_6742766,_6742772):-hnf(_6742154,_6745154,_6742766,_6745166),'blocked_Control.Search.SearchTree.searchTreeSize._\'23selFP6\'23v1_1'(_6745154,_6742760,_6745166,_6742772).

'blocked_Control.Search.SearchTree.searchTreeSize._\'23selFP6\'23v1_1'(_6745744,_6745746,_6745748,_6745750):-freeze(_6745748,'blocked_blocked_Control.Search.SearchTree.searchTreeSize._\'23selFP6\'23v1_1'(_6745744,_6745746,_6745748,_6745750)).
'blocked_blocked_Control.Search.SearchTree.searchTreeSize._\'23selFP6\'23v1_1'('Prelude.(,,)'(_6742270,_6742288,_6742306),_6746128,_6746134,_6746140):-!,hnf(_6742270,_6746128,_6746134,_6746140).
'blocked_blocked_Control.Search.SearchTree.searchTreeSize._\'23selFP6\'23v1_1'('FAIL'(_6746910),'FAIL'(_6746910),_6746924,_6746924):-nonvar(_6746910).

'Control.Search.SearchTree.searchTreeSize._\'23selFP7\'23f1'(_6749140,_6749142,_6749144,_6749146):-freeze(_6749144,'blocked_Control.Search.SearchTree.searchTreeSize._\'23selFP7\'23f1'(_6749140,_6749142,_6749144,_6749146)).
'blocked_Control.Search.SearchTree.searchTreeSize._\'23selFP7\'23f1'(_6749226,_6749832,_6749838,_6749844):-hnf(_6749226,_6752226,_6749838,_6752238),'blocked_Control.Search.SearchTree.searchTreeSize._\'23selFP7\'23f1_1'(_6752226,_6749832,_6752238,_6749844).

'blocked_Control.Search.SearchTree.searchTreeSize._\'23selFP7\'23f1_1'(_6752816,_6752818,_6752820,_6752822):-freeze(_6752820,'blocked_blocked_Control.Search.SearchTree.searchTreeSize._\'23selFP7\'23f1_1'(_6752816,_6752818,_6752820,_6752822)).
'blocked_blocked_Control.Search.SearchTree.searchTreeSize._\'23selFP7\'23f1_1'('Prelude.(,,)'(_6749342,_6749360,_6749378),_6753200,_6753206,_6753212):-!,hnf(_6749360,_6753200,_6753206,_6753212).
'blocked_blocked_Control.Search.SearchTree.searchTreeSize._\'23selFP7\'23f1_1'('FAIL'(_6753982),'FAIL'(_6753982),_6753996,_6753996):-nonvar(_6753982).

'Control.Search.SearchTree.searchTreeSize._\'23selFP8\'23o1'(_6756212,_6756214,_6756216,_6756218):-freeze(_6756216,'blocked_Control.Search.SearchTree.searchTreeSize._\'23selFP8\'23o1'(_6756212,_6756214,_6756216,_6756218)).
'blocked_Control.Search.SearchTree.searchTreeSize._\'23selFP8\'23o1'(_6756298,_6756904,_6756910,_6756916):-hnf(_6756298,_6759298,_6756910,_6759310),'blocked_Control.Search.SearchTree.searchTreeSize._\'23selFP8\'23o1_1'(_6759298,_6756904,_6759310,_6756916).

'blocked_Control.Search.SearchTree.searchTreeSize._\'23selFP8\'23o1_1'(_6759888,_6759890,_6759892,_6759894):-freeze(_6759892,'blocked_blocked_Control.Search.SearchTree.searchTreeSize._\'23selFP8\'23o1_1'(_6759888,_6759890,_6759892,_6759894)).
'blocked_blocked_Control.Search.SearchTree.searchTreeSize._\'23selFP8\'23o1_1'('Prelude.(,,)'(_6756414,_6756432,_6756450),_6760272,_6760278,_6760284):-!,hnf(_6756450,_6760272,_6760278,_6760284).
'blocked_blocked_Control.Search.SearchTree.searchTreeSize._\'23selFP8\'23o1_1'('FAIL'(_6761054),'FAIL'(_6761054),_6761068,_6761068):-nonvar(_6761054).

'Control.Search.SearchTree.searchTreeSize._\'23selFP3\'23v2'(_6763284,_6763286,_6763288,_6763290):-freeze(_6763288,'blocked_Control.Search.SearchTree.searchTreeSize._\'23selFP3\'23v2'(_6763284,_6763286,_6763288,_6763290)).
'blocked_Control.Search.SearchTree.searchTreeSize._\'23selFP3\'23v2'(_6763370,_6763976,_6763982,_6763988):-hnf(_6763370,_6766370,_6763982,_6766382),'blocked_Control.Search.SearchTree.searchTreeSize._\'23selFP3\'23v2_1'(_6766370,_6763976,_6766382,_6763988).

'blocked_Control.Search.SearchTree.searchTreeSize._\'23selFP3\'23v2_1'(_6766960,_6766962,_6766964,_6766966):-freeze(_6766964,'blocked_blocked_Control.Search.SearchTree.searchTreeSize._\'23selFP3\'23v2_1'(_6766960,_6766962,_6766964,_6766966)).
'blocked_blocked_Control.Search.SearchTree.searchTreeSize._\'23selFP3\'23v2_1'('Prelude.(,,)'(_6763486,_6763504,_6763522),_6767344,_6767350,_6767356):-!,hnf(_6763486,_6767344,_6767350,_6767356).
'blocked_blocked_Control.Search.SearchTree.searchTreeSize._\'23selFP3\'23v2_1'('FAIL'(_6768126),'FAIL'(_6768126),_6768140,_6768140):-nonvar(_6768126).

'Control.Search.SearchTree.searchTreeSize._\'23selFP4\'23f2'(_6770356,_6770358,_6770360,_6770362):-freeze(_6770360,'blocked_Control.Search.SearchTree.searchTreeSize._\'23selFP4\'23f2'(_6770356,_6770358,_6770360,_6770362)).
'blocked_Control.Search.SearchTree.searchTreeSize._\'23selFP4\'23f2'(_6770442,_6771048,_6771054,_6771060):-hnf(_6770442,_6773442,_6771054,_6773454),'blocked_Control.Search.SearchTree.searchTreeSize._\'23selFP4\'23f2_1'(_6773442,_6771048,_6773454,_6771060).

'blocked_Control.Search.SearchTree.searchTreeSize._\'23selFP4\'23f2_1'(_6774032,_6774034,_6774036,_6774038):-freeze(_6774036,'blocked_blocked_Control.Search.SearchTree.searchTreeSize._\'23selFP4\'23f2_1'(_6774032,_6774034,_6774036,_6774038)).
'blocked_blocked_Control.Search.SearchTree.searchTreeSize._\'23selFP4\'23f2_1'('Prelude.(,,)'(_6770558,_6770576,_6770594),_6774416,_6774422,_6774428):-!,hnf(_6770576,_6774416,_6774422,_6774428).
'blocked_blocked_Control.Search.SearchTree.searchTreeSize._\'23selFP4\'23f2_1'('FAIL'(_6775198),'FAIL'(_6775198),_6775212,_6775212):-nonvar(_6775198).

'Control.Search.SearchTree.searchTreeSize._\'23selFP5\'23o2'(_6777428,_6777430,_6777432,_6777434):-freeze(_6777432,'blocked_Control.Search.SearchTree.searchTreeSize._\'23selFP5\'23o2'(_6777428,_6777430,_6777432,_6777434)).
'blocked_Control.Search.SearchTree.searchTreeSize._\'23selFP5\'23o2'(_6777514,_6778120,_6778126,_6778132):-hnf(_6777514,_6780514,_6778126,_6780526),'blocked_Control.Search.SearchTree.searchTreeSize._\'23selFP5\'23o2_1'(_6780514,_6778120,_6780526,_6778132).

'blocked_Control.Search.SearchTree.searchTreeSize._\'23selFP5\'23o2_1'(_6781104,_6781106,_6781108,_6781110):-freeze(_6781108,'blocked_blocked_Control.Search.SearchTree.searchTreeSize._\'23selFP5\'23o2_1'(_6781104,_6781106,_6781108,_6781110)).
'blocked_blocked_Control.Search.SearchTree.searchTreeSize._\'23selFP5\'23o2_1'('Prelude.(,,)'(_6777630,_6777648,_6777666),_6781488,_6781494,_6781500):-!,hnf(_6777666,_6781488,_6781494,_6781500).
'blocked_blocked_Control.Search.SearchTree.searchTreeSize._\'23selFP5\'23o2_1'('FAIL'(_6782270),'FAIL'(_6782270),_6782284,_6782284):-nonvar(_6782270).

'Control.Search.SearchTree.limitSearchTree'(_6784026,_6784028,_6784030,_6784032,_6784034):-freeze(_6784032,'blocked_Control.Search.SearchTree.limitSearchTree'(_6784026,_6784028,_6784030,_6784032,_6784034)).
'blocked_Control.Search.SearchTree.limitSearchTree'(_6784122,_6784140,_6787284,_6787290,_6787296):-makeShare(_6784140,_6785988),hnf(_6785988,_6789146,_6787290,_6789170),'blocked_Control.Search.SearchTree.limitSearchTree_2'(_6789146,_6784122,_6789146,_6787284,_6789170,_6787296).

'blocked_Control.Search.SearchTree.limitSearchTree_2'(_6789686,_6789688,_6789690,_6789692,_6789694,_6789696):-freeze(_6789694,'blocked_blocked_Control.Search.SearchTree.limitSearchTree_2'(_6789686,_6789688,_6789690,_6789692,_6789694,_6789696)).
'blocked_blocked_Control.Search.SearchTree.limitSearchTree_2'('Control.Search.SearchTree.Value'(_6784256),_6784122,_6785988,_6790322,_6790328,_6790334):-hnf(_6785988,_6790322,_6790328,_6790334).
'blocked_blocked_Control.Search.SearchTree.limitSearchTree_2'('Control.Search.SearchTree.Fail'(_6784366),_6784122,_6785988,_6791536,_6791542,_6791548):-hnf(_6785988,_6791536,_6791542,_6791548).
'blocked_blocked_Control.Search.SearchTree.limitSearchTree_2'('Control.Search.SearchTree.Or'(_6784476,_6784494),_6784122,_6785988,_6794940,_6794946,_6794952):-!,makeShare(_6784122,_6792896),hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3C\'23Prelude.Ord\'23Prelude.Int\'23',_6792896),0),_6798154,_6794946,_6798108),'blocked_blocked_Control.Search.SearchTree.limitSearchTree_2_Control.Search.SearchTree.Or_ComplexCase'(_6798154,_6784476,_6784494,_6792896,_6785988,_6794940,_6798108,_6794952).

'blocked_blocked_Control.Search.SearchTree.limitSearchTree_2_Control.Search.SearchTree.Or_ComplexCase'(_6798958,_6798960,_6798962,_6798964,_6798966,_6798968,_6798970,_6798972):-freeze(_6798970,freeze(_6798958,'blocked_blocked_blocked_Control.Search.SearchTree.limitSearchTree_2_Control.Search.SearchTree.Or_ComplexCase'(_6798958,_6798960,_6798962,_6798964,_6798966,_6798968,_6798970,_6798972))).
'blocked_blocked_blocked_Control.Search.SearchTree.limitSearchTree_2_Control.Search.SearchTree.Or_ComplexCase'('Prelude.True',_6784476,_6784494,_6792896,_6785988,'Control.Search.SearchTree.Fail'('Prelude._impl\'23negate\'23Prelude.Num\'23Prelude.Int\'23'(1)),_6799388,_6799388).
'blocked_blocked_blocked_Control.Search.SearchTree.limitSearchTree_2_Control.Search.SearchTree.Or_ComplexCase'('Prelude.False',_6784476,_6784494,_6792896,_6785988,'Control.Search.SearchTree.Or'('Control.Search.SearchTree.limitSearchTree'('Prelude._impl\'23\'2D\'23Prelude.Num\'23Prelude.Int\'23'(_6801644,1),_6784476),'Control.Search.SearchTree.limitSearchTree'('Prelude._impl\'23\'2D\'23Prelude.Num\'23Prelude.Int\'23'(_6801644,1),_6784494)),_6801456,_6801462):-!,makeShare(_6792896,_6801644),_6801456=_6801462.
'blocked_blocked_blocked_Control.Search.SearchTree.limitSearchTree_2_Control.Search.SearchTree.Or_ComplexCase'('FAIL'(_6805058),_6784476,_6784494,_6792896,_6785988,'FAIL'(_6805058),_6805072,_6805072).
'blocked_blocked_Control.Search.SearchTree.limitSearchTree_2'('FAIL'(_6805156),_6784122,_6785988,'FAIL'(_6805156),_6805170,_6805170):-nonvar(_6805156).

'Control.Search.SearchTree.dfsStrategy'(_6806776,_6806778,_6806780,_6806782):-freeze(_6806780,'blocked_Control.Search.SearchTree.dfsStrategy'(_6806776,_6806778,_6806780,_6806782)).
'blocked_Control.Search.SearchTree.dfsStrategy'(_6806862,_6808292,_6808298,_6808304):-hnf(_6806862,_6810002,_6808298,_6810014),'blocked_Control.Search.SearchTree.dfsStrategy_1'(_6810002,_6808292,_6810014,_6808304).

'blocked_Control.Search.SearchTree.dfsStrategy_1'(_6810478,_6810480,_6810482,_6810484):-freeze(_6810482,'blocked_blocked_Control.Search.SearchTree.dfsStrategy_1'(_6810478,_6810480,_6810482,_6810484)).
'blocked_blocked_Control.Search.SearchTree.dfsStrategy_1'('Control.Search.SearchTree.Fail'(_6806978),_6811082,_6811088,_6811094):-hnf('Control.Search.SearchTree.failVS'(_6806978),_6811082,_6811088,_6811094).
'blocked_blocked_Control.Search.SearchTree.dfsStrategy_1'('Control.Search.SearchTree.Value'(_6807172),_6812438,_6812444,_6812450):-hnf('Prelude.apply'('Prelude.apply'('Control.Search.SearchTree.addVS',_6807172),'Control.Search.SearchTree.emptyVS'),_6812438,_6812444,_6812450).
'blocked_blocked_Control.Search.SearchTree.dfsStrategy_1'('Control.Search.SearchTree.Or'(_6807618,_6807636),_6814440,_6814446,_6814452):-!,hnf('Control.Search.SearchTree.\'7C\'2B\'2B\'7C'('Control.Search.SearchTree.dfsStrategy'(_6807618),'Control.Search.SearchTree.dfsStrategy'(_6807636)),_6814440,_6814446,_6814452).
'blocked_blocked_Control.Search.SearchTree.dfsStrategy_1'('FAIL'(_6816148),'FAIL'(_6816148),_6816162,_6816162):-nonvar(_6816148).

'Control.Search.SearchTree.bfsStrategy'(_6817752,_6817754,_6817756,_6817758):-freeze(_6817756,'blocked_Control.Search.SearchTree.bfsStrategy'(_6817752,_6817754,_6817756,_6817758)).
'blocked_Control.Search.SearchTree.bfsStrategy'(_6817838,_6818106,_6818112,_6818118):-hnf('Control.Search.SearchTree.allBFS'([_6817838]),_6818106,_6818112,_6818118).

'Control.Search.SearchTree.allBFS'(_6820424,_6820426,_6820428,_6820430):-freeze(_6820428,'blocked_Control.Search.SearchTree.allBFS'(_6820424,_6820426,_6820428,_6820430)).
'blocked_Control.Search.SearchTree.allBFS'(_6820510,_6821762,_6821768,_6821774):-hnf(_6820510,_6823292,_6821768,_6823304),'blocked_Control.Search.SearchTree.allBFS_1'(_6823292,_6821762,_6823304,_6821774).

'blocked_Control.Search.SearchTree.allBFS_1'(_6823738,_6823740,_6823742,_6823744):-freeze(_6823742,'blocked_blocked_Control.Search.SearchTree.allBFS_1'(_6823738,_6823740,_6823742,_6823744)).
'blocked_blocked_Control.Search.SearchTree.allBFS_1'([],_6823980,_6823986,_6823992):-hnf('Control.Search.SearchTree.emptyVS',_6823980,_6823986,_6823992).
'blocked_blocked_Control.Search.SearchTree.allBFS_1'([_6820726|_6820744],_6824806,_6824812,_6824818):-!,makeShare(_6820726,_6824954),makeShare(_6820744,_6824974),hnf('Control.Search.SearchTree.\'7C\'2B\'2B\'7C'('Control.Search.SearchTree.values'([_6824954|_6824974]),'Control.Search.SearchTree.allBFS'('Control.Search.SearchTree.children'([_6824954|_6824974]))),_6824806,_6824812,_6824818).
'blocked_blocked_Control.Search.SearchTree.allBFS_1'('FAIL'(_6827630),'FAIL'(_6827630),_6827644,_6827644):-nonvar(_6827630).

'Control.Search.SearchTree.children'(_6829120,_6829122,_6829124,_6829126):-freeze(_6829124,'blocked_Control.Search.SearchTree.children'(_6829120,_6829122,_6829124,_6829126)).
'blocked_Control.Search.SearchTree.children'(_6829206,_6830688,_6830694,_6830700):-hnf(_6829206,_6832290,_6830694,_6832302),'blocked_Control.Search.SearchTree.children_1'(_6832290,_6830688,_6832302,_6830700).

'blocked_Control.Search.SearchTree.children_1'(_6832748,_6832750,_6832752,_6832754):-freeze(_6832752,'blocked_blocked_Control.Search.SearchTree.children_1'(_6832748,_6832750,_6832752,_6832754)).
'blocked_blocked_Control.Search.SearchTree.children_1'([],[],_6832996,_6832996).
'blocked_blocked_Control.Search.SearchTree.children_1'([_6829422|_6829440],_6833950,_6833956,_6833962):-!,hnf(_6829422,_6836032,_6833956,_6836050),'blocked_blocked_Control.Search.SearchTree.children_1_[|]_1'(_6836032,_6829440,_6833950,_6836050,_6833962).

'blocked_blocked_Control.Search.SearchTree.children_1_[|]_1'(_6836606,_6836608,_6836610,_6836612,_6836614):-freeze(_6836612,'blocked_blocked_blocked_Control.Search.SearchTree.children_1_[|]_1'(_6836606,_6836608,_6836610,_6836612,_6836614)).
'blocked_blocked_blocked_Control.Search.SearchTree.children_1_[|]_1'('Control.Search.SearchTree.Fail'(_6829568),_6829440,_6837220,_6837226,_6837232):-hnf('Control.Search.SearchTree.children'(_6829440),_6837220,_6837226,_6837232).
'blocked_blocked_blocked_Control.Search.SearchTree.children_1_[|]_1'('Control.Search.SearchTree.Value'(_6829762),_6829440,_6838728,_6838734,_6838740):-hnf('Control.Search.SearchTree.children'(_6829440),_6838728,_6838734,_6838740).
'blocked_blocked_blocked_Control.Search.SearchTree.children_1_[|]_1'('Control.Search.SearchTree.Or'(_6829956,_6829974),_6829440,[_6829956,_6829974|'Control.Search.SearchTree.children'(_6829440)],_6840214,_6840214):-!.
'blocked_blocked_blocked_Control.Search.SearchTree.children_1_[|]_1'('FAIL'(_6841680),_6829440,'FAIL'(_6841680),_6841694,_6841694):-nonvar(_6841680).
'blocked_blocked_Control.Search.SearchTree.children_1'('FAIL'(_6841758),'FAIL'(_6841758),_6841772,_6841772):-nonvar(_6841758).

'Control.Search.SearchTree.values'(_6843172,_6843174,_6843176,_6843178):-freeze(_6843176,'blocked_Control.Search.SearchTree.values'(_6843172,_6843174,_6843176,_6843178)).
'blocked_Control.Search.SearchTree.values'(_6843258,_6844980,_6844986,_6844992):-hnf(_6843258,_6846510,_6844986,_6846522),'blocked_Control.Search.SearchTree.values_1'(_6846510,_6844980,_6846522,_6844992).

'blocked_Control.Search.SearchTree.values_1'(_6846956,_6846958,_6846960,_6846962):-freeze(_6846960,'blocked_blocked_Control.Search.SearchTree.values_1'(_6846956,_6846958,_6846960,_6846962)).
'blocked_blocked_Control.Search.SearchTree.values_1'([],_6847198,_6847204,_6847210):-hnf('Control.Search.SearchTree.emptyVS',_6847198,_6847204,_6847210).
'blocked_blocked_Control.Search.SearchTree.values_1'([_6843474|_6843492],_6848354,_6848360,_6848366):-!,hnf(_6843474,_6850364,_6848360,_6850382),'blocked_blocked_Control.Search.SearchTree.values_1_[|]_1'(_6850364,_6843492,_6848354,_6850382,_6848366).

'blocked_blocked_Control.Search.SearchTree.values_1_[|]_1'(_6850926,_6850928,_6850930,_6850932,_6850934):-freeze(_6850932,'blocked_blocked_blocked_Control.Search.SearchTree.values_1_[|]_1'(_6850926,_6850928,_6850930,_6850932,_6850934)).
'blocked_blocked_blocked_Control.Search.SearchTree.values_1_[|]_1'('Control.Search.SearchTree.Fail'(_6843620),_6843492,_6851540,_6851546,_6851552):-hnf('Control.Search.SearchTree.\'7C\'2B\'2B\'7C'('Control.Search.SearchTree.failVS'(_6843620),'Control.Search.SearchTree.values'(_6843492)),_6851540,_6851546,_6851552).
'blocked_blocked_blocked_Control.Search.SearchTree.values_1_[|]_1'('Control.Search.SearchTree.Value'(_6844052),_6843492,_6853768,_6853774,_6853780):-hnf('Prelude.apply'('Prelude.apply'('Control.Search.SearchTree.addVS',_6844052),'Control.Search.SearchTree.values'(_6843492)),_6853768,_6853774,_6853780).
'blocked_blocked_blocked_Control.Search.SearchTree.values_1_[|]_1'('Control.Search.SearchTree.Or'(_6844568,_6844586),_6843492,_6855998,_6856004,_6856010):-!,hnf('Control.Search.SearchTree.values'(_6843492),_6855998,_6856004,_6856010).
'blocked_blocked_blocked_Control.Search.SearchTree.values_1_[|]_1'('FAIL'(_6857030),_6843492,'FAIL'(_6857030),_6857044,_6857044):-nonvar(_6857030).
'blocked_blocked_Control.Search.SearchTree.values_1'('FAIL'(_6857108),'FAIL'(_6857108),_6857122,_6857122):-nonvar(_6857108).

'Control.Search.SearchTree.idsStrategy'(_6858712,_6858714,_6858716,_6858718):-freeze(_6858716,'blocked_Control.Search.SearchTree.idsStrategy'(_6858712,_6858714,_6858716,_6858718)).
'blocked_Control.Search.SearchTree.idsStrategy'(_6858798,_6859066,_6859072,_6859078):-hnf('Control.Search.SearchTree.idsStrategyWith'('Control.Search.SearchTree.defIDSDepth','Control.Search.SearchTree.defIDSInc',_6858798),_6859066,_6859072,_6859078).

'Control.Search.SearchTree.defIDSDepth'(_6862062,_6862064,_6862066):-freeze(_6862064,'blocked_Control.Search.SearchTree.defIDSDepth'(_6862062,_6862064,_6862066)).
'blocked_Control.Search.SearchTree.defIDSDepth'(100,_6862142,_6862142).

'Control.Search.SearchTree.defIDSInc'(_6863948,_6863950,_6863952):-freeze(_6863950,'blocked_Control.Search.SearchTree.defIDSInc'(_6863948,_6863950,_6863952)).
'blocked_Control.Search.SearchTree.defIDSInc'(_6864106,_6864112,_6864118):-hnf(partcall(1,'Prelude._impl\'23\'2A\'23Prelude.Num\'23Prelude.Int\'23',[2]),_6864106,_6864112,_6864118).

'Control.Search.SearchTree.idsStrategyWith'(_6866572,_6866574,_6866576,_6866578,_6866580,_6866582):-freeze(_6866580,'blocked_Control.Search.SearchTree.idsStrategyWith'(_6866572,_6866574,_6866576,_6866578,_6866580,_6866582)).
'blocked_Control.Search.SearchTree.idsStrategyWith'(_6866678,_6866696,_6866714,_6867248,_6867254,_6867260):-makeShare(_6866714,_6867456),makeShare(_6866678,_6867476),hnf('Control.Search.SearchTree.idsStrategyWith.iterIDS.109'(_6867456,_6866696,_6867476,'Control.Search.SearchTree.collectInBounds'(0,_6867476,_6867456)),_6867248,_6867254,_6867260).

'Control.Search.SearchTree.idsStrategyWith.iterIDS.109'(_6871788,_6871790,_6871792,_6871794,_6871796,_6871798,_6871800):-freeze(_6871798,'blocked_Control.Search.SearchTree.idsStrategyWith.iterIDS.109'(_6871788,_6871790,_6871792,_6871794,_6871796,_6871798,_6871800)).
'blocked_Control.Search.SearchTree.idsStrategyWith.iterIDS.109'(_6871904,_6871922,_6871940,_6871958,_6875028,_6875034,_6875040):-hnf(_6871958,_6877338,_6875034,_6877368),'blocked_Control.Search.SearchTree.idsStrategyWith.iterIDS.109_4'(_6877338,_6871904,_6871922,_6871940,_6875028,_6877368,_6875040).

'blocked_Control.Search.SearchTree.idsStrategyWith.iterIDS.109_4'(_6877952,_6877954,_6877956,_6877958,_6877960,_6877962,_6877964):-freeze(_6877962,'blocked_blocked_Control.Search.SearchTree.idsStrategyWith.iterIDS.109_4'(_6877952,_6877954,_6877956,_6877958,_6877960,_6877962,_6877964)).
'blocked_blocked_Control.Search.SearchTree.idsStrategyWith.iterIDS.109_4'('Control.Search.SearchTree.Nil',_6871904,_6871922,_6871940,_6878564,_6878570,_6878576):-hnf('Control.Search.SearchTree.emptyVS',_6878564,_6878570,_6878576).
'blocked_blocked_Control.Search.SearchTree.idsStrategyWith.iterIDS.109_4'('Control.Search.SearchTree.Cons'(_6872174,_6872192),_6871904,_6871922,_6871940,_6880080,_6880086,_6880092):-hnf('Prelude.apply'('Prelude.apply'('Control.Search.SearchTree.addVS',_6872174),'Control.Search.SearchTree.idsStrategyWith.iterIDS.109'(_6871904,_6871922,_6871940,_6872192)),_6880080,_6880086,_6880092).
'blocked_blocked_Control.Search.SearchTree.idsStrategyWith.iterIDS.109_4'('Control.Search.SearchTree.FCons'(_6872924,_6872942),_6871904,_6871922,_6871940,_6883112,_6883118,_6883124):-hnf('Control.Search.SearchTree.\'7C\'2B\'2B\'7C'('Control.Search.SearchTree.failVS'(_6872924),'Control.Search.SearchTree.idsStrategyWith.iterIDS.109'(_6871904,_6871922,_6871940,_6872942)),_6883112,_6883118,_6883124).
'blocked_blocked_Control.Search.SearchTree.idsStrategyWith.iterIDS.109_4'('Control.Search.SearchTree.Abort',_6871904,_6871922,_6871940,_6886096,_6886102,_6886108):-!,makeShare(_6873600,_6886456),makeShare(_6871922,_6886476),makeShare(_6871940,_6886496),makeShare(_6871904,_6886516),hnf('Prelude.cond'(letrec4PAKCS(_6886456,'Prelude.apply'(_6886476,_6886496)),'Control.Search.SearchTree.idsStrategyWith.iterIDS.109'(_6886516,_6886476,_6886456,'Control.Search.SearchTree.collectInBounds'(_6886496,_6886456,_6886516))),_6886096,_6886102,_6886108).
'blocked_blocked_Control.Search.SearchTree.idsStrategyWith.iterIDS.109_4'('FAIL'(_6890152),_6871904,_6871922,_6871940,'FAIL'(_6890152),_6890166,_6890166):-nonvar(_6890152).

'Control.Search.SearchTree.collectInBounds'(_6891932,_6891934,_6891936,_6891938,_6891940,_6891942):-freeze(_6891940,'blocked_Control.Search.SearchTree.collectInBounds'(_6891932,_6891934,_6891936,_6891938,_6891940,_6891942)).
'blocked_Control.Search.SearchTree.collectInBounds'(_6892038,_6892056,_6892074,_6892384,_6892390,_6892396):-makeShare(_6892056,_6892550),hnf('Control.Search.SearchTree.collectInBounds.collectLevel.122'(_6892550,_6892038,_6892550,_6892074),_6892384,_6892390,_6892396).

'Control.Search.SearchTree.collectInBounds.collectLevel.122'(_6896354,_6896356,_6896358,_6896360,_6896362,_6896364,_6896366):-freeze(_6896364,'blocked_Control.Search.SearchTree.collectInBounds.collectLevel.122'(_6896354,_6896356,_6896358,_6896360,_6896362,_6896364,_6896366)).
'blocked_Control.Search.SearchTree.collectInBounds.collectLevel.122'(_6896470,_6896488,_6896506,_6896524,_6900634,_6900640,_6900646):-hnf(_6896524,_6903124,_6900640,_6903154),'blocked_Control.Search.SearchTree.collectInBounds.collectLevel.122_4'(_6903124,_6896470,_6896488,_6896506,_6900634,_6903154,_6900646).

'blocked_Control.Search.SearchTree.collectInBounds.collectLevel.122_4'(_6903768,_6903770,_6903772,_6903774,_6903776,_6903778,_6903780):-freeze(_6903778,'blocked_blocked_Control.Search.SearchTree.collectInBounds.collectLevel.122_4'(_6903768,_6903770,_6903772,_6903774,_6903776,_6903778,_6903780)).
'blocked_blocked_Control.Search.SearchTree.collectInBounds.collectLevel.122_4'('Control.Search.SearchTree.Fail'(_6896640),_6896470,_6896488,_6896506,_6906878,_6906884,_6906890):-hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3C\'23Prelude.Ord\'23Prelude.Int\'23',_6896506),'Prelude._impl\'23\'2D\'23Prelude.Num\'23Prelude.Int\'23'(_6896470,_6896488)),_6910772,_6906884,_6910726),'blocked_blocked_Control.Search.SearchTree.collectInBounds.collectLevel.122_4_Control.Search.SearchTree.Fail_ComplexCase'(_6910772,_6896640,_6896470,_6896488,_6896506,_6906878,_6910726,_6906890).

'blocked_blocked_Control.Search.SearchTree.collectInBounds.collectLevel.122_4_Control.Search.SearchTree.Fail_ComplexCase'(_6911660,_6911662,_6911664,_6911666,_6911668,_6911670,_6911672,_6911674):-freeze(_6911672,freeze(_6911660,'blocked_blocked_blocked_Control.Search.SearchTree.collectInBounds.collectLevel.122_4_Control.Search.SearchTree.Fail_ComplexCase'(_6911660,_6911662,_6911664,_6911666,_6911668,_6911670,_6911672,_6911674))).
'blocked_blocked_blocked_Control.Search.SearchTree.collectInBounds.collectLevel.122_4_Control.Search.SearchTree.Fail_ComplexCase'('Prelude.True',_6896640,_6896470,_6896488,_6896506,'Control.Search.SearchTree.FCons'(_6896640,'Control.Search.SearchTree.Nil'),_6912090,_6912090).
'blocked_blocked_blocked_Control.Search.SearchTree.collectInBounds.collectLevel.122_4_Control.Search.SearchTree.Fail_ComplexCase'('Prelude.False',_6896640,_6896470,_6896488,_6896506,'Control.Search.SearchTree.Nil',_6914140,_6914140):-!.
'blocked_blocked_blocked_Control.Search.SearchTree.collectInBounds.collectLevel.122_4_Control.Search.SearchTree.Fail_ComplexCase'('FAIL'(_6915498),_6896640,_6896470,_6896488,_6896506,'FAIL'(_6915498),_6915512,_6915512).
'blocked_blocked_Control.Search.SearchTree.collectInBounds.collectLevel.122_4'('Control.Search.SearchTree.Value'(_6897598),_6896470,_6896488,_6896506,_6918608,_6918614,_6918620):-hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3C\'23Prelude.Ord\'23Prelude.Int\'23',_6896506),'Prelude._impl\'23\'2D\'23Prelude.Num\'23Prelude.Int\'23'(_6896470,_6896488)),_6922532,_6918614,_6922486),'blocked_blocked_Control.Search.SearchTree.collectInBounds.collectLevel.122_4_Control.Search.SearchTree.Value_ComplexCase'(_6922532,_6897598,_6896470,_6896488,_6896506,_6918608,_6922486,_6918620).

'blocked_blocked_Control.Search.SearchTree.collectInBounds.collectLevel.122_4_Control.Search.SearchTree.Value_ComplexCase'(_6923426,_6923428,_6923430,_6923432,_6923434,_6923436,_6923438,_6923440):-freeze(_6923438,freeze(_6923426,'blocked_blocked_blocked_Control.Search.SearchTree.collectInBounds.collectLevel.122_4_Control.Search.SearchTree.Value_ComplexCase'(_6923426,_6923428,_6923430,_6923432,_6923434,_6923436,_6923438,_6923440))).
'blocked_blocked_blocked_Control.Search.SearchTree.collectInBounds.collectLevel.122_4_Control.Search.SearchTree.Value_ComplexCase'('Prelude.True',_6897598,_6896470,_6896488,_6896506,'Control.Search.SearchTree.Cons'(_6897598,'Control.Search.SearchTree.Nil'),_6923856,_6923856).
'blocked_blocked_blocked_Control.Search.SearchTree.collectInBounds.collectLevel.122_4_Control.Search.SearchTree.Value_ComplexCase'('Prelude.False',_6897598,_6896470,_6896488,_6896506,'Control.Search.SearchTree.Nil',_6925906,_6925906):-!.
'blocked_blocked_blocked_Control.Search.SearchTree.collectInBounds.collectLevel.122_4_Control.Search.SearchTree.Value_ComplexCase'('FAIL'(_6927270),_6897598,_6896470,_6896488,_6896506,'FAIL'(_6927270),_6927284,_6927284).
'blocked_blocked_Control.Search.SearchTree.collectInBounds.collectLevel.122_4'('Control.Search.SearchTree.Or'(_6898556,_6898574),_6896470,_6896488,_6896506,_6930438,_6930444,_6930450):-!,makeShare(_6896506,_6928210),hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'23Prelude.Ord\'23Prelude.Int\'23',_6928210),0),_6934278,_6930444,_6934226),'blocked_blocked_Control.Search.SearchTree.collectInBounds.collectLevel.122_4_Control.Search.SearchTree.Or_ComplexCase'(_6934278,_6898556,_6898574,_6896470,_6896488,_6928210,_6930438,_6934226,_6930450).

'blocked_blocked_Control.Search.SearchTree.collectInBounds.collectLevel.122_4_Control.Search.SearchTree.Or_ComplexCase'(_6935186,_6935188,_6935190,_6935192,_6935194,_6935196,_6935198,_6935200,_6935202):-freeze(_6935200,freeze(_6935186,'blocked_blocked_blocked_Control.Search.SearchTree.collectInBounds.collectLevel.122_4_Control.Search.SearchTree.Or_ComplexCase'(_6935186,_6935188,_6935190,_6935192,_6935194,_6935196,_6935198,_6935200,_6935202))).
'blocked_blocked_blocked_Control.Search.SearchTree.collectInBounds.collectLevel.122_4_Control.Search.SearchTree.Or_ComplexCase'('Prelude.True',_6898556,_6898574,_6896470,_6896488,_6928210,_6935620,_6935626,_6935632):-makeShare(_6896470,_6935998),makeShare(_6896488,_6936018),makeShare(_6928210,_6936038),hnf('Control.Search.SearchTree.concA'('Control.Search.SearchTree.collectInBounds.collectLevel.122'(_6935998,_6936018,'Prelude._impl\'23\'2D\'23Prelude.Num\'23Prelude.Int\'23'(_6936038,1),_6898556),'Control.Search.SearchTree.collectInBounds.collectLevel.122'(_6935998,_6936018,'Prelude._impl\'23\'2D\'23Prelude.Num\'23Prelude.Int\'23'(_6936038,1),_6898574)),_6935620,_6935626,_6935632).
'blocked_blocked_blocked_Control.Search.SearchTree.collectInBounds.collectLevel.122_4_Control.Search.SearchTree.Or_ComplexCase'('Prelude.False',_6898556,_6898574,_6896470,_6896488,_6928210,'Control.Search.SearchTree.Abort',_6940892,_6940892):-!.
'blocked_blocked_blocked_Control.Search.SearchTree.collectInBounds.collectLevel.122_4_Control.Search.SearchTree.Or_ComplexCase'('FAIL'(_6942324),_6898556,_6898574,_6896470,_6896488,_6928210,'FAIL'(_6942324),_6942338,_6942338).
'blocked_blocked_Control.Search.SearchTree.collectInBounds.collectLevel.122_4'('FAIL'(_6942430),_6896470,_6896488,_6896506,'FAIL'(_6942430),_6942444,_6942444):-nonvar(_6942430).

'Control.Search.SearchTree.concA'(_6943830,_6943832,_6943834,_6943836,_6943838):-freeze(_6943836,'blocked_Control.Search.SearchTree.concA'(_6943830,_6943832,_6943834,_6943836,_6943838)).
'blocked_Control.Search.SearchTree.concA'(_6943926,_6943944,_6946428,_6946434,_6946440):-hnf(_6943926,_6947930,_6946434,_6947948),'blocked_Control.Search.SearchTree.concA_1'(_6947930,_6943944,_6946428,_6947948,_6946440).

'blocked_Control.Search.SearchTree.concA_1'(_6948384,_6948386,_6948388,_6948390,_6948392):-freeze(_6948390,'blocked_blocked_Control.Search.SearchTree.concA_1'(_6948384,_6948386,_6948388,_6948390,_6948392)).
'blocked_blocked_Control.Search.SearchTree.concA_1'('Control.Search.SearchTree.Abort',_6943944,_6949324,_6949330,_6949336):-hnf(_6943944,_6952146,_6949330,_6952158),'blocked_blocked_Control.Search.SearchTree.concA_1_Control.Search.SearchTree.Abort_1'(_6952146,_6949324,_6952158,_6949336).

'blocked_blocked_Control.Search.SearchTree.concA_1_Control.Search.SearchTree.Abort_1'(_6952838,_6952840,_6952842,_6952844):-freeze(_6952842,'blocked_blocked_blocked_Control.Search.SearchTree.concA_1_Control.Search.SearchTree.Abort_1'(_6952838,_6952840,_6952842,_6952844)).
'blocked_blocked_blocked_Control.Search.SearchTree.concA_1_Control.Search.SearchTree.Abort_1'('Control.Search.SearchTree.Abort','Control.Search.SearchTree.Abort',_6953450,_6953450).
'blocked_blocked_blocked_Control.Search.SearchTree.concA_1_Control.Search.SearchTree.Abort_1'('Control.Search.SearchTree.Nil','Control.Search.SearchTree.Abort',_6954804,_6954804).
'blocked_blocked_blocked_Control.Search.SearchTree.concA_1_Control.Search.SearchTree.Abort_1'('Control.Search.SearchTree.Cons'(_6944358,_6944376),'Control.Search.SearchTree.Cons'(_6944358,'Control.Search.SearchTree.concA'('Control.Search.SearchTree.Abort',_6944376)),_6956188,_6956188).
'blocked_blocked_blocked_Control.Search.SearchTree.concA_1_Control.Search.SearchTree.Abort_1'('Control.Search.SearchTree.FCons'(_6944814,_6944832),'Control.Search.SearchTree.FCons'(_6944814,'Control.Search.SearchTree.concA'('Control.Search.SearchTree.Abort',_6944832)),_6958498,_6958498):-!.
'blocked_blocked_blocked_Control.Search.SearchTree.concA_1_Control.Search.SearchTree.Abort_1'('FAIL'(_6960276),'FAIL'(_6960276),_6960290,_6960290):-nonvar(_6960276).
'blocked_blocked_Control.Search.SearchTree.concA_1'('Control.Search.SearchTree.Nil',_6943944,_6960848,_6960854,_6960860):-hnf(_6943944,_6960848,_6960854,_6960860).
'blocked_blocked_Control.Search.SearchTree.concA_1'('Control.Search.SearchTree.Cons'(_6945362,_6945380),_6943944,'Control.Search.SearchTree.Cons'(_6945362,'Control.Search.SearchTree.concA'(_6945380,_6943944)),_6961876,_6961876).
'blocked_blocked_Control.Search.SearchTree.concA_1'('Control.Search.SearchTree.FCons'(_6945804,_6945822),_6943944,'Control.Search.SearchTree.FCons'(_6945804,'Control.Search.SearchTree.concA'(_6945822,_6943944)),_6963830,_6963830):-!.
'blocked_blocked_Control.Search.SearchTree.concA_1'('FAIL'(_6965252),_6943944,'FAIL'(_6965252),_6965266,_6965266):-nonvar(_6965252).

'Control.Search.SearchTree.diagStrategy'(_6966902,_6966904,_6966906,_6966908):-freeze(_6966906,'blocked_Control.Search.SearchTree.diagStrategy'(_6966902,_6966904,_6966906,_6966908)).
'blocked_Control.Search.SearchTree.diagStrategy'(_6966988,_6967508,_6967514,_6967520):-hnf('Control.Search.SearchTree.values'('Prelude.apply'('Data.List.diagonal','Control.Search.SearchTree.levels'([_6966988]))),_6967508,_6967514,_6967520).

'Control.Search.SearchTree.levels'(_6970538,_6970540,_6970542,_6970544):-freeze(_6970542,'blocked_Control.Search.SearchTree.levels'(_6970538,_6970540,_6970542,_6970544)).
'blocked_Control.Search.SearchTree.levels'(_6970624,_6973292,_6973298,_6973304):-makeShare(_6970624,_6972070),hnf('Prelude.null'(_6972070),_6974918,_6973298,_6974890),'blocked_Control.Search.SearchTree.levels_ComplexCase'(_6974918,_6972070,_6973292,_6974890,_6973304).

'blocked_Control.Search.SearchTree.levels_ComplexCase'(_6975410,_6975412,_6975414,_6975416,_6975418):-freeze(_6975416,freeze(_6975410,'blocked_blocked_Control.Search.SearchTree.levels_ComplexCase'(_6975410,_6975412,_6975414,_6975416,_6975418))).
'blocked_blocked_Control.Search.SearchTree.levels_ComplexCase'('Prelude.True',_6972070,[],_6975810,_6975810).
'blocked_blocked_Control.Search.SearchTree.levels_ComplexCase'('Prelude.False',_6972070,_6977624,_6977630,_6977636):-!,hnf('Prelude.otherwise',_6980398,_6977630,_6980370),'blocked_blocked_Control.Search.SearchTree.levels_ComplexCase_Prelude.False_ComplexCase'(_6980398,_6972070,_6977624,_6980370,_6977636).

'blocked_blocked_Control.Search.SearchTree.levels_ComplexCase_Prelude.False_ComplexCase'(_6981100,_6981102,_6981104,_6981106,_6981108):-freeze(_6981106,freeze(_6981100,'blocked_blocked_blocked_Control.Search.SearchTree.levels_ComplexCase_Prelude.False_ComplexCase'(_6981100,_6981102,_6981104,_6981106,_6981108))).
'blocked_blocked_blocked_Control.Search.SearchTree.levels_ComplexCase_Prelude.False_ComplexCase'('Prelude.True',_6972070,[_6981596|'Control.Search.SearchTree.levels'('Prelude.foldr'(partcall(2,'Control.Search.SearchTree.levels._\'23lambda4',[]),[],_6981596))],_6981500,_6981506):-makeShare(_6972070,_6981596),_6981500=_6981506.
'blocked_blocked_blocked_Control.Search.SearchTree.levels_ComplexCase_Prelude.False_ComplexCase'('Prelude.False',_6972070,_6983970,_6983976,_6983982):-!,hnf(reportFailure4PAKCS('Control.Search.SearchTree.levels',['Prelude.False']),_6983970,_6983976,_6983982).
'blocked_blocked_blocked_Control.Search.SearchTree.levels_ComplexCase_Prelude.False_ComplexCase'('FAIL'(_6985578),_6972070,'FAIL'(_6985578),_6985592,_6985592).
'blocked_blocked_Control.Search.SearchTree.levels_ComplexCase'('FAIL'(_6985652),_6972070,'FAIL'(_6985652),_6985666,_6985666).

'Control.Search.SearchTree.levels._\'23lambda4'(_6987478,_6987480,_6987482,_6987484,_6987486):-freeze(_6987484,'blocked_Control.Search.SearchTree.levels._\'23lambda4'(_6987478,_6987480,_6987482,_6987484,_6987486)).
'blocked_Control.Search.SearchTree.levels._\'23lambda4'(_6987574,_6987592,_6988966,_6988972,_6988978):-hnf(_6987574,_6990936,_6988972,_6990954),'blocked_Control.Search.SearchTree.levels._\'23lambda4_1'(_6990936,_6987592,_6988966,_6990954,_6988978).

'blocked_Control.Search.SearchTree.levels._\'23lambda4_1'(_6991474,_6991476,_6991478,_6991480,_6991482):-freeze(_6991480,freeze(_6991474,'blocked_blocked_Control.Search.SearchTree.levels._\'23lambda4_1'(_6991474,_6991476,_6991478,_6991480,_6991482))).
'blocked_blocked_Control.Search.SearchTree.levels._\'23lambda4_1'('Control.Search.SearchTree.Or'(_6987708,_6987726),_6987592,_6992078,_6992084,_6992090):-hnf('Prelude.++'('Prelude.map'(partcall(1,'Control.Search.SearchTree.levels._\'23lambda4._\'23lambda6',[]),[_6987708,_6987726]),_6987592),_6992078,_6992084,_6992090).
'blocked_blocked_Control.Search.SearchTree.levels._\'23lambda4_1'('Control.Search.SearchTree.Value'(_6988486),_6987592,_6994716,_6994722,_6994728):-hnf(_6987592,_6994716,_6994722,_6994728).
'blocked_blocked_Control.Search.SearchTree.levels._\'23lambda4_1'('Control.Search.SearchTree.Fail'(_6988596),_6987592,_6995874,_6995880,_6995886):-!,hnf(_6987592,_6995874,_6995880,_6995886).
'blocked_blocked_Control.Search.SearchTree.levels._\'23lambda4_1'('FAIL'(_6996526),_6987592,'FAIL'(_6996526),_6996540,_6996540).

'Control.Search.SearchTree.levels._\'23lambda4._\'23lambda6'(_6998760,_6998762,_6998764,_6998766):-freeze(_6998764,'blocked_Control.Search.SearchTree.levels._\'23lambda4._\'23lambda6'(_6998760,_6998762,_6998764,_6998766)).
'blocked_Control.Search.SearchTree.levels._\'23lambda4._\'23lambda6'(_6998846,_6998862,_6998868,_6998874):-hnf(_6998846,_6998862,_6998868,_6998874).

'Control.Search.SearchTree.allValuesWith'(_7001044,_7001046,_7001048,_7001050,_7001052):-freeze(_7001050,'blocked_Control.Search.SearchTree.allValuesWith'(_7001044,_7001046,_7001048,_7001050,_7001052)).
'blocked_Control.Search.SearchTree.allValuesWith'(_7001140,_7001158,_7001412,_7001418,_7001424):-hnf('Control.Search.SearchTree.vsToList'('Prelude.apply'(_7001140,_7001158)),_7001412,_7001418,_7001424).

'Control.Search.SearchTree.allValuesDFS'(_7004134,_7004136,_7004138):-freeze(_7004136,'blocked_Control.Search.SearchTree.allValuesDFS'(_7004134,_7004136,_7004138)).
'blocked_Control.Search.SearchTree.allValuesDFS'(_7004306,_7004312,_7004318):-hnf(partcall(1,'Control.Search.SearchTree.allValuesWith',[partcall(1,'Control.Search.SearchTree.dfsStrategy',[])]),_7004306,_7004312,_7004318).

'Control.Search.SearchTree.allValuesBFS'(_7006860,_7006862,_7006864):-freeze(_7006862,'blocked_Control.Search.SearchTree.allValuesBFS'(_7006860,_7006862,_7006864)).
'blocked_Control.Search.SearchTree.allValuesBFS'(_7007032,_7007038,_7007044):-hnf(partcall(1,'Control.Search.SearchTree.allValuesWith',[partcall(1,'Control.Search.SearchTree.bfsStrategy',[])]),_7007032,_7007038,_7007044).

'Control.Search.SearchTree.allValuesIDS'(_7009586,_7009588,_7009590):-freeze(_7009588,'blocked_Control.Search.SearchTree.allValuesIDS'(_7009586,_7009588,_7009590)).
'blocked_Control.Search.SearchTree.allValuesIDS'(_7009842,_7009848,_7009854):-hnf('Control.Search.SearchTree.allValuesIDSwith'('Control.Search.SearchTree.defIDSDepth','Control.Search.SearchTree.defIDSInc'),_7009842,_7009848,_7009854).

'Control.Search.SearchTree.allValuesIDSwith'(_7012874,_7012876,_7012878,_7012880,_7012882):-freeze(_7012880,'blocked_Control.Search.SearchTree.allValuesIDSwith'(_7012874,_7012876,_7012878,_7012880,_7012882)).
'blocked_Control.Search.SearchTree.allValuesIDSwith'(_7012970,_7012988,_7013242,_7013248,_7013254):-hnf(partcall(1,'Control.Search.SearchTree.allValuesWith',[partcall(1,'Control.Search.SearchTree.idsStrategyWith',[_7012988,_7012970])]),_7013242,_7013248,_7013254).

'Control.Search.SearchTree.allValuesDiag'(_7016234,_7016236,_7016238):-freeze(_7016236,'blocked_Control.Search.SearchTree.allValuesDiag'(_7016234,_7016236,_7016238)).
'blocked_Control.Search.SearchTree.allValuesDiag'(_7016406,_7016412,_7016418):-hnf(partcall(1,'Control.Search.SearchTree.allValuesWith',[partcall(1,'Control.Search.SearchTree.diagStrategy',[])]),_7016406,_7016412,_7016418).

'Control.Search.SearchTree.getAllValuesWith'(_7019124,_7019126,_7019128,_7019130,_7019132):-freeze(_7019130,'blocked_Control.Search.SearchTree.getAllValuesWith'(_7019124,_7019126,_7019128,_7019130,_7019132)).
'blocked_Control.Search.SearchTree.getAllValuesWith'(_7019220,_7019238,_7019744,_7019750,_7019756):-hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','Control.Search.SearchTree.getSearchTree'(_7019238)),partcall(1,'Control.Search.SearchTree.getAllValuesWith._\'23lambda8',[_7019220])),_7019744,_7019750,_7019756).

'Control.Search.SearchTree.getAllValuesWith._\'23lambda8'(_7024156,_7024158,_7024160,_7024162,_7024164):-freeze(_7024162,'blocked_Control.Search.SearchTree.getAllValuesWith._\'23lambda8'(_7024156,_7024158,_7024160,_7024162,_7024164)).
'blocked_Control.Search.SearchTree.getAllValuesWith._\'23lambda8'(_7024252,_7024270,_7025034,_7025040,_7025046):-makeShare(_7024298,_7025202),hnf('Prelude.cond'(letrec4PAKCS(_7025202,_7024270),'Prelude.apply'('Prelude._impl\'23return\'23Prelude.Monad\'23Prelude.IO\'23','Control.Search.SearchTree.vsToList'('Prelude.apply'(_7024252,_7025202)))),_7025034,_7025040,_7025046).

'Control.Search.SearchTree.printAllValuesWith'(_7029602,_7029604,_7029606,_7029608,_7029610,_7029612):-freeze(_7029610,'blocked_Control.Search.SearchTree.printAllValuesWith'(_7029602,_7029604,_7029606,_7029608,_7029610,_7029612)).
'blocked_Control.Search.SearchTree.printAllValuesWith'(_7029708,_7029726,_7029744,_7030488,_7030494,_7030500):-hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','Control.Search.SearchTree.getAllValuesWith'(_7029726,_7029744)),'Prelude.mapM_'(partcall(1,'Prelude._inst\'23Prelude.Monad\'23Prelude.IO\'23',[]),'Prelude.print'(_7029708))),_7030488,_7030494,_7030500).

'Control.Search.SearchTree.printValuesWith'(_7034996,_7034998,_7035000,_7035002,_7035004,_7035006):-freeze(_7035004,'blocked_Control.Search.SearchTree.printValuesWith'(_7034996,_7034998,_7035000,_7035002,_7035004,_7035006)).
'blocked_Control.Search.SearchTree.printValuesWith'(_7035102,_7035120,_7035138,_7035714,_7035720,_7035726):-hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','Control.Search.SearchTree.getAllValuesWith'(_7035120,_7035138)),partcall(1,'Control.Search.SearchTree.printValuesWith.printValues.167',[_7035102])),_7035714,_7035720,_7035726).

'Control.Search.SearchTree.printValuesWith.printValues.167'(_7040508,_7040510,_7040512,_7040514,_7040516):-freeze(_7040514,'blocked_Control.Search.SearchTree.printValuesWith.printValues.167'(_7040508,_7040510,_7040512,_7040514,_7040516)).
'blocked_Control.Search.SearchTree.printValuesWith.printValues.167'(_7040604,_7040622,_7043040,_7043046,_7043052):-hnf(_7040622,_7045478,_7043046,_7045496),'blocked_Control.Search.SearchTree.printValuesWith.printValues.167_2'(_7045478,_7040604,_7043040,_7045496,_7043052).

'blocked_Control.Search.SearchTree.printValuesWith.printValues.167_2'(_7046088,_7046090,_7046092,_7046094,_7046096):-freeze(_7046094,'blocked_blocked_Control.Search.SearchTree.printValuesWith.printValues.167_2'(_7046088,_7046090,_7046092,_7046094,_7046096)).
'blocked_blocked_Control.Search.SearchTree.printValuesWith.printValues.167_2'([],_7040604,_7046340,_7046346,_7046352):-hnf('Prelude.apply'('Prelude._impl\'23return\'23Prelude.Monad\'23Prelude.IO\'23','Prelude.()'),_7046340,_7046346,_7046352).
'blocked_blocked_Control.Search.SearchTree.printValuesWith.printValues.167_2'([_7041006|_7041024],_7040604,_7047868,_7047874,_7047880):-!,makeShare(_7040604,_7048056),hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'23Prelude.Monad\'23Prelude.IO\'23','Prelude.putStr'('Prelude.apply'('Prelude.show'(_7048056),_7041006))),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'23Prelude.Monad\'23Prelude.IO\'23','System.IO.hFlush'('System.IO.stdout')),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','Prelude.getLine'),partcall(1,'Control.Search.SearchTree.printValuesWith.printValues.167._\'23lambda11',[_7048056,_7041024])))),_7047868,_7047874,_7047880).
'blocked_blocked_Control.Search.SearchTree.printValuesWith.printValues.167_2'('FAIL'(_7053380),_7040604,'FAIL'(_7053380),_7053394,_7053394):-nonvar(_7053380).

'Control.Search.SearchTree.printValuesWith.printValues.167._\'23lambda11'(_7056198,_7056200,_7056202,_7056204,_7056206,_7056208):-freeze(_7056206,'blocked_Control.Search.SearchTree.printValuesWith.printValues.167._\'23lambda11'(_7056198,_7056200,_7056202,_7056204,_7056206,_7056208)).
'blocked_Control.Search.SearchTree.printValuesWith.printValues.167._\'23lambda11'(_7056304,_7056322,_7056340,_7056510,_7056516,_7056522):-hnf('Control.Search.SearchTree.printValuesWith.printValues.167'(_7056322,_7056304),_7056510,_7056516,_7056522).

'Control.Search.SearchTree.someValue'(_7059328,_7059330,_7059332):-freeze(_7059330,'blocked_Control.Search.SearchTree.someValue'(_7059328,_7059330,_7059332)).
'blocked_Control.Search.SearchTree.someValue'(_7059500,_7059506,_7059512):-hnf(partcall(1,'Control.Search.SearchTree.someValueWith',[partcall(1,'Control.Search.SearchTree.bfsStrategy',[])]),_7059500,_7059506,_7059512).

'Control.Search.SearchTree.someValueWith'(_7062074,_7062076,_7062078,_7062080,_7062082):-freeze(_7062080,'blocked_Control.Search.SearchTree.someValueWith'(_7062074,_7062076,_7062078,_7062080,_7062082)).
'blocked_Control.Search.SearchTree.someValueWith'(_7062170,_7062188,_7062694,_7062700,_7062706):-hnf('Prelude.head'('Control.Search.SearchTree.vsToList'('Prelude.apply'(_7062170,'Prelude.apply'('Control.Search.SearchTree.someSearchTree',_7062188)))),_7062694,_7062700,_7062706).

'Control.Search.SearchTree.emptyVS'(_7065944,_7065946,_7065948):-freeze(_7065946,'blocked_Control.Search.SearchTree.emptyVS'(_7065944,_7065946,_7065948)).
'blocked_Control.Search.SearchTree.emptyVS'('Control.Search.SearchTree.EmptyVS',_7066038,_7066038).

'Control.Search.SearchTree.addVS'(_7067894,_7067896,_7067898):-freeze(_7067896,'blocked_Control.Search.SearchTree.addVS'(_7067894,_7067896,_7067898)).
'blocked_Control.Search.SearchTree.addVS'(_7067982,_7067988,_7067994):-hnf('Control.Search.SearchTree.ConsVS',_7067982,_7067988,_7067994).

'Control.Search.SearchTree.failVS'(_7069882,_7069884,_7069886,_7069888):-freeze(_7069886,'blocked_Control.Search.SearchTree.failVS'(_7069882,_7069884,_7069886,_7069888)).
'blocked_Control.Search.SearchTree.failVS'(_7069968,'Control.Search.SearchTree.EmptyVS',_7070004,_7070004).

'Control.Search.SearchTree.\'7C\'2B\'2B\'7C'(_7072030,_7072032,_7072034,_7072036,_7072038):-freeze(_7072036,'blocked_Control.Search.SearchTree.\'7C\'2B\'2B\'7C'(_7072030,_7072032,_7072034,_7072036,_7072038)).
'blocked_Control.Search.SearchTree.\'7C\'2B\'2B\'7C'(_7072126,_7072144,_7073012,_7073018,_7073024):-hnf(_7072126,_7074766,_7073018,_7074784),'blocked_Control.Search.SearchTree.\'7C\'2B\'2B\'7C_1'(_7074766,_7072144,_7073012,_7074784,_7073024).

'blocked_Control.Search.SearchTree.\'7C\'2B\'2B\'7C_1'(_7075268,_7075270,_7075272,_7075274,_7075276):-freeze(_7075274,freeze(_7075268,'blocked_blocked_Control.Search.SearchTree.\'7C\'2B\'2B\'7C_1'(_7075268,_7075270,_7075272,_7075274,_7075276))).
'blocked_blocked_Control.Search.SearchTree.\'7C\'2B\'2B\'7C_1'('Control.Search.SearchTree.EmptyVS',_7072144,_7075914,_7075920,_7075926):-hnf(_7072144,_7075914,_7075920,_7075926).
'blocked_blocked_Control.Search.SearchTree.\'7C\'2B\'2B\'7C_1'('Control.Search.SearchTree.ConsVS'(_7072346,_7072364),_7072144,'Control.Search.SearchTree.ConsVS'(_7072346,'Control.Search.SearchTree.\'7C\'2B\'2B\'7C'(_7072364,_7072144)),_7077008,_7077008):-!.
'blocked_blocked_Control.Search.SearchTree.\'7C\'2B\'2B\'7C_1'('FAIL'(_7078520),_7072144,'FAIL'(_7078520),_7078534,_7078534).

'Control.Search.SearchTree.vsToList'(_7080014,_7080016,_7080018,_7080020):-freeze(_7080018,'blocked_Control.Search.SearchTree.vsToList'(_7080014,_7080016,_7080018,_7080020)).
'blocked_Control.Search.SearchTree.vsToList'(_7080100,_7080888,_7080894,_7080900):-hnf(_7080100,_7082490,_7080894,_7082502),'blocked_Control.Search.SearchTree.vsToList_1'(_7082490,_7080888,_7082502,_7080900).

'blocked_Control.Search.SearchTree.vsToList_1'(_7082948,_7082950,_7082952,_7082954):-freeze(_7082952,'blocked_blocked_Control.Search.SearchTree.vsToList_1'(_7082948,_7082950,_7082952,_7082954)).
'blocked_blocked_Control.Search.SearchTree.vsToList_1'('Control.Search.SearchTree.EmptyVS',[],_7083584,_7083584).
'blocked_blocked_Control.Search.SearchTree.vsToList_1'('Control.Search.SearchTree.ConsVS'(_7080316,_7080334),[_7080316|'Control.Search.SearchTree.vsToList'(_7080334)],_7084568,_7084568):-!.
'blocked_blocked_Control.Search.SearchTree.vsToList_1'('FAIL'(_7085650),'FAIL'(_7085650),_7085664,_7085664):-nonvar(_7085650).

'Control.Search.SearchTree.showSearchTree.indent.24._\'23caseor0'(_7088156,_7088158,_7088160,_7088162):-freeze(_7088160,'blocked_Control.Search.SearchTree.showSearchTree.indent.24._\'23caseor0'(_7088156,_7088158,_7088160,_7088162)).
'blocked_Control.Search.SearchTree.showSearchTree.indent.24._\'23caseor0'(_7088242,_7088898,_7088904,_7088910):-hnf(_7088242,_7091508,_7088904,_7091520),'blocked_Control.Search.SearchTree.showSearchTree.indent.24._\'23caseor0_1'(_7091508,_7088898,_7091520,_7088910).

'blocked_Control.Search.SearchTree.showSearchTree.indent.24._\'23caseor0_1'(_7092140,_7092142,_7092144,_7092146):-freeze(_7092144,freeze(_7092140,'blocked_blocked_Control.Search.SearchTree.showSearchTree.indent.24._\'23caseor0_1'(_7092140,_7092142,_7092144,_7092146))).
'blocked_blocked_Control.Search.SearchTree.showSearchTree.indent.24._\'23caseor0_1'('Prelude.True','^09492',_7092530,_7092530).
'blocked_blocked_Control.Search.SearchTree.showSearchTree.indent.24._\'23caseor0_1'('Prelude.False','^09500',_7093448,_7093448):-!.
'blocked_blocked_Control.Search.SearchTree.showSearchTree.indent.24._\'23caseor0_1'('FAIL'(_7094062),'FAIL'(_7094062),_7094076,_7094076).

'Control.Search.SearchTree.showSearchTree.indent.24.showIndent.35._\'23caseor0'(_7097096,_7097098,_7097100,_7097102):-freeze(_7097100,'blocked_Control.Search.SearchTree.showSearchTree.indent.24.showIndent.35._\'23caseor0'(_7097096,_7097098,_7097100,_7097102)).
'blocked_Control.Search.SearchTree.showSearchTree.indent.24.showIndent.35._\'23caseor0'(_7097182,_7097922,_7097928,_7097934):-hnf(_7097182,_7101036,_7097928,_7101048),'blocked_Control.Search.SearchTree.showSearchTree.indent.24.showIndent.35._\'23caseor0_1'(_7101036,_7097922,_7101048,_7097934).

'blocked_Control.Search.SearchTree.showSearchTree.indent.24.showIndent.35._\'23caseor0_1'(_7101752,_7101754,_7101756,_7101758):-freeze(_7101756,freeze(_7101752,'blocked_blocked_Control.Search.SearchTree.showSearchTree.indent.24.showIndent.35._\'23caseor0_1'(_7101752,_7101754,_7101756,_7101758))).
'blocked_blocked_Control.Search.SearchTree.showSearchTree.indent.24.showIndent.35._\'23caseor0_1'('Prelude.True','^ ',_7102142,_7102142).
'blocked_blocked_Control.Search.SearchTree.showSearchTree.indent.24.showIndent.35._\'23caseor0_1'('Prelude.False','^09474',_7103120,_7103120):-!.
'blocked_blocked_Control.Search.SearchTree.showSearchTree.indent.24.showIndent.35._\'23caseor0_1'('FAIL'(_7103818),'FAIL'(_7103818),_7103832,_7103832).

:-costCenters(['']).




%%%%% Number of shared variables: 40

