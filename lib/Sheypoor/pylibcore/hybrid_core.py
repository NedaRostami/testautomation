import inspect


class HybridCore(object):

    def __init__(self, library_components, *args, **kwargs):
        self.keywords = {}
        self.attributes = {}
        self.add_library_components(library_components)
        self.add_library_components([self])

    def get_keyword_names(self):
        return sorted(self.keywords)

    def add_library_components(self, library_components):
        for component in library_components:
            for name, func in self._get_members(component):
                if callable(func) and hasattr(func, 'robot_name'):
                    kw = getattr(component, name)
                    kw_name = func.robot_name or name
                    self.keywords[kw_name] = kw
                    self.attributes[name] = self.attributes[kw_name] = kw

    def _get_members(self, component):
        if inspect.ismodule(component):
            return inspect.getmembers(component)
        if inspect.isclass(component):
            raise TypeError(f'Libraries must be modules or instances, got '
                            f'class {component.__name__} instead.')
        if type(component) != component.__class__:
            raise TypeError(f'Libraries must be modules or new-style class '
                            f'instances, got old-style class {component.__class__.__name__} instead.')
        return self._get_members_from_instance(component)

    @staticmethod
    def _get_members_from_instance(instance):
        cls = type(instance)
        for name in dir(instance):
            owner = cls if hasattr(cls, name) else instance
            yield name, getattr(owner, name)

    def __getattr__(self, name):
        if name in self.attributes:
            return self.attributes[name]
        raise AttributeError(f'{type(self).__name__} object has no attribute {name}')

    def __dir__(self):
        my_attrs = super().__dir__()
        return sorted(set(my_attrs) | set(self.attributes))
