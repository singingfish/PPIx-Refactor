#!/usr/bin/env perl;
use warnings;
use strict;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'PPIx::Refactor',
    AUTHOR           => q{Kieren Diment <zarquon@cpan.org>},
    VERSION_FROM     => 'lib/PPIx/Refactor.pm',
    ABSTRACT_FROM    => 'lib/PPIx/Refactor.pm',
    LICENSE          => 'Artistic_2_0',
    PL_FILES         => {},
    MIN_PERL_VERSION => 5.006,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'Test::More' => 0,
    },
    PREREQ_PM => {
        'Moo' => 0,
        'strictures' => 2,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'PPIx-Refactor-*' },
    META_MERGE => {
        'meta-spec' => { version => 2 },
         resources => {
             repository => {
                 type => 'git',
                 url  => 'git@github.com:singingfish/PPIx-Refactor.git',
                 web  => 'https://github.com/singingfish/PPIx-Refactor',
             },
         },
    },
);
