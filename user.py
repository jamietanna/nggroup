#!/usr/bin/env python2

import config

import os


class User:

    def __init__(self, username, passwordHash, userEmail):
        self.username = username
        self.passwordHash = passwordHash
        self.userEmail = userEmail

    def getUserRulePath(self):
        return GetUserRulePath(self.username)

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


def GetUserRulePath(username):
    return "%s/.%s.rules" % (
        config.USER_DIR,
        username
        )


def PopulateUser(username):
    userRulePath = GetUserRulePath(username)

    if not os.path.exists(userRulePath):
        return None

    with open(userRulePath, "rb") as userRuleFile:
        csvReader = config.getCSVReader(userRuleFile)
        userData = []
        for line in csvReader:
            userData = line

        return User(userData[0], userData[1], userData[2])
