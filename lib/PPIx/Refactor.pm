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
    my $p = PPIx::Refactor->new(file => '...', search => 'RoleName|\&found',
                                rewrite => 'RoleName|\&found');

    ...

=head1 ATTRIBUTES


=cut


has file => (
    is => 'ro',
    coerce => sub {
        path($_[0]);
    }
);

has doc => (
    is => 'ro',
    lazy => 1,
    default => sub {
        my ($self) = @_;
        return PPI::Document->new($self->file->stringify);
    },
);

has ppi_find => (
    is => 'ro',
    # isa CodeRef
    required => 1,
);

has writer => (
    is => 'ro',
    default => sub {},
);

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

sub rewrite {
    my ($self) = @_;
    $self->writer->($self->finds);
    $self->doc->save($self->file);
}

sub dump {
    my ($self, $doc, $whitespace) = @_;
    $whitespace ||=0;
    my $dump = PPI::Dumper->new($doc, whitespace => $whitespace);
    $dump->print;
}


=head1 METHODS


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
