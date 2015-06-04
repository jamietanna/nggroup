#!/usr/bin/env python2

import config


class User:

    def __init__(self, username, passwordHash, userEmail):
        self.username = username
        self.passwordHash = passwordHash
        self.userEmail = userEmail

    def getUserRulePath(self):
        return "%s/.%s.rules" % (
            config.USER_DIR,
            self.username
            )

    def saveUserRule(self):
        with open(self.getUserRulePath(), "wb+") as userRuleFile:
            ruleWriter = config.getCSVWriter(userRuleFile)
            ruleWriter.writerow(
                [
                    self.username,
                    self.passwordHash,
                    self.userEmail
                ]
                )
