#!/usr/bin/env python2

import unittest

from group import Group, AddGroup, DeleteGroup, PopulateGroup, GroupExists
from user import User, AddUser, DeleteUser

from nggroup_exceptions import UserAlreadyExistsInGroup, GroupAlreadyExistsError, GroupDoesNotExistError, UserDoesNotExistInGroupError


class TestGroupObject(unittest.TestCase):

    def cleanUpWorkingDirectory(self):
        # wrap in a try-except in case it's the first run, and we don't have a
        # Groups array
        try:
            groups = self.groups
        except AttributeError:
            return

        # then loop through our Users, cleaning up as we go
        for group in groups:
            try:
                DeleteGroup(group)
            except GroupDoesNotExistError:
                # it doesn't matter if we can't delete a user that doesn't exist
                continue

    def tearDown(self):
        self.cleanUpWorkingDirectory()

    # TODO make this a `setUpClass` - therefore less work before each test run
    def setUp(self):
        # make sure we clean up our temp files before we run the test, just in
        # case we have some files left over from before
        self.cleanUpWorkingDirectory()

        groups = []
        groupDetails = []

        groupDetails.append(
            (
                "TestGroup"
            )
            )

        groupDetails.append(
            (
                "TestGroup2"
            )
            )

        for groupDetail in groupDetails:
            groups.append((
                groupDetail
                ))

        self.groupDetails = groupDetails
        self.groups = groups

        testuser = User("testuser", "*****", "test@localhost")
        testuser2 = User("testuser2", "*****", "test2@localhost")

        testuser.delete()
        testuser2.delete()

    def test_properties(self):
        GROUP_NAME = "TestGroup"
        GROUP = AddGroup(GROUP_NAME)
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

    def test_addGroupTwice(self):
        GROUP_NAME = "TestGroup"
        GROUP = AddGroup(GROUP_NAME)
        with self.assertRaises(GroupAlreadyExistsError):
            GROUP2 = AddGroup(GROUP_NAME)

    def test_populateGroup(self):
        GROUP_NAME = "TestGroup"
        group = AddGroup(GROUP_NAME)

        testuser = AddUser("testuser", "*****", "test@localhost")
        testuser2 = AddUser("testuser2", "*****", "test2@localhost")

        group.addUser(testuser)
        group.addUser(testuser2)

        group.saveGroupRuleFile()
        # now populate and compare the two
        group2 = PopulateGroup(GROUP_NAME)

        self.assertEqual(group.groupName, group2.groupName)
        self.assertEqual(group.userList, group2.userList)

        DeleteUser("testuser")
        DeleteUser("testuser2")

    def test_deleteGroup(self):
        # first test with the group.delete() function
        GROUP_NAME = "TestGroup"

        self.assertFalse(GroupExists(GROUP_NAME))

        GROUP = AddGroup(GROUP_NAME)

        self.assertTrue(GroupExists(GROUP_NAME))

        GROUP.delete()

        self.assertFalse(GroupExists(GROUP_NAME))

        # then test with the DeleteGroup() function

        GROUP = AddGroup(GROUP_NAME)

        self.assertTrue(GroupExists(GROUP_NAME))

        DeleteGroup(GROUP_NAME)

        self.assertFalse(GroupExists(GROUP_NAME))
