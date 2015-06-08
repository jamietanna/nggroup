#!/usr/bin/env python2

import unittest

import config
import os
from user import User, PopulateUser, AddUser, GetUserRulePath, UserExists, DeleteUser
from nggroup_exceptions import UserDoesNotExistError


class TestUserObject(unittest.TestCase):

    def cleanUpWorkingDirectory(self):
        # wrap in a try-except in case it's the first run, and we don't have a
        # Users array
        try:
            users = self.users
        except AttributeError:
            return

        # then loop through our Users, cleaning up as we go
        for user in users:
            try:
                DeleteUser(user.username)
            except UserDoesNotExistError:
                # it doesn't matter if we can't delete a user that doesn't exist
                continue

    def tearDown(self):
        self.cleanUpWorkingDirectory()

    # TODO make this a `setUpClass` - therefore less work before each test run
    def setUp(self):
        # make sure we clean up our temp files before we run the test, just in
        # case we have some files left over from before
        self.cleanUpWorkingDirectory()

        users = []
        userDetails = []

        userDetails.append(
            (
                "jamietanna",
                "******",
                "jamie@jamietanna.co.uk"
            )
            )

        userDetails.append(
            (
                "testuser",
                "******",
                "test@localhost"
            )
            )

        for userDetail in userDetails:
            users.append(AddUser(
                userDetail[0],
                userDetail[1],
                userDetail[2]
                ))

        self.userDetails = userDetails
        self.users = users

    def test_saveUserRule(self):
        # Initialise our test data
        NUMBER_PARAMS = 3

        # TODO abstract out this code into a separate function if possible
        # i.e. by adding a wrapper that will run a function given the test data
        for user in self.users:
            USERNAME = user.username
            PASSWORDHASH = user.passwordHash
            USEREMAIL = user.userEmail

            # test that we can save the file correctly
            userRulePath = GetUserRulePath(USERNAME)
            with open(userRulePath, "rb") as userRuleFile:
                csvReader = config.getCSVReader(userRuleFile)

                lineCount = 0
                for line in csvReader:
                    lineCount += 1
                    # we can only have one user per file
                    self.assertEqual(lineCount, 1)

                    # ensure that we have the correct number of params
                    self.assertEqual(NUMBER_PARAMS, len(line))
                    # and that they're the same that we passed in
                    self.assertEqual(USERNAME, line[0])
                    self.assertEqual(PASSWORDHASH, line[1])
                    self.assertEqual(USEREMAIL, line[2])

            # remove the file we're testing with
            DeleteUser(USERNAME)

    def test_populateUser(self):
        for user in self.users:
            USERNAME = user.username
            PASSWORDHASH = user.passwordHash
            USEREMAIL = user.userEmail

            # make sure we don't have any conflicts with previously saved files
            DeleteUser(USERNAME)

            # create our test object
            user = AddUser(USERNAME, PASSWORDHASH, USEREMAIL)

            user2 = PopulateUser(USERNAME)
            # TODO assert equal on getts
            self.assertEqual(user.username, user2.username)
            self.assertEqual(user.passwordHash, user2.passwordHash)
            self.assertEqual(user.userEmail, user2.userEmail)

    def test_properties(self):
        USERNAME = self.users[0].username
        PASSWORDHASH = self.users[0].passwordHash
        USEREMAIL = self.users[0].passwordHash

        # create our test object
        user = User(USERNAME, PASSWORDHASH, USEREMAIL)
        self.assertEqual(USERNAME, user.username)
        self.assertEqual(PASSWORDHASH, user.passwordHash)
        self.assertEqual(USEREMAIL, user.userEmail)

        NEW_USERNAME = "jvtanna"
        user.username = NEW_USERNAME
        self.assertEquals(NEW_USERNAME, user.username)

    def test_deleteRealUser(self):
        USERNAME = self.users[0].username
        DeleteUser(USERNAME)
        self.assertFalse(UserExists(USERNAME))

    def test_deleteNonExistentUser(self):
        USERNAME = "thisisnotavalidusername"
        with self.assertRaises(UserDoesNotExistError):
            DeleteUser(USERNAME)

if __name__ == "__main__":
    unittest.main()
