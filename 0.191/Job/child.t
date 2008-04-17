print STDERR "Child (pid=$$) [STDERR]\n";
while (1) {
	wait unless defined fork;
	$y++ for (1 .. 1000_000);
	print "$$: $y [STDOUT]\n";
};
