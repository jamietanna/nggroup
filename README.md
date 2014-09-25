# nggroupIn “Basic” HTTP AUTH credentials are sent unencrypted over the wire, which makes HTTP AUTH particularly subject to so called “man-in-the-middle” attacks. As a result, this authentication method shouldn’t be used for protecting sensitive information.

nggroup (nginx htgroup) is a method of providing nginx with an emulation of Apache's htgroups feature, which allows easy ACL control for basic HTTP authentication. Nginx supports htpasswd, however, which allows us to create a `__TODO__`

## Usage

## Known Issues

- No input validation
- If you delete a user, then `generate`, you will have errors - need to remove from groups

## Future Features (?)

The following features are subject to change, but will most probably be added as they'll make my life easier:

- Add global group `@all`
- tests.sh <testname>
- autocomplete
- groups can contain groups?
- circular refs?