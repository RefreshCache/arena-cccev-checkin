/**********************************************************************
* Description:	Based on the OccurrenceTypeGroupList module!
* Created By:	Nick Airdo @ Central Christian Church of the East Valley
* Date Created:	9/23/2008 4:09:00 PM
*
* $Workfile: AttendanceTypeCategoryList.ascx.cs $
* $Revision: 1 $ 
* $Header: /Arena/Arena/Inetpub/wwwroot/Arena/UserControls/Custom/Cccev/Checkin/AttendanceTypeCategoryList.ascx.cs   1   2008-09-23 17:56:53-07:00   nicka $
* 
* $Log: /Arena/Arena/Inetpub/wwwroot/Arena/UserControls/Custom/Cccev/Checkin/AttendanceTypeCategoryList.ascx.cs $
*  
*  Revision: 1   Date: 2008-09-24 00:56:53Z   User: nicka 
*  initial working draft 
**********************************************************************/

namespace ArenaWeb.UserControls.Custom.Cccev.Checkin
{
	using System;
	using System.Web.UI;
	using System.Web.UI.WebControls;

	using Arena.Portal;
	using Arena.DataLayer.Core;
	using Arena.Core;
	using Arena.Security;
	using System.Text;

	public partial class AttendanceTypeCategoryList : PortalControl
	{

		#region Module Settings
		[PageSetting("Report Page", "The page used to show attendance reports for a particular category.", true)]
		public string ReportPageIDSetting { get	{ return base.Setting("ReportPageID", "", true); } }

		#endregion

		protected bool EditAllowed;

		protected int EditGroupID
		{
			get { return (int)ViewState[ "EditGroupID" ]; }
			set { ViewState[ "EditGroupID" ] = value; }
		}

		#region Event Handlers

		protected void Page_Load( object sender, EventArgs e )
		{
			EditAllowed = base.CurrentModule.Permissions.Allowed( OperationType.Edit, base.CurrentUser );

			if ( ! Page.IsPostBack )
			{
				ShowList();
			}
		}
		protected void DataGrid_EditCommand( object sender, DataGridCommandEventArgs e )
		{
			EditGroupID = Convert.ToInt32( e.Item.Cells[ 0 ].Text );
			ShowEdit( );
		}

		protected void btnUpdate_Click( object sender, EventArgs e )
		{
			OccurrenceTypeGroup occurrenceTypeGroup = new OccurrenceTypeGroup( EditGroupID );
			occurrenceTypeGroup.OrganizationId = base.CurrentPortal.OrganizationID;
			DateTime minDate = DateTime.Parse( "1/1/1900" );

			occurrenceTypeGroup.ReportStart = ( tbReportFrom.Text.Trim() == string.Empty ) ? minDate : DateTime.Parse( tbReportFrom.Text.Trim() );
			occurrenceTypeGroup.ReportEnd = ( tbReportTo.Text.Trim() == string.Empty ) ? minDate : DateTime.Parse( tbReportTo.Text.Trim() );

			occurrenceTypeGroup.MinAge = ( tbMinAge.Text.Trim() == string.Empty ) ? 0 : int.Parse( tbMinAge.Text );
			occurrenceTypeGroup.MaxAge = ( tbMaxAge.Text.Trim() == string.Empty ) ? 0 : int.Parse( tbMaxAge.Text );

			occurrenceTypeGroup.MinGrade = ( tbMinGrade.Text.Trim() == string.Empty ) ? 0 : int.Parse( tbMinGrade.Text );
			occurrenceTypeGroup.MaxGrade = ( tbMaxGrade.Text.Trim() == string.Empty ) ? 0 : int.Parse( tbMaxGrade.Text );

			occurrenceTypeGroup.Save( CurrentUser.Identity.Name );

			ShowList();
		}

		protected void btnCancel_Click( object sender, EventArgs e )
		{
			ShowList();
		}

		protected void DataGrid_ReBind( object sender, EventArgs e )
		{

		}

		#endregion

		public void ShowList()
		{
			pnlList.Visible = true;
			pnlEdit.Visible = false;
			dgOccurrenceTypeGroups.EditItemIndex = -1;
			dgOccurrenceTypeGroups.SelectedIndex = -1;

			dgOccurrenceTypeGroups.AddEnabled = false;
			dgOccurrenceTypeGroups.AllowSorting = true;
			dgOccurrenceTypeGroups.DeleteEnabled = false;
			dgOccurrenceTypeGroups.EditEnabled = false;
			dgOccurrenceTypeGroups.ExportEnabled = true;
			dgOccurrenceTypeGroups.ItemAltBgColor = CurrentPortalPage.Setting( "ItemAltBgColor", string.Empty, false );
			dgOccurrenceTypeGroups.ItemBgColor = CurrentPortalPage.Setting( "ItemBgColor", string.Empty, false );
			dgOccurrenceTypeGroups.ItemMouseOverColor = CurrentPortalPage.Setting( "ItemMouseOverColor", string.Empty, false );
			dgOccurrenceTypeGroups.ItemType = "Attendance Type Category";
			dgOccurrenceTypeGroups.MailEnabled = false;
			dgOccurrenceTypeGroups.MergeEnabled = false;
			dgOccurrenceTypeGroups.MoveEnabled = false;
			dgOccurrenceTypeGroups.SourceTableKeyColumnName = "group_id";
			dgOccurrenceTypeGroups.SourceTableName = "core_occurrence_type_group";

			dgOccurrenceTypeGroups.DataSource = new OccurrenceTypeGroupData().GetOccurrenceTypeGroupByOrganizationID_DT( base.CurrentPortal.OrganizationID );
			dgOccurrenceTypeGroups.DataBind();
		}

		private void ShowEdit( )
		{
			pnlList.Visible = false;
			pnlEdit.Visible = true;
			btnUpdate.Visible = EditAllowed;
			
			OccurrenceTypeGroup occurrenceTypeGroup = new OccurrenceTypeGroup( EditGroupID );
			lbName.Text = occurrenceTypeGroup.GroupName;

			tbReportFrom.Text = occurrenceTypeGroup.ReportStart.ToShortDateString();
			tbReportTo.Text = occurrenceTypeGroup.ReportEnd.ToShortDateString();
			tbMinAge.Text = occurrenceTypeGroup.MinAge.ToString();
			tbMaxAge.Text = occurrenceTypeGroup.MaxAge.ToString();
			tbMinGrade.Text = occurrenceTypeGroup.MinGrade.ToString();
			tbMaxGrade.Text = occurrenceTypeGroup.MaxGrade.ToString();
		}

		#region Helper Utils
		public string GetFormattedReportLink( object groupIDobj )
		{
			int groupID = (int)groupIDobj;

			if ( ReportPageIDSetting == string.Empty )
			{
				return string.Empty;
			}

			OccurrenceTypeGroup group = new OccurrenceTypeGroup( groupID );
			StringBuilder builder = new StringBuilder();
			builder.AppendFormat( "default.aspx?page={0}&Title={1}&GroupID={2}", ReportPageIDSetting, group.GroupName, groupID.ToString() );
			if ( ( group.ReportStart != DateTime.MinValue ) && ( group.ReportStart != DateTime.Parse( "1/1/1900" ) ) )
			{
				builder.AppendFormat( "&StartDate={0}", group.ReportStart.ToShortDateString() );
			}
			if ( ( group.ReportEnd != DateTime.MinValue ) && ( group.ReportEnd != DateTime.Parse( "1/1/1900" ) ) )
			{
				builder.AppendFormat( "&EndDate={0}", group.ReportEnd.ToShortDateString() );
			}
			builder.AppendFormat( "&MinAge={0}&MaxAge={1}&MinGrade={2}&MaxGrade={3}", new object[] { group.MinAge.ToString(), group.MaxAge.ToString(), group.MinGrade.ToString(), group.MaxGrade.ToString() } );
			return builder.ToString();
		}

		#endregion
		
	} // end class
} // end namespace