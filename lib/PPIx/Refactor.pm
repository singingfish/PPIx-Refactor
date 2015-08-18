package PPIx::Refactor;
use Moo;
use Path::Tiny;

=head1 NAME

PPIx::Refactor - Hooks for refactoring perl via L<PPI>

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

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
