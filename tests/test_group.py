#!/usr/bin/env python2

import unittest

from group import Group
from user import User

from nggroup_exceptions import UserAlreadyExistsInGroup, UserDoesNotExistInGroupError


class TestGroupObject(unittest.TestCase):

    def test_properties(self):
        GROUP_NAME = "TestGroup"
        GROUP = Group(GROUP_NAME)
        USER1 = User("testuser", "*****", "test@localhost")
        USER2 = User("testuser2", "*****", "test@localhost")

        self.assertEqual(GROUP_NAME, GROUP.groupName)

        # Ensure that we start with an empty list
        self.assertEqual(0, len(GROUP.userList))

        GROUP.addUser(USER1)
        self.assertEqual(1, len(GROUP.userList))

        GROUP.addUser(USER2)
        self.assertEqual(2, len(GROUP.userList))

    def test_addUserToGroupTwice(self):
        GROUP = Group("TestGroup")
        USER = User("testuser", "*****", "test@localhost")

        GROUP.addUser(USER)
        with self.assertRaises(UserAlreadyExistsInGroup):
            GROUP.addUser(USER)

    def test_deleteUser(self):
        GROUP = Group("TestGroup")
        USERNAME = "testuser"
        USER = User(USERNAME, "*****", "test@localhost")
        GROUP.addUser(USER)

        self.assertEqual(1, len(GROUP.userList))
        self.assertTrue(GROUP.isUserInGroup(USERNAME))

        GROUP.deleteUser(USER)
        self.assertEqual(0, len(GROUP.userList))
        self.assertFalse(GROUP.isUserInGroup(USERNAME))

    def test_deleteNonExistentUser(self):
        GROUP = Group("TestGroup")
        USER = User("usernotpartofgroup", "*****", "test@localhost")

        self.assertFalse(GROUP.isUserInGroup(USER.username))

        with self.assertRaises(UserDoesNotExistInGroupError):
            GROUP.deleteUser(USER)
