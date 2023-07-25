package Koha::Plugin::Com::ByWaterSolutions::BarcodeGenerator::ApiController;

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# This program comes with ABSOLUTELY NO WARRANTY;

use Modern::Perl;

use C4::Auth qw(checkpw);
use C4::Context;

use Mojo::Base 'Mojolicious::Controller';
use Mojo::JSON qw(decode_json);
use Encode qw(encode_utf8);
use Template;

use Try::Tiny;

=head1 Koha::Plugin::Com::ByWaterSolutions::CoverFlow::Controller

A class implementing the controller code for CoverFlow requests

=head2 Class methods

=head3 barcode

Returns a generated PNG image of a barcode

=cut

sub generate {
    my $c = shift->openapi->valid_input or return;

    my $key     = $c->validation->param('key');
    my $notext  = $c->validation->param('notext') ? 1 : 0;
    my $type    = $c->validation->param('type') || 'Code39';
    my $barcode = $c->validation->param('barcode');

    my $BarcodeGeneratorPluginApiKey =
      C4::Context->preference('BarcodeGeneratorPluginApiKey');

    return try {
        if (   $BarcodeGeneratorPluginApiKey
            && $key ne $BarcodeGeneratorPluginApiKey )
        {
            return $c->render( status => 401 );
        }

        my $image =
          GD::Barcode->new( $type, $barcode )->plot( NoText => $notext )->png();

        return $c->render( data => $image, format => 'png' );
    }
    catch {
        return $c->render(
            status  => 500,
            openapi => { error => "Unhandled exception ($_)" }
        );
    };
}

1;
