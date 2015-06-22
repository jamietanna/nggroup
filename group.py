#!/usr/bin/env python2

import os
import config
from nggroup_exceptions import UserAlreadyExistsInGroup, GroupAlreadyExistsError, GroupDoesNotExistError, UserDoesNotExistInGroupError

from user import PopulateUser
from unit import Unit


class Group(Unit):

    def __init__(self, groupName):
        super(Group, self).__init__(groupName)
        self.userList = {}

    @property
    def groupName(self):
        """The Group's name"""
        return self.unitName

    @property
    def userList(self):
        return self._userList

    @userList.setter
    def userList(self, value):
        self._userList = value

    def getUnitRulePath(self):
        return GetGroupRulePath(self.groupName)

    def getGroupRulePath(self):
        return self.getUnitRulePath()

    def getUnitConfigPath(self):
        return GetGroupConfigPath(self.groupName)

    def getGroupConfigPath(self):
        return self.getUnitConfigPath()

    def saveUnitRule(self):
        if not self.userList:
            # we want to just create the file, making sure it's there, even if it's not a CSV
            # http://stackoverflow.com/a/12654798
            open(self.getGroupRulePath(), "wb+").close()
            return

        self.saveCSVFile(self.getGroupRulePath(), [
            [
                self.groupName,
                self.passwordHash,
                self.groupEmail
            ]
            ])

    def saveGroupRule(self):
        return self.saveUnitRule()

    def saveUnitConfig(self):
        raise NotImplementedError

    def saveGroupConfig(self):
        return self.saveUnitConfig()

    def generate(self):
        self.saveGroupRule()
        self.saveGroupConfig()

    def unitExists(self):
        return GroupExists(self.groupName)

    def groupExists(self):
        return self.unitExists()

    def isUserInGroup(self, username):
        return username in self.userList

    def addUser(self, user):
        if self.isUserInGroup(user.username):
            raise UserAlreadyExistsInGroup(user.username, self.groupName)

        self.userList[user.username] = user

    def deleteUser(self, user):
        if not self.isUserInGroup(user.username):
            raise UserDoesNotExistInGroupError(user.username, self.groupName)

        del self.userList[user.username]

    def saveGroupRuleFile(self):
        if not self.userList:
            # we want to just create the file, making sure it's there, even if it's not a CSV
            # http://stackoverflow.com/a/12654798
            open(self.getGroupRulePath(), "wb+").close()
            return

        with open(self.getGroupRulePath(), "wb+") as groupRuleFile:
            ruleWriter = config.getCSVWriter(groupRuleFile)
            for user in self.userList:
                ruleWriter.writerow([user])

    def delete(self):
        if GroupExists(self.groupName):
            os.remove(GetGroupRulePath(self.groupName))


def AddGroup(groupName, userList=[]):
    if GroupExists(groupName):
        raise GroupAlreadyExistsError(groupName)

    group = Group(groupName)
    for user in userList:
        group.addUser(group)

    group.saveGroupRuleFile()

    return group


def GroupExists(groupName):
    return os.path.exists(GetGroupRulePath(groupName))


def GetGroupRulePath(groupName):
    return "%s/.%s.rules" % (
        config.GROUP_DIR,
        groupName
        )


def GetGroupConfigPath(groupName):
    raise NotImplementedError


def DeleteGroup(groupName):
    if not GroupExists(groupName):
        raise GroupDoesNotExistError(groupName)

    group = PopulateGroup(groupName)
    if not group:
        return group

    group.delete()
    return group


def PopulateGroup(groupName):
    groupRulePath = GetGroupRulePath(groupName)

    if not os.path.exists(groupRulePath):
        return None

    with open(groupRulePath, "rb") as groupRuleFile:
        csvReader = config.getCSVReader(groupRuleFile)
        groupData = []
        for line in csvReader:
            groupData.append(line)

        group = Group(groupName)
        for line in groupData:
            userName = line[0]
            if userName:
                user = PopulateUser(userName)
                if user:
                    group.addUser(user)

    return group
