Select 
TO_UTCTIME(timegenerated) as Date, 
EventID, 
CASE EventID 
	WHEN 1149 THEN STRCAT(EXTRACT_TOKEN(strings, 1, '|'),STRCAT('\\',EXTRACT_TOKEN(strings, 0, '|'))) 
	WHEN 39 THEN '' 
	WHEN 40 THEN '' 
	ELSE EXTRACT_TOKEN(strings, 0, '|') 
END as User, 
CASE EventID 
	WHEN 21 THEN 'Session logon succeeded' 
	WHEN 22 THEN 'Shell start notification received' 
	WHEN 23 THEN 'Session logoff succeeded' 
	WHEN 24 THEN 'Session has been disconnected' 
	WHEN 25 THEN 'Session reconnection succeeded' 
	WHEN 39 THEN STRCAT('Session ',STRCAT(EXTRACT_TOKEN(strings, 0, '|'),STRCAT(' has been disconnected by session ',EXTRACT_TOKEN(strings, 1, '|')))) 
	WHEN 40 THEN STRCAT('Session ',STRCAT(EXTRACT_TOKEN(strings, 0, '|'),' has been disconnected')) 
	WHEN 1149 THEN 'User authentication succeeded' 
END as Description, 
CASE EventID 
	WHEN 1149 THEN '' 
	WHEN 39 THEN EXTRACT_TOKEN(strings, 0, '|') 
	WHEN 40 THEN EXTRACT_TOKEN(strings, 0, '|') 
	ELSE EXTRACT_TOKEN(strings, 1, '|') 
END as SessionID, 
CASE EventID 
	WHEN 39 THEN EXTRACT_TOKEN(strings, 1, '|') 
END AS SourceSessionID, 
CASE EventID 
	WHEN 40 THEN 
		CASE EXTRACT_TOKEN(strings, 1, '|') 
		WHEN '0' THEN 'No additional information is available' 
		WHEN '1' THEN 'An application initiated the disconnection' 
		WHEN '2' THEN 'An application logged off the client' 
		WHEN '3' THEN 'The server has disconnected the client because the client has been idle for a period of time longer than the designated time-out period' 
		WHEN '4' THEN 'The server has disconnected the client because the client has exceeded the period designated for connection' 
		WHEN '5' THEN 'The clients connection was replaced by another connection' 
		WHEN '6' THEN 'No memory is available' 
		WHEN '7' THEN 'The server denied the connection' 
		WHEN '8' THEN 'The server denied the connection for security reasons' 
		WHEN '9' THEN 'The server denied the connection for security reasons' 
		WHEN '10' THEN 'Fresh credentials are required' 
		WHEN '11' THEN 'User activity has initiated the disconnect' 
		WHEN '12' THEN 'The user logged off, disconnecting the session' 
		WHEN '256' THEN 'Internal licensing error' 
		WHEN '257' THEN 'No license server was available' 
		WHEN '258' THEN 'No valid software license was available' 
		WHEN '259' THEN 'The remote computer received a licensing message that was not valid' 
		WHEN '260' THEN 'The hardware ID does not match the one designated on the software license' 
		WHEN '261' THEN 'Client license error' 
		WHEN '262' THEN 'Network problems occurred during the licensing protocol' 
		WHEN '263' THEN 'The client ended the licensing protocol prematurely' 
		WHEN '264' THEN 'A licensing message was encrypted incorrectly' 
		WHEN '265' THEN 'The local computers client access license could not be upgraded or renewed' 
		WHEN '266' THEN 'The remote computer is not licensed to accept remote connections' 
		WHEN '267' THEN 'An access denied error was received while creating a registry key for the license store' 
		WHEN '768' THEN 'Invalid credentials were encountered' 
		ELSE EXTRACT_TOKEN(strings, 1, '|') 
	END 
END as ReasonCode, 
EXTRACT_TOKEN(strings, 2, '|') as SourceIP,
SourceName,
'%host%' AS HostName
INTO '.\OUTLOG\%host%-RDP-activity.csv' 
FROM '.\%host%\*.evtx' 
WHERE (SourceName = 'Microsoft-Windows-TerminalServices-LocalSessionManager' 
	AND (EventID = 21 or EventID = 22 or EventID = 23 or EventID = 24 or EventID = 25 or EventID = 39 or EventID = 40)) 
	OR (SourceName = 'Microsoft-Windows-TerminalServices-RemoteConnectionManager' AND EventID = 1149)