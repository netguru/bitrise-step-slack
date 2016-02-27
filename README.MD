# bitrise-step-slack

A next-gen Slack webhook step for Bitrise.

## Usage

### bitrise.yml

To use this step in your Bitrise workflow, prefix the step name with a Git URL of this repository:


```yml
steps:
  - git::https://github.com/netguru/bitrise-step-slack::slack:
      inputs:
        - webhook_url: https://netguru.slack.com/...
        - channel: "#sandbox"
```

### bitrise.io

As bitrise.io doesn't allow to add a custom step using the UI Workflow Editor, use the YAML editor to manually add the step to the workflow. Follow the guide above.

## Development

### Requirements

This step requires the following dev dependencies:

- [Bitrise](https://bitrise.io) >= 1.2
- [Ruby](https://rvm.io) >= 2.2
- [Bundler](http://bundler.io) >= 1.10

### Dependencies

Install required dependencies using Bundler:

```bash
$ bundle install
```

### Committing

This repository uses git-flow and protects `develop` and `master` branches from force pushes, which means the whole development process is pull-request-driven.

The standard code review procedures are in place as well (although perhaps they should be done by Ruby developers).

## About

This project is made with <3 by [Netguru](https://netguru.co/opensource).

### License

Licensed under the MIT License. See [LICENSE.MD](LICENSE.MD) for more info.
