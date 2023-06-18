601,100
602,"SysExecuteHttpRequest"
562,"NULL"
586,
585,
564,
565,"h6\\@sqcasngZKOT\B<tTbNPW81aF^V_ViU47KN:y[FvGR8=8fn_`o90TV<Ml_\OL:lQ@X?eOlAxneFiGNMKNPkjNIN4kpG?3\`j<u4mXVSLVw:dafx_ytqFpS3Zp>P_XTKCs5HIqqrs59CZXecUj[KGU5M^bOqFkXm`gOC\WlIzwCH9UM3JH6E\bJMDZK6lFL?1U1bu"
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
569,0
592,0
599,1000
560,20
pRequestId
pMethod
pUrl
pBody
pAuthorizationType
pCredentialToBase64Encode
pWriteResponseToFile
pCertificateFile
pIgnoreTLSValidation
pHeader1Name
pHeader1Value
pHeader2Name
pHeader2Value
pHeader3Name
pHeader3Value
pHeader4Name
pHeader4Value
pHeader5Name
pHeader5Value
pCreateHttpFolder
561,20
2
2
2
2
2
2
2
2
2
2
2
2
2
2
2
2
2
2
2
2
590,20
pRequestId,"0"
pMethod,""
pUrl,""
pBody,""
pAuthorizationType,""
pCredentialToBase64Encode,""
pWriteResponseToFile,""
pCertificateFile,""
pIgnoreTLSValidation,""
pHeader1Name,""
pHeader1Value,""
pHeader2Name,""
pHeader2Value,""
pHeader3Name,""
pHeader3Value,""
pHeader4Name,""
pHeader4Value,""
pHeader5Name,""
pHeader5Value,""
pCreateHttpFolder,"Yes"
637,20
pRequestId,"Request Id we use for tracking responses"
pMethod,"The method of the HTTP request. Supported methods are GET, POST, PATCH, PUT and DELETE"
pUrl,"# The URL where you want to execute the request. The URL must use the HTTP or HTTPS protocol."
pBody,"The request body. When started with an @ character, the body will be read from the file having the name found following the @ character."
pAuthorizationType," can be Basic / Negotiate / CAMNamespace"
pCredentialToBase64Encode,"We will encode this in base64, user:password for basic or user:password:namespace for CAM"
pWriteResponseToFile,"file to which the response is written."
pCertificateFile,"Custom CA certificate file"
pIgnoreTLSValidation,"Not implemented"
pHeader1Name,""
pHeader1Value,""
pHeader2Name,""
pHeader2Value,""
pHeader3Name,""
pHeader3Value,""
pHeader4Name,""
pHeader4Value,""
pHeader5Name,""
pHeader5Value,""
pCreateHttpFolder,"Create a folder to store  response files"
577,0
578,0
579,0
580,0
581,0
582,0
603,0
572,139
#****Begin: Generated Statements***
#****End: Generated Statements****

# how long to store http request files
nResponseFileRetentionDays = 5;

if (pCreateHttpFolder @= 'Yes');
  # we need a folder to store http responses
  ExecuteCommand( 'cmd /c if not exist http mkdir http', 1 );
endif;

# Powershell script name
sScriptFile = 'http\iwr_' | pRequestId |'_' | TimSt( Now, '\Y\m\d\h\i\s' ) | '_' | NumberToString(RAND()*10000) | '.ps1';
DatasourceASCIIDelimiter='';
DatasourceASCIIQuoteCharacter = '';
# let's write the script
TextOutput( sScriptFile, '#our request tracking ID' );
TextOutput( sScriptFile, Expand(  '$RequestId = "%pRequestId%"') );
TextOutput( sScriptFile, 'Start-Transcript -Path "http\${RequestId}_transcript.log"' );

TextOutput( sScriptFile, '#remove old response files' );

TextOutput( sScriptFile,'Get-ChildItem –Path "http" -Recurse | Where-Object {($_.LastWriteTime -lt (Get-Date).AddDays(-'|NumberToString( nResponseFileRetentionDays )|'))} | Remove-Item');


TextOutput( sScriptFile,'# pass the parameters from TI');
TextOutput( sScriptFile,'# ExecuteHttpRequest parameter: The method of the HTTP request. Supported methods are GET, POST, PATCH, PUT and DELETE');
TextOutput( sScriptFile, Expand ('$Method = "%pMethod%"') );

TextOutput( sScriptFile,'# ExecuteHttpRequest parameter  The URL where you want to execute the request. The URL must use the HTTP or HTTPS protocol.');
TextOutput( sScriptFile, '$Url = '''|pUrl|''' ' );

TextOutput( sScriptFile,'#  ExecuteHttpRequest parameter The request body. When started with an @ character, the body will be read from the file having the name found following the @ character.');
TextOutput( sScriptFile, Expand ('$Body = ''%pBody%''') );

TextOutput( sScriptFile, '# ExecuteHttpRequest parameter: ' );
TextOutput( sScriptFile, '# -u user The basic user credential' );
TextOutput( sScriptFile, '# We do it as 2 different parameters' );
TextOutput( sScriptFile, '# special type of header for Authorization, we need it for PA Rest API to do Base64' );
TextOutput( sScriptFile, '# $AuthorizationType can be Basic / Negotiate / CAMNamespace' );
TextOutput( sScriptFile, Expand('$AuthorizationType = "%pAuthorizationType%"'));

TextOutput( sScriptFile, '# this parameter will be base64 encoded' );
TextOutput( sScriptFile, Expand( '$CredentialToBase64Encode = "%pCredentialToBase64Encode%"') );


TextOutput( sScriptFile, '#ExecuteHttpRequest parameter: -o filename' );
TextOutput( sScriptFile, '#The file to which the response is written.' );
TextOutput( sScriptFile, Expand('$WriteResponseToFile = "%pWriteResponseToFile%"') );

TextOutput( sScriptFile, '# ExecuteHttpRequest parameter: -c certificate_file' );
TextOutput( sScriptFile, '# A custom CA certificate file' );
TextOutput( sScriptFile, Expand('$CertificateFile = "%pCertificateFile%"' ));

TextOutput( sScriptFile, '# ExecuteHttpRequest parameter:  -k or $IgnoreTLSValidation = ""' );
TextOutput( sScriptFile, '# can be done as IWR SkipCertificateCheck, but that available on only in Powershell 6.0 and 5.2 is installed by default' );
 
TextOutput( sScriptFile, '# ExecuteHttpRequest parameter -h header' );
TextOutput( sScriptFile, '# The request header. A request can have multiple headers.' );
TextOutput( sScriptFile, '# Multiple headers' );
TextOutput( sScriptFile, Expand('$Header1Name = "%pHeader1Name%" ') );
TextOutput( sScriptFile, Expand('$Header1Value = "%pHeader1Value%" ') );
TextOutput( sScriptFile, Expand('$Header2Name = "%pHeader2Name%" ') );
TextOutput( sScriptFile, Expand('$Header2Value = "%pHeader2Value%" ') );
TextOutput( sScriptFile, Expand('$Header3Name = "%pHeader3Name%" ') );
TextOutput( sScriptFile, Expand('$Header3Value = "%pHeader3Value%" ') );
TextOutput( sScriptFile, Expand('$Header4Name = "%pHeader4Name%" ') );
TextOutput( sScriptFile, Expand('$Header4Value = "%pHeader4Value%" ') );
TextOutput( sScriptFile, Expand('$Header5Name = "%pHeader5Name%" ') );
TextOutput( sScriptFile, Expand('$Header5Value = "%pHeader5Value%" ') );


TextOutput( sScriptFile, '# files we are writing the response details to' );
TextOutput( sScriptFile, '$HttpFolder = "http\"' );
TextOutput( sScriptFile, '$ResponseFile = "${HttpFolder}${RequestId}.response"' );
TextOutput( sScriptFile, '$BodyFile = "${HttpFolder}${RequestId}.body"' );
TextOutput( sScriptFile, '$SessionVariableFile = "${HttpFolder}${RequestId}.sv"' );
TextOutput( sScriptFile, '$HeadersFile = "${HttpFolder}${RequestId}.headers"' );
TextOutput( sScriptFile, '$StatusFile = "${HttpFolder}${RequestId}.status"' );
TextOutput( sScriptFile, '#Headers - a an array we are adding to' );
TextOutput( sScriptFile, '$RequestHeaders = @{}' );

TextOutput( sScriptFile, '#loop through passed in headers and append' );
TextOutput( sScriptFile, 'for ($i = 1; $i -le 5; $i++) {' );
TextOutput( sScriptFile, '    $HeaderName = Get-Variable -Name "Header${i}Name" -ValueOnly' );
TextOutput( sScriptFile, '    if ($HeaderName) {' );
TextOutput( sScriptFile, '        $HeaderValue = Get-Variable -Name "Header${i}Value" -ValueOnly' );
TextOutput( sScriptFile, '        $RequestHeaders.add($HeaderName,$HeaderValue)   ' );
TextOutput( sScriptFile, '    }' );
TextOutput( sScriptFile, '}' );

TextOutput( sScriptFile, '#Encode credentials if passed through directly' );
TextOutput( sScriptFile, 'if ($AuthorizationType -and $CredentialToBase64Encode) {' );
TextOutput( sScriptFile, '    $CredentialBytes = [System.Text.Encoding]::UTF8.GetBytes($CredentialToBase64Encode)' );
TextOutput( sScriptFile, '    # Encode string content to Base64 string' );
TextOutput( sScriptFile, '    $Base64Credential =[Convert]::ToBase64String($CredentialBytes)' );
TextOutput( sScriptFile, '    $RequestHeaders.add("Authorization","${AuthorizationType} ${Base64Credential}")   ' );
TextOutput( sScriptFile, '}' );

TextOutput( sScriptFile, '# Build parameters for Invoke Web Request' );
TextOutput( sScriptFile, '$InvokeWebRequestParameters = @{"Uri"=$Url;"Headers"=$RequestHeaders;"UseBasicParsing"=$true}' );
TextOutput( sScriptFile, 'if ($Method) { $InvokeWebRequestParameters.add("Method","$Method")}' );
TextOutput( sScriptFile, 'if ($Body) {' );
TextOutput( sScriptFile, '    # check if it starts with @ and read it from a file if it does' );
TextOutput( sScriptFile, '    if ($Body.SubString(0,1) -eq "@") {' );
TextOutput( sScriptFile, '        $FilePath = $Body.SubString(1,$Body.Length - 1  )' );
TextOutput( sScriptFile, '		$BodyFromFile = Get-Content -Path $FilePath -Raw ' );
TextOutput( sScriptFile, '		$InvokeWebRequestParameters.add("Body","$BodyFromFile")' );
TextOutput( sScriptFile, '    }' );
TextOutput( sScriptFile, '    else { $InvokeWebRequestParameters.add("Body","$Body") }   ' );
TextOutput( sScriptFile, '}' );

TextOutput( sScriptFile, '#check if we have a cookies file already and read from $Session from it if it exists' );
TextOutput( sScriptFile, 'if (Test-Path $SessionVariableFile -PathType Leaf) {' );
TextOutput( sScriptFile, '    $WebSession = Import-Clixml -Path $SessionVariableFile' );
TextOutput( sScriptFile, '    $InvokeWebRequestParameters.add("SessionVariable", ''$WebSession'' ) ');
TextOutput( sScriptFile, '}' );
TextOutput( sScriptFile, 'else {' );
TextOutput( sScriptFile, '    $InvokeWebRequestParameters.add("SessionVariable",''WebSession'')' );
TextOutput( sScriptFile, '}' );

TextOutput( sScriptFile, '# Finally run request' );
TextOutput( sScriptFile, 'try {' );
TextOutput( sScriptFile, '    $Response = Invoke-WebRequest @InvokeWebRequestParameters' );
TextOutput( sScriptFile, '    Out-File -FilePath $ResponseFile -InputObject $Response.RawContent' );
TextOutput( sScriptFile, '} ' );
TextOutput( sScriptFile, 'catch {' );
TextOutput( sScriptFile, '    $Response = $_.Exception.Response' );
TextOutput( sScriptFile, '    Out-File -FilePath $ResponseFile -InputObject $Response   ' );
TextOutput( sScriptFile, '} ' );
TextOutput( sScriptFile, '# write results' );
TextOutput( sScriptFile, '$Response.Headers.GetEnumerator() | Export-Csv  -Path "${HeadersFile}.csv"' );
TextOutput( sScriptFile, 'Out-File -FilePath $BodyFile -InputObject $Response.Content' );
TextOutput( sScriptFile, 'Out-File -FilePath $StatusFile -InputObject $([int]$Response.StatusCode)' );
TextOutput( sScriptFile, '$WebSession | export-clixml -path $SessionVariableFile' );

TextOutput( sScriptFile, 'if ($WriteResponseToFile) {Out-File -FilePath $WriteResponseToFile -InputObject $Response.Content}  ' );
TextOutput( sScriptFile, 'Stop-Transcript' );

573,3
#****Begin: Generated Statements***
#****End: Generated Statements****

574,3
#****Begin: Generated Statements***
#****End: Generated Statements****

575,7
#****Begin: Generated Statements***
#****End: Generated Statements****
# let's run the script
ExecuteCommand( 'powershell.exe -File ' | sScriptFile , 1);
# and remove it as it can contain sensistive information
ASCIIDelete( sScriptFile );

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
