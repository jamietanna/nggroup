# nggroup (nginx htgroup)

*Group ACLs for Basic HTTP Authentication with Nginx*

[Basic HTTP authentication](https://cdn.tutsplus.com/net/uploads/legacy/511_http/401_prompt.png) is a simple popup for a username/password combination that is rendered by the browser, and handled by the web server. This authentication is implemented in both major web servers, [Apache](http://apache.org) and [Nginx](http://nginx.org), via the [`.htaccess`](http://en.wikipedia.org/wiki/.htaccess) and [`.htpasswd`](http://en.wikipedia.org/wiki/.htpasswd) files. In addition to having control over users with access to a site or directory, Apache also has the ability to assign groups for more [fine grained access control](http://qdig.sourceforge.net/Tips/HttpAuthGuide). However, nginx does not - this tool aims to fix that.

nggroup is a tool hoping to solve this issue by allowing sysadmins to generate their own group files. A global collection of users and groups can be accessed, and then can be fed into user-generated sites. The generated files can then be used by nginx as authentication files, as they are the format of the `.htpasswd` file.

As has been answered on [StackOverflow](http://stackoverflow.com/questions/11074766/nginx-group-http-auth), there is some need for this. As I myself have to manage a server like this, with ~100 and ~20 groups, I found making a tool to solve this issue would be a good course of action. *[Relevant XKCD](http://xkcd.com/1319/)*.

**Note: This system is not written to be completely secure. Passwords are entered stored in plaintext and cannot be changed by users. Ensure that no passwords stored in this system are passwords any user normally uses. Please also note that basic HTTP authentication does not encrypt passwords in transit. As such, to increase security, ensure the nginx server you are using this tool with is running HTTPS.**

## Installation

The only command that is needed in order to run this tool is `htpasswd`, which is included in:

| Distro |         Package           |
| ------ | ------------------------- |
| Ubuntu | `apache2-utils`           |
| Debian | `libapache-htpasswd-perl` |
| RHEL6  | `httpd-tools`             |
| CentOS | `httpd-tools`             |

### Testing Locally

Testing locally does not require any special steps to run, provided the above dependency is met. You will be able to start straight away by running `/path/to/nggroup <cmd>`.

Note that the working directory will be the directory that `nggroup` resides in.

### Running in Production

In order to install `nggroup`, you will need to:
- Set a global environment variable, `$_IN_PRODUCTION` to i.e. your hostname (as long as it is non-null). This is best set in the `/etc/environment` file. Remember to `source /etc/environment` to ensure that the variable is set. 
- Copy this repository to somewhere in the `$PATH`, ensuring that only `nggroup` has execute rights.
- Have `sudo` rights

Once complete, you will be able to start by running `nggroup <cmd>` from any directory.

Note that the working directory will be the `/etc/nginx/htpasswd` directory.

## Usage

### Examples

**NOTE:** In order for any changes you make to become live, you will need to run `nggroup generate`

#### Adding a New User and Site

```
nggroup siteadd newsite
nggroup useradd testuser testpwd noone@localhost "User Name"
nggroup sitemod newsite +testuser
nggroup generate
```

#### Creating a Group for a Site

```
nggroup groupadd testgroup
nggroup useradd testuser1 testpwd1 noone@localhost "User Name"
nggroup useradd testuser2 testpwd2 nowhere@localhost "Name User"
nggroup sitemod newsite +@testgroup
nggroup generate
```

#### Delete a Group

```
nggroup groupdel testgroup
```

**NOTE**: This will remove all references to the group. Any sites that require the group will now not have the group, or the users that were in said group. Also note that this applies to users and sites.

### Full Command Listing

`nggroup siteadd <sitename>` - add a new site

`nggroup sitedel <sitename>` - remove the  site

`nggroup sitemod <sitename> +<user>` - add user to site

`nggroup sitemod <sitename> -<user>` - remove user from site

`nggroup sitemod <sitename> +@<group>` - add group to site

`nggroup sitemod <sitename> -@<group>` - remove group from site


`nggroup groupadd <groupname>` - add a new group

`nggroup groupdel <groupname>` - remove the group

`nggroup groupmod <groupname> +<user>` - add user to group

`nggroup groupmod <groupname> -<user>` - remove user from group


`nggroup useradd <username> <password> <email_address> <full_name>` - add a new user

`nggroup userdel <username>` - remove a user


`nggroup generate` - generate all user, site and group files


`nggroup email list` - list all email addresses stored

Note that when removing performing `(user|group)del` you will remove all references to it.

## Known Issues

- No input validation
- case statements don't have a default case
- if `groupadd a`, then `groupmod <!a> +@a`, will get error; need to generate first
- if try to generate when i.e. no sites exist, exits as error
- **insecure**
  - keeping password on command line
  - anyone can read rule files
    - need to implement permissions
    - add into tests
    - **encrypt pwd into rules file - then can't sniff**
- not all greps are necessarily strict - can cause outliers

## Future Features (?)

The following features are subject to change, but will most probably be added as they'll make my life easier:

- dry run mode
  - ability to go through all the changes that we're going to make, and any potential issues
- `nggroup setup file.csv`
- `tests.sh <testname>`
- autocomplete
- generate random passwords
  - utilise `/usr/share/dict/words`
- cleanup
  - remove trailing spaces
    sed -i 's/[ \t]*$//' $(find . -path '*/.git' -prune -o -type f -print)
  - comments
  - utilise `mktemp TEMPLATE`
    - i.e. nggroupXXX
