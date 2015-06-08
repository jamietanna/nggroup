#!/usr/bin/env python2


class AlreadyExistsError(Exception):

    def __init__(self, typeOfError, whatAlreadyExists):
        self.typeOfError = typeOfError
        self.whatAlreadyExists = whatAlreadyExists
        self.message = "The %s `%s` already exists." % (
            self.typeOfError,
            self.whatAlreadyExists
            )

    def __str__(self):
        return self.message


class UserAlreadyExistsError(AlreadyExistsError):

    def __init__(self, whatAlreadyExists):
        super(UserAlreadyExistsError, self).__init__("user", whatAlreadyExists)
