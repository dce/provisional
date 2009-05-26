# Provisional

## Description

Provisional creates a new Rails project, using a standard Rails 2.3 application template, and checks it into a new SCM repository.

In the future, Provisional may be expanded to create production and staging environments, set up continuous integration, and automate other tasks that are usually performed at the beginning of a project.

## Requirements

Provisional requires Rails 2.3.0 or greater.

Provisional is only tested on Mac OS X. It should also work on Linux. It is not tested or supported on Windows.

## Installation

    sudo gem install provisional

## Usage

    Options:
          --name, -n <s>:   Name of the project
           --scm, -s <s>:   SCM to use (default: git)
      --template, -t <s>:   Rails template to use (default: viget)
        --domain, -d <s>:   Domain (for some SCMs, see below)
      --username, -u <s>:   Username (for some SCMs, see below)
      --password, -p <s>:   Password (for some SCMs, see below)
            --id, -i <s>:   Id (for some SCMs, see below)
        --config, -c <s>:   Config file (optional)
              --help, -h:   Show this message

The SCM option can be one of the following ("`project_name`" refers to the value of the --name option):

* `git`: creates a git repository in the `project_name` directory.
* `github`: creates a git repository in the `project_name` directory, creates `project_name` on GitHub using the specified credentials, adds it as the "origin" remote, and pushes. (See section below about required configuration.)
* `unfuddle`: creates a git repository in the `project_name` directory, creates a repository called `project_name` under an existing Unfuddle project using the specified credentials, and adds it as the "origin" remote. _You must push manually_ because Unfuddle typically has a lag of a few minutes between when a repository is created and when it can be accessed. (See section below about required configuration.)
* `unfuddle_svn`: creates a Subversion repository called `project_name` under an existing Unfuddle project using the specified credentials, and checks it out into the `project_name` directory.
* `beanstalk`: creates a Subversion repository called `project_name` on Beanstalk using the specified credentials, and checks it out into the `project_name` directory.

The domain, username, password, and id options are used by certain SCMs to provide information needed to use an API. The documentation on these SCMs (below) will indicate how they are to be used.

The template option can be either a literal path to a template file, a URL for a template on a remote server, or the name of one of the templates found in lib/provisional/templates (without the .rb suffix.) The default viget template does the following:

* freezes rails from currently installed gems
* installs gems: `mocha`, `factory_girl`, `shoulda`, `webrat`
* installs plugins: `hoptoad_notifier`, `jrails`, `model_generator_with_factories`, `viget_deployment`, `vl_cruise_control`, `asset_packager`
* installs a .gitignore file to ignore logs, temp files, sqlite3 databases, rcov reports, and `database.yml`
* generates Capistrano configuration with viget_deployment
* copies `database.yml` to `database.yml-sample`
* removes `public/index.html`, `test/fixtures`, prototype, and script.aculo.us
* creates an SCM repository and checks the application in

All of these options can be specified either on the command line, or in a YAML file indicated by the --config option. The YAML file should be in simple key: value format:

    name: awesome_project
    scm: git

Options specified via the command line take precedence over options specified in a YAML file, if both are specified.

## GitHub

To use [GitHub](http://github.com/), you will need to place your GitHub username and token in your Git configuration as described here: http://github.com/guides/local-github-config Since there is already this established convention for GitHub credentials, to prevent redundant configuration, Provisional does not use its own configuration options for GitHub access.

## Unfuddle

To use [Unfuddle](http://unfuddle.com/) (for either Git or Subversion) you will need to specify the --domain, --id, --username and --password options. --domain is used to specify your unfuddle.com subdomain; --id is used to specify a project ID. Using a YAML file containing these options is recommended and should be helpful.

## Beanstalk

As of this writing (May 2009) [Beanstalk](http://beanstalkapp.com/)'s API is in private beta. See [the API documentation](http://api.beanstalkapp.com/) for details on how to gain access. Thanks to Wildbit for giving us access to the private beta.

To use Beanstalk you will need to specify the --domain, ---username and --password options. --domain is used to specify your beanstalkapp.com subdomain. Using a YAML file containing these options is recommended and should be helpful.

## License

Copyright (c) 2009 Mark Cornick of Viget Labs <mark@viget.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
