# OSM Surveyor

An iOS companion app that allows [OpenStreetMap][1] contributors to complete
missing information for objects around them.

# Continuous delivery

OSM Surveyor makes use of fastlane.
For a list of available actions, please refer to [the auto-generated README][2].

## Signing

To automate the signing, this project uses [fastlane match][3].
Fetch the certificates for development with

    % bundle exec fastlane match development

[1]: https://www.openstreetmap.org
[2]: fastlane/README.md
[3]: https://docs.fastlane.tools/actions/match/
