# ES School Management

* [Description](#description)
* [Getting Started](#getting-started)
    * [Prerequisites](#prerequisites)
* [Deployment](#deployment)
    * [On dev environment](#on-dev-environment)
* [Directory structure](#directory-structure)
* [Collaborate](#collaborate)
* [License](#license)
* [Contact](#contact)

## Description

The goals for this project is to:

- Manage a ES school

## Getting Started

### Prerequisites

* Ruby 3.3.5 or later [official doc](https://www.ruby-lang.org/fr/downloads/)
    * or use Rbenv [official doc](https://github.com/rbenv/rbenv#readme)
* Git version 2.47.0 or later [official doc](https://git-scm.com/)
* Bundler 2.5.21 or later (already installed with ruby) [official doc](https://bundler.io/)

## Deployment

### On dev environment

#### Clone the repository

```bash
git clone https://github.com/drutz-cpnv/ror-es-gest
cd ror-es-gest
```

#### Install the dependencies

```bash
bundle install
```

#### Run the server

```bash
rails s
```

## Directory structure

```shell
├── Dockerfile
├── Gemfile
├── Gemfile.lock
├── Procfile.dev
├── README.md
├── Rakefile
├── app
├── bin
├── config
├── config.ru
├── db
├── lib
├── log
├── public
├── script
├── storage
├── test
├── tmp
└── vendor

```

## Collaborate

### Workflow

* [Gitflow](https://www.atlassian.com/fr/git/tutorials/comparing-workflows/gitflow-workflow#:~:text=Gitflow%20est%20l'un%20des,les%20hotfix%20vers%20la%20production.)
* [How to commit](https://www.conventionalcommits.org/en/v1.0.0/)
* [How to use your workflow](https://nvie.com/posts/a-successful-git-branching-model/)

* Propose a new feature in [GitHub issues](https://github.com/drutz-cpnv/ror-es-gest/issues)
* Pull requests are open to merge in the develop branch.
* Issues are added to the [GitHub issues page](https://github.com/drutz-cpnv/ror-es-gest/issues)

### Commits

* [How to commit](https://www.conventionalcommits.org/en/v1.0.0/)

```bash
<type>(<scope>): <subject>
```

- **build**: Changes that affect the build system or external dependencies (e.g., npm, make, etc.).
- **ci**: Changes related to integration or configuration files and scripts (e.g., Travis, Ansible, BrowserStack, etc.).
- **feat**: Adding a new feature.
- **fix**: Bug fixes.
- **perf**: Performance improvements.
- **refactor**: Modifications that neither add a new feature nor improve performance.
- **docs**: Writing or updating documentation.
- **test**: Adding or modifying tests.
- **chore**: Changes to the build process or auxiliary tools and libraries such as documentation generation.

## License

The project is released under a [MIT license](./LICENSE).

## Contact

If needed you can create an issue on GitHub I'll try to respond as quickly as possible.