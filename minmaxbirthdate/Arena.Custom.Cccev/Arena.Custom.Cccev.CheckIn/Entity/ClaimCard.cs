using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Drawing.Printing;
using System.Drawing.Text;
using System.Drawing.Imaging;
using System.Drawing.Drawing2D;
//using CentralChristianEV.Objects.Framework;

/**
 * $Workfile: ClaimCard.cs $
 * $Revision: 1 $ 
 * $Header: /trunk/Arena.Custom.Cccev/Arena.Custom.Cccev.CheckIn/Entity/ClaimCard.cs   1   2008-12-01 17:11:03-07:00   JasonO $
 * 
 * $Log: /trunk/Arena.Custom.Cccev/Arena.Custom.Cccev.CheckIn/Entity/ClaimCard.cs $
*  
*  Revision: 1   Date: 2008-12-02 00:11:03Z   User: JasonO 
 * 
 * 8     8/22/07 2:43p Nicka
 * Change to smaller nametag font for firstname = 8 chars
 * 
 * 7     8/22/07 2:13p Nicka
 * 
 * 6     12/16/04 12:35p Nicka
 * 
 * 5     12/16/04 10:32a Nicka
 * 
 * 4     11/10/04 11:14a Nicka
 * 
 * 3     9/29/04 2:50p Nicka
 * 
 * 2     9/29/04 2:32p Nicka
 * 
 * 1     9/28/04 12:55p Nicka
 * 
 * 5     8/26/04 1:17p Nicka
 * decrease size of parent signature text
 * 
 * 4     8/23/04 3:23p Nicka
 * Tweak to allow 3 lines of health notes.
 * 
 * 3     8/23/04 9:30a Nicka
 * Nearly finished (created by Jeff J)
 * 
 * 2     6/08/04 10:55a Nicka
 * alpha version 1
 */

namespace Arena.Custom.Cccev.CheckIn
{
	/// <summary>
	/// Bulk code for the AttendanceLabel class.
	/// </summary>
	public class PrinterLabel
	{
		//public System.Web.HttpResponse Response;

		public bool ScreenOutput=false;

		#region Constructors
		
		//Default constructor
        public PrinterLabel()
		{
		}
		
		#endregion
		
		#region Protected Members
		private int _pageNum = 0;
		#endregion
		
		#region ClaimCard and Attendance Label Properties

		protected string _ClaimCardSubTitle = string.Empty;
		public string ClaimCardSubTitle
		{
			get { return _ClaimCardSubTitle; }
			set { _ClaimCardSubTitle = value; }
		}		

		protected string _HealthNotes = string.Empty;
		public string HealthNotes
		{
			get { return _HealthNotes; }
			set { _HealthNotes = value; }
		}		
		
		protected string _HealthNotesTitle = string.Empty;
		public string HealthNotesTitle
		{
			get { return _HealthNotesTitle; }
			set { _HealthNotesTitle = value; }
		}		
		
		protected int _AttendanceLabelID;
		public int AttendanceLabelID
		{
			get { return _AttendanceLabelID; }
			set { _AttendanceLabelID = value; }
		}

		protected DateTime _CheckInDate = DateTime.Now;
		public DateTime CheckInDate
		{
			get { return _CheckInDate; }
			set { _CheckInDate = value; }
		}		
		
		protected string _DateTitle = string.Empty;
		public string DateTitle
		{
			get { return _DateTitle; }
			set { _DateTitle = value; }
		}
		
		protected string _Footer = string.Empty;
		public string Footer
		{
			get { return _Footer; }
			set { _Footer = value; }
		}		
		
		protected string _FirstName = string.Empty;
		public string FirstName
		{
			get { return _FirstName; }
			set { _FirstName = value; }
		}		
	
		protected string _LastName = string.Empty;
		public string LastName
		{
			get { return _LastName; }
			set { _LastName = value; }
		}

		protected string _FullName = string.Empty;
		public string FullName
		{
			get { return _FullName; }
			set { _FullName = value; }
		}		

		protected string _ParentsInitialsTitle = string.Empty;
		public string ParentsInitialsTitle
		{
			get { return _ParentsInitialsTitle; }
			set { _ParentsInitialsTitle = value; }
		}		
		
		protected string _SecurityToken = string.Empty;
		public string SecurityToken
		{
			get { return _SecurityToken; }
			set { _SecurityToken = value; }
		}

		//this needs to be split into two parts alpha and numeric portions
		// first 2 chars letters 
		// followed by numbers
		protected string _SecurityTokenTitle = string.Empty;
		public string SecurityTokenTitle
		{
			get { return _SecurityTokenTitle; }
			set { _SecurityTokenTitle = value; }
		}

		protected bool _SelfCheckOutFlag = false;
		public bool SelfCheckOutFlag
		{
			get { return _SelfCheckOutFlag; }
			set { _SelfCheckOutFlag = value; }
		}

		protected bool _HealthNoteFlag = false;
		public bool HealthNoteFlag
		{
			get { return _HealthNoteFlag; }
			set { _HealthNoteFlag = value; }
		}

		protected bool _LegalNoteFlag = false;
		public bool LegalNoteFlag
		{
			get { return _LegalNoteFlag; }
			set { _LegalNoteFlag = value; }
		}

		protected string _Services = string.Empty;
		public string Services
		{
			get { return _Services; }
			set { _Services = value; }
		}		
		
		protected string _ServicesTitle = string.Empty;
		public string ServicesTitle
		{
			get { return _ServicesTitle; }
			set { _ServicesTitle = value; }
		}		
		
		protected string _Title = string.Empty;
		protected string Title
		{
			get { return _Title; }
			set { _Title = value; }
		}		
		
		protected string _ClaimCardTitle = string.Empty;
		public string ClaimCardTitle
		{
			get { return _ClaimCardTitle; }
			set { _ClaimCardTitle = value; }
		}		

		protected string _AttendanceLabelTitle = string.Empty;
		public string AttendanceLabelTitle
		{
			get { return _AttendanceLabelTitle; }
			set { _AttendanceLabelTitle = value; }
		}			
		#endregion

		#region Nametag Properties

		protected string _AgeGroup = string.Empty;
		public string AgeGroup
		{
			get { return _AgeGroup; }
			set { _AgeGroup = value; }
		}				

		protected string _LogoURL = @"C:\Inetpub\wwwroot\CheckIn\images\xlogo_bw_lg.bmp";
		protected string LogoURL
		{
			get { return _LogoURL; }
			set { _LogoURL = value; }
		}				

		protected string _BDayCakeURL = @"C:\Inetpub\wwwroot\CheckIn\images\cake.bmp";
		protected string BDayCakeURL
		{
			get { return _BDayCakeURL; }
			set { _BDayCakeURL = value; }
		}

		protected DateTime _BirthdayDate = DateTime.MinValue;
		public DateTime BirthdayDate
		{
			get { return _BirthdayDate; }
			set { _BirthdayDate = value; }
		}

		#endregion

		#region Public Static Methods

		#endregion
		
		#region Protected Static Methods

		#endregion

		#region Public Instance Methods
		
		/// <summary>
		/// This method will print the Attendance Label and Claim Card to the given printer.
		/// </summary>
		/// <param name="printerURL">the URI/URL of the printer.</param>
		/// <exception cref="InvalidPrinter">is thrown if the given printer is invalid.</exception>
		/// <exception cref="FailedDuringPrint">will be thrown if a problem occurs when printing.</exception>
		public void PrintLabels( string printerURL, bool shouldPrintNametag )
		{
			if ( shouldPrintNametag )
			{
				PrintAllLabels( printerURL );
			}
			else
			{
				PrintAttendanceLabel( printerURL );
				PrintClaimCard( printerURL );
			}
		}

		/// <summary>
		/// This method will print the attendance label to the given printer.
		/// </summary>
		/// <param name="printerURL">the URI/URL of the printer.</param>
		/// <exception cref="InvalidPrinter">is thrown if the given printer is invalid.</exception>
		/// <exception cref="FailedDuringPrint">will be thrown if a problem occurs when printing.</exception>
		public void PrintAttendanceLabel( string printerURL )
		{
			this.Title = this.AttendanceLabelTitle;
			PrintDocument pDoc = new PrintDocument();

			// hook up the event handler for the PrintPage
			// method, which is where we will build our	document
			pDoc.PrintPage +=new PrintPageEventHandler(pEvent_PrintAttendanceLabelPage);
			
			pDoc.PrinterSettings.PrinterName = printerURL;

			// Now check to see if the printer is available
			// and call the Print method
			if (pDoc.PrinterSettings.IsValid)
			{
				try
				{
					pDoc.Print();
				}
				catch ( Exception ex )
				{
                    throw new Exception(ex.Message);
				}
			}
			else
			{
				//throw new InvalidPrinter( "The printer, " + printerURL + ", is not valid." );
			}
		}
		
		/// <summary>
		/// This method will print the Claim Card to the given printer.
		/// </summary>
		/// <param name="printerURL">the URI/URL of the printer.</param>
		/// <exception cref="InvalidPrinter">is thrown if the given printer is invalid.</exception>
		/// <exception cref="FailedDuringPrint">will be thrown if a problem occurs when printing.</exception>
		public void PrintClaimCard( string printerURL )
		{
			this.Title = this.ClaimCardTitle;
			PrintDocument pDoc = new PrintDocument();

			// hook up the event handler for the PrintPage
			// method, which is where we will build our	document
			pDoc.PrintPage += new PrintPageEventHandler(pEvent_PrintClaimCardPage);

			//pDoc.PrinterSettings.PrinterName = @"\\Quest\RoomB125";
			pDoc.PrinterSettings.PrinterName = printerURL;

			// Now check to see if the printer is available
			// and call the Print method
			if (pDoc.PrinterSettings.IsValid)
			{
				try
				{
					//throw new FailedDuringPrint( "TEST" );  // REMOVE -- FOR TESTING ONLY!!!!!
					pDoc.Print();
				}
				catch ( Exception ex )
				{
					throw new Exception( ex.Message );
				}
			}
			else
			{
                throw new Exception("The printer, " + printerURL + ", is not valid.");
			}
		}

		
		/// <summary>
		/// This method will print the Nametag to the given printer.
		/// </summary>
		/// <param name="printerURL">the URI/URL of the printer.</param>
		/// <exception cref="InvalidPrinter">is thrown if the given printer is invalid.</exception>
		/// <exception cref="FailedDuringPrint">will be thrown if a problem occurs when printing.</exception>
		public void PrintNametag( string printerURL )
		{
			PrintDocument pDoc = new PrintDocument();

			// hook up the event handler for the PrintPage
			// method, which is where we will build our	document
			pDoc.PrintPage +=new PrintPageEventHandler( pEvent_PrintNameTag );

			pDoc.PrinterSettings.PrinterName = printerURL;

			// Now check to see if the printer is available
			// and call the Print method
			if (pDoc.PrinterSettings.IsValid)
			{
				try
				{
					pDoc.Print();
				}
				catch ( Exception ex )
				{
                    throw new Exception(ex.Message);
				}
			}
			else
			{
                throw new Exception("The printer, " + printerURL + ", is not valid.");
			}
		}

		/// <summary>
		/// This method will print the Nametag to the given printer.
		/// </summary>
		/// <param name="printerURL">the URI/URL of the printer.</param>
		/// <exception cref="InvalidPrinter">is thrown if the given printer is invalid.</exception>
		/// <exception cref="FailedDuringPrint">will be thrown if a problem occurs when printing.</exception>
		public void PrintAllLabels( string printerURL )
		{
			PrintDocument pDoc = new PrintDocument();

			// hook up the event handler for the PrintPage
			// method, which is where we will build our	document
			pDoc.PrintPage +=new PrintPageEventHandler( pEvent_PrintAllLabels );
			pDoc.PrinterSettings.PrinterName = printerURL;

			// Now check to see if the printer is available
			// and call the Print method
			if (pDoc.PrinterSettings.IsValid)
			{
				try
				{
					pDoc.Print();
				}
				catch ( Exception ex )
				{
                    throw new Exception(ex.Message);
				}
			}
			else
			{
                throw new Exception("The printer, " + printerURL + ", is not valid.");
			}
		}

		// This is the event handler for printing the attendance label.
		// Build our document for printing here and it will output
		// using the print driver.
		private void pEvent_PrintAllLabels(object sender, PrintPageEventArgs e)
		{
			this._pageNum++;

			switch ( _pageNum )
			{
				case 1:
					pEvent_PrintAttendanceLabelPage( sender, e );
					e.HasMorePages = true;
					break;

				case 2:
					pEvent_PrintClaimCardPage( sender, e );
					e.HasMorePages = true;
					break;

				case 3:
					pEvent_PrintNameTag( sender, e );
					e.HasMorePages = false;
					break;
			}
		}

		public void PrintClaimCardToScreenTest()
		{
			ScreenOutput=true;
			this.Title = this.ClaimCardTitle;
			PrintDocument pDoc = new PrintDocument();

			// hook up the event handler for the PrintPage
			// method, which is where we will build our	document
			pDoc.PrintPage +=new PrintPageEventHandler(pEvent_PrintClaimCardPage );//pDoc_PrintPage);

			pDoc.Print();
		
		}

		public void PrintNametagToScreenTest()
		{
			ScreenOutput=true;
			this.FirstName = "Tommy";
			PrintDocument pDoc = new PrintDocument();

			// hook up the event handler for the PrintPage
			// method, which is where we will build our	document
			pDoc.PrintPage +=new PrintPageEventHandler( pEvent_PrintNameTag );
			pDoc.Print();
		}


		public void PrintAttendanceLabelToScreenTest()
		{
			ScreenOutput=true;
			this.Title = this.ClaimCardTitle;
			PrintDocument pDoc = new PrintDocument();

			// hook up the event handler for the PrintPage
			// method, which is where we will build our	document
			pDoc.PrintPage +=new PrintPageEventHandler(pEvent_PrintAttendanceLabelPage );//pDoc_PrintPage);

			pDoc.Print();
		
		}

		public override string ToString()
		{
			StringBuilder sb = new StringBuilder();
			sb.Append( "AttendanceLabel -> " );

			sb.Append( "SecurityToken [" + this.SecurityToken + "] : " );
			sb.Append( "ParentsInitialsTitle [" + this.ParentsInitialsTitle + "] : " );
			sb.Append( "SecurityTokenTitle [" + this.SecurityTokenTitle + "] : " );
			sb.Append( "HealthNotes [" + this.HealthNotes + "] : " );
			sb.Append( "ServicesTitle [" + this.ServicesTitle + "] : " );
			sb.Append( "CheckInDate [" + this.CheckInDate + "] : " );
			sb.Append( "Title [" + this.Title + "] : " );
			sb.Append( "DateTitle [" + this.DateTitle + "] : " );
			sb.Append( "HealthNotesTitle [" + this.HealthNotesTitle + "] : " );
			sb.Append( "Services [" + this.Services + "] : " );
			sb.Append( "AttendanceLabelID [" + this.AttendanceLabelID + "] : " );
			sb.Append( "FirstName [" + this.FirstName + "] : " );
			sb.Append( "FullName [" + this.FullName + "] : " );
			sb.Append( "Footer [" + this.Footer + "] : " );

			return ( sb.ToString() );
		}

		#endregion

		#region Protected Instance Methods

		// This is the event handler for printing
		// we build our document for printing here and it
		// will output using the print driver
		private void pEvent_PrintClaimCardPage(object sender, PrintPageEventArgs e)
		{
			// Create a Graphics object and add it to the
			// document

			int labelwidth = 195; //2.25 inches
			int labelheight = 144; //2 inches
			int xpos = 0; //temp x position placeholder
			int ypos = 0;  //temp y position placeholder

			//if (ScreenOutput) Response.Clear();
			Bitmap bmp = new Bitmap(labelwidth, labelheight, PixelFormat.Format24bppRgb);

			Graphics g;
			if (ScreenOutput) 
			{
				bmp.SetResolution(72,72);
				//grey bitmap 240,240,240 = greay background
				bmp=pDoc_SetBackground(bmp,240,240,240);
				g = Graphics.FromImage(bmp);
			}
			else
			{
				g = e.Graphics;
			}
		
			// Define the "brush" for printing
			SolidBrush br = new SolidBrush(Color.Black);


			//String format used to center text on label
			StringFormat format = new StringFormat();
			//format.Alignment=StringAlignment.Center;
			//g.DrawString(ClaimCardTitle, new Font("Arial Black", 13 ,System.Drawing.FontStyle.Italic),
			//	br, labelwidth/2, 1);
			
	
			format.Alignment = StringAlignment.Center;

			//Alignment / placement rectangle used to place all	text 
			Rectangle Rf = new Rectangle();
			//Set rectangle X Position to 0 (left)
			Rf.X=0;
			//Set y position to 5 - drop down 5 pixels from the top
			Rf.Y=5;
			//Set width of the position rectangle to the width variable
			Rf.Width=labelwidth;

			/*******************************************************************/
			/*                   Claim Card Title                              */
            /*******************************************************************/
			//Brush color to black 
			br.Color=Color.Black;
			g.DrawString(this.ClaimCardTitle , new Font("Arial Black",9,FontStyle.Italic ), br,Rf,format );

			/*******************************************************************/
			/*                   [CLAIM TICKET]                                */
			/*******************************************************************/
			//draw black rectangle
			int barwidth = 140; //black bar at the top			
			int barheight = 20;  //height of bar at top

			
			xpos=(labelwidth-barwidth)/2;//center x position of rectangle
			ypos=22;  //set y pos of rectangle
			g.FillRectangle (br,xpos,ypos,barwidth,barheight);

			//draw white text over rectangle
			Rf.X=0;
			Rf.Y=ypos;
			//Set width of the position rectangle to the width variable
			Rf.Width=labelwidth;
			
			//set the alignment of the text 
			format.Alignment= StringAlignment.Center;
			//Set text color to white
			br.Color=Color.White;
			g.DrawString(this.ClaimCardSubTitle, new Font("Arial Black",11), br,Rf,format );


			/*******************************************************************/
			/* Claim Card       DATE                 TIME                      */
			/*******************************************************************/
			ypos += 25; //advance the y position to do more drawing

			Rf.X=0;
			//set new y position (move down for next text)
			Rf.Y=ypos;

			//set the alignment
			format.Alignment= StringAlignment.Center;
			//Set text color back to black
			br.Color=Color.Black;
			g.DrawString(this.CheckInDate.ToShortDateString()+  "  " + this.CheckInDate.ToShortTimeString(), new Font("Arial",8), br, Rf,format);


			/*******************************************************************/
			/*Claim Card        Service(s): Time                 Time          */
			/*******************************************************************/
			ypos += 20; //advance the y position to do more drawing

			Rf.X=0;
			//set new y position (move down for next text)
			Rf.Y=ypos;

			//set the alignment
			format.Alignment= StringAlignment.Center;
			//Set text color back to black
			br.Color=Color.Black;
			g.DrawString(this.ServicesTitle + " " + this.Services, new Font("Arial",8), br, Rf,format);


			/*******************************************************************/
			/*Claim Card                      FirstName                        */
			/*******************************************************************/
			ypos += 15; //advance the y position to do more drawing

			Rf.X=0;
			//set new y position (move down for next text)
			Rf.Y=ypos;

			//set the alignment
			format.Alignment= StringAlignment.Center;
			//Set text color back to black
			br.Color=Color.Black;
			g.DrawString(this.FirstName, new Font("Arial",15, FontStyle.Bold), br, Rf,format);

			
			/*******************************************************************/
			/*Claim Card   Rotated Text (Security Code)                         */
			/*******************************************************************/
			int rotTextYpos=ypos+43;  //set y position of rotated text
			int rotTextXpos=35;  //set x postion of rotated text

			//not really sure what this does
			g.TranslateTransform(rotTextXpos,rotTextYpos);
			//rotate the text -90 degrees
			g.RotateTransform(-90);
			//fomrat the text
			format.FormatFlags = StringFormatFlags.NoClip;
			format.LineAlignment= StringAlignment.Center; 
			//Set text color back to black
			br.Color=Color.Black;
			//write the text
			g.DrawString(this.SecurityToken.Substring( 0, 2 ) , new Font("Arial",12), br, 0,0,format);
			//Reset the transform (thing i know nothing about)
			g.ResetTransform();

			ypos-=10; //adjust ypos height of the rotated text 

			/*******************************************************************/
			/*Claim Card         [Security Token ]                             */
			/*******************************************************************/
			//draw black rectangle

			int secbarheight = 30; //Black Security Bar Height
			int secbarwidth = 100; //Black Security Bar width
			
			xpos=(labelwidth-secbarwidth)/2;//center x position of rectangle
			ypos=ypos+secbarheight+10;  //set y pos of rectangle
			g.FillRectangle (br,xpos,ypos,secbarwidth,secbarheight);

			//draw white text over rectangle
			Rf.X=0;
			Rf.Y=ypos+(secbarheight/2);
			//Set width of the position rectangle to the width variable
			Rf.Width=labelwidth;
			
			//set the alignment of the text 
			format.Alignment= StringAlignment.Center;
			//Set text color to white
			br.Color=Color.White;
			g.DrawString(this.SecurityToken.Substring( 2 ) , new Font("Arial Black",18), br,Rf,format );

			
			/*******************************************************************/
			/*Claim Card                     Footer                            */
			/*******************************************************************/
			ypos += 65; //advance the y position to do more drawing

			Rf.X=0;
			//set new y position (move down for next text)
			Rf.Y=ypos;

			//set the alignment
			format.Alignment= StringAlignment.Center;
			//Set text color back to black
			br.Color=Color.Black;
			g.DrawString(this.Footer, new Font("Arial",7), br, Rf,format);
			
            //if (ScreenOutput)
            //{
            //    bmp.Save(Response.OutputStream, ImageFormat.Jpeg);
            //    g.Dispose();
            //    bmp.Dispose();
            //    Response.End();
            //}
			// Let it print
		}//end PrintClaimCardPage

		// This is the event handler for printing the attendance label.
		// Build our document for printing here and it will output
		// using the print driver.
		private void pEvent_PrintAttendanceLabelPage(object sender, PrintPageEventArgs e)
		{
			// Create a Graphics object and add it to the
			// document
			
			int labelwidth = 195; //2.25 inches
			int labelheight = 144; //2 inches
			int xpos = 0; //temp x position placeholder
			int ypos = 0;  //temp y position placeholder

			//if (ScreenOutput) Response.Clear();
			Bitmap bmp = new Bitmap(labelwidth, labelheight, PixelFormat.Format24bppRgb);

			Graphics g;
			if (ScreenOutput) 
			{
				bmp.SetResolution(72,72);
				//grey bitmap 240,240,240 = greay background
				bmp=pDoc_SetBackground(bmp,240,240,240);
				g = Graphics.FromImage(bmp);
			}
			else
			{
				g = e.Graphics;
			}
		
			// Define the "brush" for printing
			SolidBrush br = new SolidBrush(Color.Black);

			//String format used to center text on label
			StringFormat format = new StringFormat();
			//format.Alignment=StringAlignment.Center;
			//g.DrawString(ClaimCardTitle, new Font("Arial Black", 13 ,System.Drawing.FontStyle.Italic),
			//	br, labelwidth/2, 1);
			
			format.Alignment = StringAlignment.Center;

			//Alignment / placement rectangle used to place all	text 
			Rectangle Rf = new Rectangle();
			//Set rectangle X Position to 0 (left)
			Rf.X=0;
			//Set y position to 5 - drop down 5 pixels from the top
			Rf.Y=7;
			//Set width of the position rectangle to the width variable
			Rf.Width=labelwidth;

			/*******************************************************************/
			/*                   Attendance Card Title                         */
			/*******************************************************************/
			//Brush color to black 
			br.Color=Color.Black;
			g.DrawString(this.AttendanceLabelTitle , new Font("Arial Black",9,FontStyle.Italic ), br,Rf,format );

			/*******************************************************************/
			/*Attendance        DATE                 TIME                      */
			/*******************************************************************/
			ypos += 25; //advance the y position to do more drawing

			Rf.X=0;
			//set new y position (move down for next text)
			Rf.Y=ypos;

			//set the alignment
			format.Alignment= StringAlignment.Center;
			//Set text color back to black
			br.Color=Color.Black;
			g.DrawString(this.CheckInDate.ToShortDateString()+  "  " + this.CheckInDate.ToShortTimeString(), new Font("Arial",8), br, Rf,format);

			/*******************************************************************/
			/*Attendance        Service(s): Time                 Time          */
			/*******************************************************************/
			ypos += 20; //advance the y position to do more drawing

			Rf.X=0;
			//set new y position (move down for next text)
			Rf.Y=ypos;

			//set the alignment
			format.Alignment= StringAlignment.Center;
			//Set text color back to black
			br.Color=Color.Black;

			// Change the font based on whether or not there are multiple service times
			Font serviceFont = new Font("Arial",8);
			if ( this.Services.IndexOf("&",0 ) > 0 )
			{
				Pen blackPen = new Pen(Color.Black);
				g.DrawRectangle(blackPen, Rf.X, Rf.Y, 200.0F, 13.0F);

				this.ServicesTitle = "Transfer:";
				serviceFont = new Font("Arial Black",7, FontStyle.Italic );
			}

			g.DrawString(this.ServicesTitle + "  " + this.Services, serviceFont, br, Rf,format);

			/*******************************************************************/
			/*Attendance                     FullName                         */
			/*******************************************************************/
			ypos += 15; //advance the y position to do more drawing

			Rf.X=0;
			//set new y position (move down for next text)
			Rf.Y=ypos;

			//set the alignment
			format.Alignment= StringAlignment.Center;
			//Set text color back to black
			br.Color=Color.Black;
			g.DrawString(this.FullName, new Font("Arial",12,FontStyle.Bold), br, Rf,format);
			
			/*******************************************************************/
			/*Attendance  Rotated Text (Security Code)                         */
			/*******************************************************************/
			int rotTextYpos=ypos+35;  //set y position of rotated text
			int rotTextXpos=35;  //set x postion of rotated text

			//not really sure what this does
			g.TranslateTransform(rotTextXpos,rotTextYpos);
			//rotate the text -90 degrees
			g.RotateTransform(-90);
			//fomrat the text
			format.FormatFlags = StringFormatFlags.NoClip;
			format.LineAlignment= StringAlignment.Center; 
			//Set text color back to black
			br.Color=Color.Black;
			//write the text
			g.DrawString(this.SecurityToken.Substring( 0, 2 ) , new Font("Arial",12), br, 0,0,format);
			//Reset the transform (thing i know nothing about)
			g.ResetTransform();

			ypos-=10; //adjust ypos height of the rotated text 

			
			/*******************************************************************/
			/*Attendance         [Security Token ]                             */
			/*******************************************************************/
			//draw black rectangle

			int secbarheight = 30; //Black Security Bar Height
			int secbarwidth = 100; //Black Security Bar width
			
			xpos=(labelwidth-secbarwidth)/2;//center x position of rectangle
			ypos=ypos+secbarheight;  //set y pos of rectangle
			g.FillRectangle (br,xpos,ypos,secbarwidth,secbarheight);

			//draw white text over rectangle
			Rf.X=0;
			Rf.Y=ypos+(secbarheight/2);
			//Set width of the position rectangle to the width variable
			Rf.Width=labelwidth;
			
			//set the alignment of the text 
			format.Alignment= StringAlignment.Center;
			//Set text color to white
			br.Color=Color.White;
			g.DrawString(this.SecurityToken.Substring( 2 ) , new Font("Arial Black",18), br,Rf,format );

			/* Required Y adjustment to add flags */
			if (this.HealthNoteFlag || this.LegalNoteFlag || this.SelfCheckOutFlag )
			{   
				ypos+=10;
				xpos+=22;
			}

			/*******************************************************************/
			/*Attendance               Health note flag                        */
			/*******************************************************************/

			if (this.SelfCheckOutFlag) 
			{
				Rf.X=xpos;
				Rf.Y=ypos;
				//set the alignment
				format.Alignment= StringAlignment.Center;
				//Set text color back to black
				br.Color=Color.Black;
				g.DrawString("*", new Font("Arial",20,FontStyle.Bold ), br, Rf,format);
			}

			/*******************************************************************/
			/*Attendance               Legal note flag                         */
			/*******************************************************************/

			if (this.LegalNoteFlag) 
			{
				xpos+=12;
				//ypos+=10;

				Rf.X=xpos;
				Rf.Y=ypos;
				//set the alignment
				format.Alignment= StringAlignment.Center ;
				//Set text color back to black
				br.Color=Color.Black;
				g.DrawString("!", new Font("Arial",20,FontStyle.Bold ), br, Rf,format);
			}

			/*******************************************************************/
			/*Attendance              [HealthNotes ]                             */
			/*******************************************************************/
			//draw black rectangle

			int allergybarheight = 30; //Black Security Bar Height (20 ~ 2mm; 30 ~ 4mm)
			if (this.HealthNoteFlag) 
			{
				// Truncate HealthNotes if greater than 113 characters.
				string truncatedHealthNotes = this.HealthNotes;
				if ( truncatedHealthNotes.Length > 113 )
				{
					truncatedHealthNotes = truncatedHealthNotes.Substring( 0, 113 ) + "...";
				}

				int squishyness = 3; // amount to squish the black box text in 
				// from the side of the label edge
				int allergybarwidth = labelwidth - squishyness; //Black Security Bar width
			
				xpos=(labelwidth-allergybarwidth)/2+10;//center x position of rectangle
				ypos=ypos+30;  //set y pos of rectangle
				//Set color to black
				br.Color=Color.Black;
				g.FillRectangle (br,xpos,ypos,allergybarwidth,allergybarheight);

				//draw white text over rectangle
				Rf.X=(int)(squishyness/2)+10;
				Rf.Y=ypos+15;
				//Set width of the position rectangle to the width variable
				Rf.Width=labelwidth - squishyness;
			
				//set the alignment of the text 
				format.Alignment= StringAlignment.Near;
				//Set text color to white
				br.Color=Color.White;
				g.DrawString(this.HealthNotesTitle + " " + truncatedHealthNotes, new Font("Arial",6, FontStyle.Bold), br,Rf,format );
			}
			else
			{
				ypos=ypos+30;  //set y pos of rectangle
			}

			/*******************************************************************/
			/*Attendance           Parents Initials Title                      */
			/*******************************************************************/
			ypos += allergybarheight+25; //advance the y position to do more drawing

			Rf.X=0;
			//set new y position (move down for next text)
			Rf.Y=ypos + 5;

			//set the alignment
			format.Alignment= StringAlignment.Near;
			//Set text color back to black
			br.Color=Color.Black;
			Rf.Width=labelwidth + 30; // let the signature go all the way to the edge
			g.DrawString(this.ParentsInitialsTitle, new Font("Arial",7), br, Rf,format);

            //if (ScreenOutput)
            //{
            //    bmp.Save(Response.OutputStream, ImageFormat.Jpeg);
            //    g.Dispose();
            //    bmp.Dispose();
            //    Response.End();
            //}
			// Let it print
		}

		/// <summary>
		/// This code created by Jeff J for use with sending output
		/// to the screen.
		/// </summary>
		/// <param name="tmpbmp"></param>
		/// <param name="r"></param>
		/// <param name="g"></param>
		/// <param name="b"></param>
		/// <returns></returns>
		private Bitmap pDoc_SetBackground(Bitmap tmpbmp, int r, int g, int b)
		{
			int width = tmpbmp.Width;
			int height = tmpbmp.Height;
			int i, j;
			for (i = 0; i< width; i++) 
			{
				for (j=0; j<height; j++)
				{
					Color newColor = Color.FromArgb(r, g, b);
					tmpbmp.SetPixel(i, j, newColor);
				}
			}
			return tmpbmp;
		}


		/// <summary>
		/// This is the event handler for printing the name tag label.
		/// Build our document for printing here and it will output
		/// using the print driver.
		/// </summary>
		/// <param name="sender"></param>
		/// <param name="e"></param>
		private void pEvent_PrintNameTag(object sender, PrintPageEventArgs e)
		{
			int labelwidth = 216 ;  // 2.25 inches * 96dpi
			int labelheight = 220;//192;  // 2 inches * 96dpi
			
			//String format used to center text on label
			StringFormat format = new StringFormat();
			// Define the "brush" for printing
			SolidBrush br = new SolidBrush(Color.Black);
			Rectangle rectangle = new Rectangle();

			//if ( ScreenOutput ) Response.Clear();
			Bitmap bmp = new Bitmap(labelwidth, labelheight, PixelFormat.Format8bppIndexed);

			Graphics g;

			// If we're outputting to a screen, build the graphic a bit differently.
			if ( ScreenOutput ) 
			{
				bmp.SetResolution(96,96);
				bmp=pDoc_SetBackground(bmp,240,240,240);
				g = Graphics.FromImage(bmp);
			}
			else
			{
				g = e.Graphics;
			}
		
			// smothing mode on
			g.SmoothingMode = SmoothingMode.AntiAlias;

			/*******************************************************************/
			/*                              Age Group                          */
			/*******************************************************************/

			//Set color to black
			br.Color=Color.Black;
			g.FillRectangle (br, 0, 0, labelwidth, 20 );

			//draw white text over rectangle, starting at top and about 15 down
			rectangle.X = 0;
			rectangle.Y = 2;
			//Set width of the position rectangle to the width variable
			rectangle.Width = labelwidth;
			
			//set the alignment of the text 
			format.Alignment= StringAlignment.Far;

			//Set text color to white
			br.Color=Color.White;
			g.DrawString( this.AgeGroup, new Font("Arial", 12, FontStyle.Bold), br, rectangle, format );

			/*******************************************************************/
			/*                           FirstName                             */
			/*******************************************************************/
			br.Color=Color.Black;

			//String format used to center text on label
			format.Alignment = StringAlignment.Near;

			//Set X Position to 0 (left) and Y position down a bit
			rectangle.X = -5;
			rectangle.Y = 20;

			// Set rectangle's width to width of label
			rectangle.Width = labelwidth;

			string firstName = this.FirstName;

			// Resize based on the length of the person's firstname
			int fontSize = 35; // size for names 4 chars in length or less
			if ( 5 < this.FirstName.Length && this.FirstName.Length <= 7 )
			{
				rectangle.X = -3;
				rectangle.Y = 30;
				fontSize = 30;
			}
			else if ( 8 <= this.FirstName.Length && this.FirstName.Length <= 10 )
			{
				rectangle.X = 0;
				rectangle.Y = 35;
				fontSize = 25; //
			}
			else if ( 11 <= this.FirstName.Length )
			{
				rectangle.X = 2;
				rectangle.Y = 40;
				fontSize = 20; // max size
				if ( firstName.Length >= 13 )
					firstName = firstName.Substring( 0, 13 );
			}

			g.DrawString( firstName, new Font("Arial", fontSize, FontStyle.Bold), br, rectangle, format );

			/*******************************************************************/
			/*                           Lastname                              */
			/*******************************************************************/
			br.Color=Color.Black;

			//String format used to center text on label
			format.Alignment = StringAlignment.Near;

			//Set X Position to 0 (left) and Y position down a bit
			rectangle.X = 5;  // from left
			rectangle.Y = 70; // from top

			// Set rectangle's width to width of label
			rectangle.Width = labelwidth;

			// Resize based on the length of the person's firstname
			fontSize = 15;
			if ( 16 <= this.LastName.Length )
			{
				fontSize = 10;
			}

			// 7/9/2007 Per Julie B and Steve H, don't print lastnames.
			//g.DrawString(this.LastName, new Font("Arial", fontSize, FontStyle.Bold), br, rectangle, format);

			/*******************************************************************/
			/*              Health note & Self Check Out flag                  */
			/*******************************************************************/
			rectangle.X = 95; // from left
			rectangle.Y = 65; // from top

			format.Alignment= StringAlignment.Center;
			string flags = "";

			if ( this.SelfCheckOutFlag ) 
			{
				flags = "*";
			}

			if ( this.LegalNoteFlag ) 
			{
				flags = flags + "!";
			}

			g.DrawString(flags, new Font("Arial",20,FontStyle.Bold ), br, rectangle, format);

			/*******************************************************************/
			/*                             Separator Line                      */
			/*******************************************************************/

			//Set color to black
			br.Color=Color.Black;
			g.FillRectangle (br, 0, 95, labelwidth, 1 );

			/*******************************************************************/
			/*                             Birthday Cake or Logo               */
			/*******************************************************************/
			System.Drawing.Image img;
			// Load a graphic from a file...
			// based on whether it is the person's birthday this week.
			if ( this.BirthdayDate != DateTime.MinValue && this.BirthdayDate.DayOfYear >= DateTime.Now.DayOfYear
				&& this.BirthdayDate.DayOfYear < DateTime.Now.DayOfYear + 7 )
			{
				img = System.Drawing.Image.FromFile( this._BDayCakeURL, true );

				// determine which day of the week the birthday falls on this year:
				string dowBirthdayThisYear = new DateTime( DateTime.Now.Year, this.BirthdayDate.Month, this.BirthdayDate.Day).DayOfWeek.ToString();
				if ( dowBirthdayThisYear.Equals( DateTime.Now.DayOfWeek.ToString() ) )
				{
					dowBirthdayThisYear = "Today!";
				}
				// write the DayOfWeek that the birthday occurs under the image
				br.Color=Color.Black;
				format.Alignment = StringAlignment.Center;
				RectangleF dayOfWeekRect = new RectangleF( 130.0F, 173.0F, 56.0F, 13.0F);
				g.DrawString( dowBirthdayThisYear, new Font("Arial", 7), br, dayOfWeekRect, format );
			}
			else
			{
				img = System.Drawing.Image.FromFile( this._LogoURL, true );
			}

			// Define a rectangle to locate the graphic:
			// x,y ,width, height (where x,y is the coord of the upper left corner of the rectangle)
			RectangleF rect = new RectangleF( 130.0F, 115.0F, 56.0F, 56.0F);

			// Add the image to the document
			g.DrawImage(img, rect);

			/*******************************************************************/
			/*                          Print It / Done                        */
			/*******************************************************************/

            //if ( ScreenOutput )
            //{
            //    bmp.Save(Response.OutputStream, ImageFormat.Jpeg);
            //    g.Dispose();
            //    bmp.Dispose();
            //    Response.End();
            //}
			// Let it print
		}

		#endregion
	}
}
