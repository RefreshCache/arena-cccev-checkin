<%@ Control Language="C#" AutoEventWireup="true" CodeFile="AttendanceTypeCategoryList.ascx.cs" Inherits="ArenaWeb.UserControls.Custom.Cccev.Checkin.AttendanceTypeCategoryList" %>
<%@ Register TagPrefix="Arena" Namespace="Arena.Portal.UI" Assembly="Arena.Portal.UI" %>
<asp:Panel ID="pnlList" runat="server" Visible="true">
<Arena:DataGrid 
	id="dgOccurrenceTypeGroups" 
	Runat="server"
	EditEnabled='<%# EditAllowed %>' EditColumnText=""
	OnReBind="DataGrid_ReBind"
	OnEditCommand="DataGrid_EditCommand"
	On
	AllowSorting="true">
	<Columns>
		<asp:boundcolumn datafield="group_id" visible="false"></asp:boundcolumn>
		<asp:TemplateColumn
 			HeaderText="Category Name"
			SortExpression="group_name"
			ItemStyle-VerticalAlign="Top">
			<ItemTemplate>
				<a href='<%# GetFormattedReportLink(DataBinder.Eval(Container.DataItem, "group_id")) %>'><%# DataBinder.Eval(Container.DataItem, "group_name") %></a>
			</ItemTemplate>
			</asp:TemplateColumn>
		<asp:TemplateColumn
 			HeaderText="Report<br>From"
			SortExpression="report_start"
			ItemStyle-VerticalAlign="Top">
			<ItemTemplate>
				<asp:Label ID="lblStartTime" Runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "report_start", "{0:d}" )%>'></asp:Label>
			</ItemTemplate>
			</asp:TemplateColumn>
		<asp:TemplateColumn
 			HeaderText="Report<br>Through"
			SortExpression="report_end"
			ItemStyle-VerticalAlign="Top">
			<ItemTemplate>
				<asp:Label ID="Label1" Runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "report_end", "{0:d}") %>'></asp:Label>
			</ItemTemplate>
			</asp:TemplateColumn>
		<asp:boundcolumn 
 			HeaderText="Minimum<br>Age" 
			SortExpression="min_age"
			datafield="min_age"
			ItemStyle-VerticalAlign="Top"></asp:boundcolumn>
		<asp:boundcolumn 
 			HeaderText="Maximum<br>Age" 
			SortExpression="max_age"
			datafield="max_age"
			ItemStyle-VerticalAlign="Top"></asp:boundcolumn>
		<asp:boundcolumn 
 			HeaderText="Minimum<br>Grade" 
			SortExpression="min_grade"
			datafield="min_grade"
			ItemStyle-VerticalAlign="Top"></asp:boundcolumn>
		<asp:boundcolumn 
 			HeaderText="Maximum<br>Grade" 
			SortExpression="max_grade"
			datafield="max_grade"
			ItemStyle-VerticalAlign="Top"></asp:boundcolumn>
	</Columns>
</Arena:DataGrid>
</asp:Panel>
<asp:Panel ID="pnlEdit" runat="server" Visible="false">
<table cellpadding="0" cellspacing="5" border="0">
	<tr>
		<td class="formLabel" nowrap>Category Name </td>
		<td class="formItem" nowrap><asp:Label ID="lbName" Runat="server" CssClass="formItem"></asp:Label>
		</td>
	</tr>
	<tr>
		<td class="formLabel" nowrap>Report From </td>
		<td class="formItem" nowrap>
			<Arena:DateTextBox ID="tbReportFrom" Runat="server" style="width:70px" CssClass="formItem" />
			<asp:RangeValidator ControlToValidate="tbReportFrom" ID="rvReportFrom" Type="Date" Runat="server" ErrorMessage="Report From Date must be a valid date!<br>" MinimumValue="1/1/1900" CssClass="errorText" MaximumValue="12/31/2099" Display="Dynamic"> *</asp:RangeValidator>
		</td>
	</tr>
	<tr>
		<td class="formLabel" nowrap>Report Through </td>
		<td class="formItem" nowrap>
			<Arena:DateTextBox ID="tbReportTo" Runat="server" style="width:70px" CssClass="formItem" />
			<asp:RangeValidator ControlToValidate="tbReportTo" ID="rvReportTo" Type="Date" Runat="server" ErrorMessage="Report Through Date must be a valid date!<br>" MinimumValue="1/1/1900" CssClass="errorText" MaximumValue="12/31/2099" Display="Dynamic"> *</asp:RangeValidator>
		</td>
	</tr>
	<tr>
		<td class="formLabel" nowrap>Minimum Age </td>
		<td class="formItem" nowrap>
			<asp:TextBox ID="tbMinAge" Runat="server" MaxLength="10" style="width:100px" CssClass="formItem"></asp:TextBox>
			<asp:RangeValidator ID="rvMinAge" ControlToValidate="tbMinAge" Runat="server" CssClass="errorText" Display="Dynamic" ErrorMessage="Minimum Age Must be Numeric" MinimumValue="0" MaximumValue="999" Type="Integer"> *</asp:RangeValidator>
		</td>
	</tr>
	<tr>
		<td class="formLabel" nowrap>Maximum Age </td>
		<td class="formItem" nowrap>
			<asp:TextBox ID="tbMaxAge" Runat="server" MaxLength="10" style="width:100px" CssClass="formItem"></asp:TextBox>
			<asp:RangeValidator ID="rvMaxAge" ControlToValidate="tbMaxAge" Runat="server" CssClass="errorText" Display="Dynamic" ErrorMessage="Maximum Age Must be Numeric" MinimumValue="0" MaximumValue="999" Type="Integer"> *</asp:RangeValidator>
		</td>
	</tr>
	<tr>
		<td class="formLabel" nowrap>Minimum Grade </td>
		<td class="formItem" nowrap>
			<asp:TextBox ID="tbMinGrade" Runat="server" MaxLength="10" style="width:100px" CssClass="formItem"></asp:TextBox>
			<asp:RangeValidator ID="rvMinGrade" ControlToValidate="tbMinGrade" Runat="server" CssClass="errorText" Display="Dynamic" ErrorMessage="Minimum Grade Must be Numeric" MinimumValue="0" MaximumValue="999" Type="Integer"> *</asp:RangeValidator>
		</td>
	</tr>
	<tr>
		<td class="formLabel" nowrap>Maximum Grade </td>
		<td class="formItem" nowrap>
			<asp:TextBox ID="tbMaxGrade" Runat="server" MaxLength="10" style="width:100px" CssClass="formItem"></asp:TextBox>
			<asp:RangeValidator ID="rvMaxGrade" ControlToValidate="tbMaxGrade" Runat="server" CssClass="errorText" Display="Dynamic" ErrorMessage="Maximum Grade Must be Numeric" MinimumValue="0" MaximumValue="999" Type="Integer"> *</asp:RangeValidator>
		</td>
	</tr>
</table>

<table cellpadding="0" cellspacing="5" border="0">
	<tr>
		<td>
			<asp:Button ID="btnUpdate" Runat="server" Text="Update" CssClass="smallText" onclick="btnUpdate_Click"></asp:Button>
			<asp:Button ID="btnCancel" Runat="server" Text="Cancel" CssClass="smallText" CausesValidation="False" onclick="btnCancel_Click"></asp:Button>
		</td>
	</tr>
	<tr>
		<td class="formItem"><asp:Label ID="lblMessage" Runat="server" CssClass="errorText"></asp:Label></td>
	</tr>
</table>
</asp:Panel>
