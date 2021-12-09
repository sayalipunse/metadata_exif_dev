# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Copyright 2021 Daniel Mark Gass, see __about__.py for license information.
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
"""Structured data store type."""

from typing import Dict, Optional, Tuple, Union

from ..data import Data
from ._member import Member
from ._meta import StructureMeta
from ._structureview import StructureView


class Structure(list, Data, metaclass=StructureMeta):

    """Structured data store type."""

    # filled in by metaclass
    __ignore_flags__: Tuple[bool, ...] = ()
    __members__: Tuple[Member, ...] = ()
    __nbytes__: Union[None, int] = 0
    __offsets__: Union[None, Tuple[int, ...]] = ()
    __byteorder__: str = "little"
    __implementation__: Optional[str] = None

    # Metaclass generates the following methods for each subclass:
    #   __init__
    #   member getter/setters
    #   __eq__
    #   __ne__
    #   __pack__
    #   __pack_and_dump__
    #   __repr__
    #   __unpack__
    #   __unpack_and_dump__

    def asdict(self) -> Dict[str, object]:
        """Return structure members in dictionary form.

        :returns: structure members
        :rtype: dict

        """
        return {
            name: getattr(self, name)
            for name in (member.name for member in self.__members__)
        }

    def __setattr__(self, name, value):
        # get the attribute to raise an exception if invalid name
        getattr(self, name)
        object.__setattr__(self, name, value)

    @classmethod
    def __view__(cls, buffer, offset=0):
        """Create plum view of bytes buffer.

        :param buffer: bytes buffer
        :type buffer: bytes-like (e.g. bytes, bytearray, memoryview)
        :param int offset: byte offset

        """
        if not cls.__nbytes__:
            raise TypeError(
                f"cannot create view for structure {cls.__name__!r} "
                "with variable size"
            )

        return StructureView(cls, buffer, offset)
