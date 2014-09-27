# nggroup (nginx htgroup)

[Basic HTTP authentication](https://cdn.tutsplus.com/net/uploads/legacy/511_http/401_prompt.png) is a simple popup for a username/password combination that is rendered by the browser, and handled by the web server. This authentication is implemented in both major web servers, [Apache](http://apache.org) and [Nginx](http://nginx.org), via the [`.htaccess`](http://en.wikipedia.org/wiki/.htaccess) and [`.htpasswd`](http://en.wikipedia.org/wiki/.htpasswd) files. In addition to having control over users with access to a site or directory, Apache also has the ability to assign groups for more [fine grained access control](http://qdig.sourceforge.net/Tips/HttpAuthGuide).

nggroup is a tool hoping to solve this issue by allowing sysadmins to generate their own group files. A global group of users and groups can be accessed, and then can be fed into user-generated sites. The generated files can then be used by nginx as authentication files.

## Usage

## Known Issues

- No input validation
- Not completely portable - need to use `#!/usr/bin/env bash`.

## Future Features (?)

The following features are subject to change, but will most probably be added as they'll make my life easier:

- Add global group `@all`
- tests.sh <testname>
- autocomplete
- groups can contain groups?
- circular refs?
- pipe through to email/other cmd
  - user can choose what?
  - format string
