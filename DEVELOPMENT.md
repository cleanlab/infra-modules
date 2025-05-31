# Tagged releases

Releases are tagged in this repository for the purpose of sharing module updates.

1. Ensure that the release notes are updated in [`CHANGELOG.md`][changelog]:
    - You should update the `[Unreleased]` header to the new version and add a new `[Unreleased]` section at the top of the file.
    - You should update the link for the `[Unreleased]` code and add a new link to the code diff for the new version.
2. Create a PR and merge your changes into the `main` branch.
3. After the PR is merged into `main`, create a new release tag by running `git tag v<version>` (e.g. `git tag v0.0.1`).
4. Push the tag to the repository by running `git push origin <tag>`.

[changelog]: CHANGELOG.md