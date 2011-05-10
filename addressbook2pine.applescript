-- addressbook2pine.applescript
-- addressbook2pine

--  Created by patrick collins on 9/12/05.
-- Last updated 10/17/05.
--  Copyright 2005 Colliantor Studios, All rights reserved.



on will finish launching theObject
	set visible of window "paypal" to false
	set visible of window "preferences" to false
	set visible of window "alert" to false
	make new default entry at end of default entries of user defaults with properties {name:"distributionlist"}
	make new default entry at end of default entries of user defaults with properties {name:"nicknameid"}
	make new default entry at end of default entries of user defaults with properties {name:"usecompanyname"}
	make new default entry at end of default entries of user defaults with properties {name:"nickuses"}
	make new default entry at end of default entries of user defaults with properties {name:"commentuses"}
	make new default entry at end of default entries of user defaults with properties {name:"useemailid"}
	make new default entry at end of default entries of user defaults with properties {name:"emailidpref"}
	make new default entry at end of default entries of user defaults with properties {name:"idabbrev"}
	make new default entry at end of default entries of user defaults with properties {name:"fccpathswitch"}
	make new default entry at end of default entries of user defaults with properties {name:"fccpath"}
	make new default entry at end of default entries of user defaults with properties {name:"fccfolder"}
	make new default entry at end of default entries of user defaults with properties {name:"autobackupswitch"}
	make new default entry at end of default entries of user defaults with properties {name:"backuplocationtext"}
	make new default entry at end of default entries of user defaults with properties {name:"rememberswitch"}
	make new default entry at end of default entries of user defaults with properties {name:"pinelocation"}
	make new default entry at end of default entries of user defaults with properties {name:"pinemode"}
	make new default entry at end of default entries of user defaults with properties {name:"donation"}
	
	set dist to contents of default entry "distributionlist" of user defaults
	set nickuses to contents of default entry "nickuses" of user defaults
	set usecompanyname to contents of default entry "usecompanyname" of user defaults
	set nicknameid to contents of default entry "nicknameid" of user defaults
	set commentuses to contents of default entry "commentuses" of user defaults
	set useemailid to contents of default entry "useemailid" of user defaults
	set emailidpref to contents of default entry "emailidpref" of user defaults
	set idabbrev to contents of default entry "idabbrev" of user defaults
	set fccpathswitch to contents of default entry "fccpathswitch" of user defaults
	set fccpath to contents of default entry "fccpath" of user defaults
	set fccfolder to contents of default entry "fccfolder" of user defaults
	set autobackupswitch to contents of default entry "autobackupswitch" of user defaults
	set backuplocationtext to contents of default entry "backuplocationtext" of user defaults
	set rememberswitch to contents of default entry "rememberswitch" of user defaults
	set pinelocation to contents of default entry "pinelocation" of user defaults
	set pinemode to contents of default entry "pinemode" of user defaults
	set donation to contents of default entry "donation" of user defaults
	try
		dist
		nicknameid
		usecompanyname
		nickuses
		commentuses
		useemailid
		emailidpref
		idabbrev
		fccpathswitch
		fccpath
		fccfolder
		autobackupswitch
		backuplocationtext
		rememberswitch
		pinelocation
		pinemode
		donation
	on error
		my settheuserdefaults()
		set contents of default entry "pinelocation" of user defaults to ""
		set contents of default entry "backuplocationtext" of user defaults to ""
		set contents of default entry "donation" of user defaults to ""
		set donation to ""
		call method "synchronize" of object user defaults
	end try
	
	if donation ­ "true" then
		set visible of window "paypal" to true
		beep
	end if
	
end will finish launching

on changed
	set contents of default entry "fccpath" of user defaults to contents of text field "fccpath" of window "preferences"
end changed

on choose menu item theObject
	set checkpopup to name of theObject as string
	if checkpopup contains "pinemode" then
		set theselection to (title of current menu item of theObject as string)
		set contents of default entry "pinemode" of user defaults to theselection
		call method "synchronize" of object user defaults
		if theselection = "convert os x address book to pine" then
			my enablefieldspine()
		else if theselection = "convert pine .addressbook to os x" then
			my disablefieldspine()
		end if
	end if
	
	if checkpopup contains "nickuses" then
		set theselection to (title of current menu item of theObject as string)
		set contents of default entry "nickuses" of user defaults to theselection
		call method "synchronize" of object user defaults
	end if
	if checkpopup contains "commentuses" then
		set theselection to (title of current menu item of theObject as string)
		set contents of default entry "commentuses" of user defaults to theselection
		call method "synchronize" of object user defaults
	end if
	if checkpopup contains "emailidpref" then
		set theselection to (title of current menu item of theObject as string)
		set contents of default entry "emailidpref" of user defaults to theselection
		call method "synchronize" of object user defaults
	end if
	if checkpopup contains "fccfolder" then
		set theselection to (title of current menu item of theObject as string)
		set contents of default entry "fccfolder" of user defaults to theselection
		call method "synchronize" of object user defaults
		tell window "preferences"
			if theselection = "name" then
				set the contents of text field "fccfoldertext" to "(full name of contact will be used)"
			else if theselection = "group" then
				set the contents of text field "fccfoldertext" to "(first group ID of contact will be used)"
			else if theselection = "email" then
				set the contents of text field "fccfoldertext" to "(first email address of contact will be used)"
			else if theselection = "none" then
				set the contents of text field "fccfoldertext" to ""
			end if
		end tell
	end if
	if name of theObject is "preferences" then
		my setdefaults()
		set visible of window "preferences" to true
	end if
	
	if name of theObject is "donate" then
		tell application "System Events" to open location "https://www.paypal.com/cgi-bin/webscr?cmd=_xclick&business=patrick@collinatorstudios.com&item_name=addressbook2pine&no_shipping=1&no_note=1&tax=0&currency_code=USD&lc=US&bn=PP%2dDonationsBF&charset=UTF%2d8"
	end if
	
	if name of theObject is "visit" then
		tell application "System Events" to open location "http://collinatorstudios.com"
	end if
	
end choose menu item


on clicked theObject
	global skiplist
	global totalskip
	global preferencelist
	global successlist
	global successlistdetail
	global successful
	global pathinformation
	global backupinformation
	global autobackuplocation
	global fmode
	global VersionData
	set VersionData to word 2 of paragraph 2 of (do shell script "sw_vers")
	
	if name of theObject is "donate" then
		tell application "System Events" to open location "https://www.paypal.com/cgi-bin/webscr?cmd=_xclick&business=patrick@collinatorstudios.com&item_name=addressbook2pine&no_shipping=1&no_note=1&tax=0&currency_code=USD&lc=US&bn=PP%2dDonationsBF&charset=UTF%2d8"
	end if
	
	if name of theObject is "Done" then
		set visible of window "preferences" to false
	end if
	if name of theObject is "okbutton" then
		set visible of window "aboutaddressbook2pine" to false
	end if
	if name of theObject is "defaults" then
		my settheuserdefaults()
		my setdefaults()
	end if
	if name of theObject is "donated" then
		if (state of button "donated" of window "paypal" as boolean) then
			set contents of default entry "donation" of user defaults to "true"
		else
			set contents of default entry "donation" of user defaults to ""
		end if
		call method "synchronize" of object user defaults
	end if
	if name of theObject is "distributionlist" then
		if (state of button "distributionlist" of window "preferences" as boolean) then
			set contents of default entry "distributionlist" of user defaults to "on"
		else
			set contents of default entry "distributionlist" of user defaults to "off"
		end if
		call method "synchronize" of object user defaults
	end if
	
	if name of theObject is "companycards" then
		if (state of button "companycards" of window "preferences" as boolean) then
			set contents of default entry "usecompanyname" of user defaults to "on"
		else
			set contents of default entry "usecompanyname" of user defaults to "off"
		end if
		call method "synchronize" of object user defaults
	end if
	
	if name of theObject is "nicknameid" then
		if (state of button "nicknameid" of window "preferences" as boolean) then
			set contents of default entry "nicknameid" of user defaults to "on"
		else
			set contents of default entry "nicknameid" of user defaults to "off"
		end if
		call method "synchronize" of object user defaults
	end if
	
	if name of theObject is "useemailid" then
		if (state of button "useemailid" of window "preferences" as boolean) then
			set contents of default entry "useemailid" of user defaults to "on"
			tell window "preferences"
				set enabled of popup button "emailidpref" to true
				set enabled of matrix "idabbrev" to true
			end tell
		else
			set contents of default entry "useemailid" of user defaults to "off"
			tell window "preferences"
				set enabled of popup button "emailidpref" to false
				set enabled of matrix "idabbrev" to false
			end tell
		end if
		call method "synchronize" of object user defaults
	end if
	
	if name of theObject is "usefullid" then
		set contents of default entry "idabbrev" of user defaults to "off"
	end if
	
	if name of theObject is "useabbrev" then
		set contents of default entry "idabbrev" of user defaults to "on"
	end if
	
	if name of theObject is "fccpathswitch" then
		if (state of button "fccpathswitch" of window "preferences" as boolean) then
			set contents of default entry "fccpathswitch" of user defaults to "on"
			
			tell window "preferences"
				set enabled of text field "fccpath" to true
				set enabled of text field "fccfoldertext" to true
				set enabled of popup button "fccfolder" to true
			end tell
		else
			set contents of default entry "fccpathswitch" of user defaults to "off"
			tell window "preferences"
				set enabled of text field "fccpath" to false
				set enabled of text field "fccfoldertext" to false
				set enabled of popup button "fccfolder" to false
			end tell
		end if
		call method "synchronize" of object user defaults
	end if
	
	if name of theObject is "autobackupswitch" then
		if (state of button "autobackupswitch" of window "preferences" as boolean) then
			set contents of default entry "autobackupswitch" of user defaults to "on"
			tell window "preferences"
				set enabled of button "backuplocation" to true
			end tell
		else
			set contents of default entry "autobackupswitch" of user defaults to "off"
			tell window "preferences"
				set enabled of button "backuplocation" to false
			end tell
		end if
		call method "synchronize" of object user defaults
	end if
	
	if name of theObject is "rememberswitch" then
		if (state of button "rememberswitch" of window "preferences" as boolean) then
			set contents of default entry "rememberswitch" of user defaults to "on"
			tell window "preferences"
				set enabled of button "pinelocation" to true
			end tell
		else
			set contents of default entry "rememberswitch" of user defaults to "off"
			tell window "preferences"
				set enabled of button "pinelocation" to false
			end tell
		end if
		call method "synchronize" of object user defaults
	end if
	
	
	if name of theObject is "pinelocation" then
		set pinelocation to contents of default entry "pinelocation" of user defaults
		if pinelocation = "" then
			set browsepath to path to home folder
		else
			set browsepath to (pinelocation as POSIX file as Unicode text) as alias
		end if
		try
			set pinelocationmac to choose folder default location browsepath with prompt "Select folder where .addressbook file is to be saved" with invisibles
			set contents of default entry "pinelocation" of user defaults to POSIX path of pinelocationmac
			call method "synchronize" of object user defaults
			set contents of text field "pinelocationtext" of window "preferences" to "current location: " & contents of default entry "pinelocation" of user defaults
		end try
	end if
	
	
	if name of theObject is "backuplocation" then
		try
			set autobackuplocation to choose folder default location (path to home folder) with prompt "Select folder for OS X Address Book backups" with invisibles
			set contents of default entry "backuplocationtext" of user defaults to the POSIX path of the autobackuplocation
			call method "synchronize" of object user defaults
			set contents of text field "backuplocationtext" of window "preferences" to "current location: " & contents of default entry "backuplocationtext" of user defaults
		end try
	end if
	
	if name of theObject is "backuplocation2" then
		try
			set autobackuplocation to choose folder default location (path to home folder) with prompt "Select folder for OS X Address Book backups" with invisibles
			set contents of default entry "backuplocationtext" of user defaults to the POSIX path of the autobackuplocation
			call method "synchronize" of object user defaults
			set visible of window "alert" to false
			call method "performClick:" of (button "startbutton" of window "addressbook2pine")
		on error
			return
		end try
	end if
	
	if name of theObject is "details" then
		if (state of button "details1" of window "addressbook2pine" as boolean) and (state of theObject as boolean) then
			call method "performClick:" of (button "details1" of window "addressbook2pine")
		end if
		set theFrame to bounds of (window of theObject)
		--	call method "setHidden:" of (button "bigdetails" of window "addressbook2pine") with with parameter
		set enabled of button "bigdetails" of window "addressbook2pine" to false
		set title of button "bigdetails" of window "addressbook2pine" to ""
		tell my application "addressbook2pine"
			if totalskip = 1 then
				set skipmessage to (totalskip & " contact was not converted because it has no email address:" & return & return & skiplist) as string
			else
				set skipmessage to (totalskip & " contacts were not converted because they have no email address:" & return & return & skiplist) as string
			end if
			if totalskip = 0 and successful ­ 0 then
				set skipmessage to ("No contacts were skipped, all were successfully converted!" & return & return & pathinformation) as string
			else if totalskip = 0 and successful = 0 then
				set skipmessage to "No contacts found."
			end if
			if VersionData < "10.5" then
				tell text view "terminal" of scroll view "terminal" of window "addressbook2pine"
					set text color to {65535, 0, 0}
					set contents of text view "terminal" of scroll view "terminal" of window "addressbook2pine" to skipmessage
				end tell
			else
				tell scroll view "terminal" of window "addressbook2pine"
					set text color of text view "terminal" to {65535, 0, 0}
					set contents of text view "terminal" to skipmessage
				end tell
			end if
		end tell
		if (state of theObject as boolean) then
			set (item 2 of theFrame) to (item 2 of theFrame) - 250
		else
			set (item 2 of theFrame) to (item 2 of theFrame) + 250
		end if
		call method "setFrame:display:animate:" of (window of theObject) with parameters {theFrame, true, true}
	end if
	if name of theObject is "details1" then
		if (state of button "details" of window "addressbook2pine" as boolean) and (state of theObject as boolean) then
			call method "performClick:" of (button "details" of window "addressbook2pine")
		end if
		set theFrame to bounds of (window of theObject)
		--		call method "setHidden:" of (button "bigdetails" of window "addressbook2pine") without with parameter
		set enabled of button "bigdetails" of window "addressbook2pine" to true
		if (state of button "bigdetails" of window "addressbook2pine" as boolean) then
			set title of button "bigdetails" of window "addressbook2pine" to "click here for regular import details"
			tell my application "addressbook2pine"
				if successful = 1 then
					set successmessage to (fmode & backupinformation & pathinformation & successful & " contact was successfully converted:" & return & successlistdetail & preferencelist) as string
				else
					set successmessage to (fmode & backupinformation & pathinformation & successful & " contacts were successfully converted:" & return & successlistdetail & preferencelist) as string
				end if
				if successful = 0 and totalskip ­ 0 then
					set successmessage to "No contacts were successfully converted."
				else if successful = 0 and totalskip = 0 then
					set successmessage to "No contacts found."
				end if
				if VersionData < "10.5" then
					tell text view "terminal" of scroll view "terminal" of window "addressbook2pine"
						set text color to {0, 65535, 0}
						set contents of text view "terminal" of scroll view "terminal" of window "addressbook2pine" to successmessage
					end tell
				else
					tell scroll view "terminal" of window "addressbook2pine"
						set text color of text view "terminal" to {0, 65535, 0}
						set contents of text view "terminal" to successmessage
					end tell
				end if
			end tell
		else
			set title of button "bigdetails" of window "addressbook2pine" to "click here for more successful import details"
			tell my application "addressbook2pine"
				if successful = 1 then
					set successmessage to (fmode & successful & " contact was successfully converted:" & return & return & successlist) as string
				else
					set successmessage to (fmode & successful & " contacts were successfully converted:" & return & return & successlist) as string
				end if
				if successful = 0 and totalskip ­ 0 then
					set successmessage to "No contacts were successfully converted."
				else if successful = 0 and totalskip = 0 then
					set successmessage to "No contacts found."
				end if
				if VersionData < "10.5" then
					tell text view "terminal" of scroll view "terminal" of window "addressbook2pine"
						set text color to {0, 65535, 0}
						set contents of text view "terminal" of scroll view "terminal" of window "addressbook2pine" to successmessage
					end tell
				else
					tell scroll view "terminal" of window "addressbook2pine"
						set text color of text view "terminal" to {0, 65535, 0}
						set contents of text view "terminal" to successmessage
					end tell
				end if
			end tell
		end if
		if (state of theObject as boolean) then
			set (item 2 of theFrame) to (item 2 of theFrame) - 250
		else
			set (item 2 of theFrame) to (item 2 of theFrame) + 250
		end if
		call method "setFrame:display:animate:" of (window of theObject) with parameters {theFrame, true, true}
	end if
	
	if title of theObject is "click here for more successful import details" then
		if (state of button "bigdetails" of window "addressbook2pine" as boolean) then
			set title of button "bigdetails" of window "addressbook2pine" to "click here for regular import details"
			tell my application "addressbook2pine"
				if successful = 1 then
					set successmessage to (fmode & backupinformation & pathinformation & successful & " contact was successfully converted:" & return & successlistdetail & preferencelist) as string
				else
					set successmessage to (fmode & backupinformation & pathinformation & successful & " contacts were successfully converted:" & return & successlistdetail & preferencelist) as string
				end if
				if successful = 0 and totalskip ­ 0 then
					set successmessage to "No contacts were successfully converted."
				else if successful = 0 and totalskip = 0 then
					set successmessage to "No contacts found."
				end if
				if VersionData < "10.5" then
					tell text view "terminal" of scroll view "terminal" of window "addressbook2pine"
						set text color to {0, 65535, 0}
						set contents of text view "terminal" of scroll view "terminal" of window "addressbook2pine" to successmessage
					end tell
				else
					tell scroll view "terminal" of window "addressbook2pine"
						set text color of text view "terminal" to {0, 65535, 0}
						set contents of text view "terminal" to successmessage
					end tell
				end if
				
			end tell
		end if
	end if
	
	if title of theObject is "click here for regular import details" then
		if not (state of theObject as boolean) then
			set title of button "bigdetails" of window "addressbook2pine" to "click here for more successful import details"
			tell my application "addressbook2pine"
				if successful = 1 then
					set successmessage to (fmode & successful & " contact was successfully converted:" & return & return & successlist) as string
				else
					set successmessage to (fmode & successful & " contacts were successfully converted:" & return & return & successlist) as string
				end if
				if successful = 0 and totalskip ­ 0 then
					set successmessage to "No contacts were successfully converted."
				else if successful = 0 and totalskip = 0 then
					set successmessage to "No contacts found."
				end if
				if VersionData < "10.5" then
					tell text view "terminal" of scroll view "terminal" of window "addressbook2pine"
						set text color to {0, 65535, 0}
						set contents of text view "terminal" of scroll view "terminal" of window "addressbook2pine" to successmessage
					end tell
				else
					tell scroll view "terminal" of window "addressbook2pine"
						set text color of text view "terminal" to {0, 65535, 0}
						set contents of text view "terminal" to successmessage
					end tell
				end if
				
			end tell
		end if
	end if
	
	if name of theObject is "cancel" then
		set visible of window "alert" to false
	end if
	
	if title of theObject is "Start" then
		my resettext()
		set autobackupswitch to contents of default entry "autobackupswitch" of user defaults
		set backuplocationtext to contents of default entry "backuplocationtext" of user defaults
		if autobackupswitch = "on" then
			if backuplocationtext = "" then
				set visible of window "alert" to true
				beep
				return
			end if
			
			try
				
				set datestring to current date
				set shortdate to short date string of (datestring as date)
				set backupnamespace to "Address Book - " & shortdate & ".abbu"
				set backupname to my charreplacelist({" ", "/"}, {"\\ ", ":"}, backupnamespace)
				set completename to backuplocationtext & backupname
				try
					do shell script "rm -r " & completename
				end try
				set shelltalk to "mkdir " & completename & " ; cp ~/Library/Application\\ Support/AddressBook/AddressBook.data " & completename & "/ ; ditto ~/Library/Application\\ Support/AddressBook/Images " & completename & "/Images"
				
				do shell script (shelltalk)
				
				set completemac to completename as POSIX file as Unicode text
				set completemac to my charreplace("\\", "", completemac)
				set completemac to completemac as alias
				my extentionhide(completemac)
				
			on error errorMsg number errorNum
				display dialog ("There was an error backing up OS X addressbook.

" & "Error: " & errorNum as string) & " " & errorMsg & "" buttons {"Ok"} default button 1
				return
				
			end try
		end if
		
		if (state of button "details1" of window "addressbook2pine" as boolean) then
			call method "performClick:" of (button "details1" of window "addressbook2pine")
		end if
		
		if (state of button "details" of window "addressbook2pine" as boolean) then
			call method "performClick:" of (button "details" of window "addressbook2pine")
		end if
		
		set enabled of button "startbutton" of window "addressbook2pine" to false
		
		set enabled of button "details" of window "addressbook2pine" to false
		set enabled of button "details1" of window "addressbook2pine" to false
		call method "setHidden:" of (button "details1" of window "addressbook2pine") without with parameter
		tell window "addressbook2pine"
			set contents of progress indicator "statusbar" to 0
		end tell
		set pinemode to contents of default entry "pinemode" of user defaults
		set uniqueid to 0
		set successful to 0
		set totalskip to 0
		set compilationList to ""
		set skiplist to {}
		set successlist to {}
		set successlistdetail to {}
		if autobackupswitch = "on" and backuplocationtext ­ "" then
			set backupinformation to "OS X Address Book file \"" & backupnamespace & "\" saved to: " & backuplocationtext & return & return
		else
			set backupinformation to ""
		end if
		
		if pinemode = "convert os x address book to pine" then
			call method "setHidden:" of (button "details" of window "addressbook2pine") without with parameter
			set f to false
			my scanning(f)
			set fmode to ""
			set {totalcount, totalemailcountdistoff} to my countemails()
			my hideapps()
			my convertstart(totalcount, f)
			set tid to text item delimiters
			set {dist, nickuses, usecompanyname, nicknameid, commentuses, useemailid, emailidpref, idabbrev, fccpathswitch, fccpath, fccfolder, autobackupswitch, backuplocationtext, rememberswitch, pinelocation, pinemode} to my gettheuserdefaults()
			set preferencelist to {return & return & "distribution lists: [" & dist & "], use unique nickname id: [" & nicknameid & "], use name field of company cards: [" & usecompanyname & "], nickname field: [" & nickuses & "], comment field uses: [" & commentuses & "], add email id: [" & useemailid & "], email id uses: [" & emailidpref & "], abbreviate email id: [" & idabbrev & "], use fcc: [" & fccpathswitch & "], fcc path: [" & fccpath & "], fcc folder: [" & fccfolder & "]"}
			tell application "Address Book" to tell people
				repeat with thisPerson in it
					tell thisPerson to if (count emails) > 0 then
						set {o, p, e, el, g, b, n, f, l, mn, sn, nn, ph, phl} to its {organization, name, email's value, label of email, name of group, birth date, note, first name, last name, middle name, suffix, nickname, value of phone, label of phone}
						
						set VersionData to word 2 of paragraph 2 of (do shell script "sw_vers")
						if VersionData > "10.3.9" then
							set {u, ul} to its {value of url, label of url}
						else
							set {u, ul} to {{}, {}}
						end if
						
						try
							if f = missing value then
							end if
						on error
							set f to missing value
						end try
						
						try
							set c to its company
						on error
							set c to false
						end try
						
						set eml to e
						set ell to el
						set gl to g
						set uli to ul
						set phli to ph
						
						if (item 1 of eml as string) contains "@" and (item 1 of eml as string) contains "." then
							
							set {o, e, el, g, u, ul, b, n, f, l, mn, sn, nn, ph, phl} to my {getFirstname(o), getEmail(e), getEmaillabel(el), getGroup(g), getUrl(u, ul), getUrllabel(ul), getBirthday(b), getNote(n), getFirstname(f), getFirstname(l), getFirstname(mn), getFirstname(sn), getFirstname(nn), getPhone(ph), getPhonelabel(phl)}
							
							set nickfield to {"", "", ""}
							
							if nickuses = "company" then
								set gtemp to o
								set gtemp to my charremove({",", ":", "@", ";", "[", "]", "(", ")", "<", ">", "\\", "\""}, gtemp)
								set gtemp to my charreplace(space, "_", gtemp)
								set item 3 of nickfield to gtemp
							else if nickuses = "group" then
								set gtemp to g
								set gtemp to my charremove({",", ":", "@", ";", "[", "]", "(", ")", "<", ">", "\\", "\""}, gtemp)
								set gtemp to my charreplace(space, "_", gtemp)
								set gtemp to my charreplace(",", "/", gtemp)
								set item 3 of nickfield to (gtemp as string)
							else if nickuses = "birthday" then
								set item 3 of nickfield to b
							else if nickuses = "first name" then
								set gtemp to f
								set gtemp to my charremove({",", ":", "@", ";", "[", "]", "(", ")", "<", ">", "\\", "\""}, gtemp)
								set gtemp to my charreplace(space, "_", gtemp)
								set item 3 of nickfield to gtemp
							else if nickuses = "last name" then
								set gtemp to l
								set gtemp to my charremove({",", ":", "@", ";", "[", "]", "(", ")", "<", ">", "\\", "\""}, gtemp)
								set gtemp to my charreplace(space, "_", gtemp)
								set item 3 of nickfield to gtemp
							else if nickuses = "first+last" then
								set gtemp to f & " " & l
								set gtemp to my charremove({",", ":", "@", ";", "[", "]", "(", ")", "<", ">", "\\", "\""}, gtemp)
								set gtemp to my charreplace(space, "_", gtemp)
								set item 3 of nickfield to gtemp
							else if nickuses = "nickname" then
								set gtemp to nn
								set gtemp to my charremove({",", ":", "@", ";", "[", "]", "(", ")", "<", ">", "\\", "\""}, gtemp)
								set gtemp to my charreplace(space, "_", gtemp)
								set item 3 of nickfield to gtemp
							else if nickuses = "phone" then
								set gtemp to ph
								set gtemp to my charremove({":", "@", ";", "[", "]", "(", ")", "<", ">", "\\", "\""}, gtemp)
								set gtemp to my charreplace(space, "-", gtemp)
								set gtemp to my charreplace(",", "/", gtemp)
								set item 3 of nickfield to (phtemp as string)
							else if nickuses = "none" then
								set item 3 of nickfield to ""
							end if
							set e to my charremove({" "}, e)
							
							set emailfield to e
							set namefield to p
							
							set headings to {"Company: ", "Groups: ", "Birthday: ", "URL: ", "Phone: ", "Notes: "}
							
							if (count gl) < 2 then
								set item 2 of headings to "Group: "
							end if
							
							set n2 to my charreplace("\"", "'", n)
							set notescount to count n2 as string
							set notechar to 1
							
							if notescount > 1 then
								try
									repeat until character notechar of n2 ­ space
										if notechar > notescount then exit repeat
										set notechar to notechar + 1
									end repeat
									set n2 to characters notechar through -1 of n2 as string
								on error
									set n2 to ""
								end try
								
							end if
							
							if commentuses = "company" and o ­ "" then
								set commentfield to my commentc(headings, o)
							else if commentuses = "group" and g ­ "" then
								set commentfield to my commentg(headings, gl)
							else if commentuses = "birthday" and b ­ "" then
								set commentfield to my commentb(headings, b)
							else if commentuses = "url" and u ­ "" then
								set commentfield to my commentu(headings, u, ul)
							else if commentuses = "phone" and phli ­ {} then
								set commentfield to my commentp(headings, phl, phli)
							else if commentuses = "notes" and n2 ­ "" then
								set commentfield to my commentn(headings, n2)
							else if commentuses = "all" then
								set commentfieldlist to {}
								if o ­ "" then
									set end of commentfieldlist to my commentc(headings, o)
								end if
								if g ­ "" then
									set end of commentfieldlist to my commentg(headings, gl)
								end if
								if b ­ "" then
									set end of commentfieldlist to my commentb(headings, b)
								end if
								if u ­ "" then
									set end of commentfieldlist to my commentu(headings, u, ul)
								end if
								if phli ­ {} then
									set end of commentfieldlist to my commentp(headings, phl, phli)
								end if
								if n ­ "" then
									set end of commentfieldlist to my commentn(headings, n2)
								end if
								
								if (count commentfieldlist) > 0 then
									set commentfield to my (listToText from commentfieldlist between ", ")
								else
									set commentfield to ""
								end if
							else
								set commentfield to ""
							end if
							
							set fccfolderstring to ""
							
							if fccpathswitch = "on" then
								if fccfolder = "name" then
									set fccfolderstring to p
									set fccfolderstring to my charreplace(" ", "-", fccfolderstring)
								else if fccfolder = "group" then
									try
										set fccfolderstring to item 1 of gl
										set fccfolderstring to my charreplace(" ", "-", fccfolderstring)
									on error
										set fccfolderstring to "unknown-group"
									end try
								else if fccfolder = "email" then
									try
										set fccfolderstring to item 1 of eml
										set fccfolderstring to my charreplace(" ", "-", fccfolderstring)
									on error
										set fccfolderstring to "unknown-group"
									end try
								end if
								set fccfield to fccpath & fccfolderstring
							else
								set fccfield to ""
							end if
							
							if usecompanyname = "on" and f & mn & l & sn as string ­ "" then
								set namefield to {}
								set namefieldtemp to {f, mn, l, sn}
								repeat with i from 1 to 4
									if (count item i of namefieldtemp) > 0 then set end of namefield to item i of namefieldtemp
								end repeat
								set namefield to my (listToText from namefield between space)
							else if usecompanyname = "off" and c = true and o ­ "" then
								set namefield to o
							end if
							
							
							set namefieldbackup to namefield
							set commentfieldbackup to commentfield
							
							set elc to 0
							set currentemailcount to (count items of eml)
							if dist = "off" and currentemailcount > 1 then
								repeat with emc in items of eml
									set elc to elc + 1
									set uniqueid to uniqueid + 1
									set uniqueidpad to my uniqueidpad(uniqueid, totalemailcountdistoff)
									set emailfield to emc as string
									
									if nicknameid = "on" then
										set item 1 of nickfield to uniqueidpad
									end if
									
									if useemailid = "on" then
										if emailidpref = "nickname" then
											if idabbrev = "on" then
												set item 2 of nickfield to (character 1 of item elc of ell)
											else
												set item 2 of nickfield to item elc of ell
											end if
										else if emailidpref = "name" then
											if idabbrev = "on" then
												set namefield to namefieldbackup & " (" & (character 1 of item elc of ell) & ")"
											else
												set namefield to namefieldbackup & " (" & item elc of ell & ")"
											end if
										else if emailidpref = "comment" then
											if idabbrev = "on" then
												set commentfield to "Email id: [" & (character 1 of item elc of ell) & "]"
												if commentfieldbackup ­ "" then set commentfield to commentfield & ", " & commentfieldbackup
											else
												set commentfield to "Email id: [" & item elc of ell & "], " & commentfieldbackup
												if commentfieldbackup ­ "" then set commentfield to commentfield & ", " & commentfieldbackup
											end if
											
										end if
									end if
									
									
									set nickbackup to nickfield
									set nickfield to my listremover(nickfield)
									if (nickfield as string) ­ "" then
										tell nickfield to my (listToText from nickfield between "_")
									end if
									set nickfield to nickfield as string
									
									set pineline to {nickfield, namefield, emailfield, fccfield, commentfield}
									tell pineline to my (listToText from pineline between tab)
									set compilationList to compilationList & pineline & "
"
									set nickfield to nickbackup
								end repeat
							else
								set uniqueid to uniqueid + 1
								set uniqueidpad to my uniqueidpad(uniqueid, totalcount)
								
								if nicknameid = "on" then
									set item 1 of nickfield to uniqueidpad
								end if
								
								if useemailid = "on" then
									if emailidpref = "nickname" then
										if idabbrev = "on" then
											set item 2 of nickfield to (character 1 of item 1 of ell)
										else
											set item 2 of nickfield to item 1 of ell
										end if
									else if emailidpref = "name" then
										if idabbrev = "on" then
											set namefield to namefieldbackup & " (" & (character 1 of item 1 of ell) & ")"
										else
											set namefield to namefieldbackup & " (" & item 1 of ell & ")"
										end if
										
									else if emailidpref = "comment" then
										if idabbrev = "on" then
											set commentfield to "Email id: [" & (character 1 of item 1 of ell) & "]"
											if commentfieldbackup ­ "" then set commentfield to commentfield & ", " & commentfieldbackup
										else
											set commentfield to "Email id: [" & item 1 of ell & "]"
											if commentfieldbackup ­ "" then set commentfield to commentfield & ", " & commentfieldbackup
										end if
									end if
								end if
								
								set nickbackup to nickfield
								set nickfield to my listremover(nickfield)
								if (nickfield as string) ­ "" then
									tell nickfield to my (listToText from nickfield between "_")
								end if
								set nickfield to nickfield as string
								
								set pineline to {nickfield, namefield, emailfield, fccfield, commentfield}
								tell pineline to my (listToText from pineline between tab)
								set compilationList to compilationList & pineline & "
"
								set nickfield to nickbackup
							end if
							
							set AppleScript's text item delimiters to ","
							set eml2 to eml as string
							set url2 to u as string
							if dist = "off" and currentemailcount > 1 then
								set uniqueidfinal to uniqueid - currentemailcount + 1 & "-" & uniqueid
							else
								set uniqueidfinal to uniqueid
							end if
							set successvars to {eml2, o, ph, g, fccfield, b, url2, n}
							set successheadings to {"Email: [", "Company: [", "Phone: [", "Group: [", "Fcc: [", "Birthday: [", "Url: [", "Notes: ["}
							set successfield to {}
							set AppleScript's text item delimiters to ""
							repeat with i from 1 to 8
								if (count item i of successvars) > 0 then set end of successfield to item i of successheadings & item i of successvars & "]"
							end repeat
							set beginning of successfield to "Id: [" & uniqueidfinal & "]"
							set AppleScript's text item delimiters to ", "
							set successfield to successfield as string
							set AppleScript's text item delimiters to ""
							set successful to successful + 1
							set the end of successlistdetail to namefield & ":   " & successfield as string
							set the end of successlist to namefield
							my progress()
							my textfieldupdate(p, successful, totalskip, totalcount, VersionData)
						else
							set totalskip to totalskip + 1
							set the end of skiplist to p
							my progress()
							my textfieldupdate(p, successful, totalskip, totalcount, VersionData)
						end if
						
					else
						set totalskip to totalskip + 1
						set p to its {name}
						set the end of skiplist to p
						my progress()
						my textfieldupdate(p, successful, totalskip, totalcount, VersionData)
					end if
				end repeat
				
			end tell
			set enabled of button "startbutton" of window "addressbook2pine" to true
			tell window "addressbook2pine"
				set contents of text field "statustextfield" to "Conversion Complete!"
				set enabled of button "details" to true
				set enabled of button "details1" to true
				set the contents of text field "textblock" to "click arrows below for details"
				set {successlist, successlistdetail} to my setsuccess(successlist, successlistdetail, "shortoutput.txt", "detailout.txt")
				set AppleScript's text item delimiters to ASCII character 10
				set skiplist to skiplist's text items as string
				set AppleScript's text item delimiters to ""
				set skiplist to my sort_list(skiplist, "skipoutput.txt")
				set skiplist to my addreturn(skiplist)
				if successful ­ 0 then
					
					set folderchoice to my browserfun()
					
					try
						set addressbookname to ".addressbook"
						set folderchoicepreserve to folderchoice
						set posixfolderchoice to the POSIX path of the folderchoicepreserve
						set pathinformation to "pine addressbook file saved to: " & posixfolderchoice & addressbookname & return & return
						set folderchoice to (folderchoice & addressbookname) as string
						set docName to folderchoice as list
						set docPointer to (open for access docName with write permission)
						set eof of docPointer to 0
						write compilationList to docPointer as Çclass utf8È
						close access docPointer
					on error number -128
						tell progress indicator "statusbar" to increment by -(totalcount)
						set pathinformation to "*** pine addressbook file not saved ***" & return & return
					end try
				end if
			end tell
			
		else if pinemode = "convert pine .addressbook to os x" then
			call method "setHidden:" of (button "details" of window "addressbook2pine") with with parameter
			set f to true
			set fmode to "*** pine2addressbook mode ***" & (ASCII character 10) & (ASCII character 10)
			set addressbook2pinegroup to false
			
			set pinebooklocationfile to choose file with prompt "Choose pine .addressbook file" default location (path to home folder) with invisibles
			set pathinformation to "pine addressbook file converted to OS X Address Book from: " & POSIX path of pinebooklocationfile & return & return
			tell application "Address Book"
				set thegroups to name of groups
				repeat with currentgroup in thegroups
					if currentgroup as Unicode text = "addressbook2pine" then
						set addressbook2pinegroup to true
						exit repeat
					end if
				end repeat
				if not addressbook2pinegroup then
					make new group at end with properties {name:"addressbook2pine"}
				end if
			end tell
			my startpine("Opening Pine's .addressbook...")
			set pinebooklocationfile to pinebooklocationfile as string
			my hideapps()
			set thefile to pinebooklocationfile
			set fileid to open for access file thefile
			my startpine("Reading Pine's .addressbook...")
			set contentlist to read fileid
			close access fileid
			set contentlist to contentlist as Unicode text
			set contentlist to my (switchText of contentlist from (ASCII character 10) & (ASCII character 32) & ":" & (ASCII character (32)) to "")
			set contentlist to my (switchText of contentlist from (ASCII character 10) & (ASCII character 32) to "")
			set thelist to paragraphs of contentlist
			set thelist2 to {}
			my scanning(f)
			repeat with z from 1 to (count thelist)
				if (count (item z of thelist)) as integer > 0 and (character 1 of item z of thelist) as string = tab then
					set item z of thelist to "" & tab & characters 2 through -1 of item z of thelist
				end if
			end repeat
			my startpine("Sorting Contacts...")
			repeat with z from 1 to (count thelist)
				set AppleScript's text item delimiters to ASCII character 9
				if (count item z of thelist) > 1 and item z of thelist does not contain "#DELETED" then
					set the end of thelist2 to text items of item z of thelist
				end if
			end repeat
			set AppleScript's text item delimiters to ""
			set totalcount to count thelist2
			my startpine("Processing Contacts...")
			repeat with z from 1 to totalcount
				if item 1 of item z of thelist2 contains "_" then
					set item 1 of item z of thelist2 to my charreplace("_", space, item 1 of item z of thelist2)
				end if
				if (count item z of thelist2) < 5 then
					repeat until (count item z of thelist2) = 5
						set the end of item z of thelist2 to ""
					end repeat
				end if
			end repeat
			
			set y to 0
			set x to 0
			my convertstart(totalcount, f)
			tell application "Address Book"
				repeat with x from 1 to totalcount
					set thefullnamebackup to item 2 of item x of thelist2
					set AppleScript's text item delimiters to space
					set thefullname to thefullnamebackup's text items
					set AppleScript's text item delimiters to ""
					set thelastname to ""
					set themiddlename to ""
					set thefirstname to ""
					set thesuffix to ""
					if (count thefullname) = 2 then
						set thefirstname to item 1 of thefullname
						set thelastname to item 2 of thefullname
					else if (count thefullname) = 3 then
						set thefirstname to item 1 of thefullname
						set themiddlename to item 2 of thefullname
						set thelastname to item 3 of thefullname
					else if (count thefullname) = 4 then
						set thefirstname to item 1 of thefullname
						set themiddlename to item 2 of thefullname
						set thelastname to item 3 of thefullname
						set thesuffix to item 4 of thefullname
					else
						set AppleScript's text item delimiters to space
						set thefirstname to thefullname as string
						set AppleScript's text item delimiters to ""
					end if
					set thenickname to item 1 of item x of thelist2
					set thefcc to item 4 of item x of thelist2
					set thenote to item 5 of item x of thelist2
					set notescount to count thenote as string
					set notechar to 1
					
					if notescount > 1 then
						try
							repeat until character notechar of thenote ­ space
								if notechar > notescount then exit repeat
								set notechar to notechar + 1
							end repeat
							set thenote to characters notechar through -1 of thenote as string
						on error
							set thenote to ""
						end try
						
					end if
					
					set myCard to make new person with properties {nickname:thenickname, first name:thefirstname, middle name:themiddlename, last name:thelastname, suffix:thesuffix, note:thenote}
					set emaillist to item 3 of item x of thelist2 as string
					
					set emaillist to my truncateemail(emaillist)
					
					set thelabelbackup to "pine"
					tell myCard
						repeat with q from 1 to count emaillist
							set thelabel to thelabelbackup
							if (count emaillist) > 1 then set thelabel to thelabel & " " & q
							make new email at end of emails with properties {value:item q of emaillist, label:thelabel}
						end repeat
					end tell
					
					try
						add myCard to group "addressbook2pine"
					on error
						display dialog "There was an error adding " & thefullnamebackup & " to the address book group \"addressbook2pine\"" buttons {"Continue"} default button 1
					end try
					
					set successvars to {thenickname, emaillist, thefcc, thenote}
					set successheadings to {"Nickname: [", "Email: [", "Fcc: [", "Comments: ["}
					set successfield to {}
					set AppleScript's text item delimiters to ""
					repeat with i from 1 to 4
						if (count item i of successvars) > 0 then set end of successfield to item i of successheadings & item i of successvars & "]"
					end repeat
					set beginning of successfield to "Id: [" & x & "]"
					set AppleScript's text item delimiters to ", "
					set successfield to successfield as string
					set AppleScript's text item delimiters to ""
					set successful to successful + 1
					set the end of successlistdetail to thefullnamebackup & ":   " & successfield as string
					set the end of successlist to thefullnamebackup
					my progress()
					my textfieldupdate2(thefullnamebackup, x, totalcount, VersionData)
				end repeat
				save
			end tell
			set enabled of button "startbutton" of window "addressbook2pine" to true
			tell window "addressbook2pine"
				set contents of text field "statustextfield" to "Conversion Complete!"
				set enabled of button "details1" to true
				set the contents of text field "textblock" to "click arrow below for details"
				set {successlist, successlistdetail} to my setsuccess(successlist, successlistdetail, "shortoutputpine.txt", "detailoutput.txt")
				set preferencelist to {""}
			end tell
		end if
	end if
end clicked

on action theObject
	(*Add your script here.*)
end action

on begin editing theObject
	(*Add your script here.*)
end begin editing

on should end editing theObject object anObject
	(*Add your script here.*)
end should end editing

on end editing theObject
	(*Add your script here.*)
end end editing

on should begin editing theObject object anObject
	(*Add your script here.*)
end should begin editing

on update menu item theObject
	(*Add your script here.*)
end update menu item

on setsuccess(successlist, successlistdetail, shortname, detailname)
	set AppleScript's text item delimiters to ASCII character 10
	set successlist to successlist's text items as string
	set AppleScript's text item delimiters to ""
	set successlist to my sort_list(successlist, shortname)
	set successlist to my addreturn(successlist)
	set successlist to (ASCII character 10) & successlist
	set AppleScript's text item delimiters to ASCII character 10
	set successlistdetail to successlistdetail's text items as string
	set successlistdetail to my sort_list(successlistdetail, detailname)
	set AppleScript's text item delimiters to ""
	set successlistdetail to my addtworeturns(successlistdetail)
	set successlistdetail to (ASCII character 10) & (ASCII character 10) & successlistdetail
	return {successlist, successlistdetail}
end setsuccess

on truncateemail(emailfield)
	set emailfield to my (switchText of emailfield from "(" to "")
	set emailfield to my (switchText of emailfield from ")" to "")
	set emailedit to emailfield as string
	set AppleScript's text item delimiters to ","
	set emaillist to emailfield's text items
	return emaillist
end truncateemail

to switchText of t from s to r
	set d to text item delimiters
	set text item delimiters to s
	set t to t's text items
	set text item delimiters to r
	tell t to set t to beginning & ({""} & rest)
	set text item delimiters to d
	t
end switchText

on setdefaults()
	
	if contents of default entry "distributionlist" of user defaults = "off" then
		set (state of button "distributionlist" of window "preferences") to false
	else if contents of default entry "distributionlist" of user defaults = "on" then
		set (state of button "distributionlist" of window "preferences") to true
	end if
	
	if contents of default entry "nicknameid" of user defaults = "off" then
		set (state of button "nicknameid" of window "preferences") to false
	else if contents of default entry "nicknameid" of user defaults = "on" then
		set (state of button "nicknameid" of window "preferences") to true
	end if
	if contents of default entry "usecompanyname" of user defaults = "off" then
		set (state of button "companycards" of window "preferences") to false
	else if contents of default entry "usecompanyname" of user defaults = "on" then
		set (state of button "companycards" of window "preferences") to true
	end if
	
	if contents of default entry "nickuses" of user defaults = "company" then
		set current menu item of popup button "nickuses" of window "preferences" to menu item 1 of popup button "nickuses" of window "preferences"
	else if contents of default entry "nickuses" of user defaults = "group" then
		set current menu item of popup button "nickuses" of window "preferences" to menu item 2 of popup button "nickuses" of window "preferences"
	else if contents of default entry "nickuses" of user defaults = "phone" then
		set current menu item of popup button "nickuses" of window "preferences" to menu item 3 of popup button "nickuses" of window "preferences"
	else if contents of default entry "nickuses" of user defaults = "birthday" then
		set current menu item of popup button "nickuses" of window "preferences" to menu item 4 of popup button "nickuses" of window "preferences"
	else if contents of default entry "nickuses" of user defaults = "first name" then
		set current menu item of popup button "nickuses" of window "preferences" to menu item 5 of popup button "nickuses" of window "preferences"
	else if contents of default entry "nickuses" of user defaults = "last name" then
		set current menu item of popup button "nickuses" of window "preferences" to menu item 6 of popup button "nickuses" of window "preferences"
	else if contents of default entry "nickuses" of user defaults = "first+last" then
		set current menu item of popup button "nickuses" of window "preferences" to menu item 7 of popup button "nickuses" of window "preferences"
	else if contents of default entry "nickuses" of user defaults = "nickname" then
		set current menu item of popup button "nickuses" of window "preferences" to menu item 8 of popup button "nickuses" of window "preferences"
	else if contents of default entry "nickuses" of user defaults = "none" then
		set current menu item of popup button "nickuses" of window "preferences" to menu item 9 of popup button "nickuses" of window "preferences"
	end if
	
	if contents of default entry "commentuses" of user defaults = "notes" then
		set current menu item of popup button "commentuses" of window "preferences" to menu item 1 of popup button "commentuses" of window "preferences"
	else if contents of default entry "commentuses" of user defaults = "company" then
		set current menu item of popup button "commentuses" of window "preferences" to menu item 2 of popup button "commentuses" of window "preferences"
	else if contents of default entry "commentuses" of user defaults = "group" then
		set current menu item of popup button "commentuses" of window "preferences" to menu item 3 of popup button "commentuses" of window "preferences"
	else if contents of default entry "commentuses" of user defaults = "url" then
		set current menu item of popup button "commentuses" of window "preferences" to menu item 4 of popup button "commentuses" of window "preferences"
	else if contents of default entry "commentuses" of user defaults = "phone" then
		set current menu item of popup button "commentuses" of window "preferences" to menu item 5 of popup button "commentuses" of window "preferences"
	else if contents of default entry "commentuses" of user defaults = "birthday" then
		set current menu item of popup button "commentuses" of window "preferences" to menu item 6 of popup button "commentuses" of window "preferences"
	else if contents of default entry "commentuses" of user defaults = "all" then
		set current menu item of popup button "commentuses" of window "preferences" to menu item 7 of popup button "commentuses" of window "preferences"
	else if contents of default entry "commentuses" of user defaults = "none" then
		set current menu item of popup button "commentuses" of window "preferences" to menu item 8 of popup button "commentuses" of window "preferences"
	end if
	
	if contents of default entry "useemailid" of user defaults = "off" then
		set (state of button "useemailid" of window "preferences") to false
		tell window "preferences"
			set enabled of popup button "emailidpref" to false
			set enabled of matrix "idabbrev" to false
		end tell
	else if contents of default entry "useemailid" of user defaults = "on" then
		set (state of button "useemailid" of window "preferences") to true
	end if
	
	if contents of default entry "emailidpref" of user defaults = "nickname" then
		set current menu item of popup button "emailidpref" of window "preferences" to menu item 1 of popup button "emailidpref" of window "preferences"
	else if contents of default entry "emailidpref" of user defaults = "name" then
		set current menu item of popup button "emailidpref" of window "preferences" to menu item 2 of popup button "emailidpref" of window "preferences"
	else if contents of default entry "emailidpref" of user defaults = "comment" then
		set current menu item of popup button "emailidpref" of window "preferences" to menu item 3 of popup button "emailidpref" of window "preferences"
	end if
	
	if contents of default entry "idabbrev" of user defaults = "off" then
		set current row of matrix "idabbrev" of window "preferences" to 1
	else if contents of default entry "idabbrev" of user defaults = "on" then
		set current row of matrix "idabbrev" of window "preferences" to 2
	end if
	
	set contents of text field "fccpath" of window "preferences" to contents of default entry "fccpath" of user defaults
	
	if contents of default entry "fccpathswitch" of user defaults = "off" then
		set (state of button "fccpathswitch" of window "preferences") to false
		tell window "preferences"
			set enabled of text field "fccfoldertext" to false
			set enabled of text field "fccpath" to false
			set enabled of popup button "fccfolder" to false
		end tell
	else if contents of default entry "fccpathswitch" of user defaults = "on" then
		set (state of button "fccpathswitch" of window "preferences") to true
		tell window "preferences"
			set enabled of text field "fccpath" to true
			set enabled of text field "fccfoldertext" to true
			set enabled of popup button "fccfolder" to true
		end tell
	end if
	
	if contents of default entry "fccfolder" of user defaults = "name" then
		set current menu item of popup button "fccfolder" of window "preferences" to menu item 1 of popup button "fccfolder" of window "preferences"
		tell window "preferences"
			set the contents of text field "fccfoldertext" to "(full name of contact will be used)"
		end tell
	else if contents of default entry "fccfolder" of user defaults = "group" then
		tell window "preferences"
			set the contents of text field "fccfoldertext" to "(first group ID of contact will be used)"
		end tell
		set current menu item of popup button "fccfolder" of window "preferences" to menu item 2 of popup button "fccfolder" of window "preferences"
	else if contents of default entry "fccfolder" of user defaults = "email" then
		tell window "preferences"
			set the contents of text field "fccfoldertext" to "(first email address of contact will be used)"
		end tell
		set current menu item of popup button "fccfolder" of window "preferences" to menu item 3 of popup button "fccfolder" of window "preferences"
	else if contents of default entry "fccfolder" of user defaults = "none" then
		tell window "preferences"
			set the contents of text field "fccfoldertext" to ""
		end tell
		set current menu item of popup button "fccfolder" of window "preferences" to menu item 4 of popup button "fccfolder" of window "preferences"
	end if
	
	if contents of default entry "backuplocationtext" of user defaults = "" then
		set contents of text field "backuplocationtext" of window "preferences" to "no location has been set"
	else
		set contents of text field "backuplocationtext" of window "preferences" to "current location: " & contents of default entry "backuplocationtext" of user defaults
	end if
	
	if contents of default entry "autobackupswitch" of user defaults = "off" then
		set (state of button "autobackupswitch" of window "preferences") to false
		tell window "preferences"
			set enabled of button "backuplocation" to false
		end tell
	else if contents of default entry "autobackupswitch" of user defaults = "on" then
		set (state of button "autobackupswitch" of window "preferences") to true
		tell window "preferences"
			set enabled of button "backuplocation" to true
		end tell
	end if
	
	set pinelocation to the contents of default entry "pinelocation" of user defaults
	
	if pinelocation = "" then
		set contents of text field "pinelocationtext" of window "preferences" to "no location has been set"
	else
		set contents of text field "pinelocationtext" of window "preferences" to "current location: " & the POSIX path of pinelocation
	end if
	
	if contents of default entry "rememberswitch" of user defaults = "off" then
		set (state of button "rememberswitch" of window "preferences") to false
		tell window "preferences"
			set enabled of button "pinelocation" to false
		end tell
	else if contents of default entry "rememberswitch" of user defaults = "on" then
		set (state of button "rememberswitch" of window "preferences") to true
		tell window "preferences"
			set enabled of button "pinelocation" to true
		end tell
	end if
	
	
	if contents of default entry "pinemode" of user defaults = "convert os x address book to pine" then
		set current menu item of popup button "pinemode" of window "preferences" to menu item 1 of popup button "pinemode" of window "preferences"
		my enablefieldspine()
	else if contents of default entry "pinemode" of user defaults = "convert pine .addressbook to os x" then
		set current menu item of popup button "pinemode" of window "preferences" to menu item 2 of popup button "pinemode" of window "preferences"
		my disablefieldspine()
	end if
	
	
end setdefaults

on extentionhide(targetstring)
	tell application "Finder"
		set extension hidden of targetstring to true
	end tell
end extentionhide

on browserfun()
	set pinelocation to contents of default entry "pinelocation" of user defaults
	set rememberswitch to contents of default entry "rememberswitch" of user defaults
	if pinelocation = "" or rememberswitch = "off" then
		set folderchoice to choose folder default location (path to home folder) with prompt "Select folder where .addressbook file is to be saved" with invisibles
		if rememberswitch = "on" then
			set folderchoiceposix to POSIX path of folderchoice
			set contents of default entry "pinelocation" of user defaults to POSIX path of folderchoice
			call method "synchronize" of object user defaults
			set contents of text field "pinelocationtext" of window "preferences" to "current location: " & contents of default entry "pinelocation" of user defaults
		end if
	else
		set folderchoice to (pinelocation as POSIX file as Unicode text) as alias
	end if
	return folderchoice
end browserfun

on addtworeturns(targetold)
	set AppleScript's text item delimiters to ""
	set temp to text items of targetold
	set AppleScript's text item delimiters to "

"
	set targetold to temp's text items as string
	set AppleScript's text item delimiters to ""
	return targetold
end addtworeturns

on addreturn(targetold)
	set AppleScript's text item delimiters to ""
	set temp to text items of targetold
	set AppleScript's text item delimiters to "
"
	set targetold to temp's text items as string
	set AppleScript's text item delimiters to ""
	return targetold
end addreturn

on listremover(targetold)
	set newtarget to {}
	repeat with i from 1 to (count targetold)
		if (count item i of targetold) > 0 then set end of newtarget to item i of targetold
	end repeat
	return newtarget
end listremover

on delimiterreset()
	set text item delimiters to ""
end delimiterreset

on commentc(headings, o)
	return (item 1 of headings & "[" & o & "]")
end commentc

on commentg(headings, gl)
	set commentfield to item 2 of headings & "[" & my (listToText from gl between ", ") & "]"
	return commentfield
end commentg

on commentb(headings, b)
	return (item 3 of headings & "[" & b & "]")
end commentb

on commentu(headings, u, ul)
	set commentfieldlist to {}
	set countul to (count items in ul)
	if countul > 1 then
		repeat with i from 1 to countul
			set the end of commentfieldlist to {item i of ul & ":", "[" & item i of u & "],"}
		end repeat
		set last item of last item of commentfieldlist to text 1 thru -2 of last item of last item of commentfieldlist
		set commentfield to item 4 of headings & "[" & my (listToText from commentfieldlist between space) & "]"
	else
		set commentfieldlist to {item 1 of ul & ":", "[" & item 1 of u & "]"}
		set commentfield to item 4 of headings & "[" & my (listToText from commentfieldlist between space) & "]"
	end if
	return commentfield
end commentu

on commentp(headings, phl, phli)
	set commentfieldlist to {}
	set countphl to (count items in phl)
	if countphl > 1 then
		repeat with i from 1 to countphl
			set the end of commentfieldlist to {item i of phl & ":", item i of phli & ","}
		end repeat
		set last item of last item of commentfieldlist to text 1 thru -2 of last item of last item of commentfieldlist
		set commentfield to item 5 of headings & "[" & my (listToText from commentfieldlist between space) & "]"
	else
		set commentfieldlist to {item 1 of phl & ":", item 1 of phli}
		set commentfield to item 5 of headings & "[" & my (listToText from commentfieldlist between space) & "]"
	end if
	return commentfield
end commentp

on commentn(headings, n)
	return (item 6 of headings & "[" & n & "]")
end commentn

on resettext()
	tell window "addressbook2pine"
		set the contents of text field "textblock" to ""
		set the contents of text field "textblock2" to ""
		set the contents of text field "textblock3" to ""
		set contents of text field "statustextfield" to ""
	end tell
end resettext

on scanning(f)
	tell window "addressbook2pine"
		if not f then
			set contents of text field "statustextfield" to "Scanning Contacts..."
			set indeterminate of progress indicator "statusbar" to true
			tell progress indicator "statusbar" to start
		else
			set contents of text field "statustextfield" to "Scanning Pine's .addressbook..."
		end if
	end tell
end scanning

on startpine(pinestatusmessage)
	tell window "addressbook2pine"
		set contents of text field "statustextfield" to pinestatusmessage
		set indeterminate of progress indicator "statusbar" to true
		tell progress indicator "statusbar" to start
	end tell
end startpine

on countpeople()
	tell application "Address Book"
		set totalcount to (count every person)
	end tell
	return totalcount
end countpeople

on countemails()
	tell application "Address Book"
		set totalemailstring to {}
		set thebook to every person as list
		repeat with cperson in thebook
			set emaildata to email of cperson
			repeat with thisEmailRecord in emaildata
				set the end of totalemailstring to the value of thisEmailRecord
			end repeat
		end repeat
	end tell
	return {count thebook, count totalemailstring}
end countemails

on hideapps()
	tell application "System Events"
		set visible of first process whose name is "Address Book" to false
		set visible of first process whose name is "addressbook2pine" to true
	end tell
end hideapps

on convertstart(totalemailcount, f)
	tell window "addressbook2pine"
		if not f then
			set contents of text field "statustextfield" to "Converting Address Book Contacts:"
		else
			set contents of text field "statustextfield" to "Converting Pine's .addressbook:"
		end if
		set maximum value of progress indicator "statusbar" to totalemailcount
		set indeterminate of progress indicator "statusbar" to false
	end tell
end convertstart

on listToText from l between d
	if (l as string) ­ "" then
		set text item delimiters to d
		tell l to beginning & ({""} & rest)
	else
		return ""
	end if
end listToText

to getEmail(e)
	if (count e) is 1 then return e's item 1
	tell e to my (listToText from {"(" & beginning} & rest between ",") & ")"
end getEmail

to getEmaillabel(el)
	if el is missing value or el = {} then return ""
	if (count el) is 1 then return el's item 1 as list
	tell el to my (listToText from {beginning} & rest between ",")
	return el as list
end getEmaillabel

to getGroup(g)
	set gl to g
	if g is missing value or g is {} then return ""
	if (count g) is 1 then return g's item 1 as list
	tell g to my (listToText from {beginning} & rest between ",")
end getGroup

to getUrl(u)
	if u is missing value or u = {} then return ""
	if (count u) is 1 then return u's item 1 as list
	tell u to my (listToText from {beginning} & rest between ",")
	return u as list
end getUrl

to getUrllabel(ul)
	if ul is missing value or ul = {} then return ""
	if (count ul) is 1 then return ul's item 1 as list
	tell ul to my (listToText from {beginning} & rest between ",")
	return ul as list
end getUrllabel

to getBirthday(b)
	if b is missing value then return ""
	set b to short date string of (b as date)
end getBirthday

to getNote(n)
	if n is missing value then return ""
	listToText from n's paragraphs between space
end getNote

to getFirstname(f)
	if f is missing value then return ""
	return f
end getFirstname

to getPhone(ph)
	if ph is missing value or ph is {} then return ""
	if (count ph) is 1 then return ph's item 1 as list
	tell ph to my (listToText from {beginning} & rest between ",")
end getPhone

to getPhonelabel(phl)
	if phl is missing value or phl = {} then return ""
	if (count phl) is 1 then return phl's item 1 as list
	tell phl to my (listToText from {beginning} & rest between ",")
	return phl as list
end getPhonelabel

to charreplace(original, replacement, textfield)
	set text item delimiters to original
	set textfield to listToText of me from textfield's text items between replacement
	set text item delimiters to ""
	return textfield
end charreplace

to charremove(removal_list, textfield)
	repeat with this_delimiter in the removal_list
		set AppleScript's text item delimiters to this_delimiter
		set the temp_list to the text items of the textfield
		set AppleScript's text item delimiters to ""
		set the textfield to the temp_list as text
	end repeat
	return textfield
end charremove

to charreplacelist(removal_list, replace_list, textfield)
	set removecount to 0
	repeat with this_delimiter in the removal_list
		set removecount to removecount + 1
		set AppleScript's text item delimiters to this_delimiter
		set the temp_list to the text items of the textfield
		set AppleScript's text item delimiters to item removecount of replace_list
		set the textfield to the temp_list as text
	end repeat
	set AppleScript's text item delimiters to ""
	return textfield
end charreplacelist

on sort_list(the_list, the_filename)
	set docFolder to (path to me as string) & "Contents:Resources:"
	set docName to docFolder & the_filename as list
	set docunix to POSIX path of docFolder & the_filename
	set docPointer to (open for access docName with write permission)
	set eof of docPointer to 0
	write the_list to docPointer as string
	close access docPointer
	ignoring case
		set nl to (ASCII character 10)
		tell (a reference to my text item delimiters)
			set {old_delim, contents} to {contents, nl}
			set {the_list, contents} to {"
" & the_list, old_delim}
		end tell
	end ignoring
	return paragraphs of (do shell script "cat " & (quoted form of docunix) & " | sort -f")
end sort_list

on progress()
	tell window "addressbook2pine"
		tell progress indicator "statusbar" to increment by 1
	end tell
end progress

on textfieldupdate(fortextfield, successful, totalskip, totalcount, VersionData)
	set text item delimiters to ""
	tell window "addressbook2pine"
		set the contents of text field "textblock" to (fortextfield) as string
		set the contents of text field "textblock2" to (successful & " of " & totalcount & " successful") as string
		set the contents of text field "textblock3" to (totalskip & " skipped") as string
		--if VersionData < "10.5" then
		delay 1.0E-3
		--end if
	end tell
end textfieldupdate

on textfieldupdate2(fortextfield, successful, totalcount, VersionData)
	set text item delimiters to ""
	tell window "addressbook2pine"
		set the contents of text field "textblock" to (fortextfield) as string
		set the contents of text field "textblock2" to (successful & " of " & totalcount & " successful") as string
		--if VersionData < "10.5" then
		delay 0.1
		--end if
	end tell
end textfieldupdate2

on uniqueidpad(uniqueid, totalcount)
	set text item delimiters to ""
	set maxnumber to totalcount as string
	set zeroholder to ""
	set zerochars to count characters of maxnumber
	repeat with i from 1 to zerochars - 1
		set zeroholder to zeroholder & "0"
	end repeat
	set theNumber to (characters -zerochars through -1 of (zeroholder & (uniqueid))) as text
	return theNumber
end uniqueidpad

on settheuserdefaults()
	set contents of default entry "distributionlist" of user defaults to "on"
	set contents of default entry "nicknameid" of user defaults to "off"
	set contents of default entry "usecompanyname" of user defaults to "on"
	set contents of default entry "nickuses" of user defaults to "company"
	set contents of default entry "commentuses" of user defaults to "all"
	set contents of default entry "useemailid" of user defaults to "off"
	set contents of default entry "emailidpref" of user defaults to "nickname"
	set contents of default entry "idabbrev" of user defaults to "off"
	set contents of default entry "fccpathswitch" of user defaults to "off"
	set contents of default entry "fccpath" of user defaults to ""
	set contents of default entry "fccfolder" of user defaults to "none"
	set contents of default entry "autobackupswitch" of user defaults to "on"
	set contents of default entry "rememberswitch" of user defaults to "off"
	set contents of default entry "pinemode" of user defaults to "convert os x address book to pine"
	call method "synchronize" of object user defaults
end settheuserdefaults

on gettheuserdefaults()
	set dist to contents of default entry "distributionlist" of user defaults
	set nickuses to contents of default entry "nickuses" of user defaults
	set usecompanyname to contents of default entry "usecompanyname" of user defaults
	set nicknameid to contents of default entry "nicknameid" of user defaults
	set commentuses to contents of default entry "commentuses" of user defaults
	set useemailid to contents of default entry "useemailid" of user defaults
	set emailidpref to contents of default entry "emailidpref" of user defaults
	set idabbrev to contents of default entry "idabbrev" of user defaults
	set fccpathswitch to contents of default entry "fccpathswitch" of user defaults
	set fccpath to contents of default entry "fccpath" of user defaults
	set fccfolder to contents of default entry "fccfolder" of user defaults
	set autobackupswitch to contents of default entry "autobackupswitch" of user defaults
	set backuplocationtext to contents of default entry "backuplocationtext" of user defaults
	set rememberswitch to contents of default entry "rememberswitch" of user defaults
	set pinelocation to contents of default entry "pinelocation" of user defaults
	set pinemode to contents of default entry "pinemode" of user defaults
	return {dist, nickuses, usecompanyname, nicknameid, commentuses, useemailid, emailidpref, idabbrev, fccpathswitch, fccpath, fccfolder, autobackupswitch, backuplocationtext, rememberswitch, pinelocation, pinemode}
end gettheuserdefaults

on enablefieldspine()
	if contents of default entry "useemailid" of user defaults = "on" then
		tell window "preferences"
			set enabled of matrix "idabbrev" to true
		end tell
	end if
	if contents of default entry "autobackupswitch" of user defaults = "on" then
		tell window "preferences"
			set enabled of button "backuplocation" to true
		end tell
	end if
	if contents of default entry "fccpath" of user defaults = "on" then
		tell window "preferences"
			set enabled of text field "fccpath" to true
			set enabled of popup button "fccfolder" to true
			set enabled of text field "fccfoldertext" to true
		end tell
	end if
	if contents of default entry "rememberswitch" of user defaults = "on" then
		tell window "preferences"
			set enabled of button "pinelocation" to true
		end tell
	end if
	tell window "preferences"
		set enabled of popup button "emailidpref" to true
		set enabled of button "fccpathswitch" to true
		set enabled of button "distributionlist" to true
		set enabled of button "nicknameid" to true
		set enabled of button "companycards" to true
		set enabled of popup button "nickuses" to true
		set enabled of popup button "commentuses" to true
		set enabled of button "useemailid" to true
		set enabled of button "rememberswitch" to true
	end tell
end enablefieldspine

on disablefieldspine()
	tell window "preferences"
		set enabled of popup button "emailidpref" to false
		set enabled of matrix "idabbrev" to false
		set enabled of text field "fccfoldertext" to false
		set enabled of text field "fccpath" to false
		set enabled of text field "commentusestext" to false
		set enabled of popup button "fccfolder" to false
		set enabled of popup button "nickuses" to false
		set enabled of popup button "commentuses" to false
		set enabled of button "distributionlist" to false
		set enabled of button "nicknameid" to false
		set enabled of button "companycards" to false
		set enabled of button "useemailid" to false
		set enabled of button "fccpathswitch" to false
		set enabled of button "rememberswitch" to false
		set enabled of button "pinelocation" to false
	end tell
end disablefieldspine