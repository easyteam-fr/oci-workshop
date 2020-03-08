# Terraform and Oracle Cloud Infrastructure Workshop

This workshop guides you through the setup, configuration and a few
demonstrations of `terraform` with Oracle Cloud Infrastructure (OCI). It was
released to support my presentation at the `Paris Live for the Code 2018`
conference and updated in March 2020 to benefit from the latest OCI features.
Do not hesitate to use it and ask for enhancements if you have any ideas.

## Table of Contents

1. Installation and configuration, see `branch:master` and
[01-install.md](docs/01-install.md)
2. Remote state management, see `branch:02-demo` and
[02-remote-state.md](docs/02-remote-state.md)
3. Variables, output, inferences and dependencies, see `branch:03-demo` and
[03-inferences.md](docs/03-inferences.md)
4. Modules, input/output and registry, see `branch:04-demo` and
[04-modules.md](docs/04-modules.md)
5. Packer, see `branch:05-demo` and [05-packer.md](docs/05-packer.md)
6. dynamicgroups and OCI_CLI_AUTH, see `branch:06-demo` and
[06-dynamicgroups.md](docs/06-dynamicgroups.md)
7. Use additional providers, see `branch:07-demo` and
[07-other-providers.md](docs/07-other-providers.md)
8. Manage your secrets out-of-band, see `branch:08-demo` and
[08-secrets.md](docs/08-secrets.md)
9. Create a Bot that interacts with Slack and Twitter, see `branch:oraclecode` and [oraclecode](oraclecode/README.md)

## How to use this repository?

This is a multi-step repository, to progress through it, simply move from branch to
branch with the `git checkout` command. To start, clone it and run
`git checkout master` it will start with an empty repository.

> Note: in order for this project to work, you need to configure your access to OCI,
  a specific compartment as well as a backend file to store the state. As a
  result, parts 1 and 2 are mandatory.

## Feedback

If you like this repository, do not hesitate to add a star. If you have any
questions or ideas to enhance it, open an issue. Have fun!

![Oracle Code](docs/images/oraclecode.png)
