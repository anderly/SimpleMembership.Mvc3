using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Linq;
using System.Security.Principal;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;
using System.Web.Security;
using $rootnamespace$.Models;
using $rootnamespace$.Services;

namespace $rootnamespace$.Controllers
{
	public class SimpleMembershipAccountController : Controller
	{
		public IWebSecurityService WebSecurityService { get; set; }

		protected override void Initialize(RequestContext requestContext)
		{
			if (WebSecurityService == null) { WebSecurityService = new WebSecurityService(); }

			base.Initialize(requestContext);
		}

		// **************************************
		// URL: /Account/LogOn
		// **************************************

		public ActionResult LogOn()
		{
			return View();
		}

		[HttpPost]
		public ActionResult LogOn(LogOnModel model, string returnUrl)
		{
			if (ModelState.IsValid)
			{
				if (WebSecurityService.Login(model.UserName, model.Password, model.RememberMe))
				{
					if (Url.IsLocalUrl(returnUrl))
					{
						return Redirect(returnUrl);
					}
					else
					{
						return RedirectToAction("Index", "Home");
					}
				}
				else
				{
					ModelState.AddModelError("", "The user name or password provided is incorrect.");
				}
			}

			// If we got this far, something failed, redisplay form
			return View(model);
		}

		// **************************************
		// URL: /Account/LogOff
		// **************************************

		public ActionResult LogOff()
		{
			WebSecurityService.Logout();

			return RedirectToAction("Index", "Home");
		}

		// **************************************
		// URL: /Account/Register
		// **************************************

		public ActionResult Register()
		{
			ViewBag.PasswordLength = WebSecurityService.MinPasswordLength;
			return View();
		}

		[HttpPost]
		public ActionResult Register(RegisterModel model)
		{
			if (ModelState.IsValid)
			{
				// Attempt to register the user
				var requireEmailConfirmation = false;
				var token = WebSecurityService.CreateUserAndAccount(model.UserName, model.Password, requireEmailConfirmation);

				if (requireEmailConfirmation)
				{
					// TODO: Send email to user with confirmation token

					// Thank the user for registering and let them know an email is on its way
					return RedirectToAction("Thanks", "Account");
				}
				else
				{
					// Navigate back to the homepage and exit
					WebSecurityService.Login(model.UserName, model.Password);
					return RedirectToAction("Index", "Home");
				}
			}

			// If we got this far, something failed, redisplay form
			ViewBag.PasswordLength = WebSecurityService.MinPasswordLength;
			return View(model);
		}

		// **************************************
		// URL: /Account/ChangePassword
		// **************************************

		[Authorize]
		public ActionResult ChangePassword()
		{
			ViewBag.PasswordLength = WebSecurityService.MinPasswordLength;
			return View();
		}

		[Authorize]
		[HttpPost]
		public ActionResult ChangePassword(ChangePasswordModel model)
		{
			if (ModelState.IsValid)
			{
				if (WebSecurityService.ChangePassword(User.Identity.Name, model.OldPassword, model.NewPassword))
				{
					return RedirectToAction("ChangePasswordSuccess");
				}
				else
				{
					ModelState.AddModelError("", "The current password is incorrect or the new password is invalid.");
				}
			}

			// If we got this far, something failed, redisplay form
			ViewBag.PasswordLength = WebSecurityService.MinPasswordLength;
			return View(model);
		}

		// **************************************
		// URL: /Account/ChangePasswordSuccess
		// **************************************

		public ActionResult ChangePasswordSuccess()
		{
			return View();
		}

		public ActionResult Thanks()
		{
			return View();
		}

	}
}
