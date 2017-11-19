---
title: Webpack dev server and Rails on Cloud9
subtitle: >
  How to configure `webpack-dev-server` with [[rails]]' `webpacker`
  gem on a [[cloud9]] workspace
tags: webpack react javascript rails cloud9
---

For a while I have been trying here and there to properly configure
[`webpack-dev-server`] to serve the [[react]] frontend within a
[[rails]] app on my [[cloud9]] workspace without much success. But
eventually the frustration of not having the speed benefits of the
live compilation made it a priority to fix. While I did find a lot of
helpful information online (specially in a couple of GitHub issues,
see [sources](#sources) below), the solutions mentioned did not quite
work for me, probably because the underlying versions were not the
same. In this article I explain how I got it finally working.

Note that the solutions in this article are for a [[react]] frontend
within a [[rails]] app. This is a bit different than a pure [[react]]
app written only in [[javascript]] because the integration of the
[`webpack-dev-server`] with the [[rails]] app is ensured by the
[`webpacker`] gem, which handles the configuration in a slightly
different way. However, the approaches mentioned here might serve as a
basis to solve it for the pure [[javascript]] case.

Note as well that this explanation is **not** about the [Hot Module
Replacement (HMR)] that automatically updates the app in the browser
without reloading. Instead it is about the live compilation of the
[[javascript]] code that the [`webpack-dev-server`] offers, which is
very fast compared to the on-demand compilation, which becomes slower
when the size of the [[javascript]] codebase increases (see the
[`webpacker` documentation]). In my case the on-demand compilation
ended up taking more than 30s, which was highly inconvenient: i.e.
every time I changed a [[javascript]] code in a [[react]] component,
the server compiled the _whole_ [[javascript]] code when I refreshed
the app in the browser thus taking that long to respond.

I will discuss two ways to tackle the issue: a simple and [quick
solution](#quick-solution), which is sufficient if we work alone on a
project, and a slightly more involved but [flexible
approach](#flexible-solution), that can be useful when several people
might work in the same codebase.

[Hot Module Replacement (HMR)]: https://webpack.github.io/docs/hot-module-replacement-with-webpack.html
[`webpack-dev-server`]: https://github.com/webpack/webpack-dev-server
[`webpacker`]: https://github.com/rails/webpacker

# Quick solution

If you are working alone, the easiest way to fix the configuration of
the [`webpack-dev-server`] is to add an entry to the `/etc/hosts` and
to modify the `development.dev_server` entry of the
`config/webpacker.yml` file.

## `/etc/hosts` entry

As mentioned in some of the [sources](#sources) below, you have to add
an entry to [`/etc/hosts`](https://askubuntu.com/a/183187) to alias
the hostname of your [[cloud9]] workspace to `0.0.0.0`:

```bash
echo "0.0.0.0 ${C9_HOSTNAME}" | sudo tee -a /etc/hosts
```

Alternatively, since this has to be run every time your [[cloud9]]
workspace is restarted, you can add it to your `.bashrc` (and source
it afterwards):

```bash
echo '(HOSTS_ENTRY="0.0.0.0 ${C9_HOSTNAME}"; grep --quiet "${HOSTS_ENTRY}" /etc/hosts || echo "${HOSTS_ENTRY}" | sudo tee -a /etc/hosts)' >> ~/.bashrc
source ~/.bashrc
```

## `config/webpacker.yml` file

After trying many solutions mentioned in the [sources](#sources) below
I ended up changing the `development.dev_server` entry of the
`config/webpacker.yml` file from the following default values:

```yaml
dev_server:
  https: false
  host: localhost
  port: 3035
  public: localhost:3035
  hmr: false
  # Inline should be set to true if using HMR
  inline: true
  overlay: true
  disable_host_check: true
  use_local_ip: false
```

into the these custom configuration:

```yaml
dev_server:
  https: true
  host: your-workspace-name-yourusername.c9users.io
  port: 8082
  public: your-workspace-name-yourusername.c9users.io:8082
  hmr: false
  inline: false
  overlay: true
  disable_host_check: true
  use_local_ip: false
```

You can obtain the value `your-workspace-name-yourusername.c9users.io`
for your [[cloud9]] workspace with `echo ${C9_HOSTNAME}`.

There are three main differences with the approaches found in the
mentioned [sources](#sources):

- Some solutions stressed the need to set the
  [`https`][devserver-https] option to `false` but this failed with
  `net::ERR_ABORTED` in the browser console and raised the following
  exception in the server when the client tried to get the
  [[javascript]] sources:

  ```
  #<OpenSSL::SSL::SSLError: SSL_connect SYSCALL returned=5 errno=0 state=unknown state>
  ```

  Setting `https: true` removes the issue.

- By leaving the [`inline`][devserver-inline] option to the default
  `false` value, the live compilation still works but the browser
  console constantly reports the following error:

  ```
  Failed to load https://your-workspace-name-yourusername.c9users.io:8082/sockjs-node/info?t=1511016561187: No 'Access-Control-Allow-Origin' header is present on the requested resource.
  Origin 'https://your-workspace-name-yourusername.c9users.io' is therefore not allowed access. The response had HTTP status code 503.
  ```

  Setting `inline: false` removes the issue.


- None of the solutions I found suggested to set the
  [`public`][devserver-public] option in the `config/webpacker.yml`
  file and some suggested to pass it to the `webpack-dev-server`
  command line. By setting it in the configuration file we don't need
  to care about it in the terminal.

[devserver-https]: https://webpack.js.org/configuration/dev-server/#devserver-https
[devserver-inline]: https://webpack.js.org/configuration/dev-server/#devserver-inline
[devserver-public]: https://webpack.js.org/configuration/dev-server/#devserver-public

With this configuration, running as usual `./bin/webpack-dev-server`
in one terminal and `./bin/rails s -b $IP -p $PORT` in another did work
for me. (Finally!)

# Flexible solution

The previous solution is useful and fast to implement, but if you are
working with other people on the same repo it can be tricky to
maintain the proper configuration in the `config/webpacker.yml` file.
Moreover, the hostname of your [[cloud9]] workspace is hardcoded, so
that the configuration is not portable.

I found a hint about another way to configure the `webpack-dev-server`
in the [`webpacker` documentation]:

> You can use environment variables as options supported by
> webpack-dev-server in the form `WEBPACKER_DEV_SERVER_<OPTION>`.
> Please note that these environment variables will always take
> precedence over the ones already set in the configuration file.

However what I did not find in _that_ documentation (but in the
[`webpacker/dev_server.rb` code]) is that when the configuration of
the `webpack-dev-server` is tweaked with ENV variables, those same
values _have to be passed_ to the `rails server` process as well in
order to let it use the _same_ configuration. This makes sense when
you think about it, because if the configuration is defined in the
`config/webpacker.yml` file, both processes can refer to it. However,
if the configuration of one of the processes is overridden with ENV
variables, the other one does not know about the new values.

With that in mind I finally got a flexible solution, using
[`foreman`](https://github.com/ddollar/foreman) with the following
`Procfile.dev`:

```Procfile
web:        ./bin/rails server -b ${RAILS_SERVER_BINDING:-localhost} -p ${RAILS_SERVER_PORT:-3000}
webpacker:  ./bin/webpack-dev-server
```

and this `bin/start` script:

```bash
#!/bin/bash

# Immediately exit script on first error
set -e -o pipefail

APP_ROOT_FOLDER="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
cd "${APP_ROOT_FOLDER}"

if [ -n "${C9_USER}" ]; then
  # We are in a Cloud9 machine

  # Make sure that Postgres is running
  sudo service postgresql status || sudo service postgresql start

  # Make sure that the needed entry in /etc/hosts exists
  HOSTS_ENTRY="0.0.0.0 ${C9_HOSTNAME}"
  grep --quiet "^${HOSTS_ENTRY}\$" /etc/hosts || echo "${HOSTS_ENTRY}" | sudo tee -a /etc/hosts

  # Adapt the configuration of the webpack-dev-server
  export APP_DOMAIN="${C9_HOSTNAME}"
  export RAILS_SERVER_BINDING='0.0.0.0'
  export RAILS_SERVER_PORT='8080'
  export WEBPACKER_DEV_SERVER_PORT='8082'
  export WEBPACKER_DEV_SERVER_HTTPS='true'
  export WEBPACKER_DEV_SERVER_HOST="${C9_HOSTNAME}"
  export WEBPACKER_DEV_SERVER_PUBLIC="${C9_HOSTNAME}:${WEBPACKER_DEV_SERVER_PORT}"
  export WEBPACKER_DEV_SERVER_HMR='false'
  export WEBPACKER_DEV_SERVER_INLINE='false'
  export WEBPACKER_DEV_SERVER_OVERLAY='true'
  export WEBPACKER_DEV_SERVER_DISABLE_HOST_CHECK='true'
  export WEBPACKER_DEV_SERVER_USE_LOCAL_IP='false'
fi

foreman start -f Procfile.dev
```

With these two scripts in place, the application can always be started
by running `bin/start`, in both [[cloud9]] and other systems. The
trick is that by exporting the `WEBPACKER_DEV_SERVER_*` variables
before calling `foreman start`, we make sure that those values are
available to both `webpack-dev-server` and `rails server` processes.

# Sources

I found valuable information and hints about how to fix the issue in
at least the following resources:

- ["Making Webpacker run on Cloud 9"] (GitHub issue)
- ["Anyone here got webpack-dev-server to work on Cloud 9?"] (GitHub issue)
- [`webpacker` documentation]
- [`webpacker/dev_server.rb` code]
- [`webpack-dev-server` documentation]
- ["Using Rails With Webpack in Cloud 9"] (blog article)

["Making Webpacker run on Cloud 9"]: https://github.com/rails/webpacker/issues/176
["Anyone here got webpack-dev-server to work on Cloud 9?"]: https://github.com/webpack/webpack-dev-server/issues/230
[`webpacker` documentation]: https://github.com/rails/webpacker/tree/v3.0.2#development
[`webpacker/dev_server.rb` code]: https://github.com/rails/webpacker/blob/v3.0.2/lib/webpacker/dev_server.rb#L55
[`webpack-dev-server` documentation]: https://webpack.js.org/configuration/dev-server/
["Using Rails With Webpack in Cloud 9"]: http://aalvarez.me/blog/posts/using-rails-with-webpack-in-cloud-9.html

# Versions

Since things in this ecosystem move fast, it's relevant to mention the
versions of the world for which I got it working:

```shell
$ egrep '^    ?(ruby|webpacker|rails) ' Gemfile.lock
    rails (5.1.4)
    webpacker (3.0.2)
  ruby 2.4.2p198

$ yarn versions
yarn versions v1.1.0
{ http_parser: '2.7.0',
  node: '8.5.0',
  v8: '6.0.287.53',
  uv: '1.14.1',
  zlib: '1.2.11',
  ares: '1.10.1-DEV',
  modules: '57',
  nghttp2: '1.25.0',
  openssl: '1.0.2l',
  icu: '59.1',
  unicode: '9.0',
  cldr: '31.0.1',
  tz: '2017b' }

$ cat /etc/os-release | head -6
NAME="Ubuntu"
VERSION="14.04.5 LTS, Trusty Tahr"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 14.04.5 LTS"
VERSION_ID="14.04"
```

Everything was tested using Chrome Version 62.

# tl;dr

Change the `development.dev_server` entry `config/webpacker.yml` file into:

```yaml
dev_server:
  https: true
  host: your-workspace-name-yourusername.c9users.io
  port: 8082
  public: your-workspace-name-yourusername.c9users.io:8082
  hmr: false
  inline: false
  overlay: true
  disable_host_check: true
  use_local_ip: false
```

Then run:

```bash
echo "0.0.0.0 ${C9_HOSTNAME}" | sudo tee -a /etc/hosts # execute after every restart
```

Now running as usual `./bin/webpack-dev-server` in one terminal and `./bin/rails
s -b $IP -p $PORT` in another should work as expected.
