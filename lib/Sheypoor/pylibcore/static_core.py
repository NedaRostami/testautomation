from .hybrid_core import HybridCore


class StaticCore(HybridCore):

    def __init__(self):
        HybridCore.__init__(self, [])
