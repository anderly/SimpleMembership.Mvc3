using System.Collections.Specialized;
using System.Configuration;
using System.Web.Security;
using WebMatrix.WebData;

[assembly: WebActivator.PreApplicationStartMethod(typeof($rootnamespace$.AppStart_SimpleMembershipMVC3), "Start")]

namespace $rootnamespace$
{
	public static class AppStart_SimpleMembershipMVC3
	{
		public static readonly string EnableSimpleMembershipKey = "enableSimpleMembership";

		public static bool SimpleMembershipEnabled
		{
			get { return IsSimpleMembershipEnabled(); }
		}

		public static void Start()
		{
			if (SimpleMembershipEnabled)
			{
				MembershipProvider provider = Membership.Providers["AspNetSqlMembershipProvider"];
				if (provider != null)
				{
					MembershipProvider currentDefault = provider;
					SimpleMembershipProvider provider2 = CreateDefaultSimpleMembershipProvider("AspNetSqlMembershipProvider", currentDefault);
					Membership.Providers.Remove("AspNetSqlMembershipProvider");
					Membership.Providers.Add(provider2);
				}
				Roles.Enabled = true;
				RoleProvider provider3 = Roles.Providers["AspNetSqlRoleProvider"];
				if (provider3 != null)
				{
					RoleProvider provider6 = provider3;
					SimpleRoleProvider provider4 = CreateDefaultSimpleRoleProvider("AspNetSqlRoleProvider", provider6);
					Roles.Providers.Remove("AspNetSqlRoleProvider");
					Roles.Providers.Add(provider4);
				}
			}
		}

		#region : Private Methods :

		private static bool IsSimpleMembershipEnabled()
		{
			bool flag;
			string str = ConfigurationManager.AppSettings[EnableSimpleMembershipKey];
			if (!string.IsNullOrEmpty(str) && bool.TryParse(str, out flag))
			{
				return flag;
			}
			return true;
		}

		private static SimpleMembershipProvider CreateDefaultSimpleMembershipProvider(string name, MembershipProvider currentDefault)
		{
			MembershipProvider previousProvider = currentDefault;
			SimpleMembershipProvider provider = new SimpleMembershipProvider(previousProvider);
			NameValueCollection config = new NameValueCollection();
			provider.Initialize(name, config);
			return provider;
		}

		private static SimpleRoleProvider CreateDefaultSimpleRoleProvider(string name, RoleProvider currentDefault)
		{
			RoleProvider previousProvider = currentDefault;
			SimpleRoleProvider provider = new SimpleRoleProvider(previousProvider);
			NameValueCollection config = new NameValueCollection();
			provider.Initialize(name, config);
			return provider;
		}

		#endregion

	}
}
