#!/usr/bin/env python2

import unittest

from group import Group


class TestGroupObject(unittest.TestCase):

    def test_properties(self):
        GROUP_NAME = "TestGroup"
        GROUP = Group(GROUP_NAME)

        self.assertEqual(GROUP_NAME, GROUP.groupName)
