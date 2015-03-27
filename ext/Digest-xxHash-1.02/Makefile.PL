#! perl
use ExtUtils::MakeMaker;
WriteMakefile(
	NAME => 'Digest::xxHash',
	AUTHOR => 'Sanko Robinson',
	VERSION_FROM => 'lib/Digest/xxHash.pm',
	ABSTRACT => q/Digest::xxHash/,
	MIN_PERL_VERSION => 5.10.1,
	LINKTYPE => 'static',
	CCFLAGS => '-Isrc',
	OBJECT => q/$(O_FILES)/,
);
