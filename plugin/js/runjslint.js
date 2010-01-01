(function(args) {
  var path = args[1];
  load(path + 'fulljslint.js');
  load(path + 'jslint.settings.js');
  var input = "";
  var line = "";
  var blankcount = "0";
  while (blankcount < 10) {
    line = readline();

    if (line == "") blankcount++;
    else blankcount = 0;
    if (line == "END") break;
    input += line;
    input += "\n";
  }
  input = input.substring(0, input.length - blankcount);
  if (!JSLINT(input, jslintOpts)) {
    for (var i = 0; i < JSLINT.errors.length; i += 1) {
      var e = JSLINT.errors[i];
      if (e) {
        print(args[0] + ':' + (e.line + 1) + ':' + (e.character + 1) + ': ' + e.reason + ' ... ' + e.evidence + ' ... ');
      }
    }
  } else {
    print("jslint: No problems.");
    quit();
  }

})(arguments);
