%PAKCS3.10 swi9 VARIABLESHARING

:-noSingletonWarnings.
:-noRedefineWarnings.
:-noDiscontiguousWarnings.

:-importModule('Control.Monad').
:-importModule('Prelude').
:-importModule('System.IO').
:-importModule('System.IO.Unsafe').

:-curryModule('Debug.Trace').


%%%%%%%%%%%% function types %%%%%%%%%%%%%%%%%%%
:-multifile functiontype/6.
:-dynamic functiontype/6.
functiontype('Debug.Trace.trace',trace,2,'Debug.Trace.trace',nofix,notype).
functiontype('Debug.Trace.traceId',traceId,1,'Debug.Trace.traceId',nofix,notype).
functiontype('Debug.Trace.traceShow',traceShow,3,'Debug.Trace.traceShow',nofix,notype).
functiontype('Debug.Trace.traceShowId',traceShowId,2,'Debug.Trace.traceShowId',nofix,notype).
functiontype('Debug.Trace.traceIO',traceIO,1,'Debug.Trace.traceIO',nofix,notype).
functiontype('Debug.Trace.assert',assert,3,'Debug.Trace.assert',nofix,notype).
functiontype('Debug.Trace.assertIO',assertIO,2,'Debug.Trace.assertIO',nofix,notype).

%%%%%%%%%%%% constructor types %%%%%%%%%%%%%%%%%%%
:-multifile constructortype/7.
:-dynamic constructortype/7.

%%%%%%%%%%%% function definitions %%%%%%%%%%%%%%%%%%%
'Debug.Trace.trace'(_5768254,_5768256,_5768258,_5768260,_5768262):-freeze(_5768260,'blocked_Debug.Trace.trace'(_5768254,_5768256,_5768258,_5768260,_5768262)).
'blocked_Debug.Trace.trace'(_5768350,_5768368,_5769042,_5769048,_5769054):-hnf('System.IO.Unsafe.unsafePerformIO'('Prelude.apply'('Prelude.apply'('Prelude._impl\'23\'3E\'3E\'23Prelude.Monad\'23Prelude.IO\'23','Debug.Trace.traceIO'(_5768350)),'Prelude.apply'('Prelude._impl\'23return\'23Prelude.Monad\'23Prelude.IO\'23',_5768368))),_5769042,_5769048,_5769054).

'Debug.Trace.traceId'(_5772370,_5772372,_5772374,_5772376):-freeze(_5772374,'blocked_Debug.Trace.traceId'(_5772370,_5772372,_5772374,_5772376)).
'blocked_Debug.Trace.traceId'(_5772456,_5772626,_5772632,_5772638):-makeShare(_5772456,_5772712),hnf('Debug.Trace.trace'(_5772712,_5772712),_5772626,_5772632,_5772638).

'Debug.Trace.traceShow'(_5774444,_5774446,_5774448,_5774450,_5774452,_5774454):-freeze(_5774452,'blocked_Debug.Trace.traceShow'(_5774444,_5774446,_5774448,_5774450,_5774452,_5774454)).
'blocked_Debug.Trace.traceShow'(_5774550,_5774568,_5774586,_5774994,_5775000,_5775006):-hnf('Debug.Trace.trace'('Prelude.apply'('Prelude.show'(_5774550),_5774568),_5774586),_5774994,_5775000,_5775006).

'Debug.Trace.traceShowId'(_5777308,_5777310,_5777312,_5777314,_5777316):-freeze(_5777314,'blocked_Debug.Trace.traceShowId'(_5777308,_5777310,_5777312,_5777314,_5777316)).
'blocked_Debug.Trace.traceShowId'(_5777404,_5777422,_5777830,_5777836,_5777842):-makeShare(_5777422,_5777966),hnf('Debug.Trace.trace'('Prelude.apply'('Prelude.show'(_5777404),_5777966),_5777966),_5777830,_5777836,_5777842).

'Debug.Trace.traceIO'(_5780156,_5780158,_5780160,_5780162):-freeze(_5780160,'blocked_Debug.Trace.traceIO'(_5780156,_5780158,_5780160,_5780162)).
'blocked_Debug.Trace.traceIO'(_5780242,_5780426,_5780432,_5780438):-hnf('System.IO.hPutStrLn'('System.IO.stderr',_5780242),_5780426,_5780432,_5780438).

'Debug.Trace.assert'(_5782016,_5782018,_5782020,_5782022,_5782024,_5782026):-freeze(_5782024,'blocked_Debug.Trace.assert'(_5782016,_5782018,_5782020,_5782022,_5782024,_5782026)).
'blocked_Debug.Trace.assert'(_5782122,_5782140,_5782158,_5782634,_5782640,_5782646):-hnf(_5782122,_5783676,_5782640,_5783700),'blocked_Debug.Trace.assert_1'(_5783676,_5782140,_5782158,_5782634,_5783700,_5782646).

'blocked_Debug.Trace.assert_1'(_5784072,_5784074,_5784076,_5784078,_5784080,_5784082):-freeze(_5784080,freeze(_5784072,'blocked_blocked_Debug.Trace.assert_1'(_5784072,_5784074,_5784076,_5784078,_5784080,_5784082))).
'blocked_blocked_Debug.Trace.assert_1'('Prelude.True',_5782140,_5782158,_5784476,_5784482,_5784488):-hnf(_5782158,_5784476,_5784482,_5784488).
'blocked_blocked_Debug.Trace.assert_1'('Prelude.False',_5782140,_5782158,_5785272,_5785278,_5785284):-!,hnf('Prelude.error'(_5782140),_5785272,_5785278,_5785284).
'blocked_blocked_Debug.Trace.assert_1'('FAIL'(_5785964),_5782140,_5782158,'FAIL'(_5785964),_5785978,_5785978).

'Debug.Trace.assertIO'(_5786934,_5786936,_5786938,_5786940,_5786942):-freeze(_5786940,'blocked_Debug.Trace.assertIO'(_5786934,_5786936,_5786938,_5786940,_5786942)).
'blocked_Debug.Trace.assertIO'(_5787030,_5787048,_5787470,_5787476,_5787482):-hnf('Prelude.$'(partcall(1,'Control.Monad.unless',[_5787030,partcall(1,'Prelude._inst\'23Prelude.Applicative\'23Prelude.IO\'23',[])]),'Prelude.error'(_5787048)),_5787470,_5787476,_5787482).

:-costCenters(['']).




%%%%% Number of shared variables: 2

