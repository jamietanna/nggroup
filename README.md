# nggroup (nginx htgroup)

[Basic HTTP authentication](https://cdn.tutsplus.com/net/uploads/legacy/511_http/401_prompt.png) is a simple popup for a username/password combination that is rendered by the browser, and handled by the web server. This authentication is implemented in both major web servers, [Apache](http://apache.org) and [Nginx](http://nginx.org), via the [`.htaccess`](http://en.wikipedia.org/wiki/.htaccess) and [`.htpasswd`](http://en.wikipedia.org/wiki/.htpasswd) files. In addition to having control over users with access to a site or directory, Apache also has the ability to assign groups for more [fine grained access control](http://qdig.sourceforge.net/Tips/HttpAuthGuide).

nggroup is a tool hoping to solve this issue by allowing sysadmins to generate their own group files. A global group of users and groups can be accessed, and then can be fed into user-generated sites. The generated files can then be used by nginx as authentication files.

## Usage

`nggroup siteadd <sitename>` - add a new site
`nggroup sitedel <sitename>` - remove the  site
`nggroup sitemod <sitename> +<user>` - add user to site
`nggroup sitemod <sitename> -<user>` - delete user from site
`nggroup sitemod <sitename> +@<group>` - add group to site
`nggroup sitemod <sitename> -@<group>` - delete group from site

`nggroup groupadd <groupname>` - add a new group
`nggroup groupdel <groupname>` - remove the group
`nggroup groupmod <groupname> +<user>` - add user to group
`nggroup groupmod <groupname> -<user>` - delete user from group

`nggroup useradd <username> <password> <email_address> <full_name>` - add a new user
`nggroup userdel <username>` - remove a user

`nggroup generate` - generate all user, site and group files, as well as sending out appropriate emails

`nggroup email list` - list all email addresses stored
`nggroup email send downtime <start|stop> <start_time> <stop_time>` - email all users to indicate downtime has begun/ended

Note that when removing performing `(user|group)del` you will remove all references to it. 

**NOTE:** In order for any changes you make to become live, you will need to run `nggroup generate`


## Known Issues

- No input validation
- case statements don't have a default case
- need to implement permissions
  - add into tests
- if `groupadd a`, then `groupmod <!a> +@a`, will get error; need to generate first
- if try to generate when i.e. no sites exist, exits as error

## Dependencies

- `htpasswd`, via `apache2-utils` (Ubuntu)
  - Required for setting up users in common format for nginx
- `mutt`
  - Required for sending emails

## Future Features (?)

The following features are subject to change, but will most probably be added as they'll make my life easier:

- `nggroup setup < file.csv`
- `tests.sh <testname>`
- autocomplete
- groups
  - Add function `resolve_group`
- pipe through to email
  - on:
    - user added to site/group
	- removed (for each?)
  - `nggroup emails new_user username`
    - populates and sends
    - `nggroup emails new_user username -`
      - if `-`, prints to STDOUT
- generate random passwords
  - utilise `/usr/share/dict/words`

