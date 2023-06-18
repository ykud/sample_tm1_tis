601,100
602,"SysHttpResponseGetHeader"
562,"CHARACTERDELIMITED"
586,"model_upload\2.headers.csv"
585,"model_upload\2.headers.csv"
564,
565,"efe;Va;Mc=t;rSJ]l9]BQnzsNE9mkDbv1A7=n\EvgMD:<u5ViUMH<ecLC@:`V`DHmK;0E9W@oT5K3<gF8OHrEKqEso7@\vysAEFZ4C1]@sG[r2]]So;Hb=^wzpF\rA1`H3DKmF\<pbFf;@oLPZmNVS<p`BLrb=]u]Sg7ylBwxPwsR@=rI3gagSPawC`3Z<HkCocHl0l<"
559,1
928,0
593,
594,
595,
597,
598,
596,
800,
801,
566,0
567,","
588,"."
589,","
568,""""
570,
571,
569,2
592,0
599,1000
560,2
pRequestId
pKey
561,2
2
2
590,2
pRequestId,"0"
pKey,""
637,2
pRequestId,"Request to check"
pKey,"Header to return"
577,2
vKey
vValue
578,2
2
2
579,2
1
2
580,2
0
0
581,2
0
0
582,2
VarType=32ColType=827
VarType=32ColType=827
603,0
572,10
#****Begin: Generated Statements***
#****End: Generated Statements****
sSourceFile = Expand('http\%pRequestId%.headers.csv');
StringSessionVariable('SysHttpHeader');

#Assign Source file
DataSourceType = 'CHARACTERDELIMITED';
DatasourceNameForServer = sSourceFile;
DatasourceNameForClient = sSourceFile;
DatasourceASCIIHeaderRecords=0;
573,3
#****Begin: Generated Statements***
#****End: Generated Statements****

574,5
#****Begin: Generated Statements***
#****End: Generated Statements****
if (vKey @= pKey);
  SysHttpHeader=vValue;
endif;
575,4
#****Begin: Generated Statements***
#****End: Generated Statements****


576,_ParameterConstraints=e30=
930,0
638,1
804,0
1217,0
900,
901,
902,
938,0
937,
936,
935,
934,
932,0
933,0
903,
906,
929,
907,
908,
904,0
905,0
909,0
911,
912,
913,
914,
915,
916,
917,0
918,1
919,0
920,50000
921,""
922,""
923,0
924,""
925,""
926,""
927,""
