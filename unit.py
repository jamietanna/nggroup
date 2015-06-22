#!/usr/bin/env python2

import abc
import config
import os

class Unit(object):
    """A Unit is an abstract definition for a User, Group and Site. It defines a number of core methods that each Unit will require, such as saving and deleting."""

    __metaclass__ = abc.ABCMeta

    def __init__(self, unitName):
        self._unitName = unitName

    @property
    def unitName(self):
        """The User's unique username"""
        return self._unitName

    @abc.abstractmethod
    def getUnitRulePath(self):
        """Method that should provide a string which indicates the path to the rules file for the given Unit"""

    @abc.abstractmethod
    def getUnitConfigPath(self):
        """Method that should provide a string which indicates the path to the generated file for the given Unit"""

    @abc.abstractmethod
    def saveUnitRule(self):
        """Method for saving the Unit's rule file"""

    @abc.abstractmethod
    def saveUnitConfig(self):
        """Method for saving the Unit's generated file"""

    def delete(self):
        """Delete a given Unit, ensuring to remove the rules and generated files"""
        if not self.unitExists():
            return

        self.deleteFile(self.getUnitRulePath())
        self.deleteFile(self.getUnitConfigPath())

        # TODO we need to remove any references from other files

    @abc.abstractmethod
    def generate(self):
        """Save the unit's rule and generated files"""

    @abc.abstractmethod
    def unitExists(self):
        """A method that returns true if a given Unit exists"""

    @staticmethod
    def saveFile(fileWriterFunction, filename, xssData):
        with open(filename, "wb+") as outFile:
            fileWriter = fileWriterFunction(outFile)
            for row in xssData:
                fileWriter.writerow(row)

    @classmethod
    def saveCSVFile(cls, filename, xssData):
        return cls.saveFile(config.getCSVWriter, filename, xssData)

    @classmethod
    def saveHtpasswdFile(cls, filename, xssData):
        return cls.saveFile(config.getHtpasswdWriter, filename, xssData)

    @staticmethod
    def deleteFile(filename):
        if os.path.exists(filename):
            os.remove(filename)
