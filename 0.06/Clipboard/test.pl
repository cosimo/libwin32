# TEST.PL for the Win32::Clipboard module, version 0.03
# by Aldo Calpini <dada@divinf.it>

use Win32::Clipboard;

$clip = Win32::Clipboard();

print "Clipboard Content:\n\n";
print $clip->Get();
print "\n";

$clip->Empty();
$clip->Set("ciao mondo!");

print "\nLook at your clipboard now!\n\n";