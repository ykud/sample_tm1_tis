See description in the [blog post](https:///ykud.com/blog/pa11-executehttprequest)

A sample of how these TIs can be run:
```
NumericSessionVariable('SysHttpStatus');
StringSessionVariable('SysHttpBody');
# Create a new process from file
sProcessBody = '@http\request_body.txt';
ExecuteProcess( 'Sys ExecuteHttpRequest', 
  'pRequestId',sRequestId,
  'pMethod', 'Post',
  'pUrl','http://localhost:55130/api/v1/Processes',
  'pBody',sProcessBody,
  'pAuthorizationType','CAMNamespace',
  'pCredentialToBase64Encode',Expand('%sUser%:%sPassword%:%sNamespace%'),
  'pHeader1Name','content-type',
  'pHeader1Value','application/json'
  );
ExecuteProcess('SysHttpResponseGetStatusCode',  'pRequestId',sRequestId);
ExecuteProcess('SysHttpResponseGetBody',  'pRequestId',sRequestId);
Logoutput('info','Status ' | NumberTOString(SysHttpStatus) | ' body : ' | SysHttpBody);
# rin the process
ExecuteProcess( 'SysExecuteHttpRequest', 
  'pRequestId',sRequestId,
  'pMethod', 'Post',
  'pUrl','http://localhost:55130/api/v1/Processes(''''MyProcess'''')/tm1.ExecuteWithReturn',
  'pBody','',
  'pAuthorizationType','CAMNamespace',
  'pCredentialToBase64Encode',Expand('%sUser%:%sPassword%:%sNamespace%'),
  'pHeader1Name','content-type',
  'pHeader1Value','application/json'
  );
ExecuteProcess('SysHttpResponseGetStatusCode',  'pRequestId',sRequestId);
ExecuteProcess('SysHttpResponseGetBody',  'pRequestId',sRequestId);
StringSessionVariable('SysHttpHeader');
ExecuteProcess('SysHttpResponseGetHeader',  'pRequestId',sRequestId,'pKey','OData-Version');
Logoutput('info','Status ' | NumberTOString(SysHttpStatus) | ' body : ' | SysHttpBody | ' header ' | SysHttpHeader);
```
