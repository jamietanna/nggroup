#!/usr/bin/env python2

import unittest

import config
import os
from user import User, PopulateUser, AddUser, GetUserRulePath


class TestUserObject(unittest.TestCase):

    def test_saveUserRule(self):
        # Initialise our test data
        NUMBER_PARAMS = 3
        USERNAME = "jamietanna"
        PASSWORDHASH = "*******"
        USEREMAIL = "jamie@jamietanna.co.uk"

        # create our test object
        AddUser(USERNAME, PASSWORDHASH, USEREMAIL)

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
        os.remove(userRulePath)
        self.assertFalse(os.path.exists(userRulePath))

    def test_populateUser(self):
        USERNAME = "jamietanna"
        PASSWORDHASH = "*******"
        USEREMAIL = "jamie@jamietanna.co.uk"

        # create our test object
        user = AddUser(USERNAME, PASSWORDHASH, USEREMAIL)

        user2 = PopulateUser(USERNAME)
        # TODO assert equal on getts
        self.assertEqual(user.username, user2.username)
        self.assertEqual(user.passwordHash, user2.passwordHash)
        self.assertEqual(user.userEmail, user2.userEmail)

        # remove the file we're testing with
        userRulePath = user.getUserRulePath()
        os.remove(userRulePath)
        self.assertFalse(os.path.exists(userRulePath))

    def test_properties(self):
        USERNAME = "jamietanna"
        PASSWORDHASH = "*******"
        USEREMAIL = "jamie@jamietanna.co.uk"

        # create our test object
        user = User(USERNAME, PASSWORDHASH, USEREMAIL)
        self.assertEqual(USERNAME, user.username)
        self.assertEqual(PASSWORDHASH, user.passwordHash)
        self.assertEqual(USEREMAIL, user.userEmail)

        NEW_USERNAME = "jvtanna"
        user.username = NEW_USERNAME
        self.assertEquals(NEW_USERNAME, user.username)


if __name__ == "__main__":
    unittest.main()
