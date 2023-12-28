package ## no critic: Modules::RequireFilenameMatchesPackage
    # hide from PAUSE
    TableDataRole::Perl::CPAN::Release::Dynamic;

use 5.010001;
use strict;
use warnings;

use App::MetaCPANUtils;
use DateTime::Format::ISO8601;

use Role::Tiny;
with 'TableDataRole::Source::AOH';
with 'TableDataRole::Util::CSV';

our %SPEC;

$SPEC{new} = {
    v => 1.1,
    is_meth => 1,
    is_func => 0,
    args => {
        from_date => {
            schema => ['date*', 'x.perl.coerce_to' => 'DateTime'],
            req => 1,
            pos => 0,
        },
        to_date => {
            schema => ['date*', 'x.perl.coerce_to' => 'DateTime'],
            req => 1,
            pos => 1,
        },
    },
};

around new => sub {
    my $orig = shift;
    my ($self, %args) = @_;

    my $from_date = $args{from_date};
    if (!ref($from_date)) {
        $from_date = DateTime::Format::ISO8601->parse_datetime($from_date);
    }
    my $to_date = $args{to_date};
    if (!ref($to_date)) {
        $to_date = DateTime::Format::ISO8601->parse_datetime($to_date);
    }
    my $res = App::MetaCPANUtils::list_metacpan_releases(
        from_date => $from_date,
        to_date => $to_date,
        fields => [map {$_->[0]} @$App::MetaCPANUtils::release_fields],
    );

    my $aoh = $res->[2];
    $orig->($self, aoh=>$aoh);
};

package TableData::Perl::CPAN::Release::Dynamic;

use 5.010001;
use strict;
use warnings;

use Role::Tiny::With;

# AUTHORITY
# DATE
# DIST
# VERSION

with 'TableDataRole::Perl::CPAN::Release::Dynamic';

1;
# ABSTRACT: CPAN releases

=head1 TABLEDATA NOTES

The data is retrieved dynamically from MetaCPAN.
