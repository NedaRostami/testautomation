import inspect
import re
import versions


class Variables:

    def get_variables(self, version=None):
        _, version = self.__set_version(version)
        self.version = version()
        return self.version.variables

    def __set_version(self, version):
        if version is not None:
            return self.__version_from_string(version)
        return self.__latest_version()

    @staticmethod
    def __version_from_string(version):
        version_name = 'V{}'.format(version.replace('.', '_'))
        return version_name, getattr(versions, version_name, versions.Version.not_found)

    @staticmethod
    def __latest_version():
        classes = inspect.getmembers(versions, inspect.isclass)
        classes = [(name, obj) for name, obj in classes if re.match(r'^V\d+', name)]
        latest_version = classes[-1]
        return latest_version
