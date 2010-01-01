(function(args) {
	//first arg must by path to beautify.js
	var path = args[0];
	load(path + 'beautify.js');
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
	var options = {
		indent_size: 1,
		indent_char: '\t'
	};
	print(js_beautify(input, options));
})(arguments);
