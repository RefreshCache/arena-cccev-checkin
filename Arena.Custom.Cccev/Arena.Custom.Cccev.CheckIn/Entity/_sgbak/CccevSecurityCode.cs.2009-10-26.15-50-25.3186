using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;

using Arena.Custom.Cccev.CheckIn.DataLayer;

namespace Arena.Custom.Cccev.CheckIn.Entity
{
    public class CccevSecurityCode : ISecurityCode
    {
        private string securityCode = string.Empty;

        string ISecurityCode.GetSecurityCode()
        {
            securityCode = new CccevSecurityCodeData().GetNextSecurityCode();
            return securityCode;            
        }
    }
}
