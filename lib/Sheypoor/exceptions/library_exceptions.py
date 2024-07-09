from .robot_exception import RobotException


class JsonServerError(RobotException):
    pass


class ImageError(RobotException):
    pass


class MockError(RobotException):
    pass


class ProtoolsAttributeError(RobotException):
    pass


class TrumpetModerationError(RobotException):
    pass


class UtilsError(RobotException):
    pass

class SeoError(RobotException):
    ROBOT_EXIT_ON_FAILURE = False

class StaticDataError(RobotException):
    ROBOT_EXIT_ON_FAILURE = False
