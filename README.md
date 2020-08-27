# OSM Surveyor

An iOS companion app that allows [OpenStreetMap][1] contributors to complete
missing information for objects around them.

## Join our TestFlight beta!

Do you want to help testing pre-releases of OSM Surveyor?
[Become a TestFlight tester][4] today! 🚀

# Screenshot

![Screenshot of the map that displays annotations](screenshot.png?raw=true)

# Getting started with development

This project makes use of [Bundler][5] for managing the Ruby dependencies
(take a look at the `Gemfile`), and utilizes Cocoapods (see the `Podfile`) for
managing the iOS-related dependencies.

Getting started is quite easy. Open a terminal, change into your checkout's directory
and follow these steps.

1. Install [Bundler][5]: `gem install bundler`
2. Install the Gems (such as Cocoapods and fastlane): `bundle install`
3. Install the dependencies using Cocoapods: `bundle exec pod install`
4. Open the workspace (`OMSSurveyor.xcworkspace`)

## Formatting

In order to have a consistent code style, please make sure to install
[SwiftFormat][6] and run it on a regular basis.

# Continuous delivery

OSM Surveyor makes use of fastlane.
For a list of available actions, please refer to [the auto-generated README][2].

## Beta release

In order to create a new Beta, you first need to sign in to [OpenStreetMap.org][1]
and create a new OAuth application.
Obtain the "Consumer Key" and "Consumer Secret", and run

    % bundle exec fastlane beta osm_consumer_key:"<OSM_CONSUMER_KEY>" osm_consumer_secret:"<OSM_CONSUMER_SECRET>"

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
