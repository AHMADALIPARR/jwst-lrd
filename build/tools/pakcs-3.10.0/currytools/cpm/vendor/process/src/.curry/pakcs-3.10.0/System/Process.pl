%PAKCS3.10 swi9 VARIABLESHARING

:-noSingletonWarnings.
:-noRedefineWarnings.
:-noDiscontiguousWarnings.

:-importModule('Prelude').
:-importModule('System.Environment').

:-curryModule('System.Process').


%%%%%%%%%%%% function types %%%%%%%%%%%%%%%%%%%
:-multifile functiontype/6.
:-dynamic functiontype/6.
functiontype('System.Process.getPID',getPID,0,'System.Process.getPID',nofix,notype).
functiontype('System.Process.system',system,1,'System.Process.system',nofix,notype).
functiontype('System.Process.prim_system','System.Process.prim_system',1,'System.Process.prim_system',nofix,notype).
functiontype('System.Process.exitWith',exitWith,1,'System.Process.exitWith',nofix,notype).
functiontype('System.Process.prim_exitWith','System.Process.prim_exitWith',1,'System.Process.prim_exitWith',nofix,notype).
functiontype('System.Process.sleep',sleep,1,'System.Process.sleep',nofix,notype).
functiontype('System.Process.prim_sleep','System.Process.prim_sleep',1,'System.Process.prim_sleep',nofix,notype).
functiontype('System.Process.system._\'23caseor0','System.Process.system._#caseor0',2,'System.Process.system._\'23caseor0',nofix,notype).

%%%%%%%%%%%% constructor types %%%%%%%%%%%%%%%%%%%
:-multifile constructortype/7.
:-dynamic constructortype/7.

%%%%%%%%%%%% function definitions %%%%%%%%%%%%%%%%%%%
'System.Process.getPID'(partcall(1,'System.Process.getPID$WORLD',[]),_66040094,_66040094).
'System.Process.getPID$WORLD'(_66040400,_66040402,_66040404,_66040406):-freeze(_66040404,'blocked_System.Process.getPID$WORLD'(_66040400,_66040402,_66040404,_66040406)).
'blocked_System.Process.getPID$WORLD'(_66040480,'$io'(_66040492),_66040496,_66040094):-'System.Process.getPID'(_66040492),_66040496=_66040094.

'System.Process.system'(_66041510,_66041512,_66041514,_66041516):-freeze(_66041514,'blocked_System.Process.system'(_66041510,_66041512,_66041514,_66041516)).
'blocked_System.Process.system'(_66041596,_66042622,_66042628,_66042634):-makeShare(_66041624,_66042812),makeShare(_66041642,_66042832),hnf('Prelude.cond'(letrec4PAKCS(_66042812,'System.Environment.isWindows'),'Prelude.cond'(letrec4PAKCS(_66042832,'System.Process.system._\'23caseor0'(_66042812,_66041596)),'Prelude.$##'(partcall(1,'System.Process.prim_system',[]),_66042832))),_66042622,_66042628,_66042634).

'System.Process.prim_system'(_66046064,partcall(1,'System.Process.prim_system$WORLD',[_66046064]),_66046448,_66046448).
'System.Process.prim_system$WORLD'(_66046792,_66046794,_66046796,_66046798,_66046800):-freeze(_66046798,'blocked_System.Process.prim_system$WORLD'(_66046792,_66046794,_66046796,_66046798,_66046800)).
'blocked_System.Process.prim_system$WORLD'(_66046882,_66046888,'$io'(_66046900),_66046904,_66046448):-derefAll(_66046882,_66046064),'System.Process.prim_system'(_66046064,_66046900),_66046904=_66046448.

'System.Process.exitWith'(_66048042,_66048044,_66048046,_66048048):-freeze(_66048046,'blocked_System.Process.exitWith'(_66048042,_66048044,_66048046,_66048048)).
'blocked_System.Process.exitWith'(_66048128,_66048312,_66048318,_66048324):-hnf('Prelude.$#'(partcall(1,'System.Process.prim_exitWith',[]),_66048128),_66048312,_66048318,_66048324).

'System.Process.prim_exitWith'(_66049404,partcall(1,'System.Process.prim_exitWith$WORLD',[_66049404]),_66049812,_66049812).
'System.Process.prim_exitWith$WORLD'(_66050168,_66050170,_66050172,_66050174,_66050176):-freeze(_66050174,'blocked_System.Process.prim_exitWith$WORLD'(_66050168,_66050170,_66050172,_66050174,_66050176)).
'blocked_System.Process.prim_exitWith$WORLD'(_66050258,_66050264,'$io'(_66050276),_66050280,_66049812):-derefRoot(_66050258,_66049404),'System.Process.prim_exitWith'(_66049404,_66050276),_66050280=_66049812.

'System.Process.sleep'(_66052246,_66052248,_66052250,_66052252):-freeze(_66052250,'blocked_System.Process.sleep'(_66052246,_66052248,_66052250,_66052252)).
'blocked_System.Process.sleep'(_66052332,_66052516,_66052522,_66052528):-hnf('Prelude.$#'(partcall(1,'System.Process.prim_sleep',[]),_66052332),_66052516,_66052522,_66052528).

'System.Process.prim_sleep'(_66053554,partcall(1,'System.Process.prim_sleep$WORLD',[_66053554]),_66053926,_66053926).
'System.Process.prim_sleep$WORLD'(_66054264,_66054266,_66054268,_66054270,_66054272):-freeze(_66054270,'blocked_System.Process.prim_sleep$WORLD'(_66054264,_66054266,_66054268,_66054270,_66054272)).
'blocked_System.Process.prim_sleep$WORLD'(_66054354,_66054360,'$io'(_66054372),_66054376,_66053926):-derefRoot(_66054354,_66053554),'System.Process.prim_sleep'(_66053554,_66054372),_66054376=_66053926.

'System.Process.system._\'23caseor0'(_66056788,_66056790,_66056792,_66056794,_66056796):-freeze(_66056794,'blocked_System.Process.system._\'23caseor0'(_66056788,_66056790,_66056792,_66056794,_66056796)).
'blocked_System.Process.system._\'23caseor0'(_66056884,_66056902,_66057860,_66057866,_66057872):-hnf(_66056884,_66059434,_66057866,_66059452),'blocked_System.Process.system._\'23caseor0_1'(_66059434,_66056902,_66057860,_66059452,_66057872).

'blocked_System.Process.system._\'23caseor0_1'(_66059906,_66059908,_66059910,_66059912,_66059914):-freeze(_66059912,freeze(_66059906,'blocked_blocked_System.Process.system._\'23caseor0_1'(_66059906,_66059908,_66059910,_66059912,_66059914))).
'blocked_blocked_System.Process.system._\'23caseor0_1'('Prelude.True',_66056902,['^"'|'Prelude.++'(_66056902,['^"'])],_66060306,_66060306).
'blocked_blocked_System.Process.system._\'23caseor0_1'('Prelude.False',_66056902,_66061836,_66061842,_66061848):-!,hnf(_66056902,_66061836,_66061842,_66061848).
'blocked_blocked_System.Process.system._\'23caseor0_1'('FAIL'(_66062356),_66056902,'FAIL'(_66062356),_66062370,_66062370).

:-costCenters(['']).




%%%%% Number of shared variables: 2

:-style_check(-singleton).
'System.Process.getPID'(_66062454):-currentPID(_66062454).
'System.Process.prim_system'(_66062516,_66062518):-string2Atom(_66062516,_66062524),shellCmd(_66062524,_66062518).
'System.Process.prim_exitWith'(_66062590,_66062592):-halt(_66062590).
'System.Process.prim_sleep'(_66062650,'Prelude.()'):-sleepSeconds(_66062650).
