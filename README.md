# OSM Surveyor

An iOS companion app that allows [OpenStreetMap][1] contributors to complete
missing information for objects around them.

## Join our TestFlight beta!

Do you want to help testing pre-releases of OSM Surveyor?
[Become a TestFlight tester][4] today! 🚀

# Continuous delivery

OSM Surveyor makes use of fastlane.
For a list of available actions, please refer to [the auto-generated README][2].

## Beta release

In order to create a new Beta, run

    % bundle exec fastlane beta

## Signing

To automate the signing, this project uses [fastlane match][3].
Fetch the certificates for development with

    % bundle exec fastlane match development

[1]: https://www.openstreetmap.org
[2]: fastlane/README.md
[3]: https://docs.fastlane.tools/actions/match/
[4]: https://testflight.apple.com/join/wXtE44KZ
