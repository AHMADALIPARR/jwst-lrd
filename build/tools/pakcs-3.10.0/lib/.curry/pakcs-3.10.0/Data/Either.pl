%PAKCS3.10 swi9 VARIABLESHARING

:-noSingletonWarnings.
:-noRedefineWarnings.
:-noDiscontiguousWarnings.

:-importModule('Prelude').

:-curryModule('Data.Either').


%%%%%%%%%%%% function types %%%%%%%%%%%%%%%%%%%
:-multifile functiontype/6.
:-dynamic functiontype/6.
functiontype('Data.Either.lefts',lefts,1,'Data.Either.lefts',nofix,notype).
functiontype('Data.Either.lefts._\'23lambda3','Data.Either.lefts._#lambda3',2,'Data.Either.lefts._\'23lambda3',nofix,notype).
functiontype('Data.Either.rights',rights,1,'Data.Either.rights',nofix,notype).
functiontype('Data.Either.rights._\'23lambda7','Data.Either.rights._#lambda7',2,'Data.Either.rights._\'23lambda7',nofix,notype).
functiontype('Data.Either.isLeft',isLeft,1,'Data.Either.isLeft',nofix,notype).
functiontype('Data.Either.isRight',isRight,1,'Data.Either.isRight',nofix,notype).
functiontype('Data.Either.fromLeft',fromLeft,1,'Data.Either.fromLeft',nofix,notype).
functiontype('Data.Either.fromRight',fromRight,1,'Data.Either.fromRight',nofix,notype).
functiontype('Data.Either.partitionEithers',partitionEithers,0,'Data.Either.partitionEithers',nofix,notype).
functiontype('Data.Either.partitionEithers.left.24','Data.Either.partitionEithers.left.24',2,'Data.Either.partitionEithers.left.24',nofix,notype).
functiontype('Data.Either.partitionEithers.right.24','Data.Either.partitionEithers.right.24',2,'Data.Either.partitionEithers.right.24',nofix,notype).

%%%%%%%%%%%% constructor types %%%%%%%%%%%%%%%%%%%
:-multifile constructortype/7.
:-dynamic constructortype/7.

%%%%%%%%%%%% function definitions %%%%%%%%%%%%%%%%%%%
'Data.Either.lefts'(_3546140,_3546142,_3546144,_3546146):-freeze(_3546144,'blocked_Data.Either.lefts'(_3546140,_3546142,_3546144,_3546146)).
'blocked_Data.Either.lefts'(_3546226,_3546494,_3546500,_3546506):-hnf('Prelude.foldr'(partcall(2,'Data.Either.lefts._\'23lambda3',[]),[],_3546226),_3546494,_3546500,_3546506).

'Data.Either.lefts._\'23lambda3'(_3548592,_3548594,_3548596,_3548598,_3548600):-freeze(_3548598,'blocked_Data.Either.lefts._\'23lambda3'(_3548592,_3548594,_3548596,_3548598,_3548600)).
'blocked_Data.Either.lefts._\'23lambda3'(_3548688,_3548706,_3549366,_3549372,_3549378):-hnf(_3548688,_3550796,_3549372,_3550814),'blocked_Data.Either.lefts._\'23lambda3_1'(_3550796,_3548706,_3549366,_3550814,_3549378).

'blocked_Data.Either.lefts._\'23lambda3_1'(_3551244,_3551246,_3551248,_3551250,_3551252):-freeze(_3551250,freeze(_3551244,'blocked_blocked_Data.Either.lefts._\'23lambda3_1'(_3551244,_3551246,_3551248,_3551250,_3551252))).
'blocked_blocked_Data.Either.lefts._\'23lambda3_1'('Prelude.Left'(_3548822),_3548706,[_3548822|_3548706],_3551654,_3551654).
'blocked_blocked_Data.Either.lefts._\'23lambda3_1'('Prelude.Right'(_3549086),_3548706,_3552708,_3552714,_3552720):-!,hnf(_3548706,_3552708,_3552714,_3552720).
'blocked_blocked_Data.Either.lefts._\'23lambda3_1'('FAIL'(_3553270),_3548706,'FAIL'(_3553270),_3553284,_3553284).

'Data.Either.rights'(_3554156,_3554158,_3554160,_3554162):-freeze(_3554160,'blocked_Data.Either.rights'(_3554156,_3554158,_3554160,_3554162)).
'blocked_Data.Either.rights'(_3554242,_3554510,_3554516,_3554522):-hnf('Prelude.foldr'(partcall(2,'Data.Either.rights._\'23lambda7',[]),[],_3554242),_3554510,_3554516,_3554522).

'Data.Either.rights._\'23lambda7'(_3556658,_3556660,_3556662,_3556664,_3556666):-freeze(_3556664,'blocked_Data.Either.rights._\'23lambda7'(_3556658,_3556660,_3556662,_3556664,_3556666)).
'blocked_Data.Either.rights._\'23lambda7'(_3556754,_3556772,_3557438,_3557444,_3557450):-hnf(_3556754,_3558904,_3557444,_3558922),'blocked_Data.Either.rights._\'23lambda7_1'(_3558904,_3556772,_3557438,_3558922,_3557450).

'blocked_Data.Either.rights._\'23lambda7_1'(_3559358,_3559360,_3559362,_3559364,_3559366):-freeze(_3559364,freeze(_3559358,'blocked_blocked_Data.Either.rights._\'23lambda7_1'(_3559358,_3559360,_3559362,_3559364,_3559366))).
'blocked_blocked_Data.Either.rights._\'23lambda7_1'('Prelude.Right'(_3556888),_3556772,[_3556888|_3556772],_3559780,_3559780).
'blocked_blocked_Data.Either.rights._\'23lambda7_1'('Prelude.Left'(_3557152),_3556772,_3560828,_3560834,_3560840):-!,hnf(_3556772,_3560828,_3560834,_3560840).
'blocked_blocked_Data.Either.rights._\'23lambda7_1'('FAIL'(_3561396),_3556772,'FAIL'(_3561396),_3561410,_3561410).

'Data.Either.isLeft'(_3562282,_3562284,_3562286,_3562288):-freeze(_3562286,'blocked_Data.Either.isLeft'(_3562282,_3562284,_3562286,_3562288)).
'blocked_Data.Either.isLeft'(_3562368,_3562836,_3562842,_3562848):-hnf(_3562368,_3563862,_3562842,_3563874),'blocked_Data.Either.isLeft_1'(_3563862,_3562836,_3563874,_3562848).

'blocked_Data.Either.isLeft_1'(_3564224,_3564226,_3564228,_3564230):-freeze(_3564228,'blocked_blocked_Data.Either.isLeft_1'(_3564224,_3564226,_3564228,_3564230)).
'blocked_blocked_Data.Either.isLeft_1'('Prelude.Left'(_3562484),'Prelude.True',_3564618,_3564618).
'blocked_blocked_Data.Either.isLeft_1'('Prelude.Right'(_3562608),'Prelude.False',_3565412,_3565412):-!.
'blocked_blocked_Data.Either.isLeft_1'('FAIL'(_3565898),'FAIL'(_3565898),_3565912,_3565912):-nonvar(_3565898).

'Data.Either.isRight'(_3566818,_3566820,_3566822,_3566824):-freeze(_3566822,'blocked_Data.Either.isRight'(_3566818,_3566820,_3566822,_3566824)).
'blocked_Data.Either.isRight'(_3566904,_3567378,_3567384,_3567390):-hnf(_3566904,_3568440,_3567384,_3568452),'blocked_Data.Either.isRight_1'(_3568440,_3567378,_3568452,_3567390).

'blocked_Data.Either.isRight_1'(_3568808,_3568810,_3568812,_3568814):-freeze(_3568812,'blocked_blocked_Data.Either.isRight_1'(_3568808,_3568810,_3568812,_3568814)).
'blocked_blocked_Data.Either.isRight_1'('Prelude.Left'(_3567020),'Prelude.False',_3569202,_3569202).
'blocked_blocked_Data.Either.isRight_1'('Prelude.Right'(_3567144),'Prelude.True',_3570008,_3570008):-!.
'blocked_blocked_Data.Either.isRight_1'('FAIL'(_3570494),'FAIL'(_3570494),_3570508,_3570508):-nonvar(_3570494).

'Data.Either.fromLeft'(_3571452,_3571454,_3571456,_3571458):-freeze(_3571456,'blocked_Data.Either.fromLeft'(_3571452,_3571454,_3571456,_3571458)).
'blocked_Data.Either.fromLeft'(_3571538,_3572410,_3572416,_3572422):-hnf(_3571538,_3573508,_3572416,_3573520),'blocked_Data.Either.fromLeft_1'(_3573508,_3572410,_3573520,_3572422).

'blocked_Data.Either.fromLeft_1'(_3573882,_3573884,_3573886,_3573888):-freeze(_3573886,'blocked_blocked_Data.Either.fromLeft_1'(_3573882,_3573884,_3573886,_3573888)).
'blocked_blocked_Data.Either.fromLeft_1'('Prelude.Left'(_3571654),_3574472,_3574478,_3574484):-!,hnf(_3571654,_3574472,_3574478,_3574484).
'blocked_blocked_Data.Either.fromLeft_1'('Prelude.Right'(_3571764),_3575226,_3575232,_3575238):-!,hnf(reportFailure4PAKCS('Data.Either.fromLeft',['Prelude.Right'(_3571764)]),_3575226,_3575232,_3575238).
'blocked_blocked_Data.Either.fromLeft_1'('FAIL'(_3576512),'FAIL'(_3576512),_3576526,_3576526).

'Data.Either.fromRight'(_3577504,_3577506,_3577508,_3577510):-freeze(_3577508,'blocked_Data.Either.fromRight'(_3577504,_3577506,_3577508,_3577510)).
'blocked_Data.Either.fromRight'(_3577590,_3578468,_3578474,_3578480):-hnf(_3577590,_3579602,_3578474,_3579614),'blocked_Data.Either.fromRight_1'(_3579602,_3578468,_3579614,_3578480).

'blocked_Data.Either.fromRight_1'(_3579982,_3579984,_3579986,_3579988):-freeze(_3579986,'blocked_blocked_Data.Either.fromRight_1'(_3579982,_3579984,_3579986,_3579988)).
'blocked_blocked_Data.Either.fromRight_1'('Prelude.Right'(_3577706),_3580584,_3580590,_3580596):-!,hnf(_3577706,_3580584,_3580590,_3580596).
'blocked_blocked_Data.Either.fromRight_1'('Prelude.Left'(_3577816),_3581332,_3581338,_3581344):-!,hnf(reportFailure4PAKCS('Data.Either.fromRight',['Prelude.Left'(_3577816)]),_3581332,_3581338,_3581344).
'blocked_blocked_Data.Either.fromRight_1'('FAIL'(_3582624),'FAIL'(_3582624),_3582638,_3582638).

'Data.Either.partitionEithers'(_3583882,_3583884,_3583886):-freeze(_3583884,'blocked_Data.Either.partitionEithers'(_3583882,_3583884,_3583886)).
'blocked_Data.Either.partitionEithers'(_3584474,_3584480,_3584486):-hnf(partcall(1,'Prelude.foldr',['Prelude.(,)'([],[]),partcall(1,'Prelude.either',[partcall(2,'Data.Either.partitionEithers.right.24',[]),partcall(2,'Data.Either.partitionEithers.left.24',[])])]),_3584474,_3584480,_3584486).

'Data.Either.partitionEithers.left.24'(_3587642,_3587644,_3587646,_3587648,_3587650):-freeze(_3587648,'blocked_Data.Either.partitionEithers.left.24'(_3587642,_3587644,_3587646,_3587648,_3587650)).
'blocked_Data.Either.partitionEithers.left.24'(_3587738,_3587756,_3588534,_3588540,_3588546):-hnf(_3587756,_3590216,_3588540,_3590234),'blocked_Data.Either.partitionEithers.left.24_2'(_3590216,_3587738,_3588534,_3590234,_3588546).

'blocked_Data.Either.partitionEithers.left.24_2'(_3590700,_3590702,_3590704,_3590706,_3590708):-freeze(_3590706,'blocked_blocked_Data.Either.partitionEithers.left.24_2'(_3590700,_3590702,_3590704,_3590706,_3590708)).
'blocked_blocked_Data.Either.partitionEithers.left.24_2'('Prelude.(,)'(_3587872,_3587890),_3587738,'Prelude.(,)'([_3587738|_3587872],_3587890),_3591086,_3591086):-!.
'blocked_blocked_Data.Either.partitionEithers.left.24_2'('FAIL'(_3592218),_3587738,'FAIL'(_3592218),_3592232,_3592232):-nonvar(_3592218).

'Data.Either.partitionEithers.right.24'(_3593830,_3593832,_3593834,_3593836,_3593838):-freeze(_3593836,'blocked_Data.Either.partitionEithers.right.24'(_3593830,_3593832,_3593834,_3593836,_3593838)).
'blocked_Data.Either.partitionEithers.right.24'(_3593926,_3593944,_3594728,_3594734,_3594740):-hnf(_3593944,_3596446,_3594734,_3596464),'blocked_Data.Either.partitionEithers.right.24_2'(_3596446,_3593926,_3594728,_3596464,_3594740).

'blocked_Data.Either.partitionEithers.right.24_2'(_3596936,_3596938,_3596940,_3596942,_3596944):-freeze(_3596942,'blocked_blocked_Data.Either.partitionEithers.right.24_2'(_3596936,_3596938,_3596940,_3596942,_3596944)).
'blocked_blocked_Data.Either.partitionEithers.right.24_2'('Prelude.(,)'(_3594060,_3594078),_3593926,'Prelude.(,)'(_3594060,[_3593926|_3594078]),_3597322,_3597322):-!.
'blocked_blocked_Data.Either.partitionEithers.right.24_2'('FAIL'(_3598460),_3593926,'FAIL'(_3598460),_3598474,_3598474):-nonvar(_3598460).

:-costCenters(['']).




%%%%% Number of shared variables: 0

