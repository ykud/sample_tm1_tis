601,100
602,"SYS TM1Login Update"
562,"CHARACTERDELIMITED"
586,"tm1login.log"
585,"tm1login.log"
564,
565,"xta\Qv1;AkQfIjGaSGu<6hQ4anGBc:Q23k;Qgk5?HBLq<mGLCg\f;n2`zY0f^ZZ>LYRy^GJ9_zKLGtegN`a6A9t6T?qujbjXmTCapIIl6[r:9lNUFe1KV5M=oJ;2aU115zz7p0\8pJ7ABM\]EIvjP?I^>KY^poY9cB5Yv23gOKRMUopU3ei^9Cbvv96YeK8KA:8p]vpC"
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
567,"	"
588,"."
589,","
568,""
570,
571,
569,0
592,0
599,1000
560,1
pLogFile
561,1
2
590,1
pLogFile,""
637,1
pLogFile,"Log file to process, tm1login.log by default"
577,1
vLogLine
578,1
2
579,1
1
580,1
0
581,1
0
582,1
VarType=32ColType=827
603,0
572,58

#****Begin: Generated Statements***
#****End: Generated Statements****

# This process will generate a simple 2 dimensional cube for analysing user logins
# Cube name SYS TM1 Login:
#   * SYS TM1 Client -- client name dimension with "All Clients' consolidation
#   * SYS TM1 Login Time -- datetime dimension with 'All Time' consolidation and Year / Month / Day / Hour hieararchy. Hours would be the lowest leves of the dimension
# This process will CellPutN 1s in the hours where client logged in to make it possible to run it over the same imput multiple times
# Counting logins and having more granularity is not interesting from teh license tracking point of view (even hours are superficial), especially since Tm1Web websheets in PaW generate a separate login session, so counts would be way off

sLogFieldDelimiter='  ';
# Check whether dimensions / cube exist and create if not
if (DimensionExists('SYS TM1 Login Client') = 0);
    DimensionCreate('SYS TM1 Login Client');
    DimensionSortOrder('SYS TM1 Login Client', 'ByName', 'Ascending','ByHierarchy', 'Ascending');
endif;
if (Dimix('SYS TM1 Login Client', 'All Clients') = 0);
    DimensionElementInsert('SYS TM1 Login Client', '', 'All Clients', 'C');
endif;
if (DimensionExists('SYS TM1 Login Time') = 0);
    DimensionCreate('SYS TM1 Login Time');
    DimensionSortOrder('SYS TM1 Login Time', 'ByName', 'Ascending','ByHierarchy', 'Ascending');
endif;
if (Dimix('SYS TM1 Login Time', 'All Time') = 0);
    DimensionElementInsert('SYS TM1 Login Time', '', 'All Time', 'C');
endif;
if (CubeExists('SYS TM1 Login') = 0);
    CubeCreate('SYS TM1 Login', 'SYS TM1 Login Client', 'SYS TM1 Login Time');
    CubeRuleDestroy('SYS TM1 Login');
    CubeRuleAppend('SYS TM1 Login', 'SkipCheck;',1);
    CubeRuleAppend('SYS TM1 Login', '[] = C: ConsolidatedCountUnique (2, ''SYS TM1 Login Client'', ''SYS TM1 Login'', !SYS TM1 Login Client, !SYS TM1 Login Time);',1);
endif;

CellPutS('NO','}CubeProperties','SYS TM1 Login', 'LOGGING');

# Datasource is the tm1login.log file in the log folder by default
if (pLogFile @<>'');
    sLogFile = pLogFile;
else;
    sLogFile = GetProcessErrorFileDirectory | 'tm1login.log';
endif;

if (FileExists(sLogFile) = 1);
    DataSourceType = 'CHARACTERDELIMITED';
    DatasourceNameForServer = sLogFile;
    DatasourceNameForClient = sLogFile;
    DatasourceASCIIDelimiter=Char(9);
    DatasourceASCIIQuoteCharacter=Char(39);
    DatasourceASCIIHeaderRecords=0;
else;
    logoutput('error', 'Connot open the log file: ' | sLogFile);  
    DataSourceType = 'NULL';
endif;


nLogLines = 0;
nLogInLines = 0;
573,71

#****Begin: Generated Statements***
#****End: Generated Statements****

#we're only interested in login sucessfull lines
if (Scan('Login Success:', vLogLine) <> 0);
    # Parse logLine
    sLogStr = vLogLine;
    i = 1;
    while (Scan(sLogFieldDelimiter, sLogStr) <> 0);
        sSubstr = Subst(sLogStr, 1, Scan(sLogFieldDelimiter, sLogStr) );
        sLogStr = Subst(sLogStr, Scan(sLogFieldDelimiter, sLogStr) + Long(sLogFieldDelimiter), Long(sLogStr));
        # here we can parse what we need
        if (i = 1);
            sId = sSubstr;
        elseif ( i = 2 );
            sThreadId = sSubstr;
        elseif ( i = 3 );
            sLevel = sSubstr;
        elseif ( i = 4 );
            sTimestamp = sSubstr;
        elseif ( i = 5 );
            sModule = sSubstr;
        else;
            sCouldnotparse = sSubstr;
        endif;
        i = i + 1;
    end;
    sMessage = sLogStr;
    sUser = Subst(sMessage, Scan('User',sMessage) + Long('User'), Long(sMessage));
   
    sUpdateCube = 'Yes';
    if (dimix('}Clients', sUser) = 0);
        # must be a chore
        sUpdateCube = 'No';
	# check the CAMID and use the display name 
	elseif (DimensionExists('}ElementAttributes_}Clients') <> 0);
		 if (Dimix('}ElementAttributes_}Clients', '}TM1_DefaultDisplayValue') <> 0);
			sUserDisplayName = AttrS('}Clients', sUser, '}TM1_DefaultDisplayValue');
			if (sUserDisplayName @<> '');
				sUser = sUserDisplayName;
			endif;
		endif;
    endif;
    
    # parse time stamp
    sYear = Subst(sTimestamp, 1, 5);
    sMonth = Subst(sTimestamp, 7, 2);
    sDay = Subst(sTimestamp, 10, 2);
    sHour = Subst(sTimestamp, 13, 2);
    
    sTimeELement = sYear |'-'|sMonth | '-' | sDay | ' ' |sHour;
    sDayConso =  sYear |'-'|sMonth | '-' | sDay;
    sMonthConso = sYear |'-'|sMonth;
    sYearConso = sYear;
    if (sUpdateCube @= 'Yes');
        # 
        DimensionElementInsert('SYS TM1 Login Time', '', sYearConso, 'C');
        DimensionElementInsert('SYS TM1 Login Time', '', sMonthConso, 'C');
        DimensionElementInsert('SYS TM1 Login Time', '', sDayConso, 'C');
        DimensionElementInsert('SYS TM1 Login Time', '', sTimeELement, 'N');
        DimensionElementComponentAdd('SYS TM1 Login Time', sDayConso, sTimeELement, 1);
        DimensionElementComponentAdd('SYS TM1 Login Time', sMonthConso, sDayConso, 1);
        DimensionElementComponentAdd('SYS TM1 Login Time', sYearConso, sMonthConso, 1);
        DimensionElementComponentAdd('SYS TM1 Login Time', 'All Time', sYearConso, 1);
        #
        DimensionElementInsert('SYS TM1 Login Client', '', sUser, 'N');
        DimensionElementComponentAdd('SYS TM1 Login Client', 'All Clients', sUser, 1);
    endif;
    nLogInLines = nLogInLines + 1;
endif;
574,51

#****Begin: Generated Statements***
#****End: Generated Statements****

if (Scan('Login Success:', vLogLine) <> 0);
    # Parse logLine
    sLogStr = vLogLine;
    i = 1;
    while (Scan(sLogFieldDelimiter, sLogStr) <> 0);
        sSubstr = Subst(sLogStr, 1, Scan(sLogFieldDelimiter, sLogStr) );
        sLogStr = Subst(sLogStr, Scan(sLogFieldDelimiter, sLogStr) + Long(sLogFieldDelimiter), Long(sLogStr));
        # here we can parse what we need
        if (i = 1);
            sId = sSubstr;
        elseif ( i = 2 );
            sThreadId = sSubstr;
        elseif ( i = 3 );
            sLevel = sSubstr;
        elseif ( i = 4 );
            sTimestamp = sSubstr;
        elseif ( i = 5 );
            sModule = sSubstr;
        else;
            sCouldnotparse = sSubstr;
        endif;
        i = i + 1;
    end;
    sMessage = sLogStr;
    sUser = Subst(sMessage, Scan('User',sMessage) + Long('User'), Long(sMessage));
    if (dimix('}Clients', sUser) = 0);
	# check the CAMID and use the display name 
    elseif (DimensionExists('}ElementAttributes_}Clients') <> 0);
	 if (Dimix('}ElementAttributes_}Clients', '}TM1_DefaultDisplayValue') <> 0);
		sUserDisplayName = AttrS('}Clients', sUser, '}TM1_DefaultDisplayValue');
		if (sUserDisplayName @<> '');
			sUser = sUserDisplayName;
		endif;
	endif;
        # parse time stamp
        sYear = Subst(sTimestamp, 1, 5);
        sMonth = Subst(sTimestamp, 7, 2);
        sDay = Subst(sTimestamp, 10, 2);
        sHour = Subst(sTimestamp, 13, 2);
    
        sTimeELement = sYear |'-'|sMonth | '-' | sDay | ' ' |sHour;
        CellPutN(1, 'SYS TM1 Login' , sUser, sTimeElement);
    endif;
    nLogInLines = nLogInLines + 1;
endif;

nLogLines = nLogLines + 1;
575,5

#****Begin: Generated Statements***
#****End: Generated Statements****

logoutput('info', 'Read ' | NumberToString(nLogInLines) | ':' | NumberToString(nLogLines) | ' login:total lines from file ' | sLogFile);
576,CubeAction=1511DataAction=1503CubeLogChanges=0
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
