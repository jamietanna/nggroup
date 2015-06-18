#!/usr/bin/env python2


class Group:


    def __init__(self, groupName):
        self.groupName = groupName

    @property
    def groupName(self):
        """The Group's name"""
        return self._groupName

    @groupName.setter
    def groupName(self, value):
        self._groupName = value
