/*global jslintOpts*/
jslintOpts = {
  indent: 2,
  predef: ['jQuery', '$', 'suilib',
  'DataTableController', 'DataTreeController', 'DataTableController', 'FilterController', 'FormController'],
  browser    : true,  // if the standard browser globals should be predefined
  fragment   : true,  // if HTML fragments should be allowed
  forin      : true,  // if for in statements must filter
  bitwise    : true,  // if bitwise operators should not be allowed
  eqeqeq     : true,  // if === should be required
  glovar     : true,  // if HTML fragments should be allowed
  regexp     : true,  // if the . should not be allowed in regexp literals
  undef      : false, // if variables should be declared before used
  onevar     : false, // if only one var statement per function should be allowed
  newcap     : true,  // if Initial Caps must be used with constructor functions
  immed      : true,  // if immediate function invocations must be wrapped in parens
  plusplus   : false, // if increment/decrement should not be allowed
  nomen      : true   // if names should be checked
};
