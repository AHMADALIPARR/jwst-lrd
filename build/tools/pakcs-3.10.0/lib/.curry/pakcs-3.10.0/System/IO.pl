%PAKCS3.10 swi9 VARIABLESHARING

:-noSingletonWarnings.
:-noRedefineWarnings.
:-noDiscontiguousWarnings.

:-importModule('Prelude').

:-curryModule('System.IO').


%%%%%%%%%%%% function types %%%%%%%%%%%%%%%%%%%
:-multifile functiontype/6.
:-dynamic functiontype/6.
functiontype('System.IO._inst\'23Prelude.Eq\'23System.IO.Handle\'23','_inst#Prelude.Eq#System.IO.Handle#',1,'System.IO._inst\'23Prelude.Eq\'23System.IO.Handle\'23',nofix,notype).
functiontype('System.IO._impl\'23\'3D\'3D\'23Prelude.Eq\'23System.IO.Handle\'23','_impl#==#Prelude.Eq#System.IO.Handle#',2,'System.IO._impl\'23\'3D\'3D\'23Prelude.Eq\'23System.IO.Handle\'23',nofix,notype).
functiontype('System.IO._impl\'23\'2F\'3D\'23Prelude.Eq\'23System.IO.Handle\'23','_impl#/=#Prelude.Eq#System.IO.Handle#',0,'System.IO._impl\'23\'2F\'3D\'23Prelude.Eq\'23System.IO.Handle\'23',nofix,notype).
functiontype('System.IO._inst\'23Prelude.Data\'23System.IO.IOMode\'23','_inst#Prelude.Data#System.IO.IOMode#',1,'System.IO._inst\'23Prelude.Data\'23System.IO.IOMode\'23',nofix,notype).
functiontype('System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.IOMode\'23','_impl#===#Prelude.Data#System.IO.IOMode#',2,'System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.IOMode\'23',nofix,notype).
functiontype('System.IO._impl\'23aValue\'23Prelude.Data\'23System.IO.IOMode\'23','_impl#aValue#Prelude.Data#System.IO.IOMode#',0,'System.IO._impl\'23aValue\'23Prelude.Data\'23System.IO.IOMode\'23',nofix,notype).
functiontype('System.IO._inst\'23Prelude.Data\'23System.IO.SeekMode\'23','_inst#Prelude.Data#System.IO.SeekMode#',1,'System.IO._inst\'23Prelude.Data\'23System.IO.SeekMode\'23',nofix,notype).
functiontype('System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.SeekMode\'23','_impl#===#Prelude.Data#System.IO.SeekMode#',2,'System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.SeekMode\'23',nofix,notype).
functiontype('System.IO._impl\'23aValue\'23Prelude.Data\'23System.IO.SeekMode\'23','_impl#aValue#Prelude.Data#System.IO.SeekMode#',0,'System.IO._impl\'23aValue\'23Prelude.Data\'23System.IO.SeekMode\'23',nofix,notype).
functiontype('System.IO.handle_eq','System.IO.handle_eq',2,'System.IO.handle_eq',nofix,notype).
functiontype('System.IO.stdin',stdin,0,'System.IO.stdin',nofix,notype).
functiontype('System.IO.stdout',stdout,0,'System.IO.stdout',nofix,notype).
functiontype('System.IO.stderr',stderr,0,'System.IO.stderr',nofix,notype).
functiontype('System.IO.openFile',openFile,2,'System.IO.openFile',nofix,notype).
functiontype('System.IO.prim_openFile','System.IO.prim_openFile',2,'System.IO.prim_openFile',nofix,notype).
functiontype('System.IO.hClose',hClose,1,'System.IO.hClose',nofix,notype).
functiontype('System.IO.prim_hClose','System.IO.prim_hClose',1,'System.IO.prim_hClose',nofix,notype).
functiontype('System.IO.withFile',withFile,3,'System.IO.withFile',nofix,notype).
functiontype('System.IO.withFile._\'23lambda2','System.IO.withFile._#lambda2',2,'System.IO.withFile._\'23lambda2',nofix,notype).
functiontype('System.IO.withFile._\'23lambda2._\'23lambda4','System.IO.withFile._#lambda2._#lambda4',2,'System.IO.withFile._\'23lambda2._\'23lambda4',nofix,notype).
functiontype('System.IO.withFile._\'23lambda2._\'23lambda5','System.IO.withFile._#lambda2._#lambda5',2,'System.IO.withFile._\'23lambda2._\'23lambda5',nofix,notype).
functiontype('System.IO.hFlush',hFlush,1,'System.IO.hFlush',nofix,notype).
functiontype('System.IO.prim_hFlush','System.IO.prim_hFlush',1,'System.IO.prim_hFlush',nofix,notype).
functiontype('System.IO.hIsEOF',hIsEOF,1,'System.IO.hIsEOF',nofix,notype).
functiontype('System.IO.prim_hIsEOF','System.IO.prim_hIsEOF',1,'System.IO.prim_hIsEOF',nofix,notype).
functiontype('System.IO.isEOF',isEOF,0,'System.IO.isEOF',nofix,notype).
functiontype('System.IO.hSeek',hSeek,3,'System.IO.hSeek',nofix,notype).
functiontype('System.IO.prim_hSeek','System.IO.prim_hSeek',3,'System.IO.prim_hSeek',nofix,notype).
functiontype('System.IO.hWaitForInput',hWaitForInput,2,'System.IO.hWaitForInput',nofix,notype).
functiontype('System.IO.prim_hWaitForInput','System.IO.prim_hWaitForInput',2,prim_hWaitForInput,nofix,notype).
functiontype('System.IO.hWaitForInputs',hWaitForInputs,2,'System.IO.hWaitForInputs',nofix,notype).
functiontype('System.IO.prim_hWaitForInputs','System.IO.prim_hWaitForInputs',2,prim_hWaitForInputs,nofix,notype).
functiontype('System.IO.hReady',hReady,1,'System.IO.hReady',nofix,notype).
functiontype('System.IO.hGetChar',hGetChar,1,'System.IO.hGetChar',nofix,notype).
functiontype('System.IO.prim_hGetChar','System.IO.prim_hGetChar',1,'System.IO.prim_hGetChar',nofix,notype).
functiontype('System.IO.hGetLine',hGetLine,1,'System.IO.hGetLine',nofix,notype).
functiontype('System.IO.hGetLine._\'23lambda7','System.IO.hGetLine._#lambda7',2,'System.IO.hGetLine._\'23lambda7',nofix,notype).
functiontype('System.IO.hGetLine._\'23lambda7._\'23lambda10','System.IO.hGetLine._#lambda7._#lambda10',3,'System.IO.hGetLine._\'23lambda7._\'23lambda10',nofix,notype).
functiontype('System.IO.hGetLine._\'23lambda7._\'23lambda10._\'23lambda13','System.IO.hGetLine._#lambda7._#lambda10._#lambda13',2,'System.IO.hGetLine._\'23lambda7._\'23lambda10._\'23lambda13',nofix,notype).
functiontype('System.IO.hGetContents',hGetContents,1,'System.IO.hGetContents',nofix,notype).
functiontype('System.IO.hGetContents._\'23lambda16','System.IO.hGetContents._#lambda16',2,'System.IO.hGetContents._\'23lambda16',nofix,notype).
functiontype('System.IO.hGetContents._\'23lambda16._\'23lambda20','System.IO.hGetContents._#lambda16._#lambda20',2,'System.IO.hGetContents._\'23lambda16._\'23lambda20',nofix,notype).
functiontype('System.IO.hGetContents._\'23lambda16._\'23lambda20._\'23lambda22','System.IO.hGetContents._#lambda16._#lambda20._#lambda22',2,'System.IO.hGetContents._\'23lambda16._\'23lambda20._\'23lambda22',nofix,notype).
functiontype('System.IO.getContents',getContents,0,'System.IO.getContents',nofix,notype).
functiontype('System.IO.hPutChar',hPutChar,2,'System.IO.hPutChar',nofix,notype).
functiontype('System.IO.prim_hPutChar','System.IO.prim_hPutChar',2,'System.IO.prim_hPutChar',nofix,notype).
functiontype('System.IO.hPutStr',hPutStr,2,'System.IO.hPutStr',nofix,notype).
functiontype('System.IO.hPutStrLn',hPutStrLn,2,'System.IO.hPutStrLn',nofix,notype).
functiontype('System.IO.hPrint',hPrint,2,'System.IO.hPrint',nofix,notype).
functiontype('System.IO.hIsReadable',hIsReadable,1,'System.IO.hIsReadable',nofix,notype).
functiontype('System.IO.prim_hIsReadable','System.IO.prim_hIsReadable',1,'System.IO.prim_hIsReadable',nofix,notype).
functiontype('System.IO.hIsWritable',hIsWritable,1,'System.IO.hIsWritable',nofix,notype).
functiontype('System.IO.prim_hIsWritable','System.IO.prim_hIsWritable',1,'System.IO.prim_hIsWritable',nofix,notype).
functiontype('System.IO.hIsTerminalDevice',hIsTerminalDevice,1,'System.IO.hIsTerminalDevice',nofix,notype).
functiontype('System.IO.prim_hIsTerminalDevice','System.IO.prim_hIsTerminalDevice',1,'System.IO.prim_hIsTerminalDevice',nofix,notype).
functiontype('System.IO.hGetLine._\'23lambda7._\'23caseor0','System.IO.hGetLine._#lambda7._#caseor0',3,'System.IO.hGetLine._\'23lambda7._\'23caseor0',nofix,notype).

%%%%%%%%%%%% constructor types %%%%%%%%%%%%%%%%%%%
:-multifile constructortype/7.
:-dynamic constructortype/7.
constructortype('System.IO.ReadMode','ReadMode',0,'IO.ReadMode',0,notype,['System.IO.WriteMode'/0,'System.IO.AppendMode'/0]).
constructortype('System.IO.WriteMode','WriteMode',0,'IO.WriteMode',1,notype,['System.IO.ReadMode'/0,'System.IO.AppendMode'/0]).
constructortype('System.IO.AppendMode','AppendMode',0,'IO.AppendMode',2,notype,['System.IO.ReadMode'/0,'System.IO.WriteMode'/0]).
constructortype('System.IO.AbsoluteSeek','AbsoluteSeek',0,'IO.AbsoluteSeek',0,notype,['System.IO.RelativeSeek'/0,'System.IO.SeekFromEnd'/0]).
constructortype('System.IO.RelativeSeek','RelativeSeek',0,'IO.RelativeSeek',1,notype,['System.IO.AbsoluteSeek'/0,'System.IO.SeekFromEnd'/0]).
constructortype('System.IO.SeekFromEnd','SeekFromEnd',0,'IO.SeekFromEnd',2,notype,['System.IO.AbsoluteSeek'/0,'System.IO.RelativeSeek'/0]).

%%%%%%%%%%%% function definitions %%%%%%%%%%%%%%%%%%%
'System.IO._inst\'23Prelude.Eq\'23System.IO.Handle\'23'(_8083898,_8083900,_8083902,_8083904):-freeze(_8083902,'blocked_System.IO._inst\'23Prelude.Eq\'23System.IO.Handle\'23'(_8083898,_8083900,_8083902,_8083904)).
'blocked_System.IO._inst\'23Prelude.Eq\'23System.IO.Handle\'23'(_8083984,_8084664,_8084670,_8084676):-hnf(_8083984,_8086842,_8084670,_8086854),'blocked_System.IO._inst\'23Prelude.Eq\'23System.IO.Handle\'23_1'(_8086842,_8084664,_8086854,_8084676).

'blocked_System.IO._inst\'23Prelude.Eq\'23System.IO.Handle\'23_1'(_8087396,_8087398,_8087400,_8087402):-freeze(_8087400,'blocked_blocked_System.IO._inst\'23Prelude.Eq\'23System.IO.Handle\'23_1'(_8087396,_8087398,_8087400,_8087402)).
'blocked_blocked_System.IO._inst\'23Prelude.Eq\'23System.IO.Handle\'23_1'('Prelude.()','Prelude._Dict\'23Eq'(partcall(2,'System.IO._impl\'23\'3D\'3D\'23Prelude.Eq\'23System.IO.Handle\'23',[]),'System.IO._impl\'23\'2F\'3D\'23Prelude.Eq\'23System.IO.Handle\'23'),_8087748,_8087748):-!.
'blocked_blocked_System.IO._inst\'23Prelude.Eq\'23System.IO.Handle\'23_1'('FAIL'(_8089324),'FAIL'(_8089324),_8089338,_8089338):-nonvar(_8089324).

'System.IO._impl\'23\'3D\'3D\'23Prelude.Eq\'23System.IO.Handle\'23'(_8091504,_8091506,_8091508,_8091510,_8091512):-freeze(_8091510,'blocked_System.IO._impl\'23\'3D\'3D\'23Prelude.Eq\'23System.IO.Handle\'23'(_8091504,_8091506,_8091508,_8091510,_8091512)).
'blocked_System.IO._impl\'23\'3D\'3D\'23Prelude.Eq\'23System.IO.Handle\'23'(_8091600,_8091618,_8091956,_8091962,_8091968):-hnf('Prelude.$#'('Prelude.$#'(partcall(2,'System.IO.handle_eq',[]),_8091618),_8091600),_8091956,_8091962,_8091968).

'System.IO._impl\'23\'2F\'3D\'23Prelude.Eq\'23System.IO.Handle\'23'(_8095528,_8095530,_8095532):-freeze(_8095530,'blocked_System.IO._impl\'23\'2F\'3D\'23Prelude.Eq\'23System.IO.Handle\'23'(_8095528,_8095530,_8095532)).
'blocked_System.IO._impl\'23\'2F\'3D\'23Prelude.Eq\'23System.IO.Handle\'23'(_8095700,_8095706,_8095712):-hnf(partcall(2,'Prelude._def\'23\'2F\'3D\'23Prelude.Eq',[partcall(1,'System.IO._inst\'23Prelude.Eq\'23System.IO.Handle\'23',[])]),_8095700,_8095706,_8095712).

'System.IO._inst\'23Prelude.Data\'23System.IO.IOMode\'23'(_8098848,_8098850,_8098852,_8098854):-freeze(_8098852,'blocked_System.IO._inst\'23Prelude.Data\'23System.IO.IOMode\'23'(_8098848,_8098850,_8098852,_8098854)).
'blocked_System.IO._inst\'23Prelude.Data\'23System.IO.IOMode\'23'(_8098934,_8099626,_8099632,_8099638):-hnf(_8098934,_8101876,_8099632,_8101888),'blocked_System.IO._inst\'23Prelude.Data\'23System.IO.IOMode\'23_1'(_8101876,_8099626,_8101888,_8099638).

'blocked_System.IO._inst\'23Prelude.Data\'23System.IO.IOMode\'23_1'(_8102442,_8102444,_8102446,_8102448):-freeze(_8102446,'blocked_blocked_System.IO._inst\'23Prelude.Data\'23System.IO.IOMode\'23_1'(_8102442,_8102444,_8102446,_8102448)).
'blocked_blocked_System.IO._inst\'23Prelude.Data\'23System.IO.IOMode\'23_1'('Prelude.()','Prelude._Dict\'23Data'(partcall(2,'System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.IOMode\'23',[]),'System.IO._impl\'23aValue\'23Prelude.Data\'23System.IO.IOMode\'23'),_8102794,_8102794):-!.
'blocked_blocked_System.IO._inst\'23Prelude.Data\'23System.IO.IOMode\'23_1'('FAIL'(_8104436),'FAIL'(_8104436),_8104450,_8104450):-nonvar(_8104436).

'System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.IOMode\'23'(_8106758,_8106760,_8106762,_8106764,_8106766):-freeze(_8106764,'blocked_System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.IOMode\'23'(_8106758,_8106760,_8106762,_8106764,_8106766)).
'blocked_System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.IOMode\'23'(_8106854,_8106872,_8108580,_8108586,_8108592):-hnf(_8106854,_8111270,_8108586,_8111288),'blocked_System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.IOMode\'23_1'(_8111270,_8106872,_8108580,_8111288,_8108592).

'blocked_System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.IOMode\'23_1'(_8111922,_8111924,_8111926,_8111928,_8111930):-freeze(_8111928,'blocked_blocked_System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.IOMode\'23_1'(_8111922,_8111924,_8111926,_8111928,_8111930)).
'blocked_blocked_System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.IOMode\'23_1'('System.IO.ReadMode',_8106872,_8112904,_8112910,_8112916):-hnf(_8106872,_8116524,_8112910,_8116536),'blocked_blocked_System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.IOMode\'23_1_System.IO.ReadMode_1'(_8116524,_8112904,_8116536,_8112916).

'blocked_blocked_System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.IOMode\'23_1_System.IO.ReadMode_1'(_8117336,_8117338,_8117340,_8117342):-freeze(_8117340,'blocked_blocked_blocked_System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.IOMode\'23_1_System.IO.ReadMode_1'(_8117336,_8117338,_8117340,_8117342)).
'blocked_blocked_blocked_System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.IOMode\'23_1_System.IO.ReadMode_1'('System.IO.ReadMode','Prelude.True',_8117792,_8117792).
'blocked_blocked_blocked_System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.IOMode\'23_1_System.IO.ReadMode_1'('System.IO.WriteMode','Prelude.False',_8119032,_8119032).
'blocked_blocked_blocked_System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.IOMode\'23_1_System.IO.ReadMode_1'('System.IO.AppendMode','Prelude.False',_8120290,_8120290):-!.
'blocked_blocked_blocked_System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.IOMode\'23_1_System.IO.ReadMode_1'('FAIL'(_8121160),'FAIL'(_8121160),_8121174,_8121174):-nonvar(_8121160).
'blocked_blocked_System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.IOMode\'23_1'('System.IO.WriteMode',_8106872,_8122134,_8122140,_8122146):-hnf(_8106872,_8125784,_8122140,_8125796),'blocked_blocked_System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.IOMode\'23_1_System.IO.WriteMode_1'(_8125784,_8122134,_8125796,_8122146).

'blocked_blocked_System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.IOMode\'23_1_System.IO.WriteMode_1'(_8126602,_8126604,_8126606,_8126608):-freeze(_8126606,'blocked_blocked_blocked_System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.IOMode\'23_1_System.IO.WriteMode_1'(_8126602,_8126604,_8126606,_8126608)).
'blocked_blocked_blocked_System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.IOMode\'23_1_System.IO.WriteMode_1'('System.IO.ReadMode','Prelude.False',_8127058,_8127058).
'blocked_blocked_blocked_System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.IOMode\'23_1_System.IO.WriteMode_1'('System.IO.WriteMode','Prelude.True',_8128310,_8128310).
'blocked_blocked_blocked_System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.IOMode\'23_1_System.IO.WriteMode_1'('System.IO.AppendMode','Prelude.False',_8129568,_8129568):-!.
'blocked_blocked_blocked_System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.IOMode\'23_1_System.IO.WriteMode_1'('FAIL'(_8130444),'FAIL'(_8130444),_8130458,_8130458):-nonvar(_8130444).
'blocked_blocked_System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.IOMode\'23_1'('System.IO.AppendMode',_8106872,_8131430,_8131436,_8131442):-!,hnf(_8106872,_8135110,_8131436,_8135122),'blocked_blocked_System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.IOMode\'23_1_System.IO.AppendMode_1'(_8135110,_8131430,_8135122,_8131442).

'blocked_blocked_System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.IOMode\'23_1_System.IO.AppendMode_1'(_8135952,_8135954,_8135956,_8135958):-freeze(_8135956,'blocked_blocked_blocked_System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.IOMode\'23_1_System.IO.AppendMode_1'(_8135952,_8135954,_8135956,_8135958)).
'blocked_blocked_blocked_System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.IOMode\'23_1_System.IO.AppendMode_1'('System.IO.ReadMode','Prelude.False',_8136408,_8136408).
'blocked_blocked_blocked_System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.IOMode\'23_1_System.IO.AppendMode_1'('System.IO.WriteMode','Prelude.False',_8137666,_8137666).
'blocked_blocked_blocked_System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.IOMode\'23_1_System.IO.AppendMode_1'('System.IO.AppendMode','Prelude.True',_8138936,_8138936):-!.
'blocked_blocked_blocked_System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.IOMode\'23_1_System.IO.AppendMode_1'('FAIL'(_8139812),'FAIL'(_8139812),_8139826,_8139826):-nonvar(_8139812).
'blocked_blocked_System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.IOMode\'23_1'('FAIL'(_8139882),_8106872,'FAIL'(_8139882),_8139896,_8139896):-nonvar(_8139882).

'System.IO._impl\'23aValue\'23Prelude.Data\'23System.IO.IOMode\'23'(_8142242,_8142244,_8142246):-freeze(_8142244,'blocked_System.IO._impl\'23aValue\'23Prelude.Data\'23System.IO.IOMode\'23'(_8142242,_8142244,_8142246)).
'blocked_System.IO._impl\'23aValue\'23Prelude.Data\'23System.IO.IOMode\'23'('System.IO.ReadMode',_8142608,_8142608).
'blocked_System.IO._impl\'23aValue\'23Prelude.Data\'23System.IO.IOMode\'23'('System.IO.WriteMode',_8143236,_8143236).
'blocked_System.IO._impl\'23aValue\'23Prelude.Data\'23System.IO.IOMode\'23'('System.IO.AppendMode',_8143870,_8143870).

'System.IO._inst\'23Prelude.Data\'23System.IO.SeekMode\'23'(_8146574,_8146576,_8146578,_8146580):-freeze(_8146578,'blocked_System.IO._inst\'23Prelude.Data\'23System.IO.SeekMode\'23'(_8146574,_8146576,_8146578,_8146580)).
'blocked_System.IO._inst\'23Prelude.Data\'23System.IO.SeekMode\'23'(_8146660,_8147364,_8147370,_8147376):-hnf(_8146660,_8149686,_8147370,_8149698),'blocked_System.IO._inst\'23Prelude.Data\'23System.IO.SeekMode\'23_1'(_8149686,_8147364,_8149698,_8147376).

'blocked_System.IO._inst\'23Prelude.Data\'23System.IO.SeekMode\'23_1'(_8150264,_8150266,_8150268,_8150270):-freeze(_8150268,'blocked_blocked_System.IO._inst\'23Prelude.Data\'23System.IO.SeekMode\'23_1'(_8150264,_8150266,_8150268,_8150270)).
'blocked_blocked_System.IO._inst\'23Prelude.Data\'23System.IO.SeekMode\'23_1'('Prelude.()','Prelude._Dict\'23Data'(partcall(2,'System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.SeekMode\'23',[]),'System.IO._impl\'23aValue\'23Prelude.Data\'23System.IO.SeekMode\'23'),_8150616,_8150616):-!.
'blocked_blocked_System.IO._inst\'23Prelude.Data\'23System.IO.SeekMode\'23_1'('FAIL'(_8152294),'FAIL'(_8152294),_8152308,_8152308):-nonvar(_8152294).

'System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.SeekMode\'23'(_8154692,_8154694,_8154696,_8154698,_8154700):-freeze(_8154698,'blocked_System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.SeekMode\'23'(_8154692,_8154694,_8154696,_8154698,_8154700)).
'blocked_System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.SeekMode\'23'(_8154788,_8154806,_8156526,_8156532,_8156538):-hnf(_8154788,_8159288,_8156532,_8159306),'blocked_System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.SeekMode\'23_1'(_8159288,_8154806,_8156526,_8159306,_8156538).

'blocked_System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.SeekMode\'23_1'(_8159952,_8159954,_8159956,_8159958,_8159960):-freeze(_8159958,'blocked_blocked_System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.SeekMode\'23_1'(_8159952,_8159954,_8159956,_8159958,_8159960)).
'blocked_blocked_System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.SeekMode\'23_1'('System.IO.AbsoluteSeek',_8154806,_8160994,_8161000,_8161006):-hnf(_8154806,_8164806,_8161000,_8164818),'blocked_blocked_System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.SeekMode\'23_1_System.IO.AbsoluteSeek_1'(_8164806,_8160994,_8164818,_8161006).

'blocked_blocked_System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.SeekMode\'23_1_System.IO.AbsoluteSeek_1'(_8165654,_8165656,_8165658,_8165660):-freeze(_8165658,'blocked_blocked_blocked_System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.SeekMode\'23_1_System.IO.AbsoluteSeek_1'(_8165654,_8165656,_8165658,_8165660)).
'blocked_blocked_blocked_System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.SeekMode\'23_1_System.IO.AbsoluteSeek_1'('System.IO.AbsoluteSeek','Prelude.True',_8166158,_8166158).
'blocked_blocked_blocked_System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.SeekMode\'23_1_System.IO.AbsoluteSeek_1'('System.IO.RelativeSeek','Prelude.False',_8167470,_8167470).
'blocked_blocked_blocked_System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.SeekMode\'23_1_System.IO.AbsoluteSeek_1'('System.IO.SeekFromEnd','Prelude.False',_8168776,_8168776):-!.
'blocked_blocked_blocked_System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.SeekMode\'23_1_System.IO.AbsoluteSeek_1'('FAIL'(_8169682),'FAIL'(_8169682),_8169696,_8169696):-nonvar(_8169682).
'blocked_blocked_System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.SeekMode\'23_1'('System.IO.RelativeSeek',_8154806,_8170704,_8170710,_8170716):-hnf(_8154806,_8174516,_8170710,_8174528),'blocked_blocked_System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.SeekMode\'23_1_System.IO.RelativeSeek_1'(_8174516,_8170704,_8174528,_8170716).

'blocked_blocked_System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.SeekMode\'23_1_System.IO.RelativeSeek_1'(_8175364,_8175366,_8175368,_8175370):-freeze(_8175368,'blocked_blocked_blocked_System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.SeekMode\'23_1_System.IO.RelativeSeek_1'(_8175364,_8175366,_8175368,_8175370)).
'blocked_blocked_blocked_System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.SeekMode\'23_1_System.IO.RelativeSeek_1'('System.IO.AbsoluteSeek','Prelude.False',_8175868,_8175868).
'blocked_blocked_blocked_System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.SeekMode\'23_1_System.IO.RelativeSeek_1'('System.IO.RelativeSeek','Prelude.True',_8177186,_8177186).
'blocked_blocked_blocked_System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.SeekMode\'23_1_System.IO.RelativeSeek_1'('System.IO.SeekFromEnd','Prelude.False',_8178486,_8178486):-!.
'blocked_blocked_blocked_System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.SeekMode\'23_1_System.IO.RelativeSeek_1'('FAIL'(_8179392),'FAIL'(_8179392),_8179406,_8179406):-nonvar(_8179392).
'blocked_blocked_System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.SeekMode\'23_1'('System.IO.SeekFromEnd',_8154806,_8180402,_8180408,_8180414):-!,hnf(_8154806,_8184184,_8180408,_8184196),'blocked_blocked_System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.SeekMode\'23_1_System.IO.SeekFromEnd_1'(_8184184,_8180402,_8184196,_8180414).

'blocked_blocked_System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.SeekMode\'23_1_System.IO.SeekFromEnd_1'(_8185044,_8185046,_8185048,_8185050):-freeze(_8185048,'blocked_blocked_blocked_System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.SeekMode\'23_1_System.IO.SeekFromEnd_1'(_8185044,_8185046,_8185048,_8185050)).
'blocked_blocked_blocked_System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.SeekMode\'23_1_System.IO.SeekFromEnd_1'('System.IO.AbsoluteSeek','Prelude.False',_8185548,_8185548).
'blocked_blocked_blocked_System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.SeekMode\'23_1_System.IO.SeekFromEnd_1'('System.IO.RelativeSeek','Prelude.False',_8186860,_8186860).
'blocked_blocked_blocked_System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.SeekMode\'23_1_System.IO.SeekFromEnd_1'('System.IO.SeekFromEnd','Prelude.True',_8188160,_8188160):-!.
'blocked_blocked_blocked_System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.SeekMode\'23_1_System.IO.SeekFromEnd_1'('FAIL'(_8189054),'FAIL'(_8189054),_8189068,_8189068):-nonvar(_8189054).
'blocked_blocked_System.IO._impl\'23\'3D\'3D\'3D\'23Prelude.Data\'23System.IO.SeekMode\'23_1'('FAIL'(_8189124),_8154806,'FAIL'(_8189124),_8189138,_8189138):-nonvar(_8189124).

'System.IO._impl\'23aValue\'23Prelude.Data\'23System.IO.SeekMode\'23'(_8191560,_8191562,_8191564):-freeze(_8191562,'blocked_System.IO._impl\'23aValue\'23Prelude.Data\'23System.IO.SeekMode\'23'(_8191560,_8191562,_8191564)).
'blocked_System.IO._impl\'23aValue\'23Prelude.Data\'23System.IO.SeekMode\'23'('System.IO.AbsoluteSeek',_8191926,_8191926).
'blocked_System.IO._impl\'23aValue\'23Prelude.Data\'23System.IO.SeekMode\'23'('System.IO.RelativeSeek',_8192590,_8192590).
'blocked_System.IO._impl\'23aValue\'23Prelude.Data\'23System.IO.SeekMode\'23'('System.IO.SeekFromEnd',_8193254,_8193254).

'System.IO.handle_eq'(_8194282,_8194284,_8194286,_8194288,_8194290):-freeze(_8194288,'blocked_System.IO.handle_eq'(_8194282,_8194284,_8194286,_8194288,_8194290)).
'blocked_System.IO.handle_eq'(_8194372,_8194378,_8194384,_8194390,_8194396):-derefAll(_8194372,_8194442),derefAll(_8194378,_8194448),'System.IO.handle_eq'(_8194442,_8194448,_8194384),_8194390=_8194396.

'System.IO.stdin'(_8194912,_8194914,_8194916):-freeze(_8194914,'blocked_System.IO.stdin'(_8194912,_8194914,_8194916)).
'blocked_System.IO.stdin'(_8194982,_8194988,_8194994):-'System.IO.stdin'(_8194982),_8194988=_8194994.

'System.IO.stdout'(_8195414,_8195416,_8195418):-freeze(_8195416,'blocked_System.IO.stdout'(_8195414,_8195416,_8195418)).
'blocked_System.IO.stdout'(_8195484,_8195490,_8195496):-'System.IO.stdout'(_8195484),_8195490=_8195496.

'System.IO.stderr'(_8195916,_8195918,_8195920):-freeze(_8195918,'blocked_System.IO.stderr'(_8195916,_8195918,_8195920)).
'blocked_System.IO.stderr'(_8195986,_8195992,_8195998):-'System.IO.stderr'(_8195986),_8195992=_8195998.

'System.IO.openFile'(_8196896,_8196898,_8196900,_8196902,_8196904):-freeze(_8196902,'blocked_System.IO.openFile'(_8196896,_8196898,_8196900,_8196902,_8196904)).
'blocked_System.IO.openFile'(_8196992,_8197010,_8197348,_8197354,_8197360):-hnf('Prelude.$#'('Prelude.$##'(partcall(2,'System.IO.prim_openFile',[]),_8196992),_8197010),_8197348,_8197354,_8197360).

'System.IO.prim_openFile'(_8198792,_8198798,partcall(1,'System.IO.prim_openFile$WORLD',[_8198798,_8198792]),_8199152,_8199152).
'System.IO.prim_openFile$WORLD'(_8199486,_8199488,_8199490,_8199492,_8199494,_8199496):-freeze(_8199494,'blocked_System.IO.prim_openFile$WORLD'(_8199486,_8199488,_8199490,_8199492,_8199494,_8199496)).
'blocked_System.IO.prim_openFile$WORLD'(_8199586,_8199592,_8199598,'$io'(_8199610),_8199614,_8199152):-derefAll(_8199586,_8198792),derefAll(_8199592,_8198798),'System.IO.prim_openFile'(_8198792,_8198798,_8199610),_8199614=_8199152.

'System.IO.hClose'(_8200534,_8200536,_8200538,_8200540):-freeze(_8200538,'blocked_System.IO.hClose'(_8200534,_8200536,_8200538,_8200540)).
'blocked_System.IO.hClose'(_8200620,_8200804,_8200810,_8200816):-hnf('Prelude.$#'(partcall(1,'System.IO.prim_hClose',[]),_8200620),_8200804,_8200810,_8200816).

'System.IO.prim_hClose'(_8201770,partcall(1,'System.IO.prim_hClose$WORLD',[_8201770]),_8202094,_8202094).
'System.IO.prim_hClose$WORLD'(_8202408,_8202410,_8202412,_8202414,_8202416):-freeze(_8202414,'blocked_System.IO.prim_hClose$WORLD'(_8202408,_8202410,_8202412,_8202414,_8202416)).
'blocked_System.IO.prim_hClose$WORLD'(_8202498,_8202504,'$io'(_8202516),_8202520,_8202094):-derefAll(_8202498,_8201770),'System.IO.prim_hClose'(_8201770,_8202516),_8202520=_8202094.

'System.IO.withFile'(_8203468,_8203470,_8203472,_8203474,_8203476,_8203478):-freeze(_8203476,'blocked_System.IO.withFile'(_8203468,_8203470,_8203472,_8203474,_8203476,_8203478)).
'blocked_System.IO.withFile'(_8203574,_8203592,_8203610,_8204186,_8204192,_8204198):-hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','System.IO.openFile'(_8203574,_8203592)),partcall(1,'System.IO.withFile._\'23lambda2',[_8203610])),_8204186,_8204192,_8204198).

'System.IO.withFile._\'23lambda2'(_8207462,_8207464,_8207466,_8207468,_8207470):-freeze(_8207468,'blocked_System.IO.withFile._\'23lambda2'(_8207462,_8207464,_8207466,_8207468,_8207470)).
'blocked_System.IO.withFile._\'23lambda2'(_8207558,_8207576,_8208732,_8208738,_8208744):-makeShare(_8207604,_8208934),hnf('Prelude.cond'(letrec4PAKCS(_8208934,_8207576),'Prelude.catch'('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','Prelude.apply'(_8207558,_8208934)),partcall(1,'System.IO.withFile._\'23lambda2._\'23lambda4',[_8208934])),partcall(1,'System.IO.withFile._\'23lambda2._\'23lambda5',[_8208934]))),_8208732,_8208738,_8208744).

'System.IO.withFile._\'23lambda2._\'23lambda4'(_8213984,_8213986,_8213988,_8213990,_8213992):-freeze(_8213990,'blocked_System.IO.withFile._\'23lambda2._\'23lambda4'(_8213984,_8213986,_8213988,_8213990,_8213992)).
'blocked_System.IO.withFile._\'23lambda2._\'23lambda4'(_8214080,_8214098,_8214688,_8214694,_8214700):-hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'23Prelude.Monad\'23Prelude.IO\'23','System.IO.hClose'(_8214080)),'Prelude.apply'('Prelude._impl\'23return\'23Prelude.Monad\'23Prelude.IO\'23',_8214098)),_8214688,_8214694,_8214700).

'System.IO.withFile._\'23lambda2._\'23lambda5'(_8218624,_8218626,_8218628,_8218630,_8218632):-freeze(_8218630,'blocked_System.IO.withFile._\'23lambda2._\'23lambda5'(_8218624,_8218626,_8218628,_8218630,_8218632)).
'blocked_System.IO.withFile._\'23lambda2._\'23lambda5'(_8218720,_8218738,_8219244,_8219250,_8219256):-hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'23Prelude.Monad\'23Prelude.IO\'23','System.IO.hClose'(_8218720)),'Prelude.ioError'(_8218738)),_8219244,_8219250,_8219256).

'System.IO.hFlush'(_8221864,_8221866,_8221868,_8221870):-freeze(_8221868,'blocked_System.IO.hFlush'(_8221864,_8221866,_8221868,_8221870)).
'blocked_System.IO.hFlush'(_8221950,_8222134,_8222140,_8222146):-hnf('Prelude.$#'(partcall(1,'System.IO.prim_hFlush',[]),_8221950),_8222134,_8222140,_8222146).

'System.IO.prim_hFlush'(_8223100,partcall(1,'System.IO.prim_hFlush$WORLD',[_8223100]),_8223424,_8223424).
'System.IO.prim_hFlush$WORLD'(_8223738,_8223740,_8223742,_8223744,_8223746):-freeze(_8223744,'blocked_System.IO.prim_hFlush$WORLD'(_8223738,_8223740,_8223742,_8223744,_8223746)).
'blocked_System.IO.prim_hFlush$WORLD'(_8223828,_8223834,'$io'(_8223846),_8223850,_8223424):-derefAll(_8223828,_8223100),'System.IO.prim_hFlush'(_8223100,_8223846),_8223850=_8223424.

'System.IO.hIsEOF'(_8224722,_8224724,_8224726,_8224728):-freeze(_8224726,'blocked_System.IO.hIsEOF'(_8224722,_8224724,_8224726,_8224728)).
'blocked_System.IO.hIsEOF'(_8224808,_8224992,_8224998,_8225004):-hnf('Prelude.$#'(partcall(1,'System.IO.prim_hIsEOF',[]),_8224808),_8224992,_8224998,_8225004).

'System.IO.prim_hIsEOF'(_8225958,partcall(1,'System.IO.prim_hIsEOF$WORLD',[_8225958]),_8226282,_8226282).
'System.IO.prim_hIsEOF$WORLD'(_8226596,_8226598,_8226600,_8226602,_8226604):-freeze(_8226602,'blocked_System.IO.prim_hIsEOF$WORLD'(_8226596,_8226598,_8226600,_8226602,_8226604)).
'blocked_System.IO.prim_hIsEOF$WORLD'(_8226686,_8226692,'$io'(_8226704),_8226708,_8226282):-derefAll(_8226686,_8225958),'System.IO.prim_hIsEOF'(_8225958,_8226704),_8226708=_8226282.

'System.IO.isEOF'(_8227542,_8227544,_8227546):-freeze(_8227544,'blocked_System.IO.isEOF'(_8227542,_8227544,_8227546)).
'blocked_System.IO.isEOF'(_8227714,_8227720,_8227726):-hnf('System.IO.hIsEOF'('System.IO.stdin'),_8227714,_8227720,_8227726).

'System.IO.hSeek'(_8228976,_8228978,_8228980,_8228982,_8228984,_8228986):-freeze(_8228984,'blocked_System.IO.hSeek'(_8228976,_8228978,_8228980,_8228982,_8228984,_8228986)).
'blocked_System.IO.hSeek'(_8229082,_8229100,_8229118,_8229610,_8229616,_8229622):-hnf('Prelude.$#'('Prelude.$#'('Prelude.$#'(partcall(3,'System.IO.prim_hSeek',[]),_8229082),_8229100),_8229118),_8229610,_8229616,_8229622).

'System.IO.prim_hSeek'(_8231394,_8231400,_8231406,partcall(1,'System.IO.prim_hSeek$WORLD',[_8231406,_8231400,_8231394]),_8231730,_8231730).
'System.IO.prim_hSeek$WORLD'(_8232054,_8232056,_8232058,_8232060,_8232062,_8232064,_8232066):-freeze(_8232064,'blocked_System.IO.prim_hSeek$WORLD'(_8232054,_8232056,_8232058,_8232060,_8232062,_8232064,_8232066)).
'blocked_System.IO.prim_hSeek$WORLD'(_8232164,_8232170,_8232176,_8232182,'$io'(_8232194),_8232198,_8231730):-derefAll(_8232164,_8231394),derefAll(_8232170,_8231400),derefRoot(_8232176,_8231406),'System.IO.prim_hSeek'(_8231394,_8231400,_8231406,_8232194),_8232198=_8231730.

'System.IO.hWaitForInput'(_8234374,_8234376,_8234378,_8234380,_8234382):-freeze(_8234380,'blocked_System.IO.hWaitForInput'(_8234374,_8234376,_8234378,_8234380,_8234382)).
'blocked_System.IO.hWaitForInput'(_8234470,_8234488,_8234826,_8234832,_8234838):-hnf('Prelude.$##'('Prelude.$#'(partcall(2,'System.IO.prim_hWaitForInput',[]),_8234470),_8234488),_8234826,_8234832,_8234838).

'System.IO.hWaitForInputs'(_8237370,_8237372,_8237374,_8237376,_8237378):-freeze(_8237376,'blocked_System.IO.hWaitForInputs'(_8237370,_8237372,_8237374,_8237376,_8237378)).
'blocked_System.IO.hWaitForInputs'(_8237466,_8237484,_8237822,_8237828,_8237834):-hnf('Prelude.$##'('Prelude.$##'(partcall(2,'System.IO.prim_hWaitForInputs',[]),_8237466),_8237484),_8237822,_8237828,_8237834).

'System.IO.hReady'(_8240110,_8240112,_8240114,_8240116):-freeze(_8240114,'blocked_System.IO.hReady'(_8240110,_8240112,_8240114,_8240116)).
'blocked_System.IO.hReady'(_8240196,_8240366,_8240372,_8240378):-hnf('System.IO.hWaitForInput'(_8240196,0),_8240366,_8240372,_8240378).

'System.IO.hGetChar'(_8241838,_8241840,_8241842,_8241844):-freeze(_8241842,'blocked_System.IO.hGetChar'(_8241838,_8241840,_8241842,_8241844)).
'blocked_System.IO.hGetChar'(_8241924,_8242108,_8242114,_8242120):-hnf('Prelude.$#'(partcall(1,'System.IO.prim_hGetChar',[]),_8241924),_8242108,_8242114,_8242120).

'System.IO.prim_hGetChar'(_8243110,partcall(1,'System.IO.prim_hGetChar$WORLD',[_8243110]),_8243458,_8243458).
'System.IO.prim_hGetChar$WORLD'(_8243784,_8243786,_8243788,_8243790,_8243792):-freeze(_8243790,'blocked_System.IO.prim_hGetChar$WORLD'(_8243784,_8243786,_8243788,_8243790,_8243792)).
'blocked_System.IO.prim_hGetChar$WORLD'(_8243874,_8243880,'$io'(_8243892),_8243896,_8243458):-derefAll(_8243874,_8243110),'System.IO.prim_hGetChar'(_8243110,_8243892),_8243896=_8243458.

'System.IO.hGetLine'(_8244844,_8244846,_8244848,_8244850):-freeze(_8244848,'blocked_System.IO.hGetLine'(_8244844,_8244846,_8244848,_8244850)).
'blocked_System.IO.hGetLine'(_8244930,_8245436,_8245442,_8245448):-makeShare(_8244930,_8245530),hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','System.IO.hGetChar'(_8245530)),partcall(1,'System.IO.hGetLine._\'23lambda7',[_8245530])),_8245436,_8245442,_8245448).

'System.IO.hGetLine._\'23lambda7'(_8248674,_8248676,_8248678,_8248680,_8248682):-freeze(_8248680,'blocked_System.IO.hGetLine._\'23lambda7'(_8248674,_8248676,_8248678,_8248680,_8248682)).
'blocked_System.IO.hGetLine._\'23lambda7'(_8248770,_8248788,_8249524,_8249530,_8249536):-makeShare(_8248816,_8249704),hnf('Prelude.cond'(letrec4PAKCS(_8249704,_8248788),'System.IO.hGetLine._\'23lambda7._\'23caseor0'('Prelude._impl\'23\'3D\'3D\'23Prelude.Eq\'23Prelude.Char\'23'(_8249704,'^010'),_8249704,_8248770)),_8249524,_8249530,_8249536).

'System.IO.hGetLine._\'23lambda7._\'23lambda10'(_8253678,_8253680,_8253682,_8253684,_8253686,_8253688):-freeze(_8253686,'blocked_System.IO.hGetLine._\'23lambda7._\'23lambda10'(_8253678,_8253680,_8253682,_8253684,_8253686,_8253688)).
'blocked_System.IO.hGetLine._\'23lambda7._\'23lambda10'(_8253784,_8253802,_8253820,_8255204,_8255210,_8255216):-hnf(_8253820,_8257146,_8255210,_8257170),'blocked_System.IO.hGetLine._\'23lambda7._\'23lambda10_3'(_8257146,_8253784,_8253802,_8255204,_8257170,_8255216).

'blocked_System.IO.hGetLine._\'23lambda7._\'23lambda10_3'(_8257692,_8257694,_8257696,_8257698,_8257700,_8257702):-freeze(_8257700,freeze(_8257692,'blocked_blocked_System.IO.hGetLine._\'23lambda7._\'23lambda10_3'(_8257692,_8257694,_8257696,_8257698,_8257700,_8257702))).
'blocked_blocked_System.IO.hGetLine._\'23lambda7._\'23lambda10_3'('Prelude.True',_8253784,_8253802,_8258096,_8258102,_8258108):-hnf('Prelude.apply'('Prelude._impl\'23return\'23Prelude.Monad\'23Prelude.IO\'23',[_8253784]),_8258096,_8258102,_8258108).
'blocked_blocked_System.IO.hGetLine._\'23lambda7._\'23lambda10_3'('Prelude.False',_8253784,_8253802,_8259880,_8259886,_8259892):-!,hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','System.IO.hGetLine'(_8253802)),partcall(1,'System.IO.hGetLine._\'23lambda7._\'23lambda10._\'23lambda13',[_8253784])),_8259880,_8259886,_8259892).
'blocked_blocked_System.IO.hGetLine._\'23lambda7._\'23lambda10_3'('FAIL'(_8262138),_8253784,_8253802,'FAIL'(_8262138),_8262152,_8262152).

'System.IO.hGetLine._\'23lambda7._\'23lambda10._\'23lambda13'(_8264332,_8264334,_8264336,_8264338,_8264340):-freeze(_8264338,'blocked_System.IO.hGetLine._\'23lambda7._\'23lambda10._\'23lambda13'(_8264332,_8264334,_8264336,_8264338,_8264340)).
'blocked_System.IO.hGetLine._\'23lambda7._\'23lambda10._\'23lambda13'(_8264428,_8264446,_8265126,_8265132,_8265138):-makeShare(_8264474,_8265292),hnf('Prelude.cond'(letrec4PAKCS(_8265292,_8264446),'Prelude.apply'('Prelude._impl\'23return\'23Prelude.Monad\'23Prelude.IO\'23',[_8264428|_8265292])),_8265126,_8265132,_8265138).

'System.IO.hGetContents'(_8268478,_8268480,_8268482,_8268484):-freeze(_8268482,'blocked_System.IO.hGetContents'(_8268478,_8268480,_8268482,_8268484)).
'blocked_System.IO.hGetContents'(_8268564,_8269070,_8269076,_8269082):-makeShare(_8268564,_8269164),hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','System.IO.hIsEOF'(_8269164)),partcall(1,'System.IO.hGetContents._\'23lambda16',[_8269164])),_8269070,_8269076,_8269082).

'System.IO.hGetContents._\'23lambda16'(_8272540,_8272542,_8272544,_8272546,_8272548):-freeze(_8272546,'blocked_System.IO.hGetContents._\'23lambda16'(_8272540,_8272542,_8272544,_8272546,_8272548)).
'blocked_System.IO.hGetContents._\'23lambda16'(_8272636,_8272654,_8274234,_8274240,_8274246):-hnf(_8272654,_8275880,_8274240,_8275898),'blocked_System.IO.hGetContents._\'23lambda16_2'(_8275880,_8272636,_8274234,_8275898,_8274246).

'blocked_System.IO.hGetContents._\'23lambda16_2'(_8276364,_8276366,_8276368,_8276370,_8276372):-freeze(_8276370,freeze(_8276364,'blocked_blocked_System.IO.hGetContents._\'23lambda16_2'(_8276364,_8276366,_8276368,_8276370,_8276372))).
'blocked_blocked_System.IO.hGetContents._\'23lambda16_2'('Prelude.True',_8272636,_8276758,_8276764,_8276770):-hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'23Prelude.Monad\'23Prelude.IO\'23','System.IO.hClose'(_8272636)),'Prelude.apply'('Prelude._impl\'23return\'23Prelude.Monad\'23Prelude.IO\'23',[])),_8276758,_8276764,_8276770).
'blocked_blocked_System.IO.hGetContents._\'23lambda16_2'('Prelude.False',_8272636,_8279328,_8279334,_8279340):-!,makeShare(_8272636,_8279430),hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','System.IO.hGetChar'(_8279430)),partcall(1,'System.IO.hGetContents._\'23lambda16._\'23lambda20',[_8279430])),_8279328,_8279334,_8279340).
'blocked_blocked_System.IO.hGetContents._\'23lambda16_2'('FAIL'(_8281642),_8272636,'FAIL'(_8281642),_8281656,_8281656).

'System.IO.hGetContents._\'23lambda16._\'23lambda20'(_8283572,_8283574,_8283576,_8283578,_8283580):-freeze(_8283578,'blocked_System.IO.hGetContents._\'23lambda16._\'23lambda20'(_8283572,_8283574,_8283576,_8283578,_8283580)).
'blocked_System.IO.hGetContents._\'23lambda16._\'23lambda20'(_8283668,_8283686,_8284534,_8284540,_8284546):-makeShare(_8283714,_8284704),hnf('Prelude.cond'(letrec4PAKCS(_8284704,_8283686),'Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','System.IO.hGetContents'(_8283668)),partcall(1,'System.IO.hGetContents._\'23lambda16._\'23lambda20._\'23lambda22',[_8284704]))),_8284534,_8284540,_8284546).

'System.IO.hGetContents._\'23lambda16._\'23lambda20._\'23lambda22'(_8289996,_8289998,_8290000,_8290002,_8290004):-freeze(_8290002,'blocked_System.IO.hGetContents._\'23lambda16._\'23lambda20._\'23lambda22'(_8289996,_8289998,_8290000,_8290002,_8290004)).
'blocked_System.IO.hGetContents._\'23lambda16._\'23lambda20._\'23lambda22'(_8290092,_8290110,_8290790,_8290796,_8290802):-makeShare(_8290138,_8290956),hnf('Prelude.cond'(letrec4PAKCS(_8290956,_8290110),'Prelude.apply'('Prelude._impl\'23return\'23Prelude.Monad\'23Prelude.IO\'23',[_8290092|_8290956])),_8290790,_8290796,_8290802).

'System.IO.getContents'(_8294134,_8294136,_8294138):-freeze(_8294136,'blocked_System.IO.getContents'(_8294134,_8294136,_8294138)).
'blocked_System.IO.getContents'(_8294306,_8294312,_8294318):-hnf('System.IO.hGetContents'('System.IO.stdin'),_8294306,_8294312,_8294318).

'System.IO.hPutChar'(_8295754,_8295756,_8295758,_8295760,_8295762):-freeze(_8295760,'blocked_System.IO.hPutChar'(_8295754,_8295756,_8295758,_8295760,_8295762)).
'blocked_System.IO.hPutChar'(_8295850,_8295868,_8296206,_8296212,_8296218):-hnf('Prelude.$##'('Prelude.$#'(partcall(2,'System.IO.prim_hPutChar',[]),_8295850),_8295868),_8296206,_8296212,_8296218).

'System.IO.prim_hPutChar'(_8297650,_8297656,partcall(1,'System.IO.prim_hPutChar$WORLD',[_8297656,_8297650]),_8298010,_8298010).
'System.IO.prim_hPutChar$WORLD'(_8298344,_8298346,_8298348,_8298350,_8298352,_8298354):-freeze(_8298352,'blocked_System.IO.prim_hPutChar$WORLD'(_8298344,_8298346,_8298348,_8298350,_8298352,_8298354)).
'blocked_System.IO.prim_hPutChar$WORLD'(_8298444,_8298450,_8298456,'$io'(_8298468),_8298472,_8298010):-derefAll(_8298444,_8297650),derefRoot(_8298450,_8297656),'System.IO.prim_hPutChar'(_8297650,_8297656,_8298468),_8298472=_8298010.

'System.IO.hPutStr'(_8300372,_8300374,_8300376,_8300378,_8300380):-freeze(_8300378,'blocked_System.IO.hPutStr'(_8300372,_8300374,_8300376,_8300378,_8300380)).
'blocked_System.IO.hPutStr'(_8300468,_8300486,_8301740,_8301746,_8301752):-hnf(_8300486,_8302738,_8301746,_8302756),'blocked_System.IO.hPutStr_2'(_8302738,_8300468,_8301740,_8302756,_8301752).

'blocked_System.IO.hPutStr_2'(_8303108,_8303110,_8303112,_8303114,_8303116):-freeze(_8303114,'blocked_blocked_System.IO.hPutStr_2'(_8303108,_8303110,_8303112,_8303114,_8303116)).
'blocked_blocked_System.IO.hPutStr_2'([],_8300468,_8303360,_8303366,_8303372):-hnf('Prelude.apply'('Prelude._impl\'23return\'23Prelude.Monad\'23Prelude.IO\'23','Prelude.()'),_8303360,_8303366,_8303372).
'blocked_blocked_System.IO.hPutStr_2'([_8300870|_8300888],_8300468,_8304648,_8304654,_8304660):-!,makeShare(_8300468,_8304814),hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'23Prelude.Monad\'23Prelude.IO\'23','System.IO.hPutChar'(_8304814,_8300870)),'System.IO.hPutStr'(_8304814,_8300888)),_8304648,_8304654,_8304660).
'blocked_blocked_System.IO.hPutStr_2'('FAIL'(_8306996),_8300468,'FAIL'(_8306996),_8307010,_8307010):-nonvar(_8306996).

'System.IO.hPutStrLn'(_8307924,_8307926,_8307928,_8307930,_8307932):-freeze(_8307930,'blocked_System.IO.hPutStrLn'(_8307924,_8307926,_8307928,_8307930,_8307932)).
'blocked_System.IO.hPutStrLn'(_8308020,_8308038,_8308684,_8308690,_8308696):-makeShare(_8308020,_8308814),hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'23Prelude.Monad\'23Prelude.IO\'23','System.IO.hPutStr'(_8308814,_8308038)),'System.IO.hPutChar'(_8308814,'^010')),_8308684,_8308690,_8308696).

'System.IO.hPrint'(_8311624,_8311626,_8311628,_8311630,_8311632):-freeze(_8311630,'blocked_System.IO.hPrint'(_8311624,_8311626,_8311628,_8311630,_8311632)).
'blocked_System.IO.hPrint'(_8311720,_8311738,_8312076,_8312082,_8312088):-hnf('Prelude..'(partcall(1,'System.IO.hPutStrLn',[_8311738]),'Prelude.show'(_8311720)),_8312076,_8312082,_8312088).

'System.IO.hIsReadable'(_8314128,_8314130,_8314132,_8314134):-freeze(_8314132,'blocked_System.IO.hIsReadable'(_8314128,_8314130,_8314132,_8314134)).
'blocked_System.IO.hIsReadable'(_8314214,_8314398,_8314404,_8314410):-hnf('Prelude.$#'(partcall(1,'System.IO.prim_hIsReadable',[]),_8314214),_8314398,_8314404,_8314410).

'System.IO.prim_hIsReadable'(_8315454,partcall(1,'System.IO.prim_hIsReadable$WORLD',[_8315454]),_8315838,_8315838).
'System.IO.prim_hIsReadable$WORLD'(_8316182,_8316184,_8316186,_8316188,_8316190):-freeze(_8316188,'blocked_System.IO.prim_hIsReadable$WORLD'(_8316182,_8316184,_8316186,_8316188,_8316190)).
'blocked_System.IO.prim_hIsReadable$WORLD'(_8316272,_8316278,'$io'(_8316290),_8316294,_8315838):-derefAll(_8316272,_8315454),'System.IO.prim_hIsReadable'(_8315454,_8316290),_8316294=_8315838.

'System.IO.hIsWritable'(_8317356,_8317358,_8317360,_8317362):-freeze(_8317360,'blocked_System.IO.hIsWritable'(_8317356,_8317358,_8317360,_8317362)).
'blocked_System.IO.hIsWritable'(_8317442,_8317626,_8317632,_8317638):-hnf('Prelude.$#'(partcall(1,'System.IO.prim_hIsWritable',[]),_8317442),_8317626,_8317632,_8317638).

'System.IO.prim_hIsWritable'(_8318682,partcall(1,'System.IO.prim_hIsWritable$WORLD',[_8318682]),_8319066,_8319066).
'System.IO.prim_hIsWritable$WORLD'(_8319410,_8319412,_8319414,_8319416,_8319418):-freeze(_8319416,'blocked_System.IO.prim_hIsWritable$WORLD'(_8319410,_8319412,_8319414,_8319416,_8319418)).
'blocked_System.IO.prim_hIsWritable$WORLD'(_8319500,_8319506,'$io'(_8319518),_8319522,_8319066):-derefAll(_8319500,_8318682),'System.IO.prim_hIsWritable'(_8318682,_8319518),_8319522=_8319066.

'System.IO.hIsTerminalDevice'(_8320812,_8320814,_8320816,_8320818):-freeze(_8320816,'blocked_System.IO.hIsTerminalDevice'(_8320812,_8320814,_8320816,_8320818)).
'blocked_System.IO.hIsTerminalDevice'(_8320898,_8321082,_8321088,_8321094):-hnf('Prelude.$#'(partcall(1,'System.IO.prim_hIsTerminalDevice',[]),_8320898),_8321082,_8321088,_8321094).

'System.IO.prim_hIsTerminalDevice'(_8322246,partcall(1,'System.IO.prim_hIsTerminalDevice$WORLD',[_8322246]),_8322702,_8322702).
'System.IO.prim_hIsTerminalDevice$WORLD'(_8323082,_8323084,_8323086,_8323088,_8323090):-freeze(_8323088,'blocked_System.IO.prim_hIsTerminalDevice$WORLD'(_8323082,_8323084,_8323086,_8323088,_8323090)).
'blocked_System.IO.prim_hIsTerminalDevice$WORLD'(_8323172,_8323178,'$io'(_8323190),_8323194,_8322702):-derefAll(_8323172,_8322246),'System.IO.prim_hIsTerminalDevice'(_8322246,_8323190),_8323194=_8322702.

'System.IO.hGetLine._\'23lambda7._\'23caseor0'(_8324958,_8324960,_8324962,_8324964,_8324966,_8324968):-freeze(_8324966,'blocked_System.IO.hGetLine._\'23lambda7._\'23caseor0'(_8324958,_8324960,_8324962,_8324964,_8324966,_8324968)).
'blocked_System.IO.hGetLine._\'23lambda7._\'23caseor0'(_8325064,_8325082,_8325100,_8326378,_8326384,_8326390):-hnf(_8325064,_8328284,_8326384,_8328308),'blocked_System.IO.hGetLine._\'23lambda7._\'23caseor0_1'(_8328284,_8325082,_8325100,_8326378,_8328308,_8326390).

'blocked_System.IO.hGetLine._\'23lambda7._\'23caseor0_1'(_8328824,_8328826,_8328828,_8328830,_8328832,_8328834):-freeze(_8328832,freeze(_8328824,'blocked_blocked_System.IO.hGetLine._\'23lambda7._\'23caseor0_1'(_8328824,_8328826,_8328828,_8328830,_8328832,_8328834))).
'blocked_blocked_System.IO.hGetLine._\'23lambda7._\'23caseor0_1'('Prelude.True',_8325082,_8325100,_8329228,_8329234,_8329240):-hnf('Prelude.apply'('Prelude._impl\'23return\'23Prelude.Monad\'23Prelude.IO\'23',[]),_8329228,_8329234,_8329240).
'blocked_blocked_System.IO.hGetLine._\'23lambda7._\'23caseor0_1'('Prelude.False',_8325082,_8325100,_8330804,_8330810,_8330816):-!,makeShare(_8325100,_8330940),hnf('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'3D\'23Prelude.Monad\'23Prelude.IO\'23','System.IO.hIsEOF'(_8330940)),partcall(1,'System.IO.hGetLine._\'23lambda7._\'23lambda10',[_8330940,_8325082])),_8330804,_8330810,_8330816).
'blocked_blocked_System.IO.hGetLine._\'23lambda7._\'23caseor0_1'('FAIL'(_8333300),_8325082,_8325100,'FAIL'(_8333300),_8333314,_8333314).

:-costCenters(['']).




%%%%% Number of shared variables: 11

:-style_check(-singleton).
'System.IO.handle_eq'(_8333406,_8333408,_8333410):-_8333406=_8333408->_8333410='Prelude.True';_8333410='Prelude.False'.
'System.IO.stdin'(_8333514):-stdInputStream(_8333514).
'System.IO.stdout'(_8333564):-stdOutputStream(_8333564).
'System.IO.stderr'(_8333614):-stdErrorStream(_8333614).
'System.IO.prim_openFile'(_8333664,_8333666,_8333668):-string2Atom(_8333664,_8333674),curryFileMode2plmode(_8333666,_8333680),fileOpenOptions(_8333684),open(_8333674,_8333680,_8333668,_8333684).
curryFileMode2plmode('System.IO.ReadMode',read).
curryFileMode2plmode('System.IO.WriteMode',write).
curryFileMode2plmode('System.IO.AppendMode',append).
'System.IO.prim_hClose'(_8333906,'Prelude.()'):-catch(try_prim_hClose(_8333906),_8333918,true).
try_prim_hClose('$stream'('$inoutstream'(_8333974,_8333976))):-!,flush_output(_8333976),close(_8333976),(_8333974==_8333976->true;close(_8333974)).
try_prim_hClose(_8334078):-(isOutputStream(_8334078)->flush_output(_8334078);true),close(_8334078).
'System.IO.prim_hFlush'('$stream'('$inoutstream'(_8334154,_8334156)),'Prelude.()'):-!,flush_output(_8334156).
'System.IO.prim_hFlush'(_8334230,'Prelude.()'):-isOutputStream(_8334230)->flush_output(_8334230);true.
'System.IO.prim_hIsEOF'('$stream'('$inoutstream'(_8334306,_8334308)),_8334318):-!,(atEndOfStream(_8334306)->_8334318='Prelude.True';_8334318='Prelude.False').
'System.IO.prim_hIsEOF'(_8334406,_8334408):-atEndOfStream(_8334406)->_8334408='Prelude.True';_8334408='Prelude.False'.
'System.IO.prim_hSeek'(_8334490,_8334492,_8334494,'Prelude.()'):-currySeekMode2plmode(_8334492,_8334502),seek(_8334490,_8334494,_8334502,_8334512).
currySeekMode2plmode('System.IO.AbsoluteSeek',bof).
currySeekMode2plmode('System.IO.RelativeSeek',current).
currySeekMode2plmode('System.IO.SeekFromEnd',eof).
prim_hWaitForInput(_8335004,_8335006,_8335008,_8335010,_8335012):-freeze(_8335010,blocked_prim_hWaitForInput(_8335004,_8335006,_8335008,_8335010,_8335012)).
blocked_prim_hWaitForInput(_8335098,_8335092,partcall(1,exec_hWaitForInput,[_8335092,_8335098]),_8335118,_8335118).
exec_hWaitForInput(_8335472,_8335474,_8335476,_8335478,_8335480,_8335482):-freeze(_8335480,blocked_exec_hWaitForInput(_8335472,_8335474,_8335476,_8335478,_8335480,_8335482)).
blocked_exec_hWaitForInput(_8335572,_8335574,_8335576,'$io'(_8335568),_8335580,_8335582):-exec_hWaitForInputs([_8335572],_8335574,_8335576,'$io'(_8335594),_8335580,_8335608),(_8335594=0->_8335568='Prelude.True';_8335568='Prelude.False'),!,_8335608=_8335582.
prim_hWaitForInputs(_8336038,_8336040,_8336042,_8336044,_8336046):-freeze(_8336044,blocked_prim_hWaitForInputs(_8336038,_8336040,_8336042,_8336044,_8336046)).
blocked_prim_hWaitForInputs(_8336132,_8336126,partcall(1,exec_hWaitForInputs,[_8336126,_8336132]),_8336152,_8336152).
exec_hWaitForInputs(_8336512,_8336514,_8336516,_8336518,_8336520,_8336522):-freeze(_8336520,blocked_exec_hWaitForInputs(_8336512,_8336514,_8336516,_8336518,_8336520,_8336522)).
blocked_exec_hWaitForInputs(_8336612,_8336614,_8336616,'$io'(_8336608),_8336620,_8336622):-user:derefAll(_8336612,_8336628),selectInstreams(_8336628,_8336640),user:derefRoot(_8336614,_8336646),waitForInputDataOnStreams(_8336640,_8336646,_8336608),!,_8336620=_8336622.
selectInstreams([],[]).
selectInstreams(['$stream'('$inoutstream'(_8336828,_8336830))|_8336840],[_8336828|_8336848]):-!,selectInstreams(_8336840,_8336848).
selectInstreams([_8336922|_8336924],[_8336922|_8336932]):-selectInstreams(_8336924,_8336932).
'System.IO.prim_hGetChar'('$stream'('$inoutstream'(_8336998,_8337000)),_8337010):-!,get_code(_8336998,_8337016),char_int(_8337010,_8337016).
'System.IO.prim_hGetChar'(_8337088,_8337090):-get_code(_8337088,_8337096),char_int(_8337090,_8337096).
'System.IO.prim_hPutChar'('$stream'('$inoutstream'(_8337162,_8337164)),_8337174,'Prelude.()'):-!,char_int(_8337174,_8337182),put_code(_8337164,_8337182).
'System.IO.prim_hPutChar'(_8337262,_8337264,'Prelude.()'):-char_int(_8337264,_8337272),put_code(_8337262,_8337272).
'System.IO.prim_hIsReadable'('$stream'('$inoutstream'(_8337346,_8337348)),'Prelude.True'):-!.
'System.IO.prim_hIsReadable'(_8337412,_8337414):-isInputStream(_8337412)->_8337414='Prelude.True';_8337414='Prelude.False'.
'System.IO.prim_hIsWritable'('$stream'('$inoutstream'(_8337496,_8337498)),'Prelude.True'):-!.
'System.IO.prim_hIsWritable'(_8337562,_8337564):-isOutputStream(_8337562)->_8337564='Prelude.True';_8337564='Prelude.False'.
'System.IO.prim_hIsTerminalDevice'('$stream'('$inoutstream'(_8337646,_8337648)),_8337658):-!,prim_hIsTerminalDevice(_8337648,_8337658).
'System.IO.prim_hIsTerminalDevice'(_8337724,_8337726):-isTerminalDeviceStream(_8337724)->_8337726='Prelude.True';_8337726='Prelude.False'.
