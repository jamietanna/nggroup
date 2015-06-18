#!/usr/bin/env python2

import config

import os

from nggroup_exceptions import UserAlreadyExistsError, UserDoesNotExistError


class User:

    def __init__(self, username, passwordHash, userEmail):
        self.username = username
        self.passwordHash = passwordHash
        self.userEmail = userEmail

    def __eq__(self, other):
        # usernames are unique
        return self.username == other.username

    @property
    def username(self):
        """The User's unique username"""
        return self._username

    @username.setter
    def username(self, value):
        self._username = value

    @property
    def passwordHash(self):
        """The User's password hash"""
        return self._passwordHash

    @passwordHash.setter
    def passwordHash(self, value):
        self._passwordHash = value

    @property
    def userEmail(self):
        """The User's email"""
        return self._userEmail

    @userEmail.setter
    def userEmail(self, value):
        self._userEmail = value

    def getUserRulePath(self):
        return GetUserRulePath(self.username)

    def getUserConfigPath(self):
        return GetUserConfigPath(self.username)

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

    def delete(self):
        if UserExists(self.username):
            os.remove(GetUserRulePath(self.username))

        if os.path.exists(GetUserConfigPath(self.username)):
            os.remove(GetUserConfigPath(self.username))

        # TODO also remove any references in other generated files -- warn user before, which files/etc will be affected

    def saveUserConfig(self):
        with open(self.getUserConfigPath(), "wb+") as userConfigFile:
            configWriter = config.getHtpasswdWriter(userConfigFile)
            configWriter.writerow(
                [
                    self.username,
                    self.passwordHash
                ]
                )

    def generate(self):
        self.saveUserRule()
        self.saveUserConfig()


def UserExists(username):
    return os.path.exists(GetUserRulePath(username))


def AddUser(username, passwordHash, userEmail):
    if UserExists(username):
        raise UserAlreadyExistsError(username)

    user = User(username, passwordHash, userEmail)
    user.saveUserRule()
    return user

def DeleteUser(username):
    if not UserExists(username):
        raise UserDoesNotExistError(username)

    user = PopulateUser(username)
    user.delete()
    return user

def GetUserConfigPath(username):
    return "%s/%s" % (
        config.USER_DIR,
        username
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
