#!/usr/bin/env python2


class AlreadyExistsError(Exception):

    def __init__(self, typeOfWhatExists, whatAlreadyExists, typeOfWhatExistsIn="", whatAlreadyExistsIn=""):

        existsInStr = ""
        if typeOfWhatExistsIn and whatAlreadyExistsIn:
            existsInStr = " in the %s `%s`" % (
                typeOfWhatExistsIn,
                whatAlreadyExistsIn
                )

        self.message = "The %s `%s` already exists%s." % (
            typeOfWhatExists,
            whatAlreadyExists,
            existsInStr
            )

    def __str__(self):
        return self.message


class UserAlreadyExistsError(AlreadyExistsError):

    def __init__(self, whatAlreadyExists):
        super(UserAlreadyExistsError, self).__init__("user", whatAlreadyExists)


class UserAlreadyExistsInGroup(AlreadyExistsError):

    def __init__(self, whichUserAlreadyExists, whichGroupExistsIn):
        super(AlreadyExistsError, self).__init__("user", whichUserAlreadyExists, "group", whichGroupExistsIn)


class DoesNotExistError(Exception):

    def __init__(self, typeOfWhatDoesNotExist, whatDoesNotExist, typeOfWhatDoesNotExistIn="", whatDoesNotExistIn=""):

        doesNotExistInStr = ""
        if typeOfWhatDoesNotExistIn and whatDoesNotExistIn:
            doesNotExistInStr = " in the %s `%s`" % (
                typeOfWhatDoesNotExistIn,
                whatDoesNotExistIn
                )

        self.message = "The %s `%s` does not exist%s." % (
            typeOfWhatDoesNotExist,
            whatDoesNotExist,
            doesNotExistInStr
            )

    def __str__(self):
        return self.message


class UserDoesNotExistError(DoesNotExistError):

    def __init__(self, whatDoesNotExist):
        super(UserDoesNotExistError, self).__init__("user", whatDoesNotExist)


class UserDoesNotExistInGroupError(DoesNotExistError):

    def __init__(self, whichUserDoesNotExist, whichGroupDoesNotExistIn):
        super(UserDoesNotExistInGroupError, self).__init__("user", whichUserDoesNotExist, "group", whichGroupDoesNotExistIn)
