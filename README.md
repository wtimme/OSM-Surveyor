# OSM Surveyor

An iOS companion app that allows [OpenStreetMap][1] contributors to complete
missing information for objects around them.

## Join our TestFlight beta!

Do you want to help testing pre-releases of OSM Surveyor?
[Become a TestFlight tester][4] today! 🚀

# Screenshot

![Screenshot of the map that displays annotations](screenshot.png?raw=true)

# Development

This project makes use of [Bundler][5] for managing the Ruby dependencies
(take a look at the `Gemfile`), and utilizes Cocoapods (see the `Podfile`) for
managing the iOS-related dependencies.

## Prerequisites

### Access token for Jawg.io

In order to render the map, the app makes use of vector map tiles provided by
[Jawg][8]. You'll need to create an account with them and set the "Access Token"
in the `Secrets.plist` file, using the key `Jawg_Access_Token`.

You can also use fastlane to set the Jawg access token, like so:

    % bundle exec fastlane update_jawg_access_token jawg_access_token:"<JAWG_ACCESS_TOKEN>"

### OAuth details for OpenStreetMap.org

The app makes use of OAuth 1 to authenticate the mapper against the
OpenStreetMap API. You'll need to sign in to [OpenStreetMap.org][1]
and create a new OAuth application.
Obtain the "Consumer Key" and "Consumer Secret" and set them in the
`Secrets.plist` file, using the keys `OSM_OAuth_ConsumerKey` and
`OSM_OAuth_ConsumerSecret`.

You can also use fastlane to set the OAuth credentials for OpenStreetMap, like so:

    % bundle exec fastlane update_osm_oauth_credentials osm_consumer_key:"<OSM_CONSUMER_KEY>" osm_consumer_secret:"<OSM_CONSUMER_SECRET>"

## Quick start

Getting started is quite easy. Open a terminal, change into your checkout's directory
and follow these steps.

1. Install [Bundler][5]: `gem install bundler`
2. Install the Gems (such as Cocoapods and fastlane): `bundle install`
3. Install the dependencies using Cocoapods: `bundle exec pod install`
4. Open the workspace (`OMSSurveyor.xcworkspace`)

## Formatting

In order to have a consistent code style, please make sure to install
[SwiftFormat][6] and run it on a regular basis. Consider setting up a `pre-commit`
Git hook, as described [here][7].

# Continuous delivery

OSM Surveyor makes use of fastlane.
For a list of available actions, please refer to [the auto-generated README][2].

## Beta release

In order to create a new Beta, you need to obtain the OAuth credentials for
OpenStreetMap, as well as the access token for Jawg (see "Prerequisites" above).

You can then run

    % bundle exec fastlane beta osm_consumer_key:"<OSM_CONSUMER_KEY>" osm_consumer_secret:"<OSM_CONSUMER_SECRET>" jawg_access_token:"<JAWG_ACCESS_TOKEN>"

## Signing

To automate the signing, this project uses [fastlane match][3].
Fetch the certificates for development with

    % bundle exec fastlane match development

[1]: https://www.openstreetmap.org
[2]: fastlane/README.md
[3]: https://docs.fastlane.tools/actions/match/
[4]: https://testflight.apple.com/join/wXtE44KZ
[5]: https://bundler.io/
[6]: https://github.com/nicklockwood/SwiftFormat
[7]: https://github.com/nicklockwood/SwiftFormat#git-pre-commit-hook
[8]: https://www.jawg.io/
