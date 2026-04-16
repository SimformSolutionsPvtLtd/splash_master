# Description
<!--
Provide a description of what this PR is doing.
If you're modifying existing behavior, describe the existing behavior, how this PR is changing it,
and what motivated the change. If this is a breaking change, specify explicitly which APIs were
changed.

For package-scoped changes, mention the impacted package(s):
- splash_master (core CLI/native generation/shared types)
- splash_master_rive
- splash_master_video
- splash_master_lottie
-->


## Checklist
<!--
Before you create this PR confirm that it meets all requirements listed below by checking the
relevant checkboxes with `[x]`. If some checkbox is not applicable, mark it as `[ ]`.
-->

- [ ] The title of my PR starts with a [Conventional Commit] prefix (`fix:`, `feat:`, `docs:` etc).
- [ ] I have followed the [Contributor Guide] when preparing my PR.
- [ ] I have updated/added tests for ALL new/updated/fixed functionality.
- [ ] I have updated/added relevant documentation in `doc/` and/or package README(s), and added dartdoc comments with `///` where applicable.
- [ ] I have updated/added relevant examples in `example/` and/or `packages/splash_master_{rive,video,lottie}/example/`.
- [ ] I have updated impacted package metadata/docs (for example: `README.md`, `CHANGELOG.md`, and package-level docs where applicable).

### Impacted package(s)
<!--
Check all packages impacted by this PR.
-->

- [ ] splash_master (core)
- [ ] splash_master_rive
- [ ] splash_master_video
- [ ] splash_master_lottie


## Breaking Change?
<!--
Would your PR require Splash Master users to update their apps following your change?
If yes, then the title of the PR should include "!" (for example, `feat!:`, `fix!:`). See
[Conventional Commit] for details. Also, for a breaking PR uncomment and fill in the "Migration
instructions" section below.

For split-package changes, explicitly mention which package(s) are breaking.
### Migration instructions
If the PR is breaking, uncomment this header and add instructions for how to migrate from the
currently released version to the new proposed way.
-->

- [ ] Yes, this PR is a breaking change.
- [ ] No, this PR is not a breaking change.


## Related Issues
<!--
Indicate which issues this PR resolves, if any. For example:
Closes #1234
!-->

<!-- Links -->
[Contributor Guide]: https://github.com/SimformSolutionsPvtLtd/splash_master/blob/main/CONTRIBUTING.md
[Conventional Commit]: https://conventionalcommits.org