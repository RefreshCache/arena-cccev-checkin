/**********************************************************************
* Description:	TBD
* Created By:   Jason Offutt @ Central Christian Church of the East Valley
* Date Created:	TBD
*
* $Workfile: ISecurityCode.cs $
* $Revision: 4 $ 
* $Header: /trunk/Arena.Custom.Cccev/Arena.Custom.Cccev.CheckIn/Entity/ISecurityCode.cs   4   2009-02-24 11:18:51-07:00   JasonO $
* 
* $Log: /trunk/Arena.Custom.Cccev/Arena.Custom.Cccev.CheckIn/Entity/ISecurityCode.cs $
*  
*  Revision: 4   Date: 2009-02-24 18:18:51Z   User: JasonO 
*  Updating org setting keys for provider class Luids. 
*  
*  Revision: 3   Date: 2009-01-06 16:06:08Z   User: JasonO 
**********************************************************************/

using System;
using System.Reflection;
using System.Text;

using Arena.Core;
using Arena.Exceptions;
using Arena.Organization;

namespace Arena.Custom.Cccev.CheckIn.Entity
{
    public interface ISecurityCode
    {
        /// <summary>
        /// Returns security code.
        /// </summary>
        /// <returns><see cref="string"/>Security Code</returns>
        string GetSecurityCode();
    }

    public static class SecurityCodeHelper
    {
        public static Lookup DefaultSecurityCodeSystem(int organizationID)
        {
            Arena.Organization.Organization org = new Arena.Organization.Organization(organizationID);
            Lookup lookup = null;

            if (org.Settings["Cccev.SecurityCodeDefaultSystemID"] != null)
            {
                try
                {
                    lookup = new Lookup(int.Parse(org.Settings["Cccev.SecurityCodeDefaultSystemID"]));
                }
                catch { }
            }

            return lookup;
        }

        public static ISecurityCode GetSecurityCodeClass(Lookup securityCodeSystem)
        {
            Assembly assembly = Assembly.Load(securityCodeSystem.Qualifier2);

            if (assembly == null)
                return null;

            Type type = assembly.GetType(securityCodeSystem.Qualifier8);

            if (type == null)
            {
                type = assembly.GetType(securityCodeSystem.Qualifier2 + "." + securityCodeSystem.Qualifier8);
            }

            if (type == null)
            {
                throw new ArenaApplicationException(string.Format("Could not find '{0}' class in '{1}' assembly.", securityCodeSystem.Qualifier2, securityCodeSystem.Qualifier8));
            }

            return (ISecurityCode)Activator.CreateInstance(type);
        }
    }
}
