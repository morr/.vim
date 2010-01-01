jslintOpts = {
	//adsafe: true,
	// if ADsafe.org  rules widget pattern should be enforced.
	//bitwise: true,
	// if bitwise operators should not be allowed
	//browser: true,
	// if the standard browser globals should be predefined
	//cap: true,
	// if upper case HTML should be allowed
	//newcap: true,
	// if Initial Caps must be used with constructor functions
	//css: true,
	// if CSS workarounds should be tolerated
	//debug: true,
	// if debugger statements should be allowed
	//eqeqeq: true,
	// if === should be required
	//evil: true,
	// if eval should be allowed
	//forin: true,
	// if unfiltered for in statements should be allowed
	//fragment: true,
	// if HTML fragments should be allowed
	indent: 2,
	//the number of spaces used for indentation (default is 4)
	//laxbreak: true,
	// if statement breaks should not be checked
	//nomen: true,
	// if names should be checked for initial underbars
	//on: true,
	// if HTML event handlers should be allowed
	//onevar: true,
	// if only one var statement per function should be allowed
	passfail: false,
	// if the scan should stop on first error
	//plusplus: true,
	// if ++ and -- should not be allowed
	predef: ['document','dojo', 'dijit', 'app', 'kley', 'console', 'dojox','dor','doh','mui'],
	//an array of strings, the names of predefined global variables
	//regexp: true,
	// if . should not be allowed in RegExp literals
	//rhino: true,
	// if the Rhino environment globals should be predefined
	//safe: true,
	// if the safe subset rules are enforced. These rules are used by ADsafe.
	//sidebar: false,
	// if the Windows Sidebar Gadgets globals should be predefined
	//strict: true,
	// if the ES3.1 "use strict"; pragma is required.
	//sub: true,
	// if subscript notation may be used for expressions better expressed in dot notation
	undef: true,
	// if undefined global variables are errors
	//white: true,
	// if strict whitespace rules apply
	//widget: false // if the Yahoo Widgets globals should be predefined
}
