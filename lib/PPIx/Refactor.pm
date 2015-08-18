package PPIx::Refactor;
use Moo;
use Path::Tiny;
BEGIN {
    use File::Path;
    use constant { CACHE => '/tmp/ppix-refactor_cache', };
    our $cache = CACHE;
    File::Path::mkpath($cache) unless -e CACHE;
}

use PPI;
use PPI::Cache path => CACHE;
use PPI::Find;

=head1 NAME

PPIx::Refactor - Hooks for refactoring perl via L<PPI>

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

    use PPIx::Refactor;
    my $p = PPIx::Refactor->new(file => '/path/to/perl/code/file.pl',
                                ppi_find => \&found,
                                [ writer => \&found ]);
    my $finds = $p->finds; # for examining them interactively
    $p->rewrite; # rewrites the file in place.  You are using version control yes?

=head1 SUMMARY

This is a really simple module to make rewriting perl code via L<PPI>
debugger friendly and easy.  See the test in
L<t/refactor.t|https://github.com/singingfish/PPIx-Refactor/blob/master/t/refactor.t>
of this distribution for a working example.  Pretty much all the real work
happens in the coderef you set up in C< $p->ppi_find > and C< $p->writer >.

NOTE L<PPI::Cache> is used to store a cached representation of the source
parse in the system temp directory.

=head2 RATIONALE

Rewriting code via ppi is a fiddly pain.  L<PPIx::Refactor> provides a
minimal interface so you can concentrate on the fiddlyness and minimise the
pain.

=head2 TODO

Would be nice to specify a rewriter via roles, and it would be nice to have
$self in C< $p->ppi_find >.  On the other hand rewrite/refactoring code like
this can either be simple throwaways, or really really complicated.  This
code is so far optimised for the throwaway case.

=cut

=head2 ATTRIBUTES

=head3 file

required string that coerces into a Path::Tiny

=cut

has file => (
    is => 'ro',
    coerce => sub {
        path($_[0]);
    }
);

=head3 doc

lazily built PPI::Document

=cut

has doc => (
    is => 'ro',
    lazy => 1,
    default => sub {
        my ($self) = @_;
        return PPI::Document->new($self->file->stringify);
    },
);

=head3 ppi_find 

required coderef with which to find the elements of interest

=cut

has ppi_find => (
    is => 'ro',
    # isa CodeRef
    required => 1,
);


=head3 writer

optional coderef with which to rewrite the code

=cut

has writer => (
    is => 'ro',
    default => sub {},
);

=head3 finds

lazy built arrayref of all the elements of interest found

=cut

has finds => (
    is => 'ro',
    lazy => 1,
    default => sub {
        my ($self) = @_;
        my $find = PPI::Find->new($self->ppi_find);
        my @results = $find->in($self->doc);
        return \@results;
    }
);

=head1 METHODS

=head2 $self->rewrite

Worker sub that rewrites the code

=cut

sub rewrite {
    my ($self) = @_;
    $self->writer->($self->finds);
    $self->doc->save($self->file);
}

=head2 $self->dump($elem, $whitespace);

For debugging.  Prints a dump of the passed in element.  If whitespace is true it will include whitespace in the dump.  Defaults to false

=cut

sub dump {
    my ($self, $doc, $whitespace) = @_;
    $whitespace ||=0;
    my $dump = PPI::Dumper->new($doc, whitespace => $whitespace);
    $dump->print;
}


=head1 AUTHOR

Kieren Diment, C<< <zarquon at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests via github:
L<https://github.com/singingfish/PPIx-Refactor/issues>.

=head1 SUPPORT

Jump on to #web-simple on irc.perl.org

=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2015 Kieren Diment.

This program is free software; you can redistribute it and/or modify it
under the same terms as perl itself.
=cut

1; 
