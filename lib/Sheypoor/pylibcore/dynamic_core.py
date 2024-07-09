import inspect

from .hybrid_core import HybridCore


class DynamicCore(HybridCore):
    _get_keyword_tags_supported = False

    def run_keyword(self, name, args, kwargs=None):
        return self.keywords[name](*args, **(kwargs or {}))

    def get_keyword_arguments(self, name):
        kw = self.keywords[name] if name != '__init__' else self.__init__
        args, defaults, varargs, kwargs = self._get_arg_spec(kw)
        args += ['{}={}'.format(name, value) for name, value in defaults]
        if varargs:
            args.append('*{}'.format(varargs))
        if kwargs:
            args.append('**{}'.format(kwargs))
        return args

    def get_keyword_tags(self, name):
        self._get_keyword_tags_supported = True
        return self.keywords[name].robot_tags

    def get_keyword_documentation(self, name):
        if name == '__intro__':
            return inspect.getdoc(self) or ''
        if name == '__init__':
            return inspect.getdoc(self.__init__) or ''
        kw = self.keywords[name]
        doc = inspect.getdoc(kw) or ''
        if kw.robot_tags and not self._get_keyword_tags_supported:
            tags = 'Tags: {}'.format(', '.join(kw.robot_tags))
            doc = '{}\n\n{}'.format(doc, tags) if doc else tags
        return doc

    @staticmethod
    def _get_arg_spec(kw):
        spec = inspect.getfullargspec(kw)
        keywords = spec.varkw
        args = spec.args[1:] if inspect.ismethod(kw) else spec.args  # drop self
        defaults = spec.defaults or ()
        nargs = len(args) - len(defaults)
        mandatory = args[:nargs]
        defaults = zip(args[nargs:], defaults)
        return mandatory, defaults, spec.varargs, keywords
