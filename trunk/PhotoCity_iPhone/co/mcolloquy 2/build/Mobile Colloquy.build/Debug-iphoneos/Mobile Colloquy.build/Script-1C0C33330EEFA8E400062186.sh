#!/usr/bin/perl -w
# Xcode auto-versioning script for Subversion
# by Axel Andersson, modified by Daniel Jalkut and Timothy Hatcher

use strict;

# Get the current subversion revision number and use it to set the CFBundleVersion value
my $infoFile = "$ENV{BUILT_PRODUCTS_DIR}/$ENV{INFOPLIST_PATH}";
my $version = undef;
$version = `/usr/bin/svnversion -n .` if -e "/usr/bin/svnversion";
$version = `/usr/local/bin/svnversion -n .` if -e "/usr/local/bin/svnversion";
$version = `/opt/local/bin/svnversion -n .` if -e "/opt/local/bin/svnversion";

# Match the last group of digits:
($version =~ m/(\d+)[MS]*$/) && ($version = $1);

if( $version ) {
	`plutil -convert xml1 "$infoFile"`;

	open( FH, "$infoFile" ) or die "$0: $infoFile: $!";
	my $content = join( "", <FH> );
	close( FH );

	$content =~ s/(\s+<key>CFBundleVersion<\/key>\s+<string>).*?(<\/string>)/$1$version$2/;

	open( FH, ">$infoFile" ) or die "$0: $infoFile: $!";
	print FH $content;
	close( FH );

	`plutil -convert binary1 "$infoFile"`;
}

