#! /usr/bin/env node
const exec = require("child_process").exec;

var n = 30*10; // Total Frames
var i = 0; // Current Frame

//
function filename_for_frame(i) {
	var s = ""+i;
	return "frames/f" + "0".repeat(5-s.length) + s + ".png";
}

// Start renderer for one frame
function next_frame(error, stdout, stderr) {
	if (i == n) return;
	if (error) {
		return;
	}

// $vpt = [-9.51, 25.47, 35.45];
// $vpr = [71.1, 0, 46.9];
// $vpd = 325.23;

	cmd = "openscad demo_charmander.scad"
		+ " --camera=-9.51,25.47,35.45,71.1,0,46.9,325.23"
		+ " --imgsize=1920,1080"
		+ " --projection=p"
		+ " -D t=" + (i/n)
		+ " -o " + filename_for_frame(i);
	
	console.log("Start rendering frame " + i + "...");
	exec(cmd, next_frame);
	
	++i;
}

var threads = 8; // Number of threads to spawn
while(threads--) next_frame();
