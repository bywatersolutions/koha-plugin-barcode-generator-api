# Barcode Generator API plugin for Koha

This plugin adds a public barcode image generator API to Koha that outputs PNG files in the specified barcode format

## Installation

Just install this plugin and restart plack!

## Configuration

To require an API key, create a new local use system preference named `BarcodeGeneratorPluginApiKey` and set the API key you wish to use in there.
Once this is set, any calls that do not have a URL parameter of `key` with this value will fail.

## Usage

This plugin exposes one API :

### API path
GET /api/v1/contrib/barcodegenerator/barcode?key=123456789&barcode=9876543241

### API Parameters
* `barcode`: The barcode value to turn into an image
* `notext`: optional, if true barcode image will not contain the barcode text
* `type`: optional, barcode type. Defaults to code39. Supported types are part of [GD::Barcode](https://metacpan.org/pod/GD::Barcode)
* `key`: optional, api key value. Required if `BarcodeGeneratorPluginApiKey` is set
