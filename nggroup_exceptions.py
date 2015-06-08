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


class DoesNotExistError(Exception):

    def __init__(self, typeOfError, whatDoesNotExist):
        self.typeOfError = typeOfError
        self.whatDoesNotExist = whatDoesNotExist
        self.message = "The %s `%s` does not exist." % (
            self.typeOfError,
            self.whatDoesNotExist
            )

    def __str__(self):
        return self.message


class UserDoesNotExistError(DoesNotExistError):

    def __init__(self, whatDoesNotExist):
        super(UserDoesNotExistError, self).__init__("user", whatDoesNotExist)
