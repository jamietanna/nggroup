#!/usr/bin/env python2

import config

import os

from nggroup_exceptions import UserAlreadyExistsError, UserDoesNotExistError

from unit import Unit

class User(Unit):
    def __init__(self, username, passwordHash, userEmail):
        super(User, self).__init__(username)
        self._passwordHash = passwordHash
        self._userEmail = userEmail

    def __eq__(self, other):
        return self.username == other.username

    @property
    def username(self):
        return self.unitName

    @property
    def passwordHash(self):
        """The User's password hash"""
        return self._passwordHash

    @property
    def userEmail(self):
        """The User's email"""
        return self._userEmail

    def getUnitRulePath(self):
        return GetUserRulePath(self.username)

    def getUserRulePath(self):
        return self.getUnitRulePath()

    def getUnitConfigPath(self):
        return GetUserConfigPath(self.username)

    def getUserConfigPath(self):
        return self.getUnitConfigPath()

    def saveUnitRule(self):
        self.saveCSVFile(self.getUserRulePath(), [
            [
                self.username,
                self.passwordHash,
                self.userEmail
            ]
            ])

    def saveUserRule(self):
        return self.saveUnitRule()

    def saveUnitConfig(self):
        self.saveHtpasswdFile(self.getUserConfigPath(), [
            [
                self.username,
                self.passwordHash
            ]
            ])

    def saveUserConfig(self):
        return self.saveUnitConfig()

    def generate(self):
        self.saveUserRule()
        self.saveUserConfig()

    def unitExists(self):
        return UserExists(self.username)

    def userExists(self):
        return self.unitExists()

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
