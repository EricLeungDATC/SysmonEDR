SELECT 
TO_UTCTIME(TimeGenerated) AS Date, 
EventID, 
CASE EventID 
	WHEN 4624 THEN 'An account was successfully logged on' 
	WHEN 4625 THEN 'An account failed to log on' 
	WHEN 4634 THEN 'An account was logged off' 
	WHEN 4647 THEN 'User initiated logoff' 
	WHEN 4648 THEN 'A logon was attempted using explicit credentials' 
	WHEN 4672 THEN 'Special privileges assigned to new logon' 
	WHEN 4778 THEN 'A session was reconnected to a Window Station' 
	WHEN 4779 THEN 'A session was disconnected from a Window Station' 
	WHEN 4800 THEN 'The workstation was locked' 
	WHEN 4801 THEN 'The workstation was unlocked' 
	WHEN 4802 THEN 'The screen saver was invoked' 
	WHEN 4803 THEN 'The screen saver was dismissed' 
END as Description, 
CASE EventID 
	WHEN 4624 THEN EXTRACT_TOKEN(Strings, 5, '|') 
	WHEN 4625 THEN EXTRACT_TOKEN(Strings, 5, '|') 
	WHEN 4634 THEN EXTRACT_TOKEN(Strings, 1, '|') 
	WHEN 4647 THEN EXTRACT_TOKEN(Strings, 1, '|') 
	WHEN 4648 THEN EXTRACT_TOKEN(Strings, 1, '|') 
	WHEN 4672 THEN EXTRACT_TOKEN(Strings, 1, '|') 
	WHEN 4778 THEN EXTRACT_TOKEN(Strings, 0, '|') 
	WHEN 4779 THEN EXTRACT_TOKEN(Strings, 0, '|') 
	WHEN 4800 THEN EXTRACT_TOKEN(Strings, 1, '|') 
	WHEN 4801 THEN EXTRACT_TOKEN(Strings, 1, '|') 
	WHEN 4802 THEN EXTRACT_TOKEN(Strings, 1, '|') 
	WHEN 4803 THEN EXTRACT_TOKEN(Strings, 1, '|') 
END as Username, 
CASE EventID 
	WHEN 4624 THEN EXTRACT_TOKEN(Strings, 6, '|') 
	WHEN 4625 THEN EXTRACT_TOKEN(Strings, 6, '|') 
	WHEN 4634 THEN EXTRACT_TOKEN(Strings, 2, '|') 
	WHEN 4647 THEN EXTRACT_TOKEN(Strings, 2, '|') 
	WHEN 4648 THEN EXTRACT_TOKEN(Strings, 2, '|') 
	WHEN 4672 THEN EXTRACT_TOKEN(Strings, 2, '|') 
	WHEN 4778 THEN EXTRACT_TOKEN(Strings, 1, '|') 
	WHEN 4779 THEN EXTRACT_TOKEN(Strings, 1, '|') 
	WHEN 4800 THEN EXTRACT_TOKEN(Strings, 2, '|') 
	WHEN 4801 THEN EXTRACT_TOKEN(Strings, 2, '|') 
	WHEN 4802 THEN EXTRACT_TOKEN(Strings, 2, '|') 
	WHEN 4803 THEN EXTRACT_TOKEN(Strings, 2, '|') 
END as Domain, 
CASE EventID 
	WHEN 4648 THEN STRCAT(EXTRACT_TOKEN(Strings, 6, '|'),STRCAT('\\',EXTRACT_TOKEN(Strings, 5, '|'))) 
END AS CredentialsUsed, 
CASE EventID WHEN 4624 THEN EXTRACT_TOKEN(Strings, 7, '|') 
	WHEN 4624 THEN EXTRACT_TOKEN(Strings, 7, '|') 
	WHEN 4634 THEN EXTRACT_TOKEN(Strings, 3, '|') 
	WHEN 4647 THEN EXTRACT_TOKEN(Strings, 3, '|') 
	WHEN 4648 THEN EXTRACT_TOKEN(Strings, 3, '|') 
	WHEN 4672 THEN EXTRACT_TOKEN(Strings, 3, '|') 
	WHEN 4778 THEN EXTRACT_TOKEN(Strings, 2, '|') 
	WHEN 4779 THEN EXTRACT_TOKEN(Strings, 2, '|') 
	WHEN 4800 THEN EXTRACT_TOKEN(Strings, 3, '|') 
	WHEN 4801 THEN EXTRACT_TOKEN(Strings, 3, '|') 
	WHEN 4802 THEN EXTRACT_TOKEN(Strings, 3, '|') 
	WHEN 4803 THEN EXTRACT_TOKEN(Strings, 3, '|') 
END AS LogonID, 
CASE EventID 
	WHEN 4778 THEN EXTRACT_TOKEN(Strings, 3, '|') 
	WHEN 4779 THEN EXTRACT_TOKEN(Strings, 3, '|') 
	WHEN 4800 THEN EXTRACT_TOKEN(Strings, 4, '|') 
	WHEN 4801 THEN EXTRACT_TOKEN(Strings, 4, '|') 
	WHEN 4802 THEN EXTRACT_TOKEN(Strings, 4, '|') 
	WHEN 4803 THEN EXTRACT_TOKEN(Strings, 4, '|') 
END AS SessionName, 
REPLACE_STR(
	REPLACE_STR(
		REPLACE_STR(
			REPLACE_STR(
				REPLACE_STR(
					REPLACE_STR(
						REPLACE_STR(
							REPLACE_STR(
								REPLACE_STR(
									REPLACE_STR(
										REPLACE_STR(
											CASE EventID 
												WHEN 4624 THEN EXTRACT_TOKEN(Strings, 8, '|') 
												WHEN 4625 THEN EXTRACT_TOKEN(Strings, 10, '|') 
												WHEN 4634 THEN EXTRACT_TOKEN(Strings, 4, '|') END,'2','Logon via console'
										),'3','Network Logon'
									),'4','Batch Logon'
								),'5','Windows Service Logon'
							),'7','Credentials used to unlock screen'
						),'8','Network logon sending credentials (cleartext)'
					),'9','Different credentials used than logged on user'
				),'10','Remote interactive logon (RDP)'
			),'11','Cached credentials used to logon'
		),'12','Cached remote interactive (similar to Type 10)'
	),'13','Cached unlock (similar to Type 7)'
) AS LogonType, 
CASE EventID 
	WHEN 4625 THEN 
		CASE EXTRACT_TOKEN(strings, 7, '|') 
			WHEN '0xc000005e' THEN 'There are currently no logon servers available to service the logon request' 
			WHEN '0xc0000064' THEN 'user name does not exist' 
			WHEN '0xc000006a' THEN 'user name is correct but the password is wrong' 
			WHEN '0xc000006d' THEN 'user logon with misspelled or bad password' 
			WHEN '0xc000006e' THEN 'unknown user name or bad password' 
			WHEN '0xc000006f' THEN 'user tried to logon outside his day of week or time of day restrictions' 
			WHEN '0xc0000070' THEN 'workstation restriction, or Authentication Policy Silo violation (look for event ID 4820 on domain controller)' 
			WHEN '0xc0000071' THEN 'expired password' 
			WHEN '0xc0000072' THEN 'account is currently disabled' 
			WHEN '0xc00000dc' THEN 'Indicates the Sam Server was in the wrong state to perform the desired operation.' 
			WHEN '0xc0000133' THEN 'clocks between DC and other computer too far out of sync' 
			WHEN '0xc000015b' THEN 'The user has not been granted the requested logon type (aka logon right) at this machine' 
			WHEN '0xc000018c' THEN 'The logon request failed because the trust relationship between the primary domain and the trusted domain failed' 
			WHEN '0xc0000192' THEN 'An attempt was made to logon, but the netlogon service was not started' 
			WHEN '0xc0000193' THEN 'account expiration' 
			WHEN '0xc0000224' THEN 'user is required to change password at next logon' 
			WHEN '0xc0000225' THEN 'evidently a bug in Windows and not a risk' 
			WHEN '0xc0000234' THEN 'user is currently locked out' 
			WHEN '0xc00002ee' THEN 'Failure Reason. An Error occurred during Logon' 
			WHEN '0xc0000413' THEN 'Logon Failure. The machine you are logging onto is protected by an authentication firewall. The specified account is not allowed to authenticate to the machine' 
			ELSE EXTRACT_TOKEN(strings, 7, '|') 
		END 
END AS Status, 
CASE EventID 
	WHEN 4625 THEN 
		CASE EXTRACT_TOKEN(strings, 9, '|') 
			WHEN '0xc000005e' THEN 'There are currently no logon servers available to service the logon request' 
			WHEN '0xc0000064' THEN 'user name does not exist' 
			WHEN '0xc000006a' THEN 'user name is correct but the password is wrong' 
			WHEN '0xc000006d' THEN 'user logon with misspelled or bad password' 
			WHEN '0xc000006e' THEN 'unknown user name or bad password' 
			WHEN '0xc000006f' THEN 'user tried to logon outside his day of week or time of day restrictions' 
			WHEN '0xc0000070' THEN 'workstation restriction, or Authentication Policy Silo violation (look for event ID 4820 on domain controller)' 
			WHEN '0xc0000071' THEN 'expired password' 
			WHEN '0xc0000072' THEN 'account is currently disabled' 
			WHEN '0xc00000dc' THEN 'Indicates the Sam Server was in the wrong state to perform the desired operation.' 
			WHEN '0xc0000133' THEN 'clocks between DC and other computer too far out of sync' 
			WHEN '0xc000015b' THEN 'The user has not been granted the requested logon type (aka logon right) at this machine' 
			WHEN '0xc000018c' THEN 'The logon request failed because the trust relationship between the primary domain and the trusted domain failed' 
			WHEN '0xc0000192' THEN 'An attempt was made to logon, but the netlogon service was not started' 
			WHEN '0xc0000193' THEN 'account expiration' 
			WHEN '0xc0000224' THEN 'user is required to change password at next logon' 
			WHEN '0xc0000225' THEN 'evidently a bug in Windows and not a risk' 
			WHEN '0xc0000234' THEN 'user is currently locked out' 
			WHEN '0xc00002ee' THEN 'Failure Reason. An Error occurred during Logon' 
			WHEN '0xc0000413' THEN 'Logon Failure. The machine you are logging onto is protected by an authentication firewall. The specified account is not allowed to authenticate to the machine' 
			ELSE EXTRACT_TOKEN(strings, 9, '|') 
		END 
END AS SubStatus, 
CASE EventID 
	WHEN 4624 THEN EXTRACT_TOKEN(strings, 9, '|') 
	WHEN 4625 THEN EXTRACT_TOKEN(strings, 11, '|') 
END AS AuthPackage, 
CASE EventID 
	WHEN 4624 THEN EXTRACT_TOKEN(Strings, 11, '|') 
	WHEN 4625 THEN EXTRACT_TOKEN(Strings, 13, '|') 
	WHEN 4648 THEN EXTRACT_TOKEN(Strings, 8, '|') 
	WHEN 4778 THEN EXTRACT_TOKEN(Strings, 4, '|') 
	WHEN 4779 THEN EXTRACT_TOKEN(Strings, 4, '|') 
END AS Workstation, 
CASE EventID 
	WHEN 4624 THEN EXTRACT_TOKEN(Strings, 18, '|') 
	WHEN 4625 THEN EXTRACT_TOKEN(Strings, 19, '|') 
	WHEN 4648 THEN EXTRACT_TOKEN(Strings, 12, '|') 
	WHEN 4778 THEN EXTRACT_TOKEN(Strings, 5, '|') 
	WHEN 4779 THEN EXTRACT_TOKEN(Strings, 5, '|') 
END AS SourceIP,
SourceName,
'%host%' AS HostName
INTO '.\OUTLOG\%host%-logon-activity.csv' 
FROM '.\%host%\Security.evtx' 
WHERE EventID IN (4624;4625;4634;4647;4648;4672;4778;4779;4800;4801;4802;4803) 
	AND Username NOT IN ('SYSTEM'; 'ANONYMOUS LOGON'; 'LOCAL SERVICE'; 'NETWORK SERVICE') 
	AND Domain NOT IN ('NT AUTHORITY')