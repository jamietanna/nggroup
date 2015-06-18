#!/usr/bin/env python2

from nggroup_exceptions import UserAlreadyExistsInGroup, UserDoesNotExistInGroupError


class Group:


    def __init__(self, groupName):
        self.groupName = groupName
        self.userList = {}

    @property
    def groupName(self):
        """The Group's name"""
        return self._groupName

    @groupName.setter
    def groupName(self, value):
        self._groupName = value

    @property
    def userList(self):
        return self._userList

    @userList.setter
    def userList(self, value):
        self._userList = value

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
