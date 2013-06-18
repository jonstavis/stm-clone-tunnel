tell application "System Events"
	tell process "SSH Tunnel Manager"
		with timeout of 0 seconds
			# if preference window is not open, open it now
			if not (window "Preferences" exists) then
				click button "Configuration" of window 1
			end if
			
			# continually show a dialog until user has selected a tunnel to clone or decides to exit
			set _status to 0
			repeat while _status = 0
				if not (text field 4 of window "Preferences" exists) then
					display dialog "Please select an existing tunnel to clone from the list and click OK." buttons {"OK", "Cancel"} default button 1
					if result = {button returned:"Cancel"} then
						return
					end if
				else
					set _status to 1
				end if
			end repeat
			
			# get all the values from source tunnel
			set _name to value of text field 4 of window "Preferences"
			set _login to value of text field 3 of window "Preferences"
			set _host to value of text field 2 of window "Preferences"
			set _port to value of text field 1 of window "Preferences"
			set _localRedirects to {}
			set _remoteRedirects to {}
			set _rows to rows of table 1 of scroll area 3 of window "Preferences"
			repeat with _row in _rows
				set _locLP to value of text field 1 of _row
				set _locRH to value of text field 2 of _row
				set _locRP to value of text field 3 of _row
				set end of _localRedirects to {_locLP, _locRH, _locRP}
			end repeat
			set _rows to rows of table 1 of scroll area 2 of window "Preferences"
			repeat with _row in _rows
				set _remRP to value of text field 1 of _row
				set _remLH to value of text field 2 of _row
				set _remLP to value of text field 3 of _row
				set end of _remoteRedirects to {_remRP, _remLH, _remLP}
			end repeat
			set _optionsChecked to value of checkbox "Options..." of window "Preferences"
			if _optionsChecked = 0 then click checkbox "Options..." of window "Preferences"
			delay (0.25)
			set _autoConnect to value of checkbox "Auto connect" of drawer 1 of window "Preferences"
			set _handleAuth to value of checkbox "Handle authentication" of drawer 1 of window "Preferences"
			set _compress to value of checkbox "Compress" of drawer 1 of window "Preferences"
			set _forceV1 to value of checkbox "Force v1 protocol" of drawer 1 of window "Preferences"
			set _allowLAN to value of checkbox "Allow LAN connections" of drawer 1 of window "Preferences"
			set _enableSOCKS4 to value of checkbox "Enable SOCKS4 proxy" of drawer 1 of window "Preferences"
			set _port to value of text field 1 of drawer 1 of window "Preferences"
			set _cryptMethod to value of pop up button 1 of drawer 1 of window "Preferences"
			set _cryptDefined to true
			try
				get _cryptMethod
			on error
				set _cryptDefined to false
			end try
			
			# copy all values to new tunnel			
			click button 5 of window "Preferences"
			delay (0.5)
			set value of text field 4 of window "Preferences" to "Clone of " & _name
			set value of text field 3 of window "Preferences" to _login
			set value of text field 2 of window "Preferences" to _host
			set value of text field 1 of window "Preferences" to _port
			
			# focus the first two text fields as it appears that moving focus from one to the other updates the name properly in the table view			
			set focused of text field 4 of window "Preferences" to true
			set focused of text field 3 of window "Preferences" to true
			
			repeat with _localRedirect in _localRedirects
				click button 7 of window "Preferences"
				delay (0.5)
				set value of text field 1 of last row of table 1 of scroll area 3 of window "Preferences" to item 1 in _localRedirect
				set value of text field 2 of last row of table 1 of scroll area 3 of window "Preferences" to item 2 in _localRedirect
				set value of text field 3 of last row of table 1 of scroll area 3 of window "Preferences" to item 3 in _localRedirect
			end repeat
			repeat with _remoteRedirect in _remoteRedirects
				click button 6 of window "Preferences"
				delay (0.5)
				set focused of text field 1 of last row of table 1 of scroll area 2 of window "Preferences" to true
				set value of text field 1 of last row of table 1 of scroll area 2 of window "Preferences" to item 1 in _remoteRedirect
				set value of text field 2 of last row of table 1 of scroll area 2 of window "Preferences" to item 2 in _remoteRedirect
				set value of text field 3 of last row of table 1 of scroll area 2 of window "Preferences" to item 3 in _remoteRedirect
			end repeat
			
			set _optionsChecked to value of checkbox "Options..." of window "Preferences"
			if _optionsChecked = 0 then click checkbox "Options..." of window "Preferences"
			delay (0.25)
			
			set _tmp to value of checkbox "Auto connect" of drawer 1 of window "Preferences"
			if _tmp is not equal to _autoConnect then click checkbox "Auto connect" of drawer 1 of window "Preferences"
			
			set _tmp to value of checkbox "Handle authentication" of drawer 1 of window "Preferences"
			if _tmp is not equal to _handleAuth then click checkbox "Handle authentication" of drawer 1 of window "Preferences"
			
			set _tmp to value of checkbox "Compress" of drawer 1 of window "Preferences"
			if _tmp is not equal to _compress then click checkbox "Compress" of drawer 1 of window "Preferences"
			
			set _tmp to value of checkbox "Force v1 protocol" of drawer 1 of window "Preferences"
			if _tmp is not equal to _forceV1 then click checkbox "Force v1 protocol" of drawer 1 of window "Preferences"
			
			set _tmp to value of checkbox "Allow LAN connections" of drawer 1 of window "Preferences"
			if _tmp is not equal to _allowLAN then click checkbox "Allow LAN connections" of drawer 1 of window "Preferences"
			
			set _tmp to value of checkbox "Enable SOCKS4 proxy" of drawer 1 of window "Preferences"
			if _tmp is not equal to _enableSOCKS4 then click checkbox "Enable SOCKS4 proxy" of drawer 1 of window "Preferences"
			
			set value of text field 1 of drawer 1 of window "Preferences" to _port
			if _cryptDefined is true then
				click pop up button 1 of drawer 1 of window "Preferences"
				click menu item _cryptMethod of menu of pop up button 1 of drawer 1 of window "Preferences"
			end if
			
			# refocus the second field as this appears to save things in the local and remote redirections scroll areas
			set focused of text field 3 of window "Preferences" to true
			set focused of text field 4 of window "Preferences" to true
		end timeout
	end tell
end tell