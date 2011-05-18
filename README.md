# SimpleMembership.Mvc3

SimpleMembership.Mvc3 enables the SimpleMembership API from WebMatrix/WebPages (i.e. WebSecurity) to be used with ASP.NET MVC3.

## Features

* Includes a web activator and web.config transforms that enable the SimpleMembershipProvider
* Includes an abstraction of the WebSecurity helper (IWebSecurityService) and an implementation (WebSecurityService) to enable use with DI/IoC frameworks such as NInject, etc.
* Includes a SimpleMembershipAccountController which can be used as a drop-in replacement for the default AccountController in new MVC projects. This controller uses the included WebSecurityService instead of the FormsAuthenticationService and MembershipService for authentication and membership.

## Usage

Install-Package SimpleMembership.Mvc3

See http://ander.ly/SimpleMembershipMvc3 for more details

## Copyright

Copyright 2011 Adam Anderly

## License

License? What License?