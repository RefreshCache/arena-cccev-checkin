﻿<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CheckInWizard.ascx.cs" Inherits="ArenaWeb.UserControls.Custom.Cccev.Checkin.CheckInWizard" %>

<asp:ScriptManagerProxy ID="smpScripts" runat="server" />

<script type="text/javascript">
    var autoConfirmCancel = '<%= AutoCancelConfirmSetting %>' == 'true';
    var longInterval = parseInt('<%= LongRefreshTimeSetting %>');
    var shortInterval = parseInt('<%= ShortRefreshTimeSetting %>');
    var interval;
    
    var startTime;    
    var rightNow;
    var refreshSeconds = 0;
    var secondsSinceLastRefresh = 0;
    var state;
    var shouldRefresh = true;

    var StartTime;
    var NowTime;

    function reloadBrowser()
    {
        window.location.reload(true);
    }
   
    function refreshPage()
    {
        startTime = new Date();
        startTime = startTime.getTime();
        refreshCountDown();
    }

    function refreshCountDown()
    {
        if (shouldRefresh && (autoConfirmCancel || state == 'init'))
        {
            rightNow = new Date();
            rightNow = rightNow.getTime();
            secondsSinceLastRefresh = (rightNow - startTime) / 1000;
            refreshSeconds = Math.round(interval - secondsSinceLastRefresh);
            var timer;

            if (interval >= secondsSinceLastRefresh)
            {
                timer = setTimeout('refreshCountDown()', 1000);
                window.status = 'Page refresh: ' + refreshSeconds + ' State: ' + state;
            }
            else
            {
                clearTimeout(timer);

                if (state == 'confirm')
                {
                    $get('<%= btnConfirmContinue.ClientID %>').click();
                }
                else
                {
                    $get('<%= btnRedirect.ClientID %>').click();
                }
            }
        }
        else
        {
            window.status = '';
        }
    }

    function resetTimer()
    {
        startTime = new Date();
        startTime = startTime.getTime();
    }

    function getState()
    {
        var init = $get('<%= pnlInit.ClientID %>');
        var familySearch = $get('<%= pnlFamilySearch.ClientID %>');
        var selectFamilyMember = $get('<%= pnlSelectFamilyMember.ClientID %>');
        var noEligible = $get('<%= pnlNoEligiblePeople.ClientID %>');
        var selectAbility = $get('<%= pnlSelectAbility.ClientID %>');
        var selectService = $get('<%= pnlSelectService.ClientID %>');
        var confirm = $get('<%= pnlConfirm.ClientID %>');
        var results = $get('<%= pnlResults.ClientID %>');
        var badKiosk = $get('<%= pnlBadKiosk.ClientID %>');
        var ajaxLoading = document.getElementById('upProgress');
        
        interval = longInterval;
        shouldRefresh = true;

        // Get the first child of the upProgress element
        if (ajaxLoading)
        {
        	ajaxLoading = ajaxLoading.childNodes.item(0);
        	ajaxLoading.className = 'ajaxProgress';
        }
        
        if (init) 
        {
            var timerLabel = $get('<%= lblTimeRemaining.ClientID %>');

            if (timerLabel) 
            {
                shouldRefresh = false;
            }
            else 
            {
                state = 'init';
                interval = shortInterval;
                shouldRefresh = true;
            }
        }
        else if (familySearch)
        {
            state = 'familySearch';
            ajaxLoading.className = 'ajaxLargeProgress';
        }
        else if (selectFamilyMember)
        {
            state = 'selectFamilyMember';
            ajaxLoading.className = 'ajaxLargeProgress';
            var imgEmpty = 'UserControls/Custom/Cccev/Checkin/images/empty_checkbox.png';
            var imgChecked = 'UserControls/Custom/Cccev/Checkin/images/checkbox.png';
            var selectedCount = 0;
            var nextButton = $('#<%= btnSelectFamilyMemberContinue.ClientID %>');
            var nextDiv = $('#divSelectFamilyMemberContinue');

            $('#<%= dgFamilyMembers.ClientID %> input:submit').click(function(event)
            {
                if ($(this).hasClass('dataButton'))
                {
                    addAttendee($(this).siblings(":last").val());
                    $(this).removeClass().addClass('dataButtonSelected');
                    $(this).parent().siblings(":first").children("input:first").attr('src', imgChecked);
                    selectedCount++;
                }
                else
                {
                    removeAttendee($(this).siblings(":last").val());
                    $(this).removeClass().addClass('dataButton');
                    $(this).parent().siblings(":first").children("input:first").attr('src', imgEmpty);
                    selectedCount--;
                }

                event.preventDefault();

                if (selectedCount > 0)
                {
                    $(nextButton).removeAttr('disabled');
                    $(nextDiv).removeAttr('disabled');
                    $(nextDiv).removeClass('nextButtonInactive').addClass('nextButton');
                }
                else
                {
                    $(nextButton).attr('disabled', 'disabled');
                    $(nextDiv).attr('disabled', 'disabled');
                    $(nextDiv).removeClass('nextButton').addClass('nextButtonInactive');
                }
            });

            $('#<%= dgFamilyMembers.ClientID %> input:image').click(function(event)
            {
                if ($(this).attr('src').indexOf('empty_checkbox', 0) > 0)
                {
                    addAttendee($(this).parent().siblings(":last").children("input:last").val());
                    $(this).attr('src', imgChecked);
                    $(this).parent().siblings(":last").children("input:first").removeClass().addClass('dataButtonSelected');
                    selectedCount++;
                }
                else
                {
                    removeAttendee($(this).parent().siblings(":last").children("input:last").val());
                    $(this).attr('src', imgEmpty);
                    $(this).parent().siblings(":last").children("input:first").removeClass().addClass('dataButton');
                    selectedCount--;
                }

                event.preventDefault();

                if (selectedCount > 0)
                {
                    $(nextButton).removeAttr('disabled');
                    $(nextDiv).removeAttr('disabled');
                    $(nextDiv).removeClass('nextButtonInactive').addClass('nextButton');
                }
                else
                {
                    $(nextButton).attr('disabled', 'disabled');
                    $(nextDiv).attr('disabled', 'disabled');
                    $(nextDiv).removeClass('nextButton').addClass('nextButtonInactive');
                }
            });
        }
        else if (noEligible)
        {
            state = 'noEligiblePeople';
            interval = shortInterval;
            ajaxLoading.className = 'ajaxLargeProgress';
        }
        else if (selectAbility)
        {
            state = 'selectAbilityLevel';
            ajaxLoading.className = 'ajaxLargeProgress';
        }
        else if (selectService)
        {
            state = 'selectService';
            ajaxLoading.className = 'ajaxLargeProgress';
        }
        else if (confirm)
        {
            state = 'confirm';
            interval = shortInterval;
            ajaxLoading.className = 'ajaxLargeProgress';
        }
        else if (results)
        {
            state = 'results';
            ajaxLoading.className = 'ajaxLargeProgress';
        }
        else if (badKiosk)
        {
            state = 'badKiosk';
        }
        else
        {
            state = 'undefined';
        }
    }

    if (!Array.prototype.indexOf)
    {
        Array.prototype.indexOf = function(val)
        {
            var length = this.length;

            var from = Number(arguments[1]) || 0;
            from = (from < 0) ? Math.ceil(from) : Math.floor(from);

            if (from < 0)
            {
                from += length;
            }

            for (; from < length; from++)
            {
                if (from in this && this[from] === val)
                {
                    return from;
                }
            }
            
            return -1;
        };
    }

    function addAttendee(id)
    {
        var attendees = $get('<%= ihAttendeeIDs.ClientID %>');
        var attendeeArray = new Array();
        attendeeArray = attendees.value.split(',');

        if (attendeeArray.indexOf(id) == -1)
        {
            if (attendees.value.length > 0)
            {
                attendees.value += ',';
            }

            attendees.value += id;
        }
    }

    function removeAttendee(id)
    {
        var attendees = $get('<%= ihAttendeeIDs.ClientID %>');
        var attendeeArray = new Array();
        var newList = new String();
        attendeeArray = attendees.value.split(',');

        if (attendeeArray.indexOf(id) > -1)
        {
            for (var i = 0; i < attendeeArray.length; i++)
            {
                if (attendeeArray[i] != id)
                {
                    if (newList.length > 0)
                    {
                        newList += ',';
                    }

                    newList += attendeeArray[i];
                }
            }

            attendees.value = newList;
        }
    }
</script>

<script type="text/javascript">
    var txtPhone;
    var button;
    var label;
    var maxDigits;

    function pageLoad() 
    {
        txtPhone = document.getElementById('<%= txtPhone.ClientID %>');
        button = document.getElementById('<%= btnFamilySearch.ClientID %>');
        label = document.getElementById('<%= lblMessage.ClientID %>');
        maxDigits = parseInt('<%= PhoneLengthSetting %>');

        getState();

        if (autoConfirmCancel || state == 'init')
        {
            refreshPage();
        }
        
        var lblTimer = $get('<%= lblTimeRemaining.ClientID %>');

        if (lblTimer)
        {
            StartTime = $get('<%= ihStartTime.ClientID %>').value;
            NowTime = $get('<%= ihNowTime.ClientID %>').value;
            
            if ($get('CountDown').innerHTML == '')
            {
                StartTimer('<%= CurrentPortalPage.PortalPageID %>');
            }
        }
    }

    function FireDefaultButton(event, target) {
        var key_Zero = 47;
        var key_Nine = 57;

        if ((event.keyCode == 13 || event.which == 13) && !(event.srcElement && (event.srcElement.tagName.toLowerCase() == 'textarea')))
        {
            var defaultButton = document.getElementById(target);
            if (defaultButton == 'undefined') defaultButton = document.all[target];

            if (defaultButton && typeof (defaultButton.click) != 'undefined')
            {
                Search();
                defaultButton.click();

                txtPhone.disabled = true;
                event.cancelBubble = true;
                if (event.stopPropagation) event.stopPropagation();
                return false;
            }
        }
        else if (event && event.keyCode >= key_Zero && event.keyCode <= key_Nine)
        {
            // if there are already 9 numbers then this is the 10th...
            if (txtPhone.value.length >= 9)
            {
                ClickDigit(String.fromCharCode(event.keyCode));
                txtPhone.disabled = true;
                event.cancelBubble = true;
                if (event.stopPropagation) event.stopPropagation();
                return false;
            }
        }
        return true;
    }

    function GetKeys() 
    {
        var key_Enter = 13;
        var key_Zero = 47;
        var key_Nine = 57;

        if (window.event && window.event.keyCode == key_Enter)
        {
            if (txtPhone.value.length >= maxDigits)
            {
                Search();
                txtPhone.disabled = true;
                ClickDigit('');
                window.event.cancelBubble = true;
                if (event.stopPropagation) event.stopPropagation();
                return false;
            }
            else
            {
                IncompleteEntry();
            }
        }
        else if (window.event && window.event.keyCode >= key_Zero && window.event.keyCode <= key_Nine)
        {
            // if there are already 9 numbers then this is the 10th...
            if (txtPhone.value.length >= 9)
            {
                ClickDigit(String.fromCharCode(event.keyCode));
            }
        }
    }

    function ClickDigit(digit) {
        txtPhone.focus();
        if (parseInt(digit) >= 0) {
            txtPhone.value = txtPhone.value + digit;
        }

        // once the person has entered all ten digits, submit by navigating to the
        // same page with the digits in the txtPhone name/value pair.
        if (txtPhone.value.length >= maxDigits) {
            Search();

            button.click();
            txtPhone.disabled = true;
            button.disabled = true;
        }

        return false;
    }

    function ClearDigit()
    {
        txtPhone.value = txtPhone.value.substring(0, txtPhone.value.length - 1);
        txtPhone.focus();
    }

    function ClearAll()
    {
        txtPhone.value = '';
        label.innerHTML = '&nbsp;';
        div = document.getElementById('ScrollArea');
        div.innerHTML = '';
        txtPhone.focus();

        return false;
    }

    function IncompleteEntry()
    {
        label.innerHTML = 'Please enter all ' + maxDigits + ' digits.';
        $(label.id).removeClass().addClass('phoneError');
    }

    function Search()
    {
        div = document.getElementById('ScrollArea');
        div.innerHTML = '';
        label.innerHTML = 'Searching...';
        $(label.id).removeClass().addClass('phoneSearching');

        return true;
    }

    function disableButton(button)
    {
        button.style.color = '#999999';
    
        if (button.getAttribute('requestSent') != 'true')
        {
            button.setAttribute('requestSent', 'true');
            return true;
        }
        else
        {
            button.disabled = true;
            return false;
        }
            
    }

    function disableDivAndPostBack(div)
    {
        if ($(div).attr('disabled') != 'disabled' && div.getAttribute('requestSent') != 'true')
        {
            div.style.color = '#999999';
            div.setAttribute('requestSent', 'true');
            $(div).prev("input").click();
        }
    }

    Sys.WebForms.PageRequestManager.getInstance().add_pageLoaded(function(sender, args)
    {
        $('.divButton').click(function() { disableDivAndPostBack(this); } );
    });

    Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function(sender, args)
    {
        if (args.get_error() != null)
        {
            if (args.get_response().get_statusCode() == '500')
            {
                args.set_errorHandled(true);
                alert('<%= AsyncTimeoutErrorMessageSetting %>');
                $get('<%= btnRedirect.ClientID %>').click();
            }
        }
    });
</script>

<meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;" />
<script type="text/javascript" src="UserControls/Custom/Cccev/Checkin/misc/ios.js"></script>
                    
<script type="text/javascript">
    var isCtrlKey = false;
    var isShiftKey = false;

    document.onkeyup = function(e)
    {
        var keyCode = (e && e.which ? e.which : event.keyCode);

        if (keyCode == 16)
        {
            isShiftKey = false;
        }

        if (keyCode == 17)
        {
            isCtrlKey = false;
        }
    }

    document.onkeydown = function(e)
    {
        var keyCode = (e && e.which ? e.which : event.keyCode);

        if (keyCode == 16)
        {
            isShiftKey = true;
        }

        if (keyCode == 17)
        {
            isCtrlKey = true;
        }

        if (keyCode == 82 && (isCtrlKey && isShiftKey))
        {
            if ('<%= FamilyRegistrationPageSetting %>' != '')
            {
                window.location = 'default.aspx?page=<%= FamilyRegistrationPageSetting %>';
                return false;
            }
        }
    }
</script>

<asp:UpdatePanel ID="upCheckin" runat="server" UpdateMode="Always">
    <ContentTemplate>
        <div class="container" onclick="resetTimer()" onkeypress="resetTimer()">
            <asp:Panel ID="pnlError" runat="server" Visible="false">
                <asp:Label ID="lblError" runat="server" CssClass="errorText" />
            </asp:Panel>
                  
            <!-- Begin Views -->
            
            
            <asp:Panel ID="pnlInit" runat="server" DefaultButton="btnScan" CssClass="initView">
            <!-- Init State -->
                <div id="divPanicButton" onclick="reloadBrowser();" style="position: absolute; top: 0; left: 0; height: 100px; width: 100px;"></div>
                <asp:Panel ID="pnlSwipeCard" runat="server" CssClass="footer">
                    <div id="divLeftFooter" runat="server" class="footerLeft">
                        <div id="divScanBox" runat="server" visible="false" style="float: left; width: 1px;">
                            <asp:textbox id="tbScan" tabIndex="0" runat="server" Font-Size="1pt" BackColor="#222222" ForeColor="#222222" BorderStyle="None" MaxLength="12" Width="1pt" />
                            <asp:Button ID="btnScan" runat="server" OnClick="btnScan_Click" Width="1" />
                        </div>
                        <div id="divScanNow" runat="server" visible="false" style="float: left;">
	                        <asp:Label ID="lblScanNow" runat="server" />
	                    </div>
	                </div>
	                <div id="divRightFooter" runat="server" class="footerRight">
                        <asp:Button id="btnSearchByPhone" CssClass="searchButton" style="display: none; vertical-align: middle" runat="server" Visible="false" Text="Search By Phone" 
                            OnClick="btnSearchByPhone_Click" OnClientClick="disableButton(this);" />
                        <div class="searchButton divButton">Search By Phone</div>
                    </div>
                    <div id="divWideFooter" runat="server" visible="false" class="footerWide">
                        <p><asp:Label ID="lblWideFooter" runat="server" /></p>
                    </div>
                    <div id="divTimer" runat="server" visible="false" class="footerWide" style="text-align: left;">
                            <asp:Label id="lblTimeRemaining" Runat="server" CssClass="footerText" />
                        </div>
                </asp:Panel>
            </asp:Panel>
            
            
            <asp:Panel ID="pnlFamilySearch" runat="server" DefaultButton="btnFamilySearch">
            <!-- Family Search State -->
                <asp:Panel ID="pnlPhoneSearch" runat="server" CssClass="container">
                    <div class="phonePanel" style="text-align: center; padding-top: 10px; margin-left: 40px;">
                        <div class="heading">
                            <h3 class="checkinText">Enter Phone #</h3>
                        </div>
                        <br />
	                    <table style="border: none;">
		                    <tr>
			                    <td style="vertical-align: top;">
				                    <table id="Table2" style="height: 302px; width: 286px; border: none; padding: 2px;" cellspacing="0">
					                    <tr style="vertical-align: top;">
                                                                    <td style="vertical-align: middle; text-align: center;"><div class="phoneButton" onclick="return ClickDigit( '1' )">1</div></td>
                                                                    <td style="vertical-align: middle; text-align: center;"><div class="phoneButton" onclick="return ClickDigit( '2' )">2</div></td>
                                                                    <td style="vertical-align: middle; text-align: center;"><div class="phoneButton" onclick="return ClickDigit( '3' )">3</div></td>
					                    </tr>
					                    <tr style="vertical-align: middle;">
                                                                    <td style="vertical-align: middle; text-align: center;"><div class="phoneButton" onclick="return ClickDigit( '4' )">4</div></td>
                                                                    <td style="vertical-align: middle; text-align: center;"><div class="phoneButton" onclick="return ClickDigit( '5' )">5</div></td>
                                                                    <td style="vertical-align: middle; text-align: center;"><div class="phoneButton" onclick="return ClickDigit( '6' )">6</div></td>
					                    </tr>
					                    <tr style="vertical-align: middle;">
                                                                    <td style="vertical-align: middle; text-align: center;"><div class="phoneButton" onclick="return ClickDigit( '7' )">7</div></td>
                                                                    <td style="vertical-align: middle; text-align: center;"><div class="phoneButton" onclick="return ClickDigit( '8' )">8</div></td>
                                                                    <td style="vertical-align: middle; text-align: center;"><div class="phoneButton" onclick="return ClickDigit( '9' )">9</div></td>
					                    </tr>
					                    <tr style="vertical-align: middle;">
                                                                    <td style="vertical-align: middle; text-align: center;"><div class="phoneButton" onclick="return ClearDigit( )">&lt;</div></td>
                                                                    <td style="vertical-align: middle; text-align: center;"><div class="phoneButton" onclick="return ClickDigit( '0' )">0</div></td>
                                                                    <td style="vertical-align: middle; text-align: center;"><div class="phoneButton" onclick="return ClearAll()">clr</div></td>
					                    </tr>
				                    </table>
				                    <p>&nbsp;</p>
				                    <p>&nbsp;</p>
			                    </td>
			                    <td style="vertical-align: top; padding-left: 20px">
				                    <p><div style="width: 100%;">
				                            <div style="width: 334px; float: left;" onkeypress="javascript:return FireDefaultButton(event,'btnFamilySearch')">
				                                <asp:textbox id="txtPhone" runat="server" CssClass="phoneText" Width="264" Height="65" MaxLength="10" />
				                            </div>
				                            <div style="width: 212px; float: left; margin-left: 15px;">
				                                <asp:button id="btnFamilySearch" runat="server" CssClass="dataButton" style="display: none;" Text="Search" OnClick="btnFamilySearch_Click" OnClientClick="disableButton(this);" />
                                                                <div class="dataButton divButton">Search</div>
				                            </div>
				                        </div>
				                        <br />
					                    <asp:Label id="lblMessage" runat="server" CssClass="checkinCaption" /></p>
				                    <div class="scrollArea" id="ScrollArea">
				                        <asp:datalist id="dgFamilies" runat="server" RepeatColumns="1" CellSpacing="5" DataKeyField="FamilyID" 
				                            OnSelectedIndexChanged="dgFamilies_SelectedIndexChanged" OnItemDataBound="dgFamilies_ItemDataBound">
						                    <ItemTemplate>
							                    <asp:Button runat="server" ID="FamilyID" CommandName="Select" CausesValidation="false" CssClass="nameButton" />
						                    </ItemTemplate>
					                    </asp:datalist>
					                </div>
			                    </td>
		                    </tr>
	                    </table>
                    </div>
                    <div class="footer">
	                    <div class="footerLeft">
                                        <asp:button id="btnFamilySearchCancel" CssClass="cancelButton" style="display: none;" runat="server" Text="Cancel" OnClick="Cancel_Click" OnClientClick="disableButton(this);" />
                                        <div class="cancelButton divButton">Cancel</div>
	                        </div>
                        </div>
                </asp:Panel>
                <script type="text/javascript">
                    txtPhone = document.getElementById( '<%= txtPhone.ClientID %>' );
                    txtPhone.focus();
                </script>
            </asp:Panel>

            
            <asp:Panel ID="pnlSelectFamilyMember" runat="server">
            <!-- Select Family Member State -->
                <div style="text-align: center; width: 100%;">
                    <input type="hidden" id="ihAttendeeIDs" runat="server" />
                    <div class="heading">
                        <p class="checkinCaption"><asp:Label ID="lblFamilyName" runat="server" /></p>
                        <p class="checkinText">Select All People Attending Today</p>
                    </div>
                    <div class="resultScrollArea">
	                    <asp:DataList id="dgFamilyMembers" runat="server" DataKeyField="PersonID" CssClass="familyMemberGrid"
		                    CellSpacing="5" RepeatColumns="1" BorderColor="Black" BorderWidth="0" Width="353"
		                    OnItemDataBound="dgFamilyMembers_ItemDataBound" ItemStyle-HorizontalAlign="Left" GridLines="Both">
                            <ItemStyle HorizontalAlign="Left"></ItemStyle>
		                    <ItemTemplate>
		                        <div style="width: 338px;">
		                            <div style="width: 263px; height: 91px; text-align: left; float: left;">
			                            <asp:Button runat="server" ID="btnPerson" Text='<%# DataBinder.Eval(Container, "DataItem.NickName") %>' 
			                                CommandArgument='<%# DataBinder.Eval(Container, "DataItem.PersonID") %>' CausesValidation="false"  CssClass="dataButton" />
			                            <input type="hidden" id="ihPersonID" runat="server" value='<%# DataBinder.Eval(Container, "DataItem.PersonID") %>' />
			                        </div>
			                        <div style="width: 75px; height: 47px; float: left;"><asp:ImageButton id="imgChecked" runat="server" CssClass="dataStar" ImageUrl="images/empty_checkbox.png" /></div>
			                    </div>
		                    </ItemTemplate>
	                    </asp:DataList>
                    </div>
                </div>

                <div class="footer">
                    <div class="footerLeft">
                        <asp:Button ID="btnSelectFamilyMemberCancel" runat="server" Text="Cancel" 
                        CssClass="cancelButton" onclick="Cancel_Click" style="margin-right: 20px; display:none;" OnClientClick="disableButton(this);" />
                        <div class="cancelButton divButton">Cancel</div>
                    </div>
                    <div class="footerRight">
                        <asp:Button ID="btnSelectFamilyMemberContinue" runat="server" Text="Next" CssClass="nextButton" style="display: none;"
                            onclick="btnSelectFamilyMemberContinue_Click" OnClientClick="disableButton(this);" />
                        <div id="divSelectFamilyMemberContinue" class="nextButtonInactive divButton" disabled="disabled">Next</div>
                    </div>
                </div>
            </asp:Panel>
            
            
            <asp:Panel ID="pnlNoEligiblePeople" runat="server">
            <!-- No Young Children State -->
                <asp:Label ID="lblNoEligiblePeople" runat="server" CssClass="errorText" Visible="false" />
                <div class="footer">
	                <div class="footerLeft">
		                <asp:button id="btnNoPeopleCancel" CssClass="cancelButton" style="display: none;" runat="server" Text="Cancel" OnClick="Cancel_Click" OnClientClick="disableButton(this);" />
                                <div class="cancelButton divButton">Cancel</div>
	                </div>
                </div>
            </asp:Panel>

            
            <asp:Panel ID="pnlSelectAbility" runat="server">
            <!-- Select Ability State -->
                <div style="text-align: center;">
                    <div class="heading">
	                    <h3 class="checkinText"><asp:Label ID="lblPersonName" runat="server" /></h3>
	                </div>
	                <asp:DataList id="dgAbilities" runat="server" DataKeyField="LookupID" 
		                CellSpacing="5" RepeatColumns="1" BorderColor="Black" 
		                onselectedindexchanged="dgAbilities_SelectedIndexChanged" ItemStyle-HorizontalAlign="Left">
		                <ItemTemplate>
			                <asp:Button runat="server" ID="lookupID" Text='<%# DataBinder.Eval(Container, "DataItem.Value") %>' 
			                    CommandArgument='<%# DataBinder.Eval(Container, "DataItem.LookupID") %>' CommandName="Select" 
			                    CausesValidation="false" CssClass="nameButton" OnClientClick="disableButton(this);" />
		                </ItemTemplate>
	                </asp:DataList>
                </div>

                <div class="footer">
                    <div class="footerLeft">
                        <asp:Button ID="btnAbilityCancel" runat="server" Text="Cancel" CssClass="cancelButton" style="display: none;" onclick="Cancel_Click" OnClientClick="disableButton(this);" />
                        <div class="cancelButton divButton">Cancel</div>
                    </div>
                </div>
                <input type="hidden" id="ihAttendeesToProcess" runat="server" />
            </asp:Panel>

            
            <asp:Panel ID="pnlSelectService" runat="server">
            <!-- Select Service State -->
                <div style="text-align: center;">
                    <div class="heading">
                        <h3 class="checkinText">Select Services</h3>
                    </div>
                    <asp:DataList ID="dgEventTimes" runat="server" CellSpacing="5" RepeatColumns="1" BorderColor="Black" BorderWidth="0" Width="350" 
                        OnSelectedIndexChanged="dgEventTimes_SelectedIndexChanged" OnItemDataBound="dgEventTimes_ItemDataBound" ItemStyle-HorizontalAlign="Left">
                        <ItemTemplate>
                            <div class="item">
                                <asp:Button runat="server" ID="btnService" CommandName="Select" CausesValidation="false" CssClass="dataButton" /><asp:ImageButton id="imgChecked" runat="server" CommandName="Select" CssClass="star" ImageUrl="images/empty_checkbox.png" />
                            </div>
                        </ItemTemplate>
                    </asp:DataList>
                </div>

                <div class="footer">
                    <div class="footerLeft">
                        <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="cancelButton" style="display: none;" onclick="Cancel_Click" OnClientClick="disableButton(this);" />
                        <div class="cancelButton divButton">Cancel</div>
                    </div>
                    <div class="footerRight">
                        <asp:Button ID="btnServicesContinue" runat="server" Text="Next" CssClass="nextButton" style="display: none;" onclick="btnServicesContinue_Click" OnClientClick="disableButton(this);" />
                        <div class="nextButton divButton">Next</div>
                    </div>
                </div>
            </asp:Panel>

            
            <asp:Panel ID="pnlConfirm" runat="server">
            <!-- Confirm State -->
                <div style="text-align: center;">
                    <div class="heading">
                        <h3 class="checkinText">Confirm</h3>
                    </div>
                    <div class="scrollAreaBig"><asp:PlaceHolder ID="phConfirm" runat="server" /></div>
                    <div id="divConfirmError" runat="server" visible="false">
                        <p><asp:Label ID="lblConfirmError" runat="server" CssClass="errorCaption" /></p>
                    </div>
                    <div class="footer">
                        <div class="footerLeft">
                            <asp:Button ID="btnConfirmCancel" runat="server" Text="Cancel" CssClass="cancelButton" style="display: none;" onclick="Cancel_Click" OnClientClick="disableButton(this);" />
                            <div class="cancelButton divButton">Cancel</div>
                        </div>
                        <div class="footerRight">
                            <asp:Button ID="btnConfirmContinue" runat="server" Text="Next" CssClass="nextButton" style="display: none;" onclick="btnConfirmContinue_Click" OnClientClick="disableButton(this);" />
                            <div class="nextButton divButton">Next</div>
		                </div>
                    </div>
                </div>
            </asp:Panel>

            
            <asp:Panel ID="pnlResults" runat="server">
            <!-- Result State -->
                <div style="text-align: center;">
                    <div class="heading">
                        <h3 class="checkinText">Thank You!</h3>
                    </div>
                    <div class="resultScrollArea"><asp:PlaceHolder ID="phResults" runat="server" /></div>
                </div>
                <div class="footer">
                    <div class="footerRight">
                        <asp:Button ID="btnResultsContinue" runat="server" Text="Finish" CssClass="nextButton" onclick="btnResultsContinue_Click" OnClientClick="disableButton(this);" />
                    </div>
                </div>
            </asp:Panel>
            
            
            <asp:Panel ID="pnlBadKiosk" runat="server">
            <!-- Bad Kiosk State -->
                <div class="heading">
                    <h3 class="checkinText">Error!</h3>
                    <asp:Label ID="lblBadKiosk" runat="server" CssClass="errorText" />
                </div>
                <div class="footer">
                    <div class="footerLeft">
                        <asp:Button ID="btnTryAgain" runat="server" Text="Retry" CssClass="cancelButton" style="display: none;" onclick="btnTryAgain_Click" />
                        <div class="cancelButton divButton">Retry</div>
		            </div>
                </div>
            </asp:Panel>


            <!-- End Views -->
            <asp:Button ID="btnRedirect" runat="server" OnClick="Redirect_Click" Width="1" Height="1" />
            <input type="hidden" id="ihStartTime" runat="server" />
            <input type="hidden" id="ihNowTime" runat="server" />
        </div>
    </ContentTemplate>
</asp:UpdatePanel>
